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

## 2. Guía Metodológica: Cómo Trabajar con Diferentes Metodologías en Pi

Pi se adapta a diferentes niveles de rigor y tamaño de tarea. Podés indicarle la metodología deseada en lenguaje natural según la necesidad del proyecto:

---

### Metodología A: Spec-Driven Development (SDD / OpenSpec)

**¿Para qué sirve?** Para cambios arquitectónicos grandes, refactorizaciones profundas o módulos críticos donde el diseño debe persistir en el repositorio antes de tocar código.

#### Estructura de Artefactos en Disco
Se genera una carpeta formal en `openspec/changes/<nombre-del-cambio>/`:

```
openspec/
└── changes/
    └── cache-layer-redis/
        ├── proposal.md   # Problema, motivación, límites del alcance y non-goals
        ├── specs/        # Especificaciones técnicas y contratos de interfaces
        │   └── cache-contract.md
        ├── design.md     # Decisiones de arquitectura, trade-offs y diagramas
        └── tasks.md      # Checklist secuencial de tareas atómicas verificables
```

#### Flujo de Trabajo en Lenguaje Natural

1. **Paso 1 (Propuesta y Alcance):**
   > *"Iniciá un cambio SDD para `cache-layer-redis`. Redactá la propuesta inicial definiendo el problema y qué queda fuera de alcance."*
   > *El agente crea `proposal.md` y espera tu revisión.*

2. **Paso 2 (Especificaciones y Diseño):**
   > *"La propuesta está aprobada. Generá las especificaciones en `specs/` y el documento de arquitectura `design.md` explicando la estrategia de invalidación."*
   > *El agente genera el diseño técnico con trade-offs.*

3. **Paso 3 (Checklist de Tareas):**
   > *"Excelente diseño. Creá el archivo `tasks.md` con las tareas atómicas y criterios de aceptación."*

4. **Paso 4 (Ejecución Paso a Paso):**
   > *"Comenzá a implementar las tareas de `tasks.md` una por una, corriendo tests en cada paso y marcando `[x]` al completar."*

---

### Metodología B: Compound Engineering (CE)

**¿Para qué sirve?** El flujo estándar para nuevas funcionalidades medianas y desarrollo ágil asistido por subagentes especializados.

```
1. Brainstorm ──► 2. Tech Plan ──► 3. Doc Review ──► 4. Work & Test ──► 5. Code Review ──► 6. Commit & PR ──► 7. Compound
```

#### Flujo de Trabajo en Lenguaje Natural

1. **Descubrimiento:**
   > *"Hagamos un brainstorm sobre cómo agregar soporte para múltiples formatos de salida en la CLI."*
   > *(Activa `ce-brainstorm`: hace preguntas sobre requerimientos y casos límite).*
2. **Plan de Arquitectura:**
   > *"Armá un plan técnico de arquitectura con archivos afectados y riesgos."*
   > *(Activa `ce-plan`: produce un plan exhaustivo).*
3. **Auditoría de Diseño:**
   > *"Auditá el plan con subagentes antes de arrancar."*
   > *(Activa `ce-doc-review`: subagentes revisores buscan fallas de diseño).*
4. **Implementación:**
   > *"Ejecutá el plan aprobado."*
   > *(Activa `ce-work`: implementa y verifica calidad).*
5. **Revisión de Código:**
   > *"Hacé un code review exhaustivo de los cambios."*
   > *(Activa `ce-code-review`: revisores independientes emiten reporte).*
6. **Entrega:**
   > *"Commiteá los cambios y abrí el PR."*
   > *(Activa `ce-commit-push-pr`: genera commits atómicos y redacta el PR).*
7. **Capitalización:**
   > *"Guardá esta solución en docs/solutions/."*
   > *(Activa `ce-compound`: registra el aprendizaje técnico).*

---

### Metodología C: Test-Driven Development (TDD Estricto)

**¿Para qué sirve?** Para lógica de negocio compleja, algoritmos, cálculos financieros, parsers y funciones puras donde se exige cobertura total.

