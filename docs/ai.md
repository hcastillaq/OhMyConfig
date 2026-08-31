# 🤖 Ecosistema AI & Coding Agents (Pi & LazyPi)

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. Esta guía detalla todas las herramientas del stack LazyPi, especificando **cómo y cuándo usarlas**, si su naturaleza es **Activa** o **Pasiva**, y profundiza en la suite completa de **Compound Engineering (CE)**.

---

## 1. ¿Qué es Pi?

**`pi`** (`@earendil-works/pi-coding-agent`) es el motor de ejecución autónomo y CLI de desarrollo en terminal.

### Características Principales:
* **Velocidad Nativa:** Diseñado para terminales modernas con arranque instantáneo e interfaz interactiva TUI.
* **Soporte Poly-Model:** Conexión nativa con Anthropic Claude, OpenAI, DeepMind Gemini, Kimi, xAI y modelos locales vía Ollama.
* **Capacidades de Sistema:** Ejecuta herramientas para leer (`read`), buscar (`grep`, `find`), inspeccionar y editar código (`edit`, `write`), y correr comandos de consola (`bash`).
* **Instalación Centralizada:** Gestionado y actualizado a través de la CLI `omc` (`./omc dev`).

---

## 2. Catálogo Completo de Herramientas de LazyPi

Las herramientas de LazyPi se clasifican según su modalidad de ejecución:
* **Activa:** El desarrollador la invoca explícitamente mediante un comando slash (`/`), mención de skill (`$`), o petición directa en el prompt.
* **Pasiva / Asistida:** Opera automáticamente en segundo plano, en la barra de estado de la TUI, o es ejecutada de forma autónoma por el agente para resolver tareas.

---

### 2.1 Orquestación y Deliberación Multi-Agente

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DELIBERACIÓN SUPERVISADA                          │
│                                                                             │
│   1. PASE INDEPENDIENTE (Sin sesgo)                                         │
│      Asesor A (oracle) ──┐                                                  │
│      Asesor B (reviewer) ──┼──► Supervisor analiza diferencias              │
│      Asesor C (custom)   ──┘                                                │
│                                                                             │
│   2. DEBATE CRUZADO (Cross-Exam)                                            │
│      Supervisor envía paquete de desafíos técnicos a cada asesor            │
│                                                                             │
│   3. DICTAMEN FINAL (Decision Memo)                                         │
│      Recomendación, trade-offs, argumentos aceptados/rechazados             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 1. `council` (Council Mode)
* **Tipo:** **Activa** (Comando `/council <pregunta>` o `$council-mode`).
* **Cómo usarla:** Ejecutá `/council ¿Debemos migrar el CLI a Rust o mantener Bash con Gum?`
* **Cuándo usarla:**
  * Decisiones de arquitectura con múltiples alternativas y *trade-offs* reales (bases de datos, frameworks, diseño de concurrencia).
  * Evaluaciones técnicas de alto riesgo donde querés evitar que un solo modelo alucine o sufra sesgo de complacencia.
* **Cuándo NO usarla:**
  * Tareas de implementación directa, refactors menores o preguntas con respuesta estándar.
* **Mecánica:** Lanza de 2 a 4 asesores en paralelo (`oracle`, `reviewer` o perfiles `council-*`). En el Pase 1 no ven las respuestas de los demás. En el Pase 2 debaten las discrepancias ante el supervisor, quien emite el memorándum final.

#### 2. `subagents` (Subprocesos y Worktrees)
* **Tipo:** **Pasiva / Asistida** (El agente principal la invoca ante tareas pesadas o paralelas).
* **Cómo usarla:** El agente delega internamente usando `subagent({ agent: "reviewer", task: "..." })` o `runs.all([...])`.
* **Cuándo se usa:**
  * Ejecutar suites de pruebas largas, revisiones de código o búsquedas profundas en segundo plano sin bloquear el chat principal.
  * Tareas de mutación de código en carpetas aisladas (*git worktrees*) para no alterar el directorio de trabajo del usuario.
* **Cuándo NO se usa:**
  * Ediciones directas de uno o dos archivos pequeños.

