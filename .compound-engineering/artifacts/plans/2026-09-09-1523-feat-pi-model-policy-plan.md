---
title: "Pi Model Policy — Enrutador Inteligente de Modelos para Subagentes"
artifact_contract: "ce-unified-plan/v1"
artifact_readiness: "implementation-ready"
product_contract_source: "ce-brainstorm"
execution: "code"
date: "2026-09-09"
---

# Goal Capsule

- **Objective:** Desarrollar una extensión para el ecosistema de Pi (`pi-model-policy`) que intercepte llamadas a subagentes en vuelo y asigne automáticamente el modelo y nivel de razonamiento (*thinking*) óptimo según la capacidad requerida por la tarea, resolviendo empates por menor costo por token y preservando cuotas sin escalado ascendente de costos.
- **Product Authority:** Decisión colaborativa de diseño entre el usuario y el asistente en sesión interactiva.
- **Open Blockers:** Ninguno.

---

# Product Contract

## Summary

Pi Model Policy desacopla la intención de trabajo de los nombres específicos de modelos. Introduce 6 tiers abstractos (`FAST`, `RESEARCH`, `BUILD`, `REASON`, `ARCHITECT`, `ORACLE`) que se pueblan automáticamente a partir de los modelos que el usuario tiene disponibles en su sesión de Pi (`ctx.modelRegistry.getAvailable()`). Al invocarse cualquier subagente (vía Compound Engineering, SDD o tool calls directas), la extensión clasifica el agente mediante heurísticas de nombre y permisos de herramientas, inyectando el modelo correspondiente de forma transparente antes de su ejecución.

## Problem Statement

1. **Sobreconsumo y quema de cuotas caras:** Sin un enrutador inteligente, los subagentes heredan el modelo de la sesión activa o configuraciones estáticas. Si la sesión principal corre en un modelo de frontera (ej. GPT-5.6 Sol o Claude Opus), lanzar un enjambre de 5 a 10 subagentes (como `ce-code-review`) multiplica el consumo de créditos premium en tareas de bajo requerimiento analítico.
2. **Subutilización y concentración en un solo proveedor:** Los desarrolladores suelen tener acceso a múltiples proveedores (OpenAI, Google/Antigravity, Anthropic), pero los subagentes saturan un solo proveedor hasta agotar la cuota o alcanzar rate limits (429), mientras otros proveedores permanecen ociosos.
3. **Fragilidad de configuraciones manuales:** Mantener un mapeo manual de decenas de subagentes en archivos de configuración es tedioso, no escala al instalar nuevas herramientas y se rompe cada vez que los proveedores actualizan nombres de modelos.

## Key Decisions

- `session-settled:cost-tie-breaker` **Desempate por menor costo por token:** Cuando múltiples modelos compiten por el mismo tier, el modelo con menor costo por millón de tokens (calculado a partir de una tabla de costos base de referencia) gana la posición primaria. Los demás forman la cadena ordenada de fallbacks.
- `session-settled:context-window-promotion` **Promoción dinámica por ventana de contexto:** Tareas con un payload estimado mayor a 30.000 tokens (estimado mediante heurística ligera de caracteres `Math.ceil(len / 4)` sin dependencias externas) se promueven automáticamente a modelos con ventanas masivas (ej. Gemini Flash con 1M de contexto) para prevenir errores de truncamiento.
- `session-settled:six-abstract-tiers` **6 Tiers de capacidad abstractos:** `FAST`, `RESEARCH`, `BUILD`, `REASON`, `ARCHITECT`, `ORACLE`. La extensión gestiona slots de capacidad en lugar de catálogos estáticos de nombres de modelos.
- `session-settled:zero-touch-interception` **Intercepción en vuelo con `pi.on("tool_call")` y telemetría en `tool_result`:** La extensión muta `event.input.model` en memoria de manera no invasiva antes de la ejecución. En `tool_result`, detecta errores 429/rate-limits para poner en cooldown al proveedor e informar las siguientes llamadas.
- `session-settled:no-upward-escalation` **Prohibición de escalado ascendente en fallos:** Si un modelo falla o entra en cooldown por rate limit, el fallback siempre se redirige a un modelo de igual o menor costo dentro del mismo tier o tiers inferiores, nunca hacia modelos reservados caros.
- `session-settled:hybrid-development-path` **Ruta de desarrollo híbrida:** Implementación inicial como extensión local dentro de OhMyConfig (`config/pi/extensions/model-policy/`) para validación y uso inmediato; desacoplamiento posterior a paquete independiente (`npm:pi-model-policy`).

