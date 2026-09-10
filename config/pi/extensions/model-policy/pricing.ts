export interface ModelWithCost {
  cost?: {
    input?: number;
    output?: number;
    cacheRead?: number;
    cacheWrite?: number;
  };
}

/**
 * Calculates blended cost per 1M tokens from native Pi model metadata.
 * Weight: 75% input, 25% output.
 * If model has no cost metadata (e.g. local Ollama), returns 0.
 */
export function calculateModelCost(model: ModelWithCost): number {
  if (!model?.cost) return 0;
  const input = typeof model.cost.input === 'number' ? model.cost.input : 0;
  const output = typeof model.cost.output === 'number' ? model.cost.output : 0;
  return Number((input * 0.75 + output * 0.25).toFixed(4));
}
