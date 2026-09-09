// Reference public pricing per 1M tokens (USD)
// Formula: blended = (input * 0.75) + (output * 0.25)
const KNOWN_PRICING: Record<string, { input: number; output: number }> = {
  // Ultra-fast / Low-cost
  'gemini-2.5-flash-lite': { input: 0.04, output: 0.15 },
  'gemini-2.5-flash': { input: 0.075, output: 0.30 },
  'gemini-3.5-flash-lite': { input: 0.05, output: 0.20 },
  'gemini-3.5-flash': { input: 0.10, output: 0.40 },
  'gemini-3.8-flash': { input: 0.10, output: 0.40 },
  'gpt-5.3-codex-spark': { input: 0.15, output: 0.60 },
  'gpt-5.4-mini': { input: 0.15, output: 0.60 },
  'gpt-5.6-luna': { input: 0.15, output: 0.60 },
  'claude-3-5-haiku': { input: 0.80, output: 4.00 },

  // Mid-tier / Build & Balanced Reason
  'gpt-5.4': { input: 2.00, output: 8.00 },
  'gpt-5.5': { input: 2.00, output: 8.00 },
  'gpt-5.6-terra': { input: 2.50, output: 10.00 },
  'gemini-2.5-pro': { input: 1.25, output: 5.00 },
  'gemini-3.1-pro': { input: 1.25, output: 5.00 },
  'claude-3-7-sonnet': { input: 3.00, output: 15.00 },
  'claude-sonnet-4-6': { input: 3.00, output: 15.00 },

  // Advanced Reasoning / Architecture
  'gpt-5.6-sol': { input: 5.00, output: 20.00 },
  'claude-opus-4-6': { input: 15.00, output: 75.00 },
  'claude-3-opus': { input: 15.00, output: 75.00 },

  // Frontier / Oracle
  'gpt-6-astra': { input: 15.00, output: 60.00 },
  'o1': { input: 15.00, output: 60.00 },
  'o3-mini': { input: 1.10, output: 4.40 },
  'o3': { input: 20.00, output: 80.00 },
};

export function getBlendedCost(provider: string, modelId: string): number {
  const normId = modelId.toLowerCase().trim();

  // 1. Direct match or partial key match in catalog
  for (const [key, rates] of Object.entries(KNOWN_PRICING)) {
    if (normId === key || normId.includes(key)) {
      return rates.input * 0.75 + rates.output * 0.25;
    }
  }

  // 2. Keyword-inferred cost for unknown/custom models
  if (/lite|mini|flash|spark|small|nano|luna/.test(normId)) {
    return 0.25; // ~0.25 USD/M
  }
  if (/coder|code|dev|terra|work/.test(normId)) {
    return 2.50; // ~2.50 USD/M
  }
  if (/pro|sonnet|reason|r1|thinking/.test(normId)) {
    return 4.00; // ~4.00 USD/M
  }
  if (/sol|ultra|max|opus|architect/.test(normId)) {
    return 10.00; // ~10.00 USD/M
  }
  if (/astra|o1|o3|frontier|flagship/.test(normId)) {
    return 25.00; // ~25.00 USD/M
  }

  // Default baseline
  return 1.50;
}