#### 3. `dynamic-workflows`
* **Tipo:** **Activa** (Comando `/workflows` o script en JavaScript con herramienta `workflow`).
* **Cómo usarla:** Ejecutá `/workflows` para abrir el panel TUI interactivo o pedí: *"Corré un workflow de code-review con límite de 50k tokens"*.
* **Cuándo usarla:**
  * Flujos complejos automatizados por fases (`pipeline()`, `parallel()`) con límite estricto de gasto en tokens (`tokenBudget`).
  * Auditorías profundas predefinidas: `code-review`, `codebase-audit`, `deep-research`, `adversarial-review`.

---

### 2.2 Calidad, Simplicidad y Diagnóstico de Código

#### 1. `ponytail`
* **Tipo:** **Activa y Pasiva** (Comandos slash explícitos y modo guardián en la sesión).
* **Cómo usarla:**
  * `/ponytail review`: Audita los cambios recientes buscando sobreingeniería y dependencias innecesarias.
  * `/ponytail audit`: Escaneo completo del repositorio clasificando qué eliminar o reemplazar por la librería estándar.
  * `/ponytail debt`: Recolecta comentarios `# ponytail:` para listar atajos deliberados y deuda técnica diferida.
  * `/ponytail gain`: Muestra el marcador de líneas de código y tokens ahorrados.
  * `/ponytail lite | full | ultra`: Ajusta la intensidad de simplificación.
* **Cuándo usarla:**
  * Tras escribir una funcionalidad nueva o antes de abrir un Pull Request, para garantizar la solución más limpia y minimalista (*YAGNI*, *stdlib-first*).
* **Cuándo NO usarla:**
  * Cuando se requiere explícitamente una abstracción compleja solicitada por el usuario.

#### 2. `simplify`
* **Tipo:** **Activa** (Comando `/simplify`).
* **Cómo usarla:** Ejecutá `/simplify` al terminar un refactor o feature.
* **Cuándo usarla:**
  * Para podar imports en desuso, eliminar funciones auxiliares huérfanas y compactar lógica recién escrita sin alterar su comportamiento.

#### 3. `lsp` (Language Server Protocol)
* **Tipo:** **Pasiva / Asistida** (`lsp_diagnostics`, `lsp_fix`).
* **Cómo usarla:** El agente consulta automáticamente los diagnósticos del servidor LSP configurado (TypeScript, Rust, Go, Python, Lua) o aplica correcciones con `lsp_fix`.
* **Cuándo se usa:**
  * Inmediatamente después de editar código para verificar en tiempo real que no existan errores de compilación, sintaxis o tipos.

---

### 2.3 Contexto, Memoria y Búsqueda Eficiente

#### 1. `memory` & `tape` (`pi-memory-md`)
* **Tipo:** **Activa y Pasiva** (`memory_search`, `memory_write`, `tape_handoff`, `tape_read`).
* **Cómo usarla:**
  * *"Guardá en memoria que usamos Node 20 y ESM en este proyecto"* (persiste en Markdown versionado en Git).
  * `tape_handoff`: Ancla puntos de control para que sesiones futuras retomen el contexto sin reenviar todo el historial.
* **Cuándo usarla:**
  * Proyectos de larga duración donde necesitás recordar reglas de negocio, preferencias de estilo o decisiones tomadas días atrás.

#### 2. `fff` (Fast Fuzzy Finder)
* **Tipo:** **Pasiva / Asistida** (`fffind`, `ffgrep`).
* **Cómo usarla:** El agente la usa en lugar de `find` o `grep` tradicionales para rastrear archivos y símbolos por frecencia.
* **Cuándo se usa:**
  * Localización instantánea de definiciones, imports y archivos relevantes sin volcar carpetas enteras al contexto.

#### 3. `btw`
* **Tipo:** **Activa** (Comando `/btw <pregunta>`).
* **Cómo usarla:** `/btw ¿Cómo era la sintaxis de array destructuring en Lua?`
* **Cuándo usarla:**
  * Dudas rápidas de sintaxis o soporte que no deben guardarse en el historial de la conversación ni consumir tokens en turnos posteriores.

