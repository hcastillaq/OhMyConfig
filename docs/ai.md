# 🤖 Ecosistema AI & Coding Agents (LazyPi)

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. El enfoque es modular, riguroso y minimalista: la CLI `omc` instala y mantiene el agente base (**`pi`**), complementado por la suite de extensiones nativas **LazyPi** y el framework **Compound Engineering (CE)**.

---

## 1. Manifiesto & Arquitectura del Ecosistema

La filosofía de ingeniería asistida por IA en OhMyConfig se basa en tres principios fundamentales:

1. **Cero código a ciegas:** Ningún cambio de arquitectura o funcionalidad no trivial debe programarse sin antes definir alcance, requerimientos y diseño técnico.
2. **Memoria y conocimiento acumulativo:** Los problemas resueltos y las decisiones de diseño se capitalizan en documentos de soluciones y memoria persistente para evitar re-investigaciones.
3. **Flujo de terminal puro y subagentes concurrentes:** Todo el ciclo de vida (análisis, planificación, edición, pruebas, revisión y commits) ocurre en la consola mediante agentes coordinados en paralelo.

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
│   │   Compound Engineering    ││       pi-memory-md        ││ @narumitw/    ││
│   │ • ce-brainstorm / ce-plan ││ • Memoria Markdown local ││   pi-plan-mode││
│   │ • ce-work / ce-debug      ││   con control Git         ││ • Modo /plan  ││
│   │ • ce-code-review multi-rol││ • Sin servidores externos ││ • Preguntas   ││
│   │ • ce-compound learnings   ││ • tape & context sync     ││   socráticas  ││
│   └───────────────────────────┘└───────────────────────────┘└───────────────┘│
│   ┌───────────────────────────┐┌───────────────────────────┐┌───────────────┐│
│   │       pi-subagents        ││      pi-antigravity       ││ pi-web-access ││
│   │ • Fanout paralelo/lanes   ││ • DeepMind Antigravity    ││ • Búsqueda    ││
│   │ • pi-ask-user dialogs     ││ • CodeGraph semántico     ││   multi-motor ││
│   │ • Worktrees aislados      ││ • Inspección de código    ││ • source_check││
│   └───────────────────────────┘└───────────────────────────┘└───────────────┘│
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Herramienta Base: Pi Coding Agent (`pi`)

**`pi`** (`@earendil-works/pi-coding-agent`) es el motor de ejecución autónomo. Diseñado para terminales modernas, combina velocidad instantánea, interfaz TUI interactiva y soporte de herramientas nativas para interactuar con tu sistema de archivos y git.

### 2.1 Gestión con la CLI `omc`

```bash
./omc dev              # Instala pi coding agent (npm global)
./omc dev status       # Diagnóstico de la versión de pi y estado de extensiones
./omc dev update       # Actualiza el binario de pi a la última versión en npm
./omc update           # Actualización total (Homebrew + Casks + pi)
```

### 2.2 Comandos Esenciales de la CLI de `pi`

| Comando                    | Descripción                                                           |
| :------------------------- | :-------------------------------------------------------------------- |
| **`pi`**                   | Abre una sesión interactiva del agente en el directorio actual.       |
| **`pi "instrucción"`**     | Ejecuta una tarea puntual en modo _one-shot_ y sale al finalizar.     |
| **`pi list`**              | Lista todas las extensiones, herramientas y skills activas.           |
| **`pi install <paquete>`** | Descarga, instala y vincula una extensión de usuario desde npm o git. |
| **`pi remove <paquete>`**  | Desinstala una extensión registrada en pi.                            |
| **`pi update`**            | Actualiza a la última versión todas las extensiones instaladas en pi. |

---

## 3. Compound Engineering (CE) & Ciclo de Vida del Software

El framework **Compound Engineering** estructura el desarrollo en etapas secuenciales y verificadas donde cada paso valida al anterior:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       CICLO COMPOUND ENGINEERING (CE)                       │
│                                                                             │
│  1. REQUERIMIENTOS ──► ce-brainstorm / ce-ideate (Alcance y casos de uso)   │
│         │                                                                   │
│  2. ARQUITECTURA  ──► ce-plan (Diseño técnico, archivos y riesgos)         │
│         │                                                                   │
│  3. AUDITORÍA     ──► ce-doc-review (Subagentes auditando el plan)          │
│         │                                                                   │
│  4. DESARROLLO    ──► ce-work / ce-worktree (Ejecución metódica y tests)    │
│         │                                                                   │
│  5. VERIFICACIÓN  ──► ce-code-review (Revisión de pares multi-rol)          │
│         │                                                                   │
│  6. ENTREGA       ──► ce-commit-push-pr (Commits atómicos y PR en GitHub)   │
│         │                                                                   │
│  7. CONOCIMIENTO  ──► ce-compound (Registro de soluciones en docs/solutions)│
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.1 Catálogo de Habilidades (Skills) de Compound Engineering