## Scope Boundaries

### In Scope (MVP)

- **Clasificador heurístico de subagentes:** Detección de tier por palabras clave en el nombre (`scout` → FAST, `worker` → BUILD, `reviewer` → REASON, `architect` → ARCHITECT) y permisos de herramientas (agentes con `write`/`bash` → BUILD; solo `read`/`grep` → RESEARCH).
- **Auto-ordenamiento dinámico de modelos:** Inspección de `ctx.modelRegistry.getAvailable()` y asignación de modelos a tiers ordenados por costo relativo y soporte de *thinking*.
- **Hook de intercepción in-flight:** Detección de llamadas a `subagent` en `pi.on("tool_call")` e inyección de `${model}:${thinking}` cuando no exista modelo explícito.
- **Circuit breaker en memoria (`tool_result`):** Detección de errores 429 para exclusión temporal (10 min) del proveedor saturado.
- **Comando `/model-policy status`:** Visualización en terminal del mapeo activo de tiers, modelos asignados, niveles de *thinking* y fallbacks.
- **Comando `/model-policy explain <agent>`:** Árbol de decisión interactivo que detalla cómo se resolvió el modelo para un subagente específico.
- **Archivo de configuración opcional:** Soporte para overrides mínimos en `~/.pi/agent/model-policy.json` (fijar tiers específicos o agentes puntuales).

### Out of Scope (Post-MVP / Futuro)

- Circuit breaker persistente en disco entre diferentes sesiones (en el MVP la salud de proveedores se monitorea en memoria por sesión).
- Reescritura profunda de ASTs para scripts arbitrarios en `workflowScript`.
- Modelos locales en Ollama como fallback exclusivo por defecto (requieren configuración explícita del usuario).
- Benchmarking automático de latencia de red y ajuste de pesos en tiempo real.

## Requirements

### R1. Clasificación y Resolución de Subagentes
- **R1.1:** Ante una llamada al tool `subagent` sin parámetro `model`, el sistema debe clasificar el subagente en uno de los 6 tiers: `FAST`, `RESEARCH`, `BUILD`, `REASON`, `ARCHITECT`, `ORACLE`.
- **R1.2:** Si el usuario definió un override explícito para el agente en `model-policy.json`, el sistema debe aplicar esa regla con precedencia absoluta.
- **R1.3:** En ausencia de override, el sistema debe evaluar el nombre y descripción del agente mediante heurísticas de palabras clave:
  - `FAST`: `scout`, `search`, `quick`.
  - `RESEARCH`: `researcher`, `history`, `docs`, `repo`.
  - `BUILD`: `worker`, `coder`, `developer`, `implementer`, `fix`.
  - `REASON`: `reviewer`, `security`, `correctness`, `reliability`, `audit`.
  - `ARCHITECT`: `architect`, `strategist`, `planner`, `spec`.
  - `ORACLE`: Solo agentes explícitos con nombre `oracle` o `advisor`.
- **R1.4:** Si el nombre no es concluyente, el sistema debe inspeccionar las herramientas declaradas del agente:
  - Si declara herramientas de modificación/ejecución (`write`, `edit`, `bash`) → clasifica en `BUILD`.
  - Si solo declara herramientas de inspección (`read`, `grep`, `find`) → clasifica en `RESEARCH`.
- **R1.5:** Ante agentes totalmente desconocidos sin herramientas ni palabras clave concluyentes, el sistema debe asignar determinísticamente el tier `FAST` (*cheap by default*), nunca `ARCHITECT` ni `ORACLE`.

### R2. Asignación Dinámica de Modelos por Tier
- **R2.1:** Al inicializar la sesión, el sistema debe leer los modelos disponibles con autenticación activa mediante `ctx.modelRegistry.getAvailable()`.
- **R2.2:** Los modelos deben calificarse en los tiers correspondientes según sus metadatos y capacidades técnicas:
  - Modelos sin reasoning y bajo costo → califican para `FAST` y `RESEARCH`.
  - Modelos con soporte de herramientas de código y costo accesible → califican para `BUILD`.
  - Modelos con soporte nativo de razonamiento (`reasoning: true` o thinking configurable) → califican para `REASON` y `ARCHITECT`.
  - Modelos de frontera de máxima capacidad (ej. Astra, o3, Opus) → se reservan para `ORACLE`.
