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

  // 1. Explicit user override
  if (overrides && overrides[agentName]?.tier) {
    return {
      tier: overrides[agentName].tier!,
      reason: `Configuración explícita para '${agentName}'`,
      ruleSource: 'override'
    };
  }

  // 2. ORACLE Check (Restricted: only explicit name matches)
  if (/\b(oracle|advisor)\b/.test(normName)) {
    return {
      tier: 'ORACLE',
      reason: "Nombre del agente coincide con rol 'oracle' o 'advisor'",
      ruleSource: 'name-heuristic'
    };
  }

  // 3. ARCHITECT Check
  if (/architect|strategist|planner|spec|proposal|design/.test(normName) ||
      /architecture|strategic planning|system design/.test(normDesc)) {
    return {
      tier: 'ARCHITECT',
      reason: "Heurística de arquitectura, estrategia o planificación",
      ruleSource: 'name-heuristic'
    };
  }

  // 4. REASON Check (Reviewers, Security, Audits, Verification)
  if (/reviewer|security|correctness|reliability|audit|maintainability|coherence|feasibility|risk|judge|verify|lens|evaluat/.test(normName) ||
      /code review|security audit|adversarial review|correctness/.test(normDesc)) {
    return {
      tier: 'REASON',
      reason: "Heurística de revisión crítica, auditoría o verificación lógica",
      ruleSource: 'name-heuristic'
    };
  }

  // 5. BUILD Check (Implementation, Coding, Writing, Execution)
  if (/worker|coder|developer|implementer|fix|builder|apply|writer/.test(normName) ||
      /implement|write code|apply changes/.test(normDesc)) {
    return {
      tier: 'BUILD',
      reason: "Heurística de desarrollo, implementación o edición de código",
      ruleSource: 'name-heuristic'
    };
  }

  // 6. RESEARCH Check (Repo analysis, docs, search, history)
  if (/research|history|docs|repo|analyst|learn|session-hist/.test(normName) ||
      /research|search history|documentation|gather context/.test(normDesc)) {
    return {
      tier: 'RESEARCH',
      reason: "Heurística de investigación, rastreo documental o análisis de historial",
      ruleSource: 'name-heuristic'
    };
  }

  // 7. FAST Check
  if (/scout|quick|fast|recon/.test(normName)) {
    return {
      tier: 'FAST',
      reason: "Heurística de exploración rápida (scout/recon)",
      ruleSource: 'name-heuristic'
    };
  }

  // 8. Tool Privileges Inspection
  const toolSet = new Set(tools.map(t => t.toLowerCase()));
  if (toolSet.has('write') || toolSet.has('edit') || toolSet.has('bash')) {
    return {
      tier: 'BUILD',
      reason: "Herramientas de modificación declaradas (write/edit/bash)",
      ruleSource: 'tool-heuristic'
    };
  }

  if (toolSet.has('read') || toolSet.has('grep') || toolSet.has('find')) {
    return {
      tier: 'RESEARCH',
      reason: "Herramientas exclusivas de lectura e inspección",
      ruleSource: 'tool-heuristic'
    };
  }

  // 9. Deterministic safe default (Cheap by default)
  return {
    tier: 'FAST',
    reason: "Agente desconocido sin heurísticas concluyentes (cheap by default)",
    ruleSource: 'default'
  };
}