| Skill | Lenguaje Natural / Prompt | Propósito Principal |
| :--- | :--- | :--- |
| **`ce-brainstorm`** | *"Hagamos un brainstorm sobre X"* | Explora requerimientos, restricciones y trade-offs sin tocar código. |
| **`ce-ideate`** | *"Dame ideas para mejorar X"* | Genera y evalúa críticamente múltiples enfoques de solución. |
| **`ce-plan`** | *"Creá un plan técnico para X"* | Diseña la arquitectura, contratos, archivos afectados y plan de testing. |
| **`ce-doc-review`** | *"Auditá este plan con doc-review"* | Lanza subagentes especializados para encontrar fallas en el diseño técnico. |
| **`ce-work`** | *"Ejecutá el plan aprobado"* | Desarrolla paso a paso manteniendo verificaciones de calidad. |
| **`ce-worktree`** | *"Creá un worktree para esta feature"* | Crea un `git worktree` aislado para trabajar sin tocar el checkout actual. |
| **`ce-debug`** | *"Debugueá por qué falla este test"* | Análisis sistemático de causa raíz, hipótesis y solución definitiva. |
| **`ce-code-review`** | *"Hacé un code review de los cambios"* | Auditoría multi-agente con filtrado de severidad antes de commitear. |
| **`ce-commit`** | *"Guardá estos cambios con un commit"* | Staging selectivo y commits atómicos con Conventional Commits. |
| **`ce-commit-push-pr`** | *"Commiteá, pusheá y abrí el PR"* | Publicación completa con descripción orientada al valor (*value-first*). |
| **`ce-compound`** | *"Documentá esta solución aprendida"* | Guarda notas técnicas reutilizables en `docs/solutions/`. |
| **`ce-sessions`** | *"¿Qué intentamos la sesión pasada?"* | Consulta el historial de sesiones previas para recuperar contexto. |

---

## 4. Skills en el Ecosistema: ¿Qué son, Cuándo y Cómo Crearlas?

Las **Skills** son unidades modulares de conocimiento procedimental empaquetadas en archivos Markdown estructurados (`SKILL.md`). Permiten que el agente ejecute tareas complejas y repetitivas siguiendo un protocolo estricto sin necesidad de escribir código TypeScript o extensiones pesadas.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             ANATOMÍA DE UNA SKILL                           │
│                                                                             │
│   SKILL.md                                                                  │
│   ├── Frontmatter YAML (Metadatos: name, description, triggers)             │
│   ├── Contexto y Restricciones (Límites claros del alcance)                 │
│   ├── Protocolo de Ejecución Paso a Paso (Instrucciones LLM-First)          │
│   └── Criterios de Aceptación y Verificación (Checklist de éxito)          │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.1 ¿Cuándo Crear una Skill?

Creá una skill cuando identifiques alguno de estos escenarios:

1. **Procedimientos Repetitivos y Críticos:** Procesos con pasos secuenciales donde un error humano o de IA es costoso (ej: publicar releases en npm/GitHub, migraciones de base de datos, creación estandarizada de endpoints API).
2. **Estándares y Convenciones Estrictas:** Normas del proyecto que el agente debe seguir obligatoriamente (ej: formato de commits, diseño de interfaces, testing con TDD estricto).
3. **Flujos de Trabajo Multi-Herramienta:** Tareas que combinan varias herramientas en un orden determinado.

### 4.2 Ubicación de las Skills

- **Ámbito del Proyecto (Recomendado):** `.pi/skills/<nombre-skill>/SKILL.md` (versionado en el repositorio y compartido con el equipo).
- **Ámbito Global del Usuario:** `~/.pi/agent/skills/<nombre-skill>/SKILL.md` (disponible en todos los proyectos de tu máquina).

---

## 5. `pi-memory-md` — Memoria Persistente Offline en Markdown + Git

`pi-memory-md` resuelve la amnesia entre sesiones mediante **archivos Markdown estructurados con control de versiones Git**, sin requerir daemons HTTP ni bases de datos externas.

```
           ┌──────────────────────────────────────────────────────┐
           │             Sesión Actual de Pi (Terminal)           │
           └──────────────────────────┬───────────────────────────┘
                                      │
                   ┌──────────────────┴──────────────────┐
                   │ Lectura Contextual                  │ Escritura Automática
                   ▼                                     ▼
        ┌─────────────────────┐               ┌─────────────────────┐
        │    memory_search    │               │     tape_handoff    │
        │ Recupera decisiones │               │ Guarda checkpoints  │
        │ y notas técnicas    │               │ y memoria de sesión │
        └──────────┬──────────┘               └──────────┬──────────┘
                   │                                     │
                   └──────────────────┬──────────────────┘
                                      ▼
                      ┌───────────────────────────────┐
                      │ Archivos Markdown + Git Local │
                      │ ~/.pi/agent/memory/           │
                      └───────────────────────────────┘
```