#### Flujo de Trabajo en Lenguaje Natural

> *"Vamos a implementar el módulo de validación de tokens siguiendo TDD estricto. No escribas código de producción sin un test en rojo primero."*

1. **RED:** El agente escribe el test unitario fallido y ejecuta la suite (`npm test`, `pytest`, `cargo test`) demostrando que falla.
2. **GREEN:** Escribe la implementación mínima necesaria para hacer pasar el test.
3. **TRIANGULATE:** Agrega casos de borde y pruebas adicionales para forzar una solución general.
4. **REFACTOR:** Limpia el código manteniendo la suite de pruebas en verde.

---

### Metodología D: Bucles Iterativos Autónomos (Ralph Loops & Autoresearch)

**¿Para qué sirve?** Para refactorizaciones masivas que tocan decenas de archivos, migraciones de librerías o tareas de optimización que requieren múltiples iteraciones controladas con checkpoints.

#### Flujo de Trabajo en Lenguaje Natural

* **Bucle Iterativo con Pacing (`pi-ralph-wiggum`):**
  > *"Iniciá un loop de desarrollo para migrar todos los componentes de clase a hooks de React en 10 iteraciones, verificando los tests tras cada componente."*
  > *El agente trabaja por iteraciones, valida el progreso y se pausa para checkpoints.*

* **Optimización guiada por Métricas (`ce-optimize` / `pi-autoresearch`):**
  > *"Optimizá la velocidad de inicio de la CLI en un loop: medí el tiempo de arranque, probá un cambio y conservalo solo si mejora el benchmark."*

---

### Metodología E: Hotfix & One-Shot (Edición Directa)

**¿Para qué sirve?** Para correcciones de 1 a 3 líneas, typos en documentación, actualización de un flag o cambios triviales donde la ceremonia de specs es innecesaria.

#### Flujo de Trabajo en Lenguaje Natural

> *"Corregí el typo en la línea 45 de `config.fish` y guardá el archivo."*  
> *El agente lee el archivo, realiza la edición directa y finaliza inmediatamente.*

---

## 3. Matriz de Decisión: ¿Qué Metodología Elegir?

| Tipo de Tarea | Complejidad | Metodología Recomendada | Herramientas en Pi |
| :--- | :---: | :--- | :--- |
| **Cambio de arquitectura mayor** | Alta | **SDD (OpenSpec)** | Carpetas `openspec/`, `proposal`, `design` |
| **Nueva funcionalidad / Feature** | Media / Alta | **Compound Engineering** | `ce-brainstorm`, `ce-plan`, `ce-code-review` |
| **Lógica crítica / Algoritmos** | Media | **TDD Estricto** | Tests unitarios, subagentes ejecutores |
| **Refactor masivo / Migración** | Alta | **Bucle Ralph / Autoresearch** | `ralph_start`, `ce-optimize` |
| **Fix puntual / Typo** | Baja | **Hotfix Directo** | Herramientas nativas `edit` / `write` |

---

## 4. Gestión de Memoria Persistente con `pi-memory-md`

`pi-memory-md` resuelve la amnesia entre sesiones mediante **archivos Markdown estructurados con control de versiones Git**, completamente offline y sin requerir daemons HTTP externos:

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

### Ejemplos de Uso en Sesión

- **Guardar un checkpoint de traspaso:**
  > *"Guardá un handoff en tape con el estado actual de la refactorización para continuar en la próxima sesión."*
- **Consultar decisiones pasadas:**
  > *"Buscá en memoria qué decisiones tomamos sobre la gestión de symlinks en deploy.sh."*

---

## 5. Planificación Socrática con `@narumitw/pi-plan-mode`

El comando **`/plan`** activa un diálogo interactivo en memoria para definir la estrategia de solución antes de tocar el sistema de archivos:

```bash
/plan Diseñar un sistema de plugins dinámicos para la CLI
```

