# 🤖 Ecosistema AI & Coding Agents (LazyPi)

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. El enfoque es modular, riguroso y minimalista: la CLI `omc` instala y mantiene el agente base (**`pi`**), complementado por la suite oficial **LazyPi** ([lazypi.org](https://lazypi.org)) y el framework **Compound Engineering (CE)**.

---

## 1. Manifiesto & Arquitectura del Ecosistema

La filosofía de LazyPi en OhMyConfig se inspira en el modelo de LazyVim: **un núcleo preconfigurado y mantenido por la comunidad con un catálogo curado de 17 herramientas de alto rendimiento**:

1. **Cero código a ciegas:** Todo cambio se estructura mediante requerimientos claros, diseño técnico y criterios de aceptación verificables.
2. **Memoria y conocimiento acumulativo:** Soluciones complejas y decisiones de diseño se guardan en notas técnicas Markdown versionadas en Git.
3. **Flujo de terminal puro y subagentes concurrentes:** Todo el ciclo de vida (análisis, planificación, edición, pruebas, revisión y commits) ocurre en la consola mediante subagentes coordinados en paralelo.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Terminal (Ghostty / Zellij)                         │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                     pi (Coding Agent Base)                          │   │
│   │   • Agente autónomo de terminal para leer, editar y ejecutar        │   │
│   │   • Gestión de modelos: Anthropic Claude, OpenAI, Gemini, Ollama    │   │
│   │   • Instalado y actualizado automáticamente con: ./omc dev          │   │
│   └──────────────────────────────────┬──────────────────────────────────┘   │
│                                      │                                      │
│                ┌─────────────────────┼─────────────────────┐                │
│                ▼                     ▼                     ▼                │
│   ┌───────────────────────────┐┌───────────────────────────┐┌───────────────┐│
│   │   LazyPi Core (12 pkgs)   ││ LazyPi Optional (5 pkgs)  ││ Compound Eng. ││
│   │ • subagents & workflows   ││ • lsp (diagnósticos)      ││ • ce-brainstorm││
│   │ • ask-user & goal         ││ • interactive-shell (TUI) ││ • ce-plan      ││
│   │ • fff & web-access        ││ • memory-md (Git offline) ││ • ce-work      ││
│   │ • simplify & ponytail     ││ • autoresearch (loops)    ││ • ce-review    ││
│   │ • skillful & mention ($)  ││ • todos (checklist live)  ││ • ce-compound  ││
│   └───────────────────────────┘└───────────────────────────┘└───────────────┘│
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Catálogo Oficial de Herramientas de LazyPi (17/17)

LazyPi divide sus herramientas en dos niveles de soporte para garantizar máxima velocidad y cero bloat:

### 2.1 LazyPi Core (12 Herramientas Principales)

| Herramienta | Paquete npm | Comando / Interacción | Propósito y Valor |
| :--- | :--- | :--- | :--- |
| **`subagents`** | `pi-subagents` | `subagent` tool / `/council` | Ejecuta agentes hijos en paralelo en worktrees aislados para tareas concurrentes. |
| **`pi-ask-user`** | `pi-ask-user` | `ask_user` tool | Despliega menús interactivos con selección estructurada antes de decisiones críticas. |
| **`pi-skillful`** | `pi-skillful` | `/skill:<nombre>` | Descubre, oculta y expande skills por encima del git root. |
| **`mention-skill`**| `@zigai/pi-mention-skill` | `$nombre-skill` | Autocompletado difuso con `$` para inyectar skills directamente en el prompt. |
| **`goal`** | `@narumitw/pi-goal` | `/goal` | Control de objetivos de largo plazo con detención en `done`, `blocked` o `wait`. |
| **`btw`** | `@narumitw/pi-btw` | `/btw <pregunta>` | Consultas rápidas al margen sin contaminar el historial de la conversación actual. |
| **`context-usage`**| `pi-context-usage` | Telemetría en footer | Muestra el consumo de tokens y presupuesto de contexto en tiempo real. |
| **`simplify`** | `pi-simplify` | `/simplify` | Revisa código modificado recientemente buscando claridad, consistencia y eliminación de código muerto. |
| **`web-access`** | `pi-web-access` | `web_search`, `source_check`| Búsqueda web multi-motor en tiempo real (Brave, Exa, Perplexity) y extracción de contenido. |
| **`fff`** | `@ff-labs/pi-fff` | `fffind`, `ffgrep`, `/fff-health`| Fast Fuzzy Finder ultrarrápido para búsqueda de archivos y símbolos. |
| **`dynamic-workflows`**| `@quintinshaw/pi-dynamic-workflows`| `/workflows` | Interfaz TUI para orquestar subagentes, deep-research y contabilidad de tokens. |
| **`ponytail`** | `@dietrichgebert/ponytail` | `/ponytail review`, `audit` | Guardián de disciplina de código minimalista y librerías estándar (*stdlib-first*). |

### 2.2 LazyPi Optional (5 Herramientas Avanzadas)

| Herramienta | Paquete npm | Comando / Interacción | Propósito y Valor |
| :--- | :--- | :--- | :--- |
| **`lsp`** | `@narumitw/pi-lsp` | `lsp_diagnostics`, `lsp_fix` | Diagnóstico de errores de compilación, sintaxis y tipos en vivo usando Language Servers. |
| **`interactive-shell`**| `pi-interactive-shell`| `interactive_shell` | Ejecuta TUIs y CLIs complejas en segundo plano (supervisadas o *hands-free*). |
| **`autoresearch`** | `pi-autoresearch` | `autoresearch-create` | Bucles autónomos de experimentación y optimización métrica con hooks. |
| **`todos`** | `pi-manage-todo-list`| `manage_todo_list` | Tracking estructurado de tareas en sesión con widgets visuales de progreso. |
| **`memory`** | `pi-memory-md` | `memory_search`, `tape_handoff`| Memoria episódica y semántica persistente en Markdown versionada en Git local. |

---

## 3. Flujos de Trabajo Prácticos (Workflows de Ingeniería)

A continuación se detallan los flujos de trabajo recomendados para el día a día:

---

### Flujo 1: Desarrollo de Nuevas Features de Punta a Punta

```
1. Brainstorm ($ce-brainstorm) ──► 2. Plan Técnico ($ce-plan) ──► 3. Auditoría ($ce-doc-review)
                                                                           │
6. Capitalizar ($ce-compound) ◄── 5. Commit & PR ($ce-commit-push-pr) ◄── 4. Ejecución ($ce-work)
```

1. **Definición de Requerimientos:**
   > *"Hagamos un brainstorm sobre cómo agregar soporte para múltiples perfiles de usuario en la CLI."*
   > *Dispara `ce-brainstorm`: te hace preguntas con opciones vía `pi-ask-user` y define el alcance.*
2. **Diseño de Arquitectura:**
   > *"Armá un plan técnico con archivos afectados, contratos de datos y riesgos."*
   > *Dispara `ce-plan`: genera un plan estructurado.*
3. **Auditoría del Plan:**
   > *"Revisá el plan con subagentes antes de arrancar."*
   > *Dispara `ce-doc-review`: subagentes revisan seguridad y diseño.*
4. **Implementación Aislada:**
   > *"Creá un worktree para esta feature y ejecutá el plan."*
   > *Dispara `ce-worktree` y `ce-work`: desarrolla en una rama aislada de Git.*
5. **Revisión de Código:**
   > *"Hacé un code review de los cambios."*
   > *Dispara `ce-code-review`: revisores especializados emiten reporte formal.*
6. **Entrega y Publicación:**
   > *"Commiteá, pusheá y abrí el PR."*
   > *Dispara `ce-commit-push-pr`: genera commits atómicos y redacta el PR.*
7. **Capitalización de Conocimiento:**
   > *"Guardá esta solución en docs/solutions/."*
   > *Dispara `ce-compound`: documenta el aprendizaje técnico.*

---

### Flujo 2: Debugging Asistido por LSP y Causa Raíz

Cuando un test falla o tenés un error de ejecución:

```
1. Diagnóstico LSP (lsp_diagnostics) ──► 2. Causa Raíz (ce-debug) ──► 3. Fix & Verificación
```

1. **Inspección de Tipos y Errores:**
   > *"Ejecutá un diagnóstico LSP en el archivo `src/services/auth.ts` para ver qué tipos están fallando."*
   > *Lanza `lsp_diagnostics` y muestra errores exactos del compilador.*
2. **Análisis Sistemático:**
   > *"Analizá la causa raíz de este error con `ce-debug` y generá un test mínimo que reproduzca el fallo."*
   > *Genera una prueba en rojo, formula hipótesis y valida el fix.*
3. **Verificación:**
   > *"Volvé a correr el diagnóstico LSP y los tests para confirmar que esté en verde."*

---

### Flujo 3: Auditoría y Simplificación de Código

Para mantener una base de código limpia y libre de complejidad accidental (*AI slop*):

```
1. Auditoría de Disciplina (/ponytail review) ──► 2. Simplificación (/simplify) ──► 3. Verificación
```

1. **Auditoría de Buenas Prácticas:**
   > `/ponytail review`  
   > *Revisa si hay sobreingeniería, dependencias innecesarias o código que podría usar la librería estándar.*
2. **Simplificación Activa:**
   > `/simplify`  
   > *Pule el código modificado recientemente, eliminando dead code y mejorando legibilidad.*

---

### Flujo 4: Consultas Rápidas al Margen (`/btw`)

Cuando querés hacerle una pregunta conceptual a la IA sin llenar el contexto de tu sesión principal:

```bash
/btw ¿Cuál es la diferencia entre cmp -s y diff -q en bash?
```

*Pi responde de forma concisa y no agrega la consulta al historial de tu conversación.*

---

### Flujo 5: Optimización en Bucle Autónomo (`autoresearch`)

Para tareas donde se busca maximizar una métrica (ej. tiempo de carga, tamaño de bundle, cobertura):

```bash
# Inicia un loop autónomo guiado por benchmark
"Iniciá un loop de autoresearch para reducir el tiempo de ejecución de deploy.sh en 5 iteraciones."
```

*El agente ejecuta experimentos, mide los resultados contra el benchmark anterior y conserva únicamente los cambios que demuestren mejoras reales.*

---

## 4. Comandos Slash (`/`) y Menciones (`$`) de LazyPi

| Comando / Mención | Descripción |
| :--- | :--- |
| **`/plan <desc>`** | Inicia el modo de planificación socrática en memoria. |
| **`/simplify`** | Simplifica y limpia el código modificado recientemente. |
| **`/ponytail review`** | Audita el código buscando patrones de sobreingeniería y complejidad. |
| **`/ponytail audit`** | Inspección profunda de deuda técnica y dependencias. |
| **`/btw <pregunta>`** | Consulta rápida sin contaminar el contexto principal. |
| **`/goal <meta>`** | Fija un objetivo de largo plazo con control de estados. |
| **`/workflows`** | Abre el panel TUI interactivo para orquestar flujos de subagentes. |
| **`/fff-health`** | Verifica la salud y velocidad del índice de búsqueda rápida. |
| **`$skill-name`** | Mención difusa para invocar e inyectar cualquier skill en el prompt. |

---

## 5. Gestión del Ecosistema desde `omc`

La CLI `omc` administra el ciclo de vida de **Pi y LazyPi** de forma 100% nativa:

```bash
./omc dev              # Ejecuta el instalador oficial de LazyPi (Core + Optional)
./omc dev status       # Muestra el estado y diagnóstico del catálogo LazyPi
./omc dev update       # Actualiza el binario de Pi y todas las extensiones instaladas
./omc dev doctor       # Chequeo de salud del entorno (Node, npm, git, auth, settings)
./omc dev remove       # Selector interactivo para desinstalar extensiones
./omc update           # Actualización total del sistema (Homebrew + Casks + Pi)
```