### 5.1 Capacidades Principales

1. **Completamente Autónomo:** No depende de servidores en segundo plano; si tu terminal está abierta, la memoria funciona.
2. **Control de Versiones Git:** Cada decisión o aprendizaje queda registrado como un commit en el historial local de memoria.
3. **Integración con Tape:** Permite crear checkpoints de traspaso de tareas (`tape_handoff`) y sincronización entre sesiones.

---

## 6. `@narumitw/pi-plan-mode` & `@plannotator/pi-extension` — Planificación Guiada

El modo **`/plan`** activa un diálogo interactivo en memoria para definir la estrategia de solución antes de tocar el sistema de archivos:

- **Cero Mutaciones:** El agente tiene prohibido crear archivos, editar código o ejecutar comandos que alteren el repo durante la fase de plan.
- **Exploración en Solo Lectura:** Inspecciona archivos existentes para fundamentar sus propuestas en hechos reales.
- **Preguntas Estructuradas (`plan_mode_question`):** Presenta preguntas cerradas con opciones claras para resolver decisiones arquitectónicas.
- **Visualización con Plannotator:** Permite inspeccionar y anotar visualmente el plan antes de iniciar la implementación.

---

## 7. Extensiones Nativas de la Suite LazyPi

| Extensión | Instalación | Capacidades Principales |
| :--- | :--- | :--- |
| **`pi-subagents`** | `pi install npm:pi-subagents` | Orquestación concurrente, subagentes en paralelo y ejecución en worktrees aislados. |
| **`pi-ask-user`** | `pi install npm:pi-ask-user` | Menús interactivos con selección única o múltiple para decisiones críticas. |
| **`@narumitw/pi-plan-mode`** | `pi install npm:@narumitw/pi-plan-mode` | Modo interactivo de planificación socrática (`/plan`). |
| **`@plannotator/pi-extension`** | `pi install npm:@plannotator/pi-extension` | Visualizador y anotador interactivo de planes de desarrollo. |
| **`pi-antigravity`** | `pi install npm:pi-antigravity` | DeepMind Antigravity y motor de indexación semántica **CodeGraph**. |
| **`pi-memory-md`** | `pi install git:github.com/VandeeFeng/pi-memory-md` | Memoria persistente offline en Markdown y control de versiones Git. |
| **`pi-web-access`** | `pi install npm:pi-web-access` | Búsqueda web en tiempo real (Brave, Exa, Perplexity) y extracción de contenido. |
| **`pi-interactive-shell`** | `pi install npm:pi-interactive-shell` | Ejecución hands-free y supervisada de CLIs y agentes TUI en segundo plano. |

---

## 8. Cheatsheet Unificado de Comandos

```bash
# ── Gestión de Infraestructura (omc) ──────────────────────────────────────────
./omc dev                      # Instalar agente base pi
./omc dev status               # Ver versión de pi y estado de extensiones
./omc dev update               # Actualizar pi a latest
./omc update                   # Actualización total (Homebrew + Casks + pi)

# ── Suite Modular LazyPi ──────────────────────────────────────────────────────
pi install npm:pi-subagents              # Subagentes concurrentes y delegación
pi install npm:pi-ask-user               # Menús y confirmaciones interactivas
pi install npm:@narumitw/pi-plan-mode    # Planificación interactiva (/plan)
pi install npm:@plannotator/pi-extension # Visualización y anotación de planes
pi install npm:pi-antigravity            # DeepMind Antigravity y CodeGraph
pi install git:github.com/VandeeFeng/pi-memory-md # Memoria Markdown + Git
pi install npm:pi-web-access             # Búsqueda web y verificación
pi install npm:pi-interactive-shell      # TUI y CLIs interactivos en background

# ── Comandos Slash Nativos en Pi ──────────────────────────────────────────────
/plan <descripción>            # Iniciar planificación interactiva en memoria
pi list                        # Listar extensiones y herramientas activas
pi update                      # Actualizar todas las extensiones de usuario

# ── Interacción en Lenguaje Natural (Compound Engineering) ───────────────────
"Hagamos un brainstorm sobre <tema>"          # ce-brainstorm: Descubrimiento y límites
"Creá un plan técnico de arquitectura"        # ce-plan: Especificaciones y diseño
"Hacé un code review exhaustivo"              # ce-code-review: Revisión multi-agente
"Commiteá, pusheá y abrí el PR"               # ce-commit-push-pr: Entrega completa
"Guardá esta solución aprendida"              # ce-compound: Memoria en docs/solutions/
```
