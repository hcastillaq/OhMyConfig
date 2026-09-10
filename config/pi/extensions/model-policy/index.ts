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
    description: "Enrutador inteligente de modelos y cuotas para subagentes",
    getArgumentCompletions: (prefix: string) => {
      const cleanPrefix = prefix.trimStart();

      // Autocompletado de opciones para el subcomando 'profile'
      if (cleanPrefix.startsWith("profile")) {
        const subArg = cleanPrefix.slice("profile".length).trimStart();
        const profiles = [
          {
            value: "profile balanced",
            label: "balanced",
            description: "Modo equilibrado: balance óptimo calidad/costo (por defecto)"
          },
          {
            value: "profile quota-saver",
            label: "quota-saver",
            description: "Modo ahorro estricto: minimiza thinking y modelos costosos"
          },
          {
            value: "profile quality",
            label: "quality",
            description: "Modo producción: máxima precisión con thinking high"
          }
        ];
        const matches = profiles.filter(p => p.label.startsWith(subArg));
        return matches.length > 0 ? matches : profiles;
      }

      // Autocompletado de agentes comunes para el subcomando 'explain'
      if (cleanPrefix.startsWith("explain")) {
        const subArg = cleanPrefix.slice("explain".length).trimStart();
        const commonAgents = [
          { value: "explain ce-security-reviewer", label: "ce-security-reviewer", description: "Reviewer de seguridad (Tier REASON)" },
          { value: "explain ce-correctness-reviewer", label: "ce-correctness-reviewer", description: "Reviewer de correctitud (Tier REASON)" },
          { value: "explain ce-architecture-strategist", label: "ce-architecture-strategist", description: "Estratega de arquitectura (Tier ARCHITECT)" },
          { value: "explain ce-git-history-analyzer", label: "ce-git-history-analyzer", description: "Analista de historial (Tier RESEARCH)" },
          { value: "explain worker", label: "worker", description: "Implementador de código (Tier BUILD)" },
          { value: "explain scout", label: "scout", description: "Explorador rápido de archivos (Tier FAST)" },
          { value: "explain oracle", label: "oracle", description: "Árbitro y consejo de frontera (Tier ORACLE)" }
        ];
        const matches = commonAgents.filter(a => a.label.startsWith(subArg));
        return matches.length > 0 ? matches : commonAgents;
      }

      // Autocompletado de subcomandos principales
      const subcommands = [
        {
          value: "status",
          label: "status",
          description: "Muestra la tabla de los 6 tiers, modelos y fallbacks"
        },
        {
          value: "profile",
          label: "profile",
          description: "Consulta o cambia el perfil activo (balanced, quota-saver, quality)"
        },
        {
          value: "explain",
          label: "explain",
          description: "Muestra la traza de decisión y reglas para un subagente"
        },
        {
          value: "cooldowns",
          label: "cooldowns",
          description: "Lista proveedores en enfriamiento temporal por rate-limits (429)"
        },
        {
          value: "help",
          label: "help",
          description: "Muestra la guía completa de comandos y opciones"
        }
      ];

      const matches = subcommands.filter(cmd => cmd.label.startsWith(cleanPrefix));
      return matches.length > 0 ? matches : subcommands;
    },
    handler: async (args: string, ctx: ExtensionContext) => {
      const parts = args.trim().split(/\s+/);
      const subcmd = parts[0] || "help";
      const config = loadConfig(ctx.cwd);
      if (activeProfileOverride) {
        config.profile = activeProfileOverride;
      }
      const availableModels = ctx.modelRegistry ? ctx.modelRegistry.getAvailable() : [];
      const candidates = buildModelCandidates(availableModels);
      const tierMap = groupAndSortTiers(candidates, config.profile);

      // --- COMANDO: status ---
      if (subcmd === "status") {
        const pad = (str: string, len: number) => String(str || "").padEnd(len);
        const formatWindow = (tokens: number) => {
          if (tokens >= 1000000) return `${(tokens / 1000000).toFixed(1)}M`;
          if (tokens >= 1000) return `${Math.round(tokens / 1000)}K`;
          return `${tokens}`;
        };

        const formatFallbacksSummary = (chain: string[]): string => {
          if (!chain || chain.length <= 1) return "(ninguno)";
          const fallbacks = chain.slice(1);
          const shortNames = fallbacks.map(f => f.includes("/") ? f.split("/")[1] : f);
          if (shortNames.length <= 2) {
            return shortNames.join(", ");
          }
          const remaining = shortNames.length - 2;
          return `${shortNames[0]}, ${shortNames[1]} (+${remaining})`;
        };

        const lines: string[] = [];
        const uniqueProviders = Array.from(new Set(availableModels.map(m => m.provider))).join(", ") || "(ninguno)";

        lines.push("Pi Model Policy — Estado de Enrutamiento de Subagentes");
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");
        lines.push(`Perfil activo: ${config.profile || "balanced"} · Modelos disponibles: ${availableModels.length} · Proveedores: ${uniqueProviders}`);
        lines.push("");

        // SECCIÓN 1: Asignación Activa de Tiers
        lines.push("1. ASIGNACIÓN ACTIVA POR TIERS");
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");
        lines.push(
          pad("Tier", 11) +
          pad("Proveedor", 15) +
          pad("Modelo Primario", 24) +
          pad("Thinking", 11) +
          pad("Costo", 10) +
          "Cadena de Fallbacks"
        );
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");

        const tiers: Tier[] = ["FAST", "RESEARCH", "BUILD", "REASON", "ARCHITECT", "ORACLE"];
        for (const tier of tiers) {
          const res = resolveModelForTier(tier, tierMap, breaker, 0, config);
          const provider = res.candidate ? res.candidate.provider : "—";
          const modelId = res.candidate ? res.candidate.id : "(sin modelo)";
          const thinking = res.candidate?.recommendedThinking || "off";
          const cost = res.candidate ? `$${res.candidate.cost.toFixed(2)}/M` : "N/A";
          const fallbacksStr = formatFallbacksSummary(res.chain);

          lines.push(
            pad(tier, 11) +
            pad(provider, 15) +
            pad(modelId, 24) +
            pad(thinking, 11) +
            pad(cost, 10) +
            fallbacksStr
          );
        }

        // SECCIÓN 2: Catálogo de Modelos Autodescubiertos
        lines.push("");
        lines.push(`2. CATÁLOGO DE MODELOS AUTODESCUBIERTOS (${availableModels.length})`);
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");
        lines.push(
          pad("Proveedor", 15) +
          pad("Modelo", 24) +
          pad("Categoría", 26) +
          pad("Costo / M", 12) +
          "Ventana"
        );
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");

        const sortedCandidates = [...candidates].sort((a, b) => {
          if (a.provider !== b.provider) return a.provider.localeCompare(b.provider);
          return a.cost - b.cost;
        });

        for (const c of sortedCandidates) {
          let category = "Estándar (Fast/Build)";
          if (c.cost >= 15.0 || (!c.cost && c.reasoning && c.contextWindow <= 64000)) {
            category = "Frontera (Oracle)";
          } else if (c.cost >= 7.0 && c.reasoning) {
            category = "Estructural (Architect)";
          } else if (c.cost >= 2.0 && c.reasoning) {
            category = "Pensante (Reasoning)";
          } else if (c.contextWindow >= 1000000) {
            category = "Estándar (1.0M Context)";
          } else if (c.reasoning) {
            category = "Pensante Ligero (Reasoning)";
          }

          const costStr = c.cost > 0 ? `$${c.cost.toFixed(2)}` : "Gratis ($0)";
          const windowStr = formatWindow(c.contextWindow);

          lines.push(
            pad(c.provider, 15) +
            pad(c.id, 24) +
            pad(category, 26) +
            pad(costStr, 12) +
            windowStr
          );
        }

        // SECCIÓN 3: Estado de Salud y Enfriamientos
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");
        const activeCooldowns = breaker.getActiveCooldowns();
        if (activeCooldowns.length > 0) {
          lines.push("Proveedores en enfriamiento temporal (Cooldown activo por 429/cuota):");
          for (const cd of activeCooldowns) {
            lines.push(`   • ${cd.target.padEnd(16)} : ${cd.remainingSec}s restantes`);
          }
        } else {
          lines.push("Salud: Todos los proveedores saludables (sin rate-limits ni bloqueos activos).");
        }
        lines.push("───────────────────────────────────────────────────────────────────────────────────────────────────");

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
          const err = "Uso: /model-policy explain <nombre-del-agente>\nEjemplo: /model-policy explain ce-security-reviewer";
          if (ctx.ui?.notify) ctx.ui.notify(err, "warning");
          else console.log(err);
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
        lines.push(`Árbol de Decisión: ${trace.agentName}`);
        lines.push("────────────────────────────────────────────────────────────────────────");
        lines.push(`1. Perfil activo         : ${config.profile || "balanced"}`);
        lines.push(`2. Clasificación de Tier : ${trace.tier}`);
        lines.push(`   Motivo                : ${trace.reason}`);
        lines.push(`   Fuente de regla       : ${trace.ruleSource}`);
        lines.push(`3. Modelo Asignado       : ${trace.selectedModel}`);
        lines.push(`   Nivel de Thinking     : ${trace.thinkingLevel}`);
        lines.push(`4. Cadena de Fallbacks   : ${trace.candidateChain.join(" → ") || "(ninguno)"}`);
        if (trace.cooldownAvoided && trace.cooldownAvoided.length > 0) {
          lines.push(`5. Excluidos por 429     : ${trace.cooldownAvoided.join(", ")}`);
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
          const lines: string[] = [];
          lines.push("Pi Model Policy — Gestión de Perfil de Enrutamiento");
          lines.push("────────────────────────────────────────────────────────────────────────");
          lines.push(`Perfil actual: '${current}'`);
          lines.push("");
          lines.push("PERFILES DISPONIBLES:");
          lines.push("  • balanced    : Equilibrio óptimo entre calidad y consumo de créditos (recomendado).");
          lines.push("  • quota-saver : Máximo ahorro: reduce thinking a low/off y prioriza modelos económicos.");
          lines.push("  • quality     : Máxima precisión: eleva thinking a high y asigna modelos superiores.");
          lines.push("");
          lines.push("CÓMO CAMBIAR DE PERFIL:");
          lines.push("  /model-policy profile balanced");
          lines.push("  /model-policy profile quota-saver");
          lines.push("  /model-policy profile quality");
          lines.push("────────────────────────────────────────────────────────────────────────");

          if (ctx.ui?.notify) ctx.ui.notify(lines.join("\n"), "info");
          else console.log(lines.join("\n"));
          return;
        }

        if (!validProfiles.includes(targetProfile)) {
          const err = `Perfil '${targetProfile}' no reconocido. Opciones válidas: ${validProfiles.join(", ")}`;
          if (ctx.ui?.notify) ctx.ui.notify(err, "warning");
          else console.log(err);
          return;
        }

        activeProfileOverride = targetProfile;
        const lines: string[] = [];
        lines.push(`Perfil cambiado exitosamente a '${targetProfile}'.`);
        lines.push(`La flota de subagentes ahora opera bajo la estrategia '${targetProfile}'.`);
        lines.push("Ejecuta '/model-policy status' para ver la nueva asignación de modelos y thinkings.");

        if (ctx.ui?.notify) ctx.ui.notify(lines.join("\n"), "info");
        else console.log(lines.join("\n"));
        return;
      }

      // --- COMANDO: cooldowns ---
      if (subcmd === "cooldowns") {
        const active = breaker.getActiveCooldowns();
        if (active.length === 0) {
          if (ctx.ui?.notify) ctx.ui.notify("No hay proveedores en cooldown en este momento. Todos saludables.", "info");
          else console.log("No hay proveedores en cooldown.");
          return;
        }
        const lines = [
          "Proveedores en Cooldown activo (10m por error 429/cuota):",
          "────────────────────────────────────────────────────────────────────────",
          ...active.map((a) => `  • ${a.target.padEnd(20)} : ${a.remainingSec}s restantes`),
          "────────────────────────────────────────────────────────────────────────"
        ];
        if (ctx.ui?.notify) ctx.ui.notify(lines.join("\n"), "warning");
        else console.log(lines.join("\n"));
        return;
      }

      // --- COMANDO: help (Manual explicativo completo) ---
      const help = [
        "Pi Model Policy — Enrutador Inteligente de Modelos para Subagentes",
        "────────────────────────────────────────────────────────────────────────",
        "COMANDOS DISPONIBLES:",
        "",
        "  /model-policy status",
        "      Muestra la tabla de los 6 tiers de capacidad, el modelo primario",
        "      asignado, nivel de thinking, costo estimado y cadena de fallbacks.",
        "",
        "  /model-policy profile [balanced | quota-saver | quality]",
        "      Consulta el perfil activo o cambia la postura de gasto y potencia:",
        "        • balanced    : Balance óptimo entre calidad y ahorro (predeterminado).",
        "        • quota-saver : Modo ahorro: minimiza tokens de thinking y prioriza modelos baratos.",
        "        • quality     : Modo producción: eleva thinking a high y usa modelos superiores.",
        "      Ejemplos:",
        "        /model-policy profile              (ver perfil actual y opciones)",
        "        /model-policy profile quota-saver  (activar modo ahorro de cuota)",
        "        /model-policy profile quality      (activar modo máxima calidad)",
        "",
        "  /model-policy explain <agente>",
        "      Muestra el árbol de decisión paso a paso para un subagente específico:",
        "      heurísticas aplicadas, tier resultante, desempate y modelo asignado.",
        "      Ejemplos:",
        "        /model-policy explain ce-security-reviewer",
        "        /model-policy explain worker",
        "        /model-policy explain scout",
        "",
        "  /model-policy cooldowns",
        "      Lista los proveedores en período de enfriamiento temporal (10m) debido a",
        "      errores 429 (rate-limits) o cuota agotada.",
        "",
        "  /model-policy help",
        "      Muestra este manual interactivo.",
        "────────────────────────────────────────────────────────────────────────"
      ].join("\n");

      if (ctx.ui?.notify) ctx.ui.notify(help, "info");
      else console.log(help);
    }
  });
}