- **R2.3:** Si múltiples modelos califican para el mismo tier, el modelo de menor costo por millón de tokens (según la tabla de referencia de precios) debe ser asignado como primario.
- **R2.4:** Los modelos restantes que compartan el tier, seguidos de modelos elegibles de tiers inferiores de igual o menor costo, deben constituir la lista ordenada de fallbacks.
- **R2.5:** Si el prompt de la tarea del subagente supera los 30.000 tokens estimados (calculado como `Math.ceil(task.length / 4)` sin librerías externas), el sistema debe seleccionar el modelo disponible con mayor ventana de contexto dentro de los tiers viables.

### R3. Intercepción, Detección de Fallas y Ejecución No Invasiva
- **R3.1:** La extensión debe suscribirse al evento `pi.on("tool_call")` para la fase de pre-ejecución.
- **R3.2:** Cuando `event.toolName === "subagent"`, debe verificar si `event.input.model` ya está establecido por el invocador. Si ya está fijado, debe respetarlo (*bypass*).
- **R3.3:** Si `event.input.model` está vacío, debe mutar `event.input.model = "${resolvedModel}:${thinkingLevel}"` antes de que se inicie el subagente.
- **R3.4:** La extensión debe suscribirse al evento `pi.on("tool_result")` para la fase de post-ejecución.
- **R3.5:** Si el resultado de una invocación a `subagent` contiene un error 429 (Rate Limit), 503 (Overloaded) o cuota agotada, la extensión debe marcar al proveedor en un cooldown temporal en memoria (10 minutos), de modo que las llamadas subsiguientes dentro de la sesión utilicen automáticamente el siguiente modelo en la cadena de fallback.

### R4. Transparencia, Auditoría y Comandos de Usuario
- **R4.1:** El comando `/model-policy status` debe imprimir en terminal una tabla legible que liste los 6 tiers, el modelo primario asignado, el nivel de *thinking* y los fallbacks de respaldo.
- **R4.2:** El comando `/model-policy explain <agent>` debe mostrar la traza de decisión: nombre del agente, reglas activadas, tier resultante, desempate por costo y modelo final seleccionado.
- **R4.3:** Si el usuario proporciona un archivo de configuración en `~/.pi/agent/model-policy.json`, los comandos deben reflejar la procedencia de cada regla (automática vs. override de usuario).

## User Flows & Scenarios

### Flujo 1: Ejecución Automática Transparente (Happy Path)
1. El usuario ejecuta un comando de Compound Engineering como `ce-code-review`.
2. Compound Engineering dispara en paralelo `ce-security-reviewer` y `ce-correctness-reviewer`.
3. Pi Model Policy intercepta ambas llamadas antes de spawnear los subagentes.
4. Clasifica ambos en el tier `REASON`.
5. Consulta los modelos disponibles y resuelve el modelo óptimo de menor costo con thinking (ej. `openai-codex/gpt-5.6-terra:medium`).
6. Muta `event.input.model` en memoria.
7. Los subagentes se ejecutan eficientemente sin que el usuario tenga que ajustar nada.

### Flujo 2: Diagnóstico y Explicación
1. El usuario desea verificar qué modelo usará un subagente antes de lanzar una tarea masiva.
2. Ejecuta `/model-policy explain ce-architecture-strategist`.
3. La terminal muestra:
   - **Agente:** `ce-architecture-strategist`
   - **Clasificación:** `ARCHITECT` (heurística: keyword `architect`/`strategist`)
   - **Modelo Primario:** `openai-codex/gpt-5.6-sol` (thinking: `high`)
   - **Criterio de desempate:** Menor costo entre modelos con reasoning avanzado.
   - **Fallback disponible:** `antigravity/gemini-3.1-pro`.

## Success Criteria

1. **Cero configuración inicial:** Un usuario recién instalado puede activar la extensión y obtener un enrutamiento coherente de subagentes sin crear archivos de configuración.
2. **Ahorro verificable de cuota:** Workflows con múltiples subagentes dejan de heredar modelos de frontera (`Sol`, `Astra`, `Opus`) para tareas de búsqueda, edición rutinaria o revisión intermedia.
3. **Cero regresiones de compatibilidad:** Los workflows de `pi-subagents`, Compound Engineering y SDD continúan funcionando sin errores ni latencias perceptibles (>15ms por despacho).
4. **Explicabilidad total:** Cada decisión de modelo puede ser consultada y auditada en cualquier momento con `/model-policy explain`.

---

# Planning Contract

## Key Technical Decisions (KTDs)

