import type { Tier, ThinkingLevel, ModelCandidate, PolicyConfig, DecisionTrace } from './types.ts';
import { calculateModelCost } from './pricing.ts';
import type { CircuitBreaker } from './breaker.ts';

export interface RawPiModel {
  id: string;
  provider: string;
  name?: string;
  contextWindow?: number;
  reasoning?: boolean;
  cost?: {
    input?: number;
    output?: number;
  };
}

const DEFAULT_THINKING_PER_TIER: Record<Tier, ThinkingLevel> = {
  FAST: 'low',
  RESEARCH: 'low',
  BUILD: 'medium',
  REASON: 'medium',
  ARCHITECT: 'high',
  ORACLE: 'high'
};

export function buildModelCandidates(availableModels: RawPiModel[]): ModelCandidate[] {
  return availableModels.map((m) => {
    const cost = calculateModelCost(m);
    const reasoning = Boolean(m.reasoning);
    const contextWindow = typeof m.contextWindow === 'number' && m.contextWindow > 0
      ? m.contextWindow
      : 128000;

    return {
      provider: m.provider,
      id: m.id,
      fullId: `${m.provider}/${m.id}`,
      tier: 'FAST', // Assigned dynamically in groupAndSortTiers
      cost,
      reasoning,
      contextWindow,
      recommendedThinking: 'off'
    };
  });
}

/**
 * Autodiscovers and groups models into the 6 abstract capability tiers
 * dynamically from their native metadata (cost, reasoning, contextWindow).
 * Zero hardcoded model names or brand regexes.
 */
export function groupAndSortTiers(
  candidates: ModelCandidate[]
): Map<Tier, ModelCandidate[]> {
  const map = new Map<Tier, ModelCandidate[]>();
  if (candidates.length === 0) return map;

  // 1. Sort global pool by cost ascending (cheapest first)
  const sortedByCostAsc = [...candidates].sort((a, b) => {
    if (Math.abs(a.cost - b.cost) > 0.0001) return a.cost - b.cost;
    return b.contextWindow - a.contextWindow;
  });

  // 2. Separate into standard and reasoning pools
  const standardPool = sortedByCostAsc.filter(c => !c.reasoning);
  const reasoningPool = sortedByCostAsc.filter(c => c.reasoning);

  // If user has no reasoning models, use cost percentiles from the whole pool
  const hasReasoning = reasoningPool.length > 0;
  const effectiveStandard = standardPool.length > 0 ? standardPool : sortedByCostAsc;
  const effectiveReasoning = hasReasoning ? reasoningPool : sortedByCostAsc;

  // --- FAST TIER ---
  // Lowest cost standard models, ordered by cost ASC
  map.set('FAST', effectiveStandard.map(c => ({
    ...c,
    tier: 'FAST' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.FAST
  })));

  // --- RESEARCH TIER ---
  // Prioritizes large context window at low cost
  const researchSorted = [...effectiveStandard].sort((a, b) => {
    if (Math.abs(a.cost - b.cost) < 1.0) {
      return b.contextWindow - a.contextWindow;
    }
    return a.cost - b.cost;
  });
  map.set('RESEARCH', researchSorted.map(c => ({
    ...c,
    tier: 'RESEARCH' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.RESEARCH
  })));

  // --- BUILD TIER ---
  // Mid-range execution models (standard pool sorted by cost ASC)
  map.set('BUILD', effectiveStandard.map(c => ({
    ...c,
    tier: 'BUILD' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.BUILD
  })));

  // --- REASON TIER ---
  // Most cost-effective reasoning models (reasoning pool sorted by cost ASC)
  map.set('REASON', effectiveReasoning.map(c => ({
    ...c,
    tier: 'REASON' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.REASON
  })));

  // --- ARCHITECT TIER ---
  // High-capacity reasoning models (upper bracket of reasoning pool)
  // If multiple reasoning models exist, exclude the apex model which is reserved for ORACLE
  let architectPool: ModelCandidate[];
  if (effectiveReasoning.length >= 3) {
    // Take the middle to upper tier, excluding the single most expensive apex model
    const withoutApex = effectiveReasoning.slice(0, effectiveReasoning.length - 1);
    architectPool = withoutApex.slice(Math.floor(withoutApex.length / 2));
    if (architectPool.length === 0) architectPool = [withoutApex[withoutApex.length - 1]];
  } else if (effectiveReasoning.length === 2) {
    architectPool = [effectiveReasoning[0]];
  } else {
    architectPool = effectiveReasoning;
  }

  map.set('ARCHITECT', architectPool.map(c => ({
    ...c,
    tier: 'ARCHITECT' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.ARCHITECT
  })));

  // --- ORACLE TIER ---
  // Apex frontier model (highest capability / highest cost in the user's reasoning pool)
  const oraclePool = [...effectiveReasoning].reverse(); // Highest cost first
  map.set('ORACLE', oraclePool.map(c => ({
    ...c,
    tier: 'ORACLE' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.ORACLE
  })));

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

  // 1. Check explicit tier override from user configuration
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

  // 2. R2.5: Context Window Promotion if prompt payload is massive (>30k tokens)
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

  // 3. Evaluate candidate chain for the requested tier
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

  // 4. Fallback downward: find an eligible model from lower tiers (no upward escalation)
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

  // 5. Absolute fallback: pick lowest cost non-cooling model from any tier
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