#### 4. `context-usage`
* **Tipo:** **Pasiva** (Telemetría visual permanente).
* **Cómo usarla:** Visible en el footer de la TUI.
* **Cuándo se usa:**
  * Monitoreo constante del porcentaje de ventana de contexto utilizado y control de costos de la sesión.

#### 5. `web-access`
* **Tipo:** **Pasiva / Asistida** (`web_search`, `source_check`, `fetch_content`).
* **Cómo usarla:** *"Buscá la documentación oficial de la última versión de Zod y cómo validar unions."*
* **Cuándo se usa:**
  * Consultar documentación técnica actualizada de librerías externas o APIs con verificación rigurosa de fuentes.

---

### 2.4 Interacción, Tareas y Automatización

#### 1. `pi-ask-user`
* **Tipo:** **Pasiva / Asistida** (`ask_user`).
* **Cómo usarla:** El agente despliega una ventana modal interactiva con opciones múltiples antes de ejecutar acciones de alto riesgo o ambiguas.
* **Cuándo se usa:**
  * Decidir entre enfoques divergentes de arquitectura o confirmar cambios destructivos.

#### 2. `interactive-shell`
* **Tipo:** **Pasiva / Asistida** (`interactive_shell`).
* **Cómo usarla:** El agente corre comandos interactivos o TUIs en modos `interactive`, `hands-free` (monitoreo con avisos al usuario), `dispatch` (background desatendido) o `monitor` (disparadores de eventos).
* **Cuándo se usa:**
  * Supervisar comandos interactivos como `lazygit`, procesos de autenticación web o scripts con prompts de confirmación.

#### 3. `goal` & `todos`
* **Tipo:** **Activa y Pasiva** (`/goal`, `manage_todo_list`).
* **Cómo usarla:** `/goal Migrar autenticación a JWT` crea un objetivo con compuertas de seguridad (`goal_complete`, `goal_blocked`). `manage_todo_list` renderiza un checklist en vivo en el chat.
* **Cuándo usarla:**
  * Tareas multi-paso extensas para mantener trazabilidad visual del progreso.

#### 4. `autoresearch` & `ralph-wiggum`
* **Tipo:** **Activa** (`autoresearch-create`, `ralph_start` / `ralph_done`).
* **Cómo usarla:** *"Iniciá un bucle de optimización con autoresearch para reducir el tiempo de build"* o *"Arrancá un loop Ralph para resolver estos 5 issues"*.
* **Cuándo usarla:**
  * Experimentación empírica iterativa con medición de métricas objetivas.

---

## 3. Matriz General de Herramientas

| Herramienta | Naturaleza | Invocación / Comando | Cuándo Usarla |
| :--- | :---: | :--- | :--- |
| **`council`** | **Activa** | `/council <pregunta>` | Decisiones técnicas críticas con debate multi-agente supervisado. |
| **`dynamic-workflows`** | **Activa** | `/workflows` | Automatización de flujos multi-agente con tope de tokens. |
| **`ponytail`** | **Activa/Pasiva** | `/ponytail review / audit / debt` | Eliminar sobreingeniería, exigir *stdlib-first* y *YAGNI*. |
| **`simplify`** | **Activa** | `/simplify` | Podar código muerto y optimizar archivos modificados. |
| **`btw`** | **Activa** | `/btw <pregunta>` | Preguntas de soporte sin ensuciar el historial de chat. |
| **`goal`** | **Activa** | `/goal <meta>` | Fijar metas de largo plazo con compuertas de parada. |
| **`mention-skill`** | **Activa** | `$nombre-skill` | Inyectar protocolos de desarrollo con autocompletado difuso. |
| **`subagents`** | **Pasiva** | Herramienta `subagent` | Tareas paralelas o pesadas en subprocesos y worktrees. |
| **`lsp`** | **Pasiva** | Herramienta `lsp_diagnostics` | Validar sintaxis, tipos y linting en vivo con Language Servers. |
| **`memory`** | **Pasiva/Activa**| `tape_handoff`, `memory_search` | Persistir conocimiento y anclajes en Markdown Git offline. |
| **`fff`** | **Pasiva** | Herramientas `fffind`, `ffgrep` | Búsqueda difusa indexada ultra-rápida de código y rutas. |
| **`context-usage`**| **Pasiva** | Footer TUI | Monitoreo visual de consumo de tokens y presupuesto. |
| **`web-access`** | **Pasiva** | Herramienta `web_search` | Búsqueda web y verificación de fuentes externas. |
| **`pi-ask-user`** | **Pasiva** | Herramienta `ask_user` | Diálogo modal interactivo para confirmar decisiones clave. |
| **`interactive-shell`**| **Pasiva**| Herramienta `interactive_shell`| Supervisión de TUIs y procesos interactivos en background. |
| **`todos`** | **Pasiva/Activa**| Herramienta `manage_todo_list` | Checklist de tareas interactivo y visible en la sesión. |
| **`autoresearch`** | **Activa** | `autoresearch-create` | Bucles autónomos de experimentación y optimización métrica. |