- **KTD-1 (Architecture / Single Extension Directory):** Ubicar la implementación en `config/pi/extensions/model-policy/` estructurada modularmente en TypeScript puro sin transpilación en tiempo de build, cargada mediante `index.ts`.
- **KTD-2 (Hook Signatures):** Utilizar `isToolCallEventType("subagent", event)` para type-narrowing seguro de `event.input` dentro de `pi.on("tool_call")`.
- **KTD-3 (Pricing & Capability Oracle):** Implementar una tabla de precios base estática para las familias estándar (OpenAI Codex, Antigravity Gemini, Anthropic Claude) que mapee `provider/modelId` a costo ponderado por millón de tokens: `cost = (input_per_m * 0.75) + (output_per_m * 0.25)`. Si un modelo no está en la tabla, se infiere su costo relativo por palabras clave en su ID (`mini`/`flash` = bajo, `pro`/`sonnet` = medio, `opus`/`sol` = alto, `astra`/`o1` = ultra).
- **KTD-4 (In-Memory Circuit Breaker State):** Mantener un mapa `providerCooldowns: Map<string, number>` que registre la marca de tiempo de expiración (Unix epoch + 10 minutos). Si un modelo pertenece a un proveedor en cooldown, es omitido del selector de modelos activos.
- **KTD-5 (Zero External Dependencies):** La extensión utilizará únicamente los tipos exportados por `@earendil-works/pi-coding-agent`, sin paquetes npm externos pesados para garantizar compatibilidad offline instantánea.

## Technical Design & Component Architecture

```text
config/pi/extensions/model-policy/
├── index.ts          # Extension entrypoint, hooks (tool_call, tool_result), commands
├── types.ts          # Core domain types (Tier, ModelEntry, PolicyConfig, Trace)
├── pricing.ts        # Pricing oracle, reference costs, blended token price formula
├── classifier.ts     # Heuristic engine: agent name keywords + tool privilege detection
├── models.ts         # ctx.modelRegistry scanner, tier qualification, candidate sorting
└── breaker.ts        # In-memory circuit breaker & rate-limit cooldown manager
```

### Flujo de Datos entre Componentes

```text
  tool_call event
        │
        ▼
   [index.ts] ───────► [classifier.ts] ──► Determina Tier (FAST..ORACLE)
        │
        ├────────────► [breaker.ts]    ──► Filtra proveedores en cooldown
        │
        ├────────────► [models.ts]     ──► Consulta tiers activos y candidatos
        │                      │
        │                      ▼
        │              [pricing.ts]    ──► Ordena por menor costo por token
        │
        ▼
   event.input.model = "${resolvedModel}:${thinking}"
```

---

# Implementation Units

### U1: Tipos del Dominio y Catálogo de Costos Base
- **Goal:** Establecer las estructuras de datos, enums de tiers, configuración y catálogo de precios de referencia.
- **Files to create:**
  - `config/pi/extensions/model-policy/types.ts`
  - `config/pi/extensions/model-policy/pricing.ts`
- **Details:**
  - `types.ts`: Define `Tier = 'FAST' | 'RESEARCH' | 'BUILD' | 'REASON' | 'ARCHITECT' | 'ORACLE'`. Define `ModelCandidate`, `DecisionTrace`, `PolicyConfig`, `SubagentToolInput`.
  - `pricing.ts`: Tabla de costos estándar (precios de lista públicos por millón de tokens). Función `getBlendedCost(provider: string, modelId: string): number`. Heurística de fallback para modelos desconocidos.
- **Verification:** Script de prueba unitaria en Node/TypeScript que calcule y ordene correctamente costos de Luna, Gemini Flash, Terra, Sol y modelos desconocidos.

### U2: Motor de Clasificación Heurística de Subagentes
- **Goal:** Clasificar cualquier subagente en su tier óptimo según nombre, descripción y herramientas declaradas.
- **Files to create:**
  - `config/pi/extensions/model-policy/classifier.ts`
- **Details:**
  - Implementar `classifySubagent(agentName: string, description?: string, tools?: string[], overrides?: PolicyConfig['agents']): { tier: Tier; reason: string }`.
  - Prioridad 1: Override explícito en config.
  - Prioridad 2: Regex de palabras clave en `agentName` y `description`.
  - Prioridad 3: Inspección de herramientas (`write`/`edit`/`bash` → `BUILD`; solo `read`/`grep`/`find` → `RESEARCH`).
  - Prioridad 4: Fallback determinista a `FAST` (*cheap by default*).
- **Verification:** Pruebas con catálogo real de agentes de OhMyConfig (ej. `ce-security-reviewer`, `ce-git-history-analyzer`, `worker`, `scout`, `oracle`, agente desconocido).

### U3: Descubrimiento de Modelos, Calificación de Tiers y Desempate
- **Goal:** Leer el registro activo de Pi, calificar modelos en tiers y generar la lista ordenada de primario + fallbacks.
- **Files to create:**
  - `config/pi/extensions/model-policy/models.ts`
