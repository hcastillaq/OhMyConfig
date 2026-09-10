/**
 * Motor de Clasificación Heurística de Subagentes.
 *
 * Propósito e Invariantes:
 * 1. Desacoplamiento de Roles y Nombres: Clasifica la naturaleza del trabajo que realiza
 *    cada subagente en 6 tiers de capacidad funcional (FAST, RESEARCH, BUILD, REASON,
 *    ARCHITECT, ORACLE) sin asumir qué modelos existen en el sistema.
 * 2. Precedencia de Intención:
 *    - La configuración explícita del usuario siempre tiene prioridad absoluta sobre cualquier heurística.
 *    - Si no hay override, se analizan palabras clave semánticas en el nombre y la descripción.
 *    - Si el nombre es ambiguo o proviene de un plugin externo desconocido, se infiere su rol
 *      a partir de las herramientas que solicita: herramientas mutadoras de código/sistema
 *      (write/edit/bash) asignan BUILD, mientras que herramientas de solo lectura asignan RESEARCH.
 * 3. Principio "Cheap by Default": Ante cualquier subagente desconocido sin heurísticas
 *    concluyentes, el sistema asigna determinísticamente el tier FAST. Se prohíbe taxativamente
 *    que un agente caiga por descarte en tiers costosos como ARCHITECT u ORACLE sin intención expresa.
 */

import type { Tier, PolicyConfig, DecisionTrace } from './types.ts';

export interface ClassificationResult {
  tier: Tier;
  reason: string;
  ruleSource: DecisionTrace['ruleSource'];
}

export function classifySubagent(
  agentName: string,
  description: string = '',
  tools: string[] = [],
  overrides?: PolicyConfig['agents']
): ClassificationResult {
  const normName = agentName.toLowerCase().trim();
  const normDesc = description.toLowerCase().trim();

  // Nivel 1: Respeto absoluto a la configuración del usuario
  if (overrides && overrides[agentName]?.tier) {
    return {
      tier: overrides[agentName].tier!,
      reason: `Configuración explícita del usuario para '${agentName}'`,
      ruleSource: 'override'
    };
  }

  // Nivel 2: Invariante de seguridad para el tier ORACLE
  // Solo agentes explícitamente diseñados como árbitros o consejeros de frontera
  // pueden recibir este tier; jamás se asigna por coincidencia parcial para proteger la cuota.
  if (/\b(oracle|advisor)\b/.test(normName)) {
    return {
      tier: 'ORACLE',
      reason: "Rol de arbitraje o consejo estratégico de frontera (oracle/advisor)",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 3: Identificación de tareas arquitectónicas y de planificación global
  // Se utilizan límites de palabra en tokens cortos como 'spec' para evitar falsos positivos
  // con subagentes como 'inspector', 'specialist' o 'perspective'.
  if (/\b(architect|strategist|planner|spec|specs|proposal|design)\b/.test(normName) ||
      /architect|strategist|planner|\bspec\b|proposal/.test(normName) ||
      /architecture|strategic planning|system design/.test(normDesc)) {
    return {
      tier: 'ARCHITECT',
      reason: "Diseño de sistemas, arquitectura o planificación de alto nivel",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 4: Tareas que demandan razonamiento crítico y verificación lógica
  if (/reviewer|security|correctness|reliability|audit|maintainability|coherence|feasibility|risk|judge|verify|lens|evaluat/.test(normName) ||
      /code review|security audit|adversarial review|correctness/.test(normDesc)) {
    return {
      tier: 'REASON',
      reason: "Revisión crítica de código, auditoría de seguridad o verificación lógica",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 5: Implementación activa, generación de código y mutación de archivos
  if (/worker|coder|developer|implementer|fix|builder|apply|writer/.test(normName) ||
      /implement|write code|apply changes/.test(normDesc)) {
    return {
      tier: 'BUILD',
      reason: "Desarrollo de software, edición de archivos o aplicación de parches",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 6: Recolección de contexto, lectura de repositorios y análisis histórico
  if (/research|history|docs|repo|analyst|learn|session-hist/.test(normName) ||
      /research|search history|documentation|gather context/.test(normDesc)) {
    return {
      tier: 'RESEARCH',
      reason: "Inspección documental, arqueología de git o investigación de contexto",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 7: Reconocimiento rápido y sondeos ligeros
  if (/scout|quick|fast|recon/.test(normName)) {
    return {
      tier: 'FAST',
      reason: "Exploración ultrarrápida y filtrado superficial (scout/recon)",
      ruleSource: 'name-heuristic'
    };
  }

  // Nivel 8: Inferencia por superficie de herramientas (Fallback para plugins desconocidos)
  // Si un subagente no coincide con patrones de nombre pero solicita ejecutar comandos
  // o modificar el disco, su tarea es inherentemente de construcción (BUILD).
  const toolSet = new Set(tools.map(t => t.toLowerCase()));
  if (toolSet.has('write') || toolSet.has('edit') || toolSet.has('bash')) {
    return {
      tier: 'BUILD',
      reason: "Capacidades de ejecución y mutación declaradas en herramientas (write/edit/bash)",
      ruleSource: 'tool-heuristic'
    };
  }

  if (toolSet.has('read') || toolSet.has('grep') || toolSet.has('find')) {
    return {
      tier: 'RESEARCH',
      reason: "Herramientas de inspección pasiva sin permisos de mutación",
      ruleSource: 'tool-heuristic'
    };
  }

  // Nivel 9: Red de seguridad económica estricta
  // Cualquier agente sin clasificación clara se enruta al modelo más económico disponible.
  return {
    tier: 'FAST',
    reason: "Agente no catalogado asignado al tier base de menor costo (cheap by default)",
    ruleSource: 'default'
  };
}
