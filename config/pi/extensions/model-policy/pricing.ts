/**
 * Métrica de Costo Ponderado para Inferencia de Subagentes.
 *
 * En flujos de trabajo basados en agentes (scouting, lectura de repositorios,
 * auditorías de código y generación de parches), el volumen de tokens de entrada
 * supera consistentemente al de salida en una proporción empírica de ~3:1 debido a
 * la inyección de contexto, historial y archivos leídos.
 *
 * Para ordenar y seleccionar modelos objetivamente sin tablas estáticas, calculamos
 * un costo ponderado único (75% input / 25% output) a partir de las tarifas por
 * millón de tokens que Pi expone de forma nativa en cada modelo.
 */

export interface ModelWithCost {
  cost?: {
    input?: number;
    output?: number;
    cacheRead?: number;
    cacheWrite?: number;
  };
}

/**
 * Computa el costo ponderado efectivo en USD por millón de tokens.
 *
 * Garantía: Si un modelo no posee metadatos de costo (por ejemplo, servidores locales
 * de Ollama o endpoints autohospedados), el costo resultante es 0.0, permitiendo que
 * estos modelos se prioricen naturalmente en tiers orientados a eficiencia económica.
 */
export function calculateModelCost(model: ModelWithCost): number {
  if (!model?.cost) return 0;
  const input = typeof model.cost.input === 'number' ? model.cost.input : 0;
  const output = typeof model.cost.output === 'number' ? model.cost.output : 0;
  return Number((input * 0.75 + output * 0.25).toFixed(4));
}
