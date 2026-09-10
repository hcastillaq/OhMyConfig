/**
 * Orquestador Dinámico de Modelos y Resolución Relativa de Tiers.
 *
 * Principio Fundamental: Autodescubrimiento Puro sin Datos Quemados.
 *
 * Esta capa no mantiene listas de nombres de modelos comerciales ni umbrales
 * fijos de precios en dólares. En su lugar, analiza en tiempo de ejecución el catálogo
 * real de modelos que el usuario tiene autenticados en su sesión de Pi (`ctx.modelRegistry`)
 * y los particiona matemáticamente utilizando tres señales nativas provistas por el harness:
 *
 * 1. `reasoning: boolean` -> Separa modelos estándar de modelos con pensamiento analítico.
 * 2. `cost: { input, output }` -> Permite ordenar de menor a mayor costo real por millón de tokens.
 * 3. `contextWindow: number` -> Habilita la promoción automática ante tareas con payloads masivos.
 *
 * Invariante de No-Escalado Ascendente:
 * Cuando un modelo falla o entra en rate-limit, la degradación de fallback busca siempre
 * candidatos de igual o menor costo dentro del tier o en tiers inferiores. Nunca escala
 * hacia modelos más caros para salvaguardar el presupuesto del usuario de forma predecible.
 */

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

/**
 * Niveles recomendados de razonamiento por tier de capacidad.
 * Tiers de alta abstracción reciben mayor profundidad de pensamiento.
 */
const DEFAULT_THINKING_PER_TIER: Record<Tier, ThinkingLevel> = {
  FAST: 'low',
  RESEARCH: 'low',
  BUILD: 'medium',
  REASON: 'medium',
  ARCHITECT: 'high',
  ORACLE: 'high'
};

/**
 * Normaliza los modelos del registro activo de Pi en candidatos evaluables.
 */
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
      tier: 'FAST', // Se asignará dinámicamente según el rol en groupAndSortTiers
      cost,
      reasoning,
      contextWindow,
      recommendedThinking: 'off'
    };
  });
}

/**
 * Distribuye dinámicamente los modelos disponibles en los 6 tiers funcionales.
 *
 * Lógica de Asignación:
 * - FAST: Modelos estándar ordenados estrictamente por menor costo.
 * - RESEARCH: Modelos estándar ordenados favoreciendo mayor ventana de contexto a costo accesible.
 * - BUILD: Modelos estándar para ejecución de código y desarrollo.
 * - REASON: El modelo con capacidad de razonamiento de menor costo (análisis eficiente).
 * - ARCHITECT: Modelos con razonamiento en el percentil superior (planificación estructural).
 * - ORACLE: El modelo de mayor capacidad/costo en el pool de razonamiento (modelo de frontera).
 */