---

## 4. Compound Engineering (CE) Suite

**Compound Engineering** es la suite metodológica central de LazyPi. Se basa en el principio de que **el código es un pasivo y el conocimiento acumulado es el activo**. Cada tarea de ingeniería debe dejar el repositorio en un estado más comprensible, probado y documentado que antes.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   CICLO DE VIDA COMPOUND ENGINEERING (7 FASES)              │
│                                                                             │
│   1. EXPLORACIÓN      $ce-brainstorm (Diálogo socrático y alcance)          │
│            │                                                                │
│            ▼                                                                │
│   2. PLAN TÉCNICO     $ce-plan (Arquitectura y desglose atómico)            │
│            │                                                                │
│            ▼                                                                │
│   3. REVISIÓN DOCS    $ce-doc-review (Auditoría multi-rol del plan)         │
│            │                                                                │
│            ▼                                                                │
│   4. EJECUCIÓN        $ce-work (Implementación TDD con verificación)        │
│            │                                                                │
│            ▼                                                                │
│   5. CODE REVIEW      $ce-code-review (Revisión multi-agente por niveles)   │
│            │                                                                │
│            ▼                                                                │
│   6. ENTREGA          $ce-commit-push-pr (Conventional Commits y PR rico)   │
│            │                                                                │
│            ▼                                                                │
│   7. CAPITALIZACIÓN   $ce-compound (Registrar solución en docs/solutions/)  │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 4.1 Detalle de las Skills de Compound Engineering

#### 1. `$ce-brainstorm` (Fase 1: Exploración y Requerimientos)
* **Naturaleza:** **Activa** (Invocación con `$ce-brainstorm` o frases como *"hagamos un brainstorm sobre X"*).
* **Propósito:** Explorar requerimientos, casos de borde y alternativas mediante diálogo colaborativo antes de comprometerse con un diseño.
* **Entrada:** Idea general o problema a resolver.
* **Salida:** Documento de especificación con alcance claro, límites (*non-goals*) y enfoque acordado.
* **Ejemplo:** `$ce-brainstorm Diseñar el sistema de caché para las respuestas de la API de usuarios.`

#### 2. `$ce-plan` (Fase 2: Planificación Técnica y Desglose)
* **Naturaleza:** **Activa** (Invocación con `$ce-plan` o *"armá el plan técnico de X"*).
* **Propósito:** Generar un plan de arquitectura detallado con contratos de interfaces, dependencias y una lista ordenada de tareas atómicas verificables.
* **Entrada:** Requerimientos acordados en el brainstorm.
* **Salida:** Plan técnico estructurado en Markdown con checklists de tareas y criterios de aceptación.
* **Ejemplo:** `$ce-plan Estructurar la migración de endpoints a GraphQL.`

