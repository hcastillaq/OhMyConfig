import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import * as os from "node:os";
import type { Tier, PolicyConfig, DecisionTrace } from "./types.ts";
import { classifySubagent } from "./classifier.ts";
import { buildModelCandidates, groupAndSortTiers, resolveModelForTier } from "./models.ts";
import { CircuitBreaker } from "./breaker.ts";

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
        // Silently continue if parsing fails
      }
    }
  }

  return { profile: "balanced" };
}

export default function piModelPolicy(pi: ExtensionAPI) {
  const breaker = new CircuitBreaker();
  const recentTraces = new Map<string, DecisionTrace>();

  // 1. In-flight tool interception (Pre-execution)
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "subagent") return;

    const input = event.input as {
      agent?: string;
      model?: string;
      task?: string;
      description?: string;
      tools?: string[];
    };

    // If caller explicitly provided a model, respect it (Bypass)
    if (!input || input.model || !input.agent) return;

    const config = loadConfig(ctx.cwd);
    const availableModels = ctx.modelRegistry ? ctx.modelRegistry.getAvailable() : [];
    if (availableModels.length === 0) return;

    const candidates = buildModelCandidates(availableModels);
    const tierMap = groupAndSortTiers(candidates);

    // Classify subagent
    const classification = classifySubagent(
      input.agent,
      input.description || "",
      input.tools || [],
      config.agents
    );

    // Approximate token count: ~4 chars per token
    const taskTokens = input.task ? Math.ceil(input.task.length / 4) : 0;

    // Resolve optimal candidate
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
      input.model = `${resolution.candidate.fullId}${thinkingSuffix}`;

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

  // 2. Telemetry and Rate-Limit Cooldown (Post-execution)
  pi.on("tool_result", async (event, ctx) => {
    if (event.toolName !== "subagent") return;

    const resultText =
      typeof event.result === "string"
        ? event.result
        : JSON.stringify(event.result || "");

    if (breaker.detectQuotaError(resultText)) {
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

  // 3. Slash Command for inspection and debugging
  pi.registerCommand("model-policy", {
    description: "Inspecciona y explica el enrutamiento inteligente de modelos para subagentes",
    getArgumentCompletions: (prefix: string) => {
      const subcommands = ["status", "explain", "cooldowns", "help"];
      const matches = subcommands.filter((cmd) => cmd.startsWith(prefix));
      return matches.length > 0 ? matches.map((m) => ({ value: m, label: m })) : null;
    },
    handler: async (args: string, ctx: ExtensionContext) => {
      const parts = args.trim().split(/\s+/);
      const subcmd = parts[0] || "status";
      const config = loadConfig(ctx.cwd);
      const availableModels = ctx.modelRegistry ? ctx.modelRegistry.getAvailable() : [];
      const candidates = buildModelCandidates(availableModels);
      const tierMap = groupAndSortTiers(candidates);

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
          lines.push("⚠️  Proveedores en enfriamiento temporal (Cooldown):");
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

      if (subcmd === "explain") {
        const targetAgent = parts[1];
        if (!targetAgent) {
          if (ctx.ui?.notify) {
            ctx.ui.notify("Uso: /model-policy explain <nombre-del-agente>", "warning");
          }
          return;
        }

        // Trace from memory or simulate on the fly
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

      if (subcmd === "cooldowns") {
        const active = breaker.getActiveCooldowns();
        if (active.length === 0) {
          if (ctx.ui?.notify) ctx.ui.notify("No hay proveedores en cooldown en este momento.", "info");
          return;
        }
        const lines = ["Proveedores en Cooldown:", ...active.map((a) => `• ${a.target}: ${a.remainingSec}s`)];
        if (ctx.ui?.notify) ctx.ui.notify(lines.join("\n"), "warning");
        return;
      }

      // Help
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
