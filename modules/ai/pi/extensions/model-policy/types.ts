export type Tier = 'FAST' | 'RESEARCH' | 'BUILD' | 'REASON' | 'ARCHITECT' | 'ORACLE';

export type ThinkingLevel = 'off' | 'minimal' | 'low' | 'medium' | 'high' | 'xhigh' | 'max';

export type Profile = 'balanced' | 'quota-saver' | 'quality';

export interface ModelCandidate {
  provider: string;
  id: string;
  fullId: string; // e.g. "openai-codex/gpt-5.6-terra"
  tier: Tier;
  cost: number; // Blended cost per million tokens (USD)
  reasoning: boolean;
  contextWindow: number;
  recommendedThinking: ThinkingLevel;
}

export interface PolicyConfig {
  profile?: Profile;
  tiers?: Partial<Record<Tier, string>>;
  agents?: Record<string, { tier?: Tier; model?: string; thinking?: ThinkingLevel }>;
  reserveModels?: string[];
}

export interface DecisionTrace {
  agentName: string;
  tier: Tier;
  reason: string;
  selectedModel: string;
  thinkingLevel: ThinkingLevel;
  ruleSource: 'override' | 'context-promotion' | 'name-heuristic' | 'tool-heuristic' | 'default';
  candidateChain: string[];
  cooldownAvoided?: string[];
}