#### 3. `$ce-doc-review` (Fase 3: Auditoría Multi-Perspectiva del Plan)
* **Naturaleza:** **Activa** (Invocación con `$ce-doc-review` o *"revisemos el plan"*).
* **Propósito:** Lanza subagentes con roles especializados (seguridad, arquitectura, rendimiento, producto) para auditar el plan antes de escribir código.
* **Entrada:** Plan técnico generado.
* **Salida:** Informe de hallazgos clasificados por severidad y sugerencias de mejora aplicadas al plan.

#### 4. `$ce-work` (Fase 4: Ejecución y Desarrollo Disciplinado)
* **Naturaleza:** **Activa** (Invocación con `$ce-work` o *"ejecutá las tareas del plan"*).
* **Propósito:** Ejecutar la implementación tarea por tarea, aplicando TDD estricto y ejecutando tests/linters tras cada modificación para garantizar cero regresiones.
* **Manejo de Worktrees:** Puede operar en un worktree aislado mediante `$ce-worktree`.

#### 5. `$ce-code-review` (Fase 5: Revisión de Código Multi-Agente)
* **Naturaleza:** **Activa** (Invocación con `$ce-code-review` o *"hacé un code review"*).
* **Propósito:** Auditoría exhaustiva del `git diff` mediante agentes clasificadores por nivel de confianza. Detecta bugs, fugas de memoria, problemas de concurrencia y desviaciones de estilo.
* **Salida:** Reporte priorizado de observaciones antes de commitear.

#### 6. `$ce-commit-push-pr` (Fase 6: Commit, Push y Creación de PR)
* **Naturaleza:** **Activa** (Invocación con `$ce-commit-push-pr` o *"creá el PR"*).
* **Propósito:** Inspecciona el staging, redacta un commit semántico según Conventional Commits, hace push de la rama y abre el Pull Request en GitHub con una descripción rica basada en valor y cambios reales.

#### 7. `$ce-compound` (Fase 7: Capitalización del Conocimiento)
* **Naturaleza:** **Activa** (Invocación con `$ce-compound` o *"documentá esta solución"*).
* **Propósito:** Extrae el problema resuelto, la causa raíz, las alternativas descartadas y el patrón aplicado, guardándolo en `docs/solutions/<categoria>/<problema>.md`.
* **Beneficio:** En futuras sesiones, el agente consulta estas soluciones para no tropezar dos veces con el mismo obstáculo.

---

### 4.2 Skills Complementarias de la Suite CE

| Skill | Naturaleza | Cuándo Invocarla | Descripción Operativa |
| :--- | :---: | :--- | :--- |
| **`$ce-debug`** | **Activa** | *"debugueá este error"* / `$ce-debug` | Localización sistemática de causa raíz mediante reproducción y trazas. |
| **`$ce-worktree`** | **Activa** | *"creá un worktree para esta rama"* | Crea un entorno git aislado para trabajar sin alterar el checkout actual. |
| **`$ce-clean-gone-branches`** | **Activa** | *"limpiá ramas borradas"* | Elimina ramas locales cuyos remotos ya fueron mergeados o eliminados. |
| **`$ce-compound-refresh`** | **Activa** | *"actualizá docs/solutions/"* | Audita y actualiza documentos de soluciones obsoletos frente al código actual. |
| **`$ce-sessions`** | **Activa** | *"¿qué hicimos en la sesión anterior?"* | Busca y analiza el historial de sesiones previas del agente. |
| **`$ce-ideate`** | **Activa** | *"dame ideas para mejorar X"* | Generación proactiva y evaluación crítica de propuestas técnicas. |
| **`$ce-optimize`** | **Activa** | *"optimizá esta función en bucle"* | Bucles de optimización empírica guiados por métricas objetivas. |
| **`$ce-resolve-pr-feedback`** | **Activa** | *"resolvé los comentarios del PR"* | Evalúa el feedback de revisores en GitHub y aplica correcciones en paralelo. |

---

## 5. Esquema de Ayuda al Desarrollo y Minimización de Tokens