1. **Cero Mutaciones:** El agente tiene prohibido crear archivos o editar código durante la fase de plan.
2. **Preguntas Estructuradas:** Presenta entre 1 y 3 preguntas con opciones cerradas para resolver trade-offs técnicos.
3. **Inspección Visual con Plannotator:** Permite inspeccionar y anotar visualmente el plan generado (`@plannotator/pi-extension`).

---

## 6. Skills en el Ecosistema: ¿Cómo Crearlas?

Las **Skills** son unidades modulares de conocimiento procedimental empaquetadas en archivos Markdown estructurados (`SKILL.md`):

```markdown
---
name: nombre-de-la-skill
description: "Trigger: palabras clave, disparadores. Descripción clara del protocolo."
---

# Título de la Skill

## Contexto y Requisitos
Reglas obligatorias que el agente debe respetar.

## Protocolo de Ejecución Paso a Paso
1. Inspeccionar el código.
2. Ejecutar pruebas.
3. Aplicar cambios.

## Criterios de Aceptación
- Checklist de verificación final.
```

### Ubicación
- **Proyecto (Recomendado):** `.pi/skills/<nombre-skill>/SKILL.md` (se comparte con el equipo en Git).
- **Global:** `~/.pi/agent/skills/<nombre-skill>/SKILL.md` (disponible en toda tu máquina).

---

## 7. Catálogo de Extensiones de la Suite LazyPi

| Extensión | Instalación | Capacidades Principales |
| :--- | :--- | :--- |
| **`pi-subagents`** | `pi install npm:pi-subagents` | Orquestación concurrente, subagentes en paralelo y delegación en worktrees. |
| **`pi-ask-user`** | `pi install npm:pi-ask-user` | Menús interactivos con selección única o múltiple para decisiones críticas. |
| **`@narumitw/pi-plan-mode`** | `pi install npm:@narumitw/pi-plan-mode` | Modo interactivo de planificación socrática (`/plan`). |
| **`@plannotator/pi-extension`** | `pi install npm:@plannotator/pi-extension` | Visualizador y anotador interactivo de planes de desarrollo. |
| **`pi-antigravity`** | `pi install npm:pi-antigravity` | DeepMind Antigravity y motor de indexación semántica **CodeGraph**. |
| **`pi-memory-md`** | `pi install git:github.com/VandeeFeng/pi-memory-md` | Memoria persistente offline en Markdown y control de versiones Git. |
| **`pi-web-access`** | `pi install npm:pi-web-access` | Búsqueda web en tiempo real (Brave, Exa, Perplexity) y extracción de contenido. |
| **`pi-interactive-shell`** | `pi install npm:pi-interactive-shell` | Ejecución hands-free y supervisada de CLIs y agentes TUI en background. |
| **`pi-ralph-wiggum`** | `pi install npm:@tmustier/pi-ralph-wiggum` | Bucles iterativos de desarrollo con pacing y checkpoints. |

---

## 8. Cheatsheet Rápido de Prompts y Comandos

```bash
# ── Gestión de Infraestructura (omc) ──────────────────────────────────────────
./omc dev                      # Instalar agente base pi
./omc dev status               # Ver versión de pi y estado de extensiones
./omc dev update               # Actualizar pi a latest
./omc update                   # Actualización total (Homebrew + Casks + pi)

# ── Planificación y Análisis ──────────────────────────────────────────────────
/plan <descripción>            # Iniciar modo de planificación en memoria
"Hagamos un brainstorm sobre <tema>"      # ce-brainstorm: Descubrimiento de alcance
"Creá un plan técnico de arquitectura"    # ce-plan: Especificaciones y diseño
"Iniciá un cambio SDD para <nombre>"      # SDD nativo en openspec/changes/

# ── Ejecución y Pruebas ───────────────────────────────────────────────────────
"Implementá el plan con TDD estricto"     # Flujo Red -> Green -> Refactor
"Hacé un code review de los cambios"      # ce-code-review: Revisión multi-agente
"Commiteá, pusheá y abrí el PR"           # ce-commit-push-pr: Entrega en GitHub
"Guardá esta solución en docs/solutions"  # ce-compound: Capitalizar aprendizaje
```
