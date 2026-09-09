import type { Tier, ThinkingLevel, ModelCandidate, PolicyConfig, DecisionTrace } from './types.ts';
import { getBlendedCost } from './pricing.ts';
import type { CircuitBreaker } from './breaker.ts';

export interface RawPiModel {
  id: string;
  provider: string;
  name?: string;
  contextWindow?: number;
  reasoning?: boolean;
}

const DEFAULT_THINKING_PER_TIER: Record<Tier, ThinkingLevel> = {
  FAST: 'low',
  RESEARCH: 'low',
  BUILD: 'medium',
  REASON: 'medium',
  ARCHITECT: 'high',
  ORACLE: 'high'
};

export function qualifyModelForTiers(model: RawPiModel): Tier[] {
  const normId = model.id.toLowerCase();
  const tiers: Tier[] = [];
  const cost = getBlendedCost(model.provider, model.id);
  const isReasoning = Boolean(model.reasoning) || /reason|thinking|r1|pro|sonnet|sol|astra|o1|o3|opus/.test(normId);

  // 1. FAST: Fast, lightweight, low cost (< $2/M)
  if (cost <= 2.0 || /lite|mini|flash|spark|luna|haiku/.test(normId)) {
    tiers.push('FAST');
  }

  // 2. RESEARCH: Lightweight to mid-cost, good for analysis and search
  if (cost <= 4.0 || /research|luna|flash|terra|haiku/.test(normId)) {
    tiers.push('RESEARCH');
  }

  // 3. BUILD: Solid code capabilities, cost-effective
  if (/flash|coder|code|terra|dev|work|sonnet/.test(normId) || (cost >= 0.1 && cost <= 6.0)) {
    tiers.push('BUILD');
  }

  // 4. REASON: Reasoning capability / critical analysis
  if (isReasoning || /terra|sonnet|pro|reason|correct|r1/.test(normId)) {
    tiers.push('REASON');
  }

  // 5. ARCHITECT: High-reasoning structural/planning models
  const isMini = normId.includes('mini') || normId.includes('lite') || normId.includes('spark');
  if ((/sol|opus|ultra|max|architect/.test(normId) || (!isMini && /(o1|o3)/.test(normId))) || (isReasoning && cost >= 7.0)) {
    tiers.push('ARCHITECT');
  }

  // 6. ORACLE: Frontier apex models (Astra, full o1, full o3, Opus)
  if ((!isMini && /astra|o1|o3|opus/.test(normId)) || (!isMini && cost >= 15.0)) {
    tiers.push('ORACLE');
  }

  // Fallback: If model qualified for nothing, treat as BUILD or FAST based on cost
  if (tiers.length === 0) {
    tiers.push(cost > 2.0 ? 'BUILD' : 'FAST');
  }

  return tiers;
}

export function buildModelCandidates(availableModels: RawPiModel[]): ModelCandidate[] {
  const candidates: ModelCandidate[] = [];

  for (const m of availableModels) {
    const cost = getBlendedCost(m.provider, m.id);
    const qualifiedTiers = qualifyModelForTiers(m);
    const fullId = `${m.provider}/${m.id}`;
    const contextWindow = m.contextWindow || (m.id.includes('gemini') ? 1048576 : 128000);
    const reasoning = Boolean(m.reasoning) || /reason|thinking|r1|pro|sonnet|sol|astra|o1|o3|opus/.test(m.id);

    for (const tier of qualifiedTiers) {
      candidates.push({
        provider: m.provider,
        id: m.id,
        fullId,
        tier,
        cost,
        reasoning,
        contextWindow,
        recommendedThinking: DEFAULT_THINKING_PER_TIER[tier]
      });
    }
  }

  return candidates;
}