- **Details:**
  - Implementar `resolveActiveTiers(ctx: ExtensionContext, breaker: CircuitBreaker): Map<Tier, ModelCandidate[]>`.
  - Calificar modelos en tiers según `reasoning: boolean`, flags técnicas y costo.
  - Ordenar modelos por costo ascendente dentro de cada tier.
  - Implementar regla R2.5: Si `taskTokens > 30000`, priorizar modelos con `contextWindow >= 1000000` (ej. Gemini Flash).
  - Implementar selección de fallback respetando la regla `no-upward-escalation`.
- **Verification:** Mock de `modelRegistry` con combinaciones de OpenAI, Antigravity y Anthropic; verificar que Luna queda en FAST, Flash en BUILD, Terra en REASON, Sol en ARCHITECT, Astra en ORACLE.

### U4: Circuit Breaker y Detección de Errores 429
- **Goal:** Monitorear la salud de proveedores y registrar períodos de enfriamiento ante saturación de cuotas.
- **Files to create:**
  - `config/pi/extensions/model-policy/breaker.ts`
- **Details:**
  - Clase `CircuitBreaker` con métodos `recordFailure(provider: string)`, `isCoolingDown(provider: string): boolean`, `getCooldownRemaining(provider: string): number`.
  - Cooldown predeterminado de 10 minutos (600.000 ms).
  - Detección de patrones de error en strings de resultados: `429`, `rate limit`, `quota exceeded`, `resource exhausted`, `overloaded`.
- **Verification:** Test unitario que simule un fallo 429 para `openai-codex`, valide que pasa a cooldown y que tras expirar el tiempo vuelve a estar activo.

### U5: Punto de Entrada de la Extensión, Hooks y Comandos TUI
- **Goal:** Unificar los módulos en la extensión de Pi, registrar comandos y montar los hooks de ejecución.
- **Files to create/modify:**
  - `config/pi/extensions/model-policy/index.ts`
  - `.pi/settings.json` (asegurar que Pi cargue la extensión local)
- **Details:**
  - `pi.on("tool_call")`: Interceptar `subagent`, resolver tier y mutar `event.input.model`.
  - `pi.on("tool_result")`: Inspeccionar errores y alimentar el `CircuitBreaker`.
  - Comando `/model-policy status`: Imprime el estado del enrutador, perfil activo, salud de proveedores y tabla de tiers.
  - Comando `/model-policy explain <agent>`: Imprime la traza de decisión paso a paso para un agente dado.
- **Verification:** Carga en Pi con `/reload`, prueba de ejecución de subagentes y verificación de los comandos `/model-policy status` y `/model-policy explain`.

---

# Verification Contract

### Automated Verification Commands
```bash
# 1. Comprobación de tipos TypeScript y sintaxis de la extensión
npx tsc --noEmit config/pi/extensions/model-policy/*.ts

# 2. Ejecución del banco de pruebas unitarias internas
node --test config/pi/extensions/model-policy/test.js

# 3. Verificación de diagnóstico de OhMyConfig
./omc doctor

# 4. Verificación de compilación de documentación
npm run build
```

### Manual Acceptance Scenarios
1. **Comando Status:** En una sesión de Pi, ejecutar `/model-policy status` y comprobar que se visualizan los 6 tiers con sus modelos primarios y fallbacks correctamente deducidos.
2. **Comando Explain:** Ejecutar `/model-policy explain ce-security-reviewer` y comprobar que la consola muestra la traza indicando `Tier: REASON`, el criterio de menor costo aplicado y el modelo final asignado.
3. **Intercepción Real:** Invocar un subagente sin modelo (`subagent({ agent: "scout", task: "ls" })`) y verificar que el subagente se lanza utilizando el modelo del tier `FAST` (ej. `openai-codex/gpt-5.6-luna`).

---

# Definition of Done

- [ ] Todos los archivos de `config/pi/extensions/model-policy/` están creados y pasan la verificación de tipos sin errores.
- [ ] El clasificador asigna determinísticamente agentes conocidos y desconocidos (*cheap by default*).
- [ ] El router desempata correctamente por menor costo por token y respeta la regla de no escalado hacia arriba.
- [ ] La intercepción en `tool_call` muta `event.input.model` en memoria sin romper workflows existentes de `pi-subagents`.
- [ ] Los comandos `/model-policy status` y `/model-policy explain` funcionan y muestran información clara en terminal.
- [ ] Los tests unitarios automatizados pasan al 100%.