export function groupAndSortTiers(
  candidates: ModelCandidate[]
): Map<Tier, ModelCandidate[]> {
  const map = new Map<Tier, ModelCandidate[]>();
  if (candidates.length === 0) return map;

  // Ordenamiento base del pool completo: Menor costo por token primero.
  // En caso de empate de costo, se prefiere la ventana de contexto más amplia.
  const sortedByCostAsc = [...candidates].sort((a, b) => {
    if (Math.abs(a.cost - b.cost) > 0.0001) return a.cost - b.cost;
    return b.contextWindow - a.contextWindow;
  });

  // Partición por capacidad de pensamiento analítico nativo
  const standardPool = sortedByCostAsc.filter(c => !c.reasoning);
  const reasoningPool = sortedByCostAsc.filter(c => c.reasoning);

  // Adaptabilidad: Si el usuario carece de modelos pensantes (ej. solo modelos locales ligeros),
  // el pool completo ordenado por costo asume ambos roles sin quebrar la ejecución.
  const hasReasoning = reasoningPool.length > 0;
  const effectiveStandard = standardPool.length > 0 ? standardPool : sortedByCostAsc;
  const effectiveReasoning = hasReasoning ? reasoningPool : sortedByCostAsc;

  // --- FAST TIER ---
  // Modelos de respuesta rápida y mínimo costo por token para sondeos y scouts.
  map.set('FAST', effectiveStandard.map(c => ({
    ...c,
    tier: 'FAST' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.FAST
  })));

  // --- RESEARCH TIER ---
  // Tareas de investigación y rastreo documental; prioriza ventanas grandes de contexto
  // en el segmento económico. Para garantizar ordenamiento transitivo y estable en TimSort,
  // la tolerancia de costo se ancla rígidamente al costo mínimo del pool base.
  const minCost = effectiveStandard[0]?.cost || 0;
  const researchSorted = [...effectiveStandard].sort((a, b) => {
    const aInBudget = (a.cost - minCost) <= 1.0;
    const bInBudget = (b.cost - minCost) <= 1.0;

    if (aInBudget && bInBudget) {
      if (b.contextWindow !== a.contextWindow) return b.contextWindow - a.contextWindow;
      return a.cost - b.cost;
    }
    if (aInBudget && !bInBudget) return -1;
    if (!aInBudget && bInBudget) return 1;
    return a.cost - b.cost;
  });
  map.set('RESEARCH', researchSorted.map(c => ({
    ...c,
    tier: 'RESEARCH' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.RESEARCH
  })));

  // --- BUILD TIER ---
  // Tareas de programación, aplicación de parches y ejecución de herramientas de sistema.
  map.set('BUILD', effectiveStandard.map(c => ({
    ...c,
    tier: 'BUILD' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.BUILD
  })));

  // --- REASON TIER ---
  // Revisiones lógicas, auditorías de seguridad y análisis crítico.
  // Selecciona el modelo con reasoning más económico para maximizar la duración de la cuota.
  map.set('REASON', effectiveReasoning.map(c => ({
    ...c,
    tier: 'REASON' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.REASON
  })));

  // --- ARCHITECT TIER ---
  // Tareas de arquitectura, diseño de sistemas y especificación.
  // Selecciona modelos de razonamiento profundo del segmento medio-alto,
  // excluyendo el modelo de frontera que queda reservado para ORACLE.
  let architectPool: ModelCandidate[];
  if (effectiveReasoning.length >= 3) {
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
  // Arbitraje final y consultas estratégicas de máxima complejidad.
  // Asigna el modelo de frontera de mayor capacidad y costo del pool.
  const oraclePool = [...effectiveReasoning].reverse();
  map.set('ORACLE', oraclePool.map(c => ({
    ...c,
    tier: 'ORACLE' as Tier,
    recommendedThinking: DEFAULT_THINKING_PER_TIER.ORACLE
  })));

  return map;
}

/**
 * Resuelve el modelo óptimo, su nivel de thinking y su cadena de fallbacks para un tier.
 *
 * Flujo de Resolución:
 * 1. Comprueba overrides manuales del usuario.
 * 2. Comprueba si el volumen de tokens exige una ventana de contexto masiva (>30k tokens).
 * 3. Filtra modelos que se encuentren en período de enfriamiento por rate limits (429).
 * 4. Si el tier queda desierto por fallos, desciende ordenadamente hacia tiers inferiores (no-escalado).
 */
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

  // 1. Respeto a la configuración manual del usuario para este tier
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

  // 2. Promoción Dinámica por Ventana de Contexto (Regla R2.5)
  // Si la tarea transporta un payload masivo (>30k tokens), priorizamos un modelo
  // con ventana de 1M tokens para evitar errores de truncamiento en mitad de la ejecución.
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

  // 3. Selección dentro del tier solicitado omitiendo proveedores saturados
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

  // 4. Cadena de Fallback hacia Abajo (Preservación estricta de costos)
  // Si todos los modelos del tier están en cooldown, se busca en tiers inferiores.
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

  // 5. Último recurso: El modelo disponible más económico del registro
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
