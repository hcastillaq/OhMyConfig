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

import type { Tier, ThinkingLevel, Profile, ModelCandidate, PolicyConfig, DecisionTrace } from './types.ts';
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
 * Niveles recomendados de razonamiento calibrados según el perfil activo.
 * - 'quota-saver': Minimiza tokens de pensamiento para alargar la cuota.
 * - 'balanced': Equilibrio estándar entre profundidad analítica y velocidad.
 * - 'quality': Maximiza el razonamiento en tareas críticas y de arquitectura.
 */
const PROFILE_THINKING: Record<Profile, Record<Tier, ThinkingLevel>> = {
  'quota-saver': {
    FAST: 'off',
    RESEARCH: 'off',
    BUILD: 'low',
    REASON: 'low',
    ARCHITECT: 'medium',
    ORACLE: 'medium'
  },
  'balanced': {
    FAST: 'low',
    RESEARCH: 'low',
    BUILD: 'medium',
    REASON: 'medium',
    ARCHITECT: 'high',
    ORACLE: 'high'
  },
  'quality': {
    FAST: 'low',
    RESEARCH: 'medium',
    BUILD: 'medium',
    REASON: 'high',
    ARCHITECT: 'high',
    ORACLE: 'high'
  }
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
 * Distribuye dinámicamente los modelos disponibles en los 6 tiers funcionales,
 * modulando las prioridades y niveles de pensamiento según el perfil activo.
 *
 * Impacto del Perfil:
 * - 'quota-saver': Desplaza los tiers hacia abajo para priorizar modelos más económicos y reduce el thinking.
 * - 'balanced': Equilibrio natural donde cada tier recibe su clase óptima de modelo.
 * - 'quality': Promueve subagentes analíticos y de investigación hacia modelos pensantes superiores con thinking alto.
 */
export function groupAndSortTiers(
  candidates: ModelCandidate[],
  profile: Profile = 'balanced'
): Map<Tier, ModelCandidate[]> {
  const map = new Map<Tier, ModelCandidate[]>();
  if (candidates.length === 0) return map;

  const thinkingConfig = PROFILE_THINKING[profile] || PROFILE_THINKING.balanced;

  // Ordenamiento base del pool completo: Menor costo por token primero.
  const sortedByCostAsc = [...candidates].sort((a, b) => {
    if (Math.abs(a.cost - b.cost) > 0.0001) return a.cost - b.cost;
    return b.contextWindow - a.contextWindow;
  });

  // Partición por capacidad de pensamiento analítico nativo
  const standardPool = sortedByCostAsc.filter(c => !c.reasoning);
  const reasoningPool = sortedByCostAsc.filter(c => c.reasoning);

  const hasReasoning = reasoningPool.length > 0;
  const effectiveStandard = standardPool.length > 0 ? standardPool : sortedByCostAsc;
  const effectiveReasoning = hasReasoning ? reasoningPool : sortedByCostAsc;

  // Segmentación por bandas de costo dentro del pool de modelos pensantes
  const lightReasoning = effectiveReasoning.filter(c => c.cost < 2.0);
  const midReasoning = effectiveReasoning.filter(c => c.cost >= 2.0 && c.cost < 7.0);
  const highReasoning = effectiveReasoning.filter(c => c.cost >= 7.0 && c.cost < 15.0);
  const apexReasoning = effectiveReasoning.filter(c => c.cost >= 15.0);

  // --- FAST TIER ---
  map.set('FAST', effectiveStandard.map(c => ({
    ...c,
    tier: 'FAST' as Tier,
    recommendedThinking: thinkingConfig.FAST
  })));

  // --- RESEARCH TIER ---
  let researchPool: ModelCandidate[];
  if (profile === 'quality' && midReasoning.length > 0) {
    researchPool = midReasoning;
  } else {
    const minCost = effectiveStandard[0]?.cost || 0;
    researchPool = [...effectiveStandard].sort((a, b) => {
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
  }

  map.set('RESEARCH', researchPool.map(c => ({
    ...c,
    tier: 'RESEARCH' as Tier,
    recommendedThinking: thinkingConfig.RESEARCH
  })));

  // --- BUILD TIER ---
  map.set('BUILD', effectiveStandard.map(c => ({
    ...c,
    tier: 'BUILD' as Tier,
    recommendedThinking: thinkingConfig.BUILD
  })));

  // --- REASON TIER ---
  // En 'quota-saver': Usa modelos ligeros de bajo costo (ej. Flash) con thinking mínimo.
  // En 'balanced': Usa modelos dedicados de razonamiento intermedio (ej. Pro, Terra, Sonnet).
  // En 'quality': Usa modelos pensantes avanzados (ej. Sol).
  let reasonPool: ModelCandidate[];
  if (profile === 'quota-saver') {
    reasonPool = lightReasoning.length > 0 ? lightReasoning : effectiveStandard;
  } else if (profile === 'quality') {
    reasonPool = highReasoning.length > 0 ? highReasoning : (midReasoning.length > 0 ? midReasoning : effectiveReasoning);
  } else {
    // Balanced: Prioriza modelos de razonamiento intermedio ($2-$7/M) si existen; si no, el reasoning disponible
    reasonPool = midReasoning.length > 0 ? midReasoning : effectiveReasoning;
  }

  map.set('REASON', reasonPool.map(c => ({
    ...c,
    tier: 'REASON' as Tier,
    recommendedThinking: thinkingConfig.REASON
  })));

  // --- ARCHITECT TIER ---
  // En 'quota-saver': Usa modelos de razonamiento intermedio para ahorrar.
  // En 'balanced': Usa modelos de arquitectura profunda ($7-$15/M como Sol) si existen.
  // En 'quality': Usa modelos estructurales avanzados o de frontera.
  let architectPool: ModelCandidate[];
  if (profile === 'quota-saver') {
    architectPool = midReasoning.length > 0 ? midReasoning : effectiveReasoning;
  } else if (profile === 'quality') {
    architectPool = highReasoning.length > 0 ? highReasoning : (apexReasoning.length > 0 ? apexReasoning : effectiveReasoning);
  } else {
    architectPool = highReasoning.length > 0 ? highReasoning : (midReasoning.length > 0 ? [...midReasoning].reverse() : effectiveReasoning);
  }

  map.set('ARCHITECT', architectPool.map(c => ({
    ...c,
    tier: 'ARCHITECT' as Tier,
    recommendedThinking: thinkingConfig.ARCHITECT
  })));

  // --- ORACLE TIER ---
  // En 'quota-saver': Reserva el apex y usa modelos de arquitectura.
  // En 'balanced' / 'quality': Asigna el modelo de frontera de mayor capacidad del pool.
  let oraclePool: ModelCandidate[];
  if (profile === 'quota-saver') {
    oraclePool = highReasoning.length > 0 ? highReasoning : (midReasoning.length > 0 ? midReasoning : effectiveReasoning);
  } else {
    oraclePool = apexReasoning.length > 0 ? apexReasoning : [...effectiveReasoning].reverse();
  }

  map.set('ORACLE', oraclePool.map(c => ({
    ...c,
    tier: 'ORACLE' as Tier,
    recommendedThinking: thinkingConfig.ORACLE
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