export function groupAndSortTiers(
  candidates: ModelCandidate[]
): Map<Tier, ModelCandidate[]> {
  const map = new Map<Tier, ModelCandidate[]>();
  const allTiers: Tier[] = ['FAST', 'RESEARCH', 'BUILD', 'REASON', 'ARCHITECT', 'ORACLE'];

  for (const tier of allTiers) {
    const tierCandidates = candidates.filter(c => c.tier === tier);
    // Sort by: Cost ASC (Cheapest first), then Context Window DESC
    tierCandidates.sort((a, b) => {
      if (Math.abs(a.cost - b.cost) > 0.001) {
        return a.cost - b.cost;
      }
      return b.contextWindow - a.contextWindow;
    });
    map.set(tier, tierCandidates);
  }

  return map;
}

export function resolveModelForTier(
  targetTier: Tier,
  tierMap: Map<Tier, ModelCandidate[]>,
  breaker: CircuitBreaker,
  taskLengthTokens: number = 0,
  config?: PolicyConfig
): {
  candidate: ModelCandidate | null;
  chain: string[];
  ruleSource: DecisionTrace['ruleSource'];
  cooldownAvoided: string[];
} {
  const cooldownAvoided: string[] = [];
  const tierOrder: Tier[] = ['ORACLE', 'ARCHITECT', 'REASON', 'BUILD', 'RESEARCH', 'FAST'];

  // Check explicit tier override from config
  if (config?.tiers && config.tiers[targetTier]) {
    const overrideId = config.tiers[targetTier]!;
    const all = Array.from(tierMap.values()).flat();
    const match = all.find(c => c.fullId === overrideId || c.id === overrideId);
    if (match) {
      return {
        candidate: match,
        chain: [match.fullId],
        ruleSource: 'override',
        cooldownAvoided
      };
    }
  }

  // R2.5: Context Window Promotion if prompt is massive (>30k tokens)
  if (taskLengthTokens > 30000) {
    const allCandidates = Array.from(tierMap.values()).flat();
    const needsReasoning = targetTier === 'REASON' || targetTier === 'ARCHITECT' || targetTier === 'ORACLE';

    const largeContextCandidate = allCandidates
      .filter(c =>
        c.contextWindow >= 1000000 &&
        (!needsReasoning || c.reasoning) &&
        !breaker.isCoolingDown(c.provider) &&
        !breaker.isCoolingDown(c.fullId)
      )
      .sort((a, b) => a.cost - b.cost)[0];

    if (largeContextCandidate) {
      return {
        candidate: largeContextCandidate,
        chain: [largeContextCandidate.fullId],
        ruleSource: 'context-promotion',
        cooldownAvoided
      };
    }
  }

  // Evaluate candidate chain for the requested tier
  const rawList = tierMap.get(targetTier) || [];
  const activeChain: ModelCandidate[] = [];

  for (const c of rawList) {
    if (breaker.isCoolingDown(c.provider) || breaker.isCoolingDown(c.fullId)) {
      cooldownAvoided.push(c.fullId);
    } else {
      activeChain.push(c);
    }
  }

  if (activeChain.length > 0) {
    return {
      candidate: activeChain[0],
      chain: activeChain.map(c => c.fullId),
      ruleSource: 'default',
      cooldownAvoided
    };
  }

  // Fallback downward: find an eligible model from lower tiers (no upward escalation)
  const targetIdx = tierOrder.indexOf(targetTier);
  for (let i = targetIdx + 1; i < tierOrder.length; i++) {
    const lowerTier = tierOrder[i];
    const lowerList = tierMap.get(lowerTier) || [];
    for (const c of lowerList) {
      if (!breaker.isCoolingDown(c.provider) && !breaker.isCoolingDown(c.fullId)) {
        return {
          candidate: c,
          chain: [c.fullId],
          ruleSource: 'default',
          cooldownAvoided
        };
      } else {
        cooldownAvoided.push(c.fullId);
      }
    }
  }

  // Absolute fallback: pick any non-cooling candidate from any tier
  const anyAvailable = Array.from(tierMap.values())
    .flat()
    .filter(c => !breaker.isCoolingDown(c.provider) && !breaker.isCoolingDown(c.fullId))
    .sort((a, b) => a.cost - b.cost)[0];

  return {
    candidate: anyAvailable || rawList[0] || null,
    chain: anyAvailable ? [anyAvailable.fullId] : [],
    ruleSource: 'default',
    cooldownAvoided
  };
}
