/**
 * Pi Model Policy — Punto de Entrada de la Extensión.
 *
 * Arquitectura de Integración:
 * 1. Hook Pre-Ejecución (`tool_call`): Intercepta llamadas al tool `subagent` justo antes
 *    de que el motor de Pi despache el proceso hijo. Al mutar directamente `event.input.model`,
 *    la extensión inyecta el modelo óptimo sin parchar el código fuente de `pi-subagents`,
 *    sin tocar dependencias de npm y respetando cualquier modelo que el usuario haya especificado
 *    manualmente en su prompt (bypass intencional).
 * 2. Hook Post-Ejecución (`tool_result`): Monitorea de forma no invasiva los resultados
 *    de subagentes. Solo si la ejecución concluyó en fallo (`isError: true`), analiza si el motivo
 *    corresponde a saturación de cuota o rate limits (429/503), activando un período de enfriamiento
 *    temporal para ese proveedor en el Circuit Breaker.
 * 3. Comandos TUI (`/model-policy`): Ofrece total transparencia y explicabilidad, permitiendo
 *    al desarrollador auditar en cualquier momento por qué un subagente recibió determinado modelo.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import * as os from "node:os";
import type { Tier, PolicyConfig, DecisionTrace } from "./types.ts";
import { classifySubagent } from "./classifier.ts";
import { buildModelCandidates, groupAndSortTiers, resolveModelForTier } from "./models.ts";
import { CircuitBreaker } from "./breaker.ts";

/**
 * Carga la configuración opcional del usuario con precedencia:
 * 1. Proyecto local: `.pi/model-policy.json`
 * 2. Configuración global de usuario: `~/.pi/agent/model-policy.json`
 * 3. Configuración por defecto: Perfil 'balanced' sin overrides.
 */
function loadConfig(cwd?: string): PolicyConfig {
  const locations: string[] = [];

  if (cwd) {
    locations.push(path.join(cwd, ".pi", "model-policy.json"));
  }
  locations.push(path.join(os.homedir(), ".pi", "agent", "model-policy.json"));

  for (const loc of locations) {
    if (fs.existsSync(loc)) {
      try {
        const content = fs.readFileSync(loc, "utf8");
        return JSON.parse(content);
      } catch {
        // En caso de error de sintaxis en el JSON, se ignora silenciosamente
        // para garantizar que la sesión de Pi jamás quede bloqueada.
      }
    }
  }

  return { profile: "balanced" };
}