El mayor problema al programar con IA es el **Monolithic Prompting** (volcar todo el proyecto al contexto), lo que genera lentitud, alucinaciones y costos excesivos. LazyPi implementa técnicas avanzadas de **Context Engineering**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                 CÓMO LAZYPI MINIMIZA EL CONSUMO DE TOKENS                   │
│                                                                             │
│   1. BÚSQUEDA QUIRÚRGICA (fff + codegraph)                                  │
│      En lugar de volcar 30 archivos, lee solo las 20 líneas relevantes.     │
│      Ahorro: de 50.000 tokens a 1.200 tokens por consulta.                  │
│                                                                             │
│   2. SUBAGENTES CON CONTEXTO EFÍMERO (pi-subagents + ce-worktree)           │
│      Las tareas pesadas (tests largos, reviews) corren en subprocesos       │
│      hijos y devuelven solo un resumen de 300 tokens al chat principal.     │
│                                                                             │
│   3. CONSULTAS AISLADAS (/btw)                                              │
│      Preguntas de sintaxis no se guardan en el historial de la sesión.      │
│                                                                             │
│   4. PODA DE CÓDIGO MUERTO (/simplify + /ponytail)                          │
│      Reduce el tamaño físico de los archivos, abaratando turnos futuros.    │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.1 Matriz de Ahorro y Rendimiento

| Métrica | Sin LazyPi (Enfoque Ad-hoc) | Con LazyPi + Context Engineering | Beneficio |
| :--- | :---: | :---: | :---: |
| **Tokens consumidos por turno** | 40.000 - 75.000 tokens | 1.500 - 4.500 tokens | **-85% consumo** 📉 |
| **Tiempo de respuesta (TTFT)** | 8 - 15 segundos | 1 - 3 segundos | **4x más rápido** ⚡ |
| **Tasa de éxito en 1er intento**| ~50% (requiere reintentos) | >90% (precisión contextual) | **Cero re-trabajo** 🎯 |
| **Contaminación del chat** | Alta (cientos de líneas de logs)| Nula (resúmenes estructurados) | **Contexto limpio** 🧼 |

---

## 6. Referencia Rápida de Comandos y Atajos

```bash
# ── Gestión de Infraestructura (omc) ──────────────────────────────────────────
./omc dev                      # Instalar Pi y el catálogo oficial completo de LazyPi
./omc dev status               # Ver estado del catálogo de 17 extensiones
./omc dev update               # Actualizar Pi y todas las extensiones instaladas
./omc dev doctor               # Diagnóstico de salud del entorno de IA
./omc dev remove               # Selector interactivo para desinstalar extensiones
./omc update                   # Actualización total (Homebrew + Casks + Pi + LazyPi)

# ── Modos y Comandos en Sesión de Pi (Activos) ────────────────────────────────
/council <pregunta>            # Iniciar consejo consultivo supervisado de decisión
/plan <descripción>            # Modo de planificación socrática en memoria
/simplify                      # Simplificar y limpiar código modificado recientemente
/ponytail review               # Auditar código buscando sobreingeniería y dependencias
/ponytail audit                # Inspección de deuda técnica en todo el repositorio
/ponytail debt                 # Recolectar comentarios de atajos (# ponytail:)
/ponytail gain                 # Scoreboard de impacto y líneas ahorradas
/btw <pregunta>                # Consulta rápida sin contaminar el historial de chat
/goal <meta>                   # Fijar objetivo de largo plazo con control de estados
/workflows                     # Panel TUI interactivo para orquestar subagentes
/skill:<nombre>                # Invocar skill específica mediante pi-skillful

# ── Invocación de Skills con Mención Difusa ($) ───────────────────────────────
$ce-brainstorm                 # Iniciar sesión de exploración y descubrimiento
$ce-plan                       # Inyectar planificación técnica de arquitectura
$ce-doc-review                 # Inyectar revisión multi-perspectiva de especificaciones
$ce-work                       # Iniciar ejecución disciplinada de tareas
$ce-code-review                # Inyectar revisión de código multi-agente
$ce-commit-push-pr             # Crear commit convencional, push y abrir PR
$ce-compound                   # Registrar aprendizaje en docs/solutions/
$ce-debug                      # Diagnóstico sistemático de bugs
$ce-worktree                   # Crear git worktree aislado para desarrollo
```