export default function piModelPolicy(pi: ExtensionAPI) {
  const breaker = new CircuitBreaker();
  const recentTraces = new Map<string, DecisionTrace>();
  let activeProfileOverride: Profile | null = null;

  // ---------------------------------------------------------------------------
  // 1. Intercepción en Vuelo: Enrutamiento Transparente antes de Ejecutar
  // ---------------------------------------------------------------------------
  pi.on("tool_call", async (event, ctx) => {
    // Solo interceptamos herramientas que orquestan subagentes
    if (event.toolName !== "subagent") return;

    const input = event.input as {
      agent?: string;
      model?: string;
      task?: string;
      description?: string;
      tools?: string[];
    };

    // Si el invocador ya especificó un modelo explícito, se respeta la decisión
    // humana o del prompt sin intervenir (Principio de no-obstrucción).
    if (!input || input.model || !input.agent) return;

    const config = loadConfig(ctx.cwd);
    if (activeProfileOverride) {
      config.profile = activeProfileOverride;
    }
    const availableModels = ctx.modelRegistry ? ctx.modelRegistry.getAvailable() : [];
    if (availableModels.length === 0) return;

    // Autodescubrimiento de modelos y ordenamiento de tiers a partir del registro activo de Pi
    const candidates = buildModelCandidates(availableModels);
    const tierMap = groupAndSortTiers(candidates, config.profile);

    // Clasificación del rol funcional del subagente
    const classification = classifySubagent(
      input.agent,
      input.description || "",
      input.tools || [],
      config.agents
    );

    // Estimación rápida de volumen de tokens (~4 caracteres por token)
    // para activar la promoción a ventanas de 1M cuando el payload es masivo.
    const taskTokens = input.task ? Math.ceil(input.task.length / 4) : 0;

    // Resolución del modelo óptimo dentro del tier correspondiente
    const resolution = resolveModelForTier(
      classification.tier,
      tierMap,
      breaker,
      taskTokens,
      config
    );

    if (resolution.candidate) {
      const thinking = resolution.candidate.recommendedThinking;
      const thinkingSuffix = thinking && thinking !== "off" ? `:${thinking}` : "";

      // Mutación directa en memoria del input del tool antes de que pi-subagents lo ejecute
      input.model = `${resolution.candidate.fullId}${thinkingSuffix}`;

      // Registro acotado en memoria (FIFO, máx 50) para auditoría y diagnóstico
      if (recentTraces.size >= 50) {
        const firstKey = recentTraces.keys().next().value;
        if (firstKey) recentTraces.delete(firstKey);
      }

      recentTraces.set(input.agent, {
        agentName: input.agent,
        tier: classification.tier,
        reason: classification.reason,
        selectedModel: input.model,
        thinkingLevel: thinking,
        ruleSource: resolution.ruleSource,
        candidateChain: resolution.chain,
        cooldownAvoided: resolution.cooldownAvoided
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 2. Telemetría Post-Ejecución: Detección Inmune a Falsos Positivos
  // ---------------------------------------------------------------------------
  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "subagent") return;

    // Invariante crítico: Solo analizamos errores reales de ejecución de infraestructura.
    // Tareas exitosas que devuelvan código discutiendo '429' o 'overload' se ignoran.
    const eventAny = event as any;
    if (!eventAny.isError) return;

    let errorText = "";
    if (typeof eventAny.content === "string") {
      errorText = eventAny.content;
    } else if (Array.isArray(eventAny.content)) {
      errorText = eventAny.content.map((c: any) => c?.text || JSON.stringify(c)).join(" ");
    } else if (eventAny.details) {
      errorText = typeof eventAny.details === "string" ? eventAny.details : JSON.stringify(eventAny.details);
    }

    if (breaker.detectQuotaError(errorText, true)) {
      const input = event.input as { model?: string };
      if (input?.model) {
        const provider = input.model.split("/")[0];
        breaker.recordFailure(provider);
        if (ctx.ui?.notify) {
          ctx.ui.notify(
            `[Model Policy] Cooldown activado (10m) para proveedor '${provider}' por rate-limit/cuota.`,
            "warning"
          );
        }
      }
    }
  });

  // ---------------------------------------------------------------------------
  // 3. Comandos de Usuario: Explicabilidad y Diagnóstico en Terminal
  // ---------------------------------------------------------------------------
  pi.registerCommand("model-policy", {
    description: "Inspecciona y explica el enrutamiento inteligente de modelos para subagentes",
    getArgumentCompletions: (prefix: string) => {
      const subcommands = ["status", "explain", "profile", "cooldowns", "help"];
      const matches = subcommands.filter((cmd) => cmd.startsWith(prefix));
      return matches.length > 0 ? matches.map((m) => ({ value: m, label: m })) : null;
    },
    handler: async (args: string, ctx: ExtensionContext) => {
      const parts = args.trim().split(/\s+/);
      const subcmd = parts[0] || "status";
      const config = loadConfig(ctx.cwd);
      if (activeProfileOverride) {
        config.profile = activeProfileOverride;
      }
      const availableModels = ctx.modelRegistry ? ctx.modelRegistry.getAvailable() : [];
      const candidates = buildModelCandidates(availableModels);
      const tierMap = groupAndSortTiers(candidates, config.profile);

      // --- COMANDO: status ---
      if (subcmd === "status") {
        const lines: string[] = [];
        lines.push("⚡ Pi Model Policy — Estado de Enrutamiento de Subagentes");
        lines.push("────────────────────────────────────────────────────────────────────────");
        lines.push(`Perfil activo: ${config.profile || "balanced"} · Modelos descubiertos: ${availableModels.length}`);
        lines.push("");

        const tiers: Tier[] = ["FAST", "RESEARCH", "BUILD", "REASON", "ARCHITECT", "ORACLE"];
        for (const tier of tiers) {
          const res = resolveModelForTier(tier, tierMap, breaker, 0, config);
          const primary = res.candidate ? res.candidate.fullId : "(sin modelo disponible)";
          const thinking = res.candidate?.recommendedThinking || "off";
          const cost = res.candidate ? `$${res.candidate.cost.toFixed(2)}/M` : "N/A";
          const fallbacks = res.chain.slice(1).join(", ") || "(ninguno)";

          lines.push(`  ${tier.padEnd(10)} → ${primary.padEnd(32)} [${thinking}] (${cost})`);
          if (fallbacks !== "(ninguno)") {
            lines.push(`               Fallbacks: ${fallbacks}`);
          }
        }

        const activeCooldowns = breaker.getActiveCooldowns();
        if (activeCooldowns.length > 0) {
          lines.push("");
          lines.push("⚠️  Proveedores en enfriamiento temporal (Cooldown activo):");
          for (const cd of activeCooldowns) {
            lines.push(`   • ${cd.target}: ${cd.remainingSec}s restantes`);
          }
        }
        lines.push("────────────────────────────────────────────────────────────────────────");

        if (ctx.ui?.notify) {
          ctx.ui.notify(lines.join("\n"), "info");
        } else {
          console.log(lines.join("\n"));
        }
        return;
      }

      // --- COMANDO: explain <agent> ---
      if (subcmd === "explain") {
        const targetAgent = parts[1];
        if (!targetAgent) {
          if (ctx.ui?.notify) {
            ctx.ui.notify("Uso: /model-policy explain <nombre-del-agente>", "warning");
          }
          return;
        }

        let trace = recentTraces.get(targetAgent);
        if (!trace) {
          const classification = classifySubagent(targetAgent, "", [], config.agents);
          const res = resolveModelForTier(classification.tier, tierMap, breaker, 0, config);
          trace = {
            agentName: targetAgent,
            tier: classification.tier,
            reason: classification.reason,
            selectedModel: res.candidate
              ? `${res.candidate.fullId}:${res.candidate.recommendedThinking}`
              : "(sin modelo)",
            thinkingLevel: res.candidate?.recommendedThinking || "off",
            ruleSource: res.ruleSource,
            candidateChain: res.chain,
            cooldownAvoided: res.cooldownAvoided
          };
        }

        const lines: string[] = [];
        lines.push(`⚡ Árbol de Decisión: ${trace.agentName}`);
        lines.push("────────────────────────────────────────────────────────────────────────");
        lines.push(`1. Clasificación de Tier : ${trace.tier}`);
        lines.push(`   Motivo                : ${trace.reason}`);
        lines.push(`   Fuente de regla       : ${trace.ruleSource}`);
        lines.push(`2. Modelo Asignado       : ${trace.selectedModel}`);
        lines.push(`   Nivel de Thinking     : ${trace.thinkingLevel}`);
        lines.push(`3. Cadena de Fallbacks   : ${trace.candidateChain.join(" → ") || "(ninguno)"}`);
        if (trace.cooldownAvoided && trace.cooldownAvoided.length > 0) {
          lines.push(`4. Excluidos por 429     : ${trace.cooldownAvoided.join(", ")}`);
        }
        lines.push("────────────────────────────────────────────────────────────────────────");

        if (ctx.ui?.notify) {
          ctx.ui.notify(lines.join("\n"), "info");
        } else {
          console.log(lines.join("\n"));
        }
        return;
      }

      // --- COMANDO: profile [name] ---
      if (subcmd === "profile") {
        const targetProfile = parts[1] as Profile | undefined;
        const validProfiles: Profile[] = ["balanced", "quota-saver", "quality"];

        if (!targetProfile) {
          const current = config.profile || "balanced";
          const msg = `Perfil activo actual: '${current}'. Perfiles disponibles: ${validProfiles.join(", ")}`;
          if (ctx.ui?.notify) ctx.ui.notify(msg, "info");
          else console.log(msg);
          return;
        }

        if (!validProfiles.includes(targetProfile)) {
          const err = `Perfil '${targetProfile}' no reconocido. Opciones válidas: ${validProfiles.join(", ")}`;
          if (ctx.ui?.notify) ctx.ui.notify(err, "warning");
          else console.log(err);
          return;
        }

        activeProfileOverride = targetProfile;
        const successMsg = `⚡ Perfil cambiado a '${targetProfile}' para la sesión actual. Ejecuta /model-policy status para ver la nueva distribución.`;
        if (ctx.ui?.notify) ctx.ui.notify(successMsg, "info");
        else console.log(successMsg);
        return;
      }

      // --- COMANDO: cooldowns ---
      if (subcmd === "cooldowns") {
        const active = breaker.getActiveCooldowns();
        if (active.length === 0) {
          if (ctx.ui?.notify) ctx.ui.notify("No hay proveedores en cooldown en este momento.", "info");
          return;
        }
        const lines = ["Proveedores en Cooldown activo:", ...active.map((a) => `• ${a.target}: ${a.remainingSec}s`)];
        if (ctx.ui?.notify) ctx.ui.notify(lines.join("\n"), "warning");
        return;
      }

      // --- COMANDO: help ---
      const help = [
        "Comandos de /model-policy:",
        "  /model-policy status          - Muestra la tabla de tiers activos y modelos asignados",
        "  /model-policy explain <agent> - Explica la decisión y reglas aplicadas a un subagente",
        "  /model-policy cooldowns       - Lista los proveedores en cooldown por rate-limits",
        "  /model-policy help            - Muestra esta ayuda"
      ].join("\n");

      if (ctx.ui?.notify) ctx.ui.notify(help, "info");
    }
  });
}
