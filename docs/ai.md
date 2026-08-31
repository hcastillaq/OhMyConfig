# 🤖 Ecosistema AI & Coding Agents

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. El enfoque es modular, riguroso y minimalista: la CLI `omc` instala y mantiene el agente base (**`pi`**), y vos activás únicamente las extensiones que potencian tu flujo de trabajo.

---

## 1. Manifiesto & Arquitectura del Ecosistema

La filosofía de ingeniería asistida por IA se basa en tres principios fundamentales:

1. **Cero código a ciegas:** Ningún cambio de arquitectura o funcionalidad no trivial debe programarse sin antes definir alcance, diseño y criterios de aceptación.
2. **Memoria de largo plazo:** El agente debe retener contexto técnico, convenciones y bugfixes históricos entre sesiones sin depender de prompts repetitivos.
3. **Flujo de terminal puro:** Todo el ciclo de vida (análisis, planificación, edición, pruebas, revisión y commits) ocurre en la consola mediante herramientas CLI/TUI ultrarrápidas.

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
│   │        gentle-pi          ││       gentle-engram       ││ @narumitw/    ││
│   │ • Spec-Driven Dev (SDD)   ││ • Memoria persistente     ││   pi-plan-mode││
│   │ • Catálogo de Skills      ││   SQLite (~/.engram/)     ││ • Modo /plan  ││
│   │ • /sdd-init & /sdd-status ││ • Retención de contexto   ││ • Preguntas   ││
│   │ • /sdd-continue dispatcher││ • mem_save / mem_search   ││   socráticas  ││
│   └───────────────────────────┘└───────────────────────────┘└───────────────┘│
│   ┌───────────────────────────┐┌───────────────────────────┐┌───────────────┐│
│   │       pi-subagents        ││      pi-antigravity       ││ pi-web-access ││
│   │ • Fanout paralelo/lanes   ││ • DeepMind Antigravity    ││ • Búsqueda    ││
│   │ • Modo Consejo (/council) ││ • CodeGraph semántico     ││   multi-motor ││
│   │ • Worktrees aislados      ││ • gentle_review audit     ││ • source_check││
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

## 3. `gentle-pi` & Spec-Driven Development (SDD)

`gentle-pi` es el harness de ingeniería de **Gentle AI**. Transforma a `pi` en un asistente con disciplina de arquitecto senior mediante la metodología **Spec-Driven Development (SDD / OpenSpec)**.

### 3.1 ¿Qué es Spec-Driven Development?

En lugar de saltar inmediatamente a modificar archivos tras un prompt, SDD establece un contrato formal y duradero dentro del repositorio bajo la carpeta `openspec/changes/<nombre-del-cambio>/`:

```
openspec/
├── config.yaml       # Configuración global del proyecto (generada por /sdd-init)
└── changes/
    └── autenticacion-oauth2/
        ├── proposal.md   # Motivación, alcance, criterios de éxito y non-goals
        ├── specs/        # Especificaciones técnicas formales de los módulos
        ├── design.md     # Decisiones de arquitectura, interfaces y trade-offs
        └── tasks.md      # Lista ordenada de tareas atómicas y verificables
```

### 3.2 Comandos Slash Nativos Registrados en Pi

`gentle-pi` registra los siguientes comandos nativos de barra diagonal (`/`):

| Comando Slash        | Acción y Propósito                                                                                              |
| :------------------- | :-------------------------------------------------------------------------------------------------------------- |
| **`/sdd-init`**      | Analiza el repositorio e inicializa `openspec/config.yaml` con la detección del stack y comandos de test.       |
| **`/sdd-status`**    | Consulta en solo lectura el estado del SDD activo, dependencias listas y tareas pendientes.                     |
| **`/sdd-continue`**  | Despachador nativo (_dispatcher_): evalúa el estado y avanza automáticamente a la siguiente fase lista del SDD. |
| **`/gentle:doctor`** | Diagnóstico del entorno, modelos configurados y extensiones de Gentle AI.                                       |
| **`/gentle:status`** | Resumen del estado general del harness de Gentle AI.                                                            |

### 3.3 ¿Cómo Iniciar un Cambio SDD? (Lenguaje Natural)

En Gentle AI, la creación de cambios se realiza mediante **lenguaje natural dirigido al orquestador**. No requiere un comando slash inventado, sino expresar tu intención directamente en el prompt:

- **Modo Guiado Paso a Paso (Secuencial con compuertas):**

  > _"Iniciá un cambio SDD para autenticacion-oauth2"_  
  > o _"Creá un nuevo cambio estructurado en SDD para sistema-pagos-stripe"_  
  > El orquestador genera `proposal.md`, se detiene a pedir tu confirmación (_gate 1_), luego genera `design.md` (_gate 2_), `tasks.md` (_gate 3_) y finalmente implementa.

- **Modo Acelerado (Fast-Forward):**
  > _"Creá un SDD fast-forward para autenticacion-oauth2"_  
  > o _"Generá todo el SDD completo en un paso para sistema-pagos-stripe"_  
  > El orquestador genera la propuesta, el diseño y el checklist de tareas en un solo paso y queda listo para implementar.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          MODO 1: Guiado Secuencial                          │
│                                                                             │
│  [1. Proposal] ──► 🛑 Gate 1 (Aprobación del desarrollador)                │
│        │                                                                    │
│  [2. Specs & Design] ──► 🛑 Gate 2 (Aprobación de arquitectura)             │
│        │                                                                    │
│  [3. Tasks Checklist] ──► 🛑 Gate 3 (Aprobación de tareas)                  │
│        │                                                                    │
│  [4. Implementación iterativa con subagentes y tests]                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         MODO 2: Fast-Forward (Acelerado)                    │
│                                                                             │
│  [Proposal + Specs + Design + Tasks generados en 1 solo paso]               │
│        │                                                                    │
│  [Implementación inmediata sobre el checklist de tasks.md]                  │
└─────────────────────────────────────────────────────────────────────────────┘
```

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

### 4.1 ¿Qué es una Skill vs un Prompt vs una Extensión?

| Tipo                   | Formato              | Cuándo se Carga                | Propósito Principal                                                                             |
| :--------------------- | :------------------- | :----------------------------- | :---------------------------------------------------------------------------------------------- |
| **Prompt Flotante**    | Mensaje en chat      | En el turno actual             | Instrucciones puntuales y efímeras. Se pierde al cerrar la sesión.                              |
| **Skill (`SKILL.md`)** | Markdown declarativo | Bajo demanda (_intent-driven_) | Procedimientos estandarizados y versionables en Git (ej: cómo hacer release, PRs, auditorías).  |
| **Extensión (`.ts`)**  | Código TypeScript    | Al iniciar Pi                  | Agrega nuevas herramientas ejecutables (`registerTool`) o comandos nativos (`registerCommand`). |

### 4.2 ¿Cuándo Crear una Skill?

Creá una skill cuando identifiques alguno de estos escenarios en cualquier proyecto o repositorio:

1. **Procedimientos Repetitivos y Críticos:** Procesos con pasos secuenciales donde un error humano o de IA es costoso (ej: publicar releases en npm/GitHub, migraciones de base de datos, creación estandarizada de endpoints API).
2. **Estándares y Convenciones Estrictas:** Normas del proyecto que el agente debe seguir obligatoriamente (ej: formato de commits, diseño de interfaces, testing con TDD estricto).
3. **Flujos de Trabajo Multi-Herramienta:** Tareas que combinan varias herramientas en un orden determinado (ej: auditar código con `rg`, ejecutar tests con `bash` y redactar un reporte con `write`).

> **Cuándo NO crear una skill:** Para tareas de una sola vez que no se van a repetir, o para consultas simples donde un prompt directo es suficiente.

---

### 4.3 ¿Cómo Crear una Skill Paso a Paso?

Disponés de la herramienta especializada **`/skill-creation`** provista por `gentle-pi`:

#### Paso 1: Ejecutar el Generador de Skills

Dentro de una sesión de Pi:

```text
> /skill-creation
```

O simplemente:

> _"Quiero crear una nueva skill llamada 'api-endpoint-creator' para estandarizar la creación de endpoints en esta API REST."_

#### Paso 2: Ubicación de la Skill

Las skills pueden guardarse en dos ámbitos:

- **Ámbito del Proyecto (Recomendado):** `.pi/skills/<nombre-skill>/SKILL.md` (se commitea en el repo y la comparten todos los colaboradores).
- **Ámbito Global del Usuario:** `~/.pi/agent/skills/<nombre-skill>/SKILL.md` (disponible en todos tus repositorios locales).

#### Paso 3: Estructura Estándar de `SKILL.md`

Un archivo de skill válido sigue este formato exacto:

```markdown
---
name: api-endpoint-creator
description: "Trigger: nuevo endpoint, crear endpoint, new route, api route. Guía la creación de endpoints REST con validación DTO, servicio y tests."
---

# API Endpoint Creator Skill

Esta skill define el protocolo obligatorio para agregar nuevos endpoints a la API del proyecto.

## Contexto y Requisitos

Cada nuevo endpoint debe implementar 4 capas sin excepción:

1. `src/dtos/`: Esquema de validación de entrada (Zod / Joi / class-validator).
2. `src/controllers/`: Manejador HTTP con códigos de estado semánticos.
3. `src/services/`: Lógica de negocio pura desacoplada de HTTP.
4. `tests/`: Pruebas de integración para casos de éxito (200/201) y error (400/404/422).

## Protocolo de Ejecución

1. **Definir DTO:** Crear el esquema de validación para el body y query params.
2. **Implementar Servicio:** Escribir la lógica de negocio con manejo de errores de dominio.
3. **Crear Controlador:** Exponer el endpoint y vincular el DTO con el middleware de validación.
4. **Escribir Pruebas:** Crear test de integración verificando la respuesta JSON y validaciones.
5. **Verificación:** Ejecutar la suite de tests (`npm test` o `pytest`) y asegurar que pase al 100%.

## Criterios de Aceptación

- Todos los tests unitarios y de integración pasan exitosamente.
- No hay tipos `any` implícitos ni variables sin tipar.
- El endpoint devuelve errores estructurados en formato JSON estándar.
```

#### Paso 4: Indexación y Descubrimiento (_Skill Registry_)

`gentle-pi` mantiene un registro indexado (`.atl/skill-registry.md`). El agente descubre automáticamente las skills leyendo el campo `description` del frontmatter:

- Si el usuario escribe _"creá un nuevo endpoint para listar usuarios con paginación"_, el agente detecta el trigger `nuevo endpoint`, carga la skill `api-endpoint-creator` y sigue su protocolo.

#### Paso 5: Auditoría y Refactorización con `skill-improver`

Podés auditar y elevar la calidad de cualquier skill existente pidiéndole al agente:

> _"Auditá y mejorá la skill `.pi/skills/api-endpoint-creator/SKILL.md` usando skill-improver."_

---

### 4.4 Catálogo de Skills Preconfiguradas en `gentle-pi`

| Skill                          | Disparador / Trigger                               | Función Principal                                          |
| :----------------------------- | :------------------------------------------------- | :--------------------------------------------------------- |
| **`gentle-ai-skill-creator`**  | `/skill-creation`, `crear skill`, `new skill`      | Crea nuevas skills modulares con frontmatter YAML válido.  |
| **`gentle-ai-skill-improver`** | `mejorar skill`, `audit skills`, `refactor skills` | Audita y eleva la calidad de skills existentes.            |
| **`skill-registry`**           | `actualizar skills`, `skill registry`              | Re-indexa el catálogo local de skills del proyecto.        |
| **`gentle-ai-branch-pr`**      | `crear PR`, `abrir PR`, `branch PR`                | Genera Pull Requests verificando issues y formato.         |
| **`gentle-ai-chained-pr`**     | `PRs grandes`, `chained PR`, `split PR`            | Divide cambios de >400 líneas en PRs encadenados.          |
| **`gentle-ai-judgment-day`**   | `judgment day`, `juzgar`, `revisión dual`          | Ejecuta revisión dual ciega y adversarial pre-merge.       |
| **`cognitive-doc-design`**     | `escribir doc`, `README`, `guía técnica`           | Diseña documentación optimizada contra la carga cognitiva. |

---

## 5. `gentle-engram` — Memoria Persistente entre Sesiones

`gentle-engram` resuelve la amnesia típica de las IAs mediante un motor de **memoria episódica y semántica respaldada por SQLite local** en `~/.engram/`.

```
           ┌──────────────────────────────────────────────────────┐
           │             Sesión Actual de Pi (Terminal)           │
           └──────────────────────────┬───────────────────────────┘
                                      │
                   ┌──────────────────┴──────────────────┐
                   │ Lectura Contextual                  │ Escritura Automática
                   ▼                                     ▼
        ┌─────────────────────┐               ┌─────────────────────┐
        │     mem_search      │               │      mem_save       │
        │ Recupera decisiones │               │ Guarda aprendizajes │
        │ y patrones previos  │               │ y bugfixes clave    │
        └──────────┬──────────┘               └──────────┬──────────┘
                   │                                     │
                   └──────────────────┬──────────────────┘
                                      ▼
                      ┌───────────────────────────────┐
                      │ Base de Datos SQLite Local    │
                      │ ~/.engram/engram.db           │
                      └───────────────────────────────┘
```

### 5.1 ¿Qué Almacena la Memoria?

1. **Decisiones de Arquitectura (`architecture`):** Por qué se eligió cierta estructura o tecnología.
2. **Bugfixes y Gotchas (`bugfix`):** Soluciones a errores complejos para evitar re-investigarlos en el futuro.
3. **Patrones y Convenciones (`pattern` / `preference`):** Estilos de nombrado, directrices del proyecto y preferencias de tooling.
4. **Resúmenes de Sesión (`session_summary`):** Qué objetivos se lograron en cada sesión de trabajo.

### 5.2 Comandos y Herramientas en la Sesión

- **Consultar memoria histórica:**
  > _"¿Qué decisiones tomamos la semana pasada sobre el esquema de la base de datos de usuarios?"_ $\rightarrow$ ejecuta `mem_search` y sintetiza el contexto.
- **Guardar una regla explícita:**
  > _"Guardá en memoria que todos los controladores de la API deben validar los permisos del usuario usando el middleware `requireRole('admin')`."_ $\rightarrow$ ejecuta `mem_save`.
- **Auditoría de estado:**
  > _"Ejecutá un diagnóstico de la memoria con `mem_doctor`."_

---

## 6. `@narumitw/pi-plan-mode` — Planificación Socrática (`/plan`)

El modo **`/plan`** activa un diálogo interactivo en memoria para definir la estrategia de solución antes de tocar el sistema de archivos.

### 6.1 Reglas del Modo Plan

- **Cero Mutaciones:** El agente tiene prohibido crear archivos, editar código o ejecutar comandos que alteren el repo.
- **Exploración en Solo Lectura:** Inspecciona archivos existentes para fundamentar sus propuestas en hechos reales.
- **Preguntas Estructuradas (`plan_mode_question`):** Presenta entre 1 y 3 preguntas con opciones cerradas para resolver trade-offs.
- **Plan Decisión-Completo (`plan_mode_complete`):** Finaliza emitiendo un documento Markdown exhaustivo sin cabos sueltos.

---

## 7. Estrategia Maestra: De `/plan` a SDD (El Flujo Óptimo)

La combinación de **`/plan` + SDD** representa la mejor práctica para abordar funcionalidades medianas o grandes:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            EL FLUJO MAESTRO                                 │
│                                                                             │
│  1. DESCUBRIMIENTO (En memoria con /plan)                                   │
│     > /plan implementá un sistema de rate limiting con Redis                │
│     • El agente inspecciona el repo                                         │
│     • Plantea 2 preguntas interactivas con opciones (algoritmo, fallback)   │
│     • Vos seleccionás el enfoque preferido                                  │
│     • Emite el Implementation Plan final                                    │
│                                                                             │
│  2. PERSISTENCIA FORMAL (En disco en openspec/)                             │
│     > "Excelente plan, pasalo a SDD fast-forward para rate-limiting-redis"  │
│     • Vuelca el plan acordado en openspec/changes/rate-limiting-redis/      │
│     • Genera proposal.md, design.md y tasks.md sin tener que reescribir     │
│                                                                             │
│  3. EJECUCIÓN METÓDICA (/sdd-continue)                                      │
│     • El agente ejecuta tarea por tarea marcando [x] en tasks.md            │
│     • Corre tests de verificación en cada paso                              │
│                                                                             │
│  4. CIERRE Y MEMORIA                                                        │
│     • Guarda los aprendizajes clave en gentle-engram (mem_save)             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 7.1 Matriz de Decisión: ¿Qué Herramienta Usar?

```text
                             ¿Qué tamaño tiene la tarea?
                                          │
           ┌──────────────────────────────┼──────────────────────────────┐
           ▼                              ▼                              ▼
     [ Tarea Pequeña ]             [ Tarea Mediana ]              [ Tarea Grande ]
   (1 archivo / Fix menor)      (Módulo nuevo / Refactor)       (Nueva feature crítica)
           │                              │                              │
           ▼                              ▼                              ▼
    Prompt Directo              /plan  ──► SDD Fast-Forward         SDD Guiado
  "Corregí el typo en el        Diseño interactivo y pase       Paso a paso con gates
   mensaje del login"           automático a tasks.md           formales de aprobación
```

---

## 8. Extensiones Complementarias del Stack

### 8.1 `pi-subagents` — Orquestación Concurrente & Modo Consejo

- **Instalación:** `pi install pi-subagents`
- **Capacidades:**
  - **Modo Consejo (`/council`):** Convoca múltiples agentes especializados (ej: arquitecto, tester, especialista en seguridad) para debatir una decisión técnica compleja antes de implementarla.
  - **Worktrees Aislados:** Ejecuta tareas en ramas efímeras paralelas de git sin colisionar con tu espacio de trabajo actual.

### 8.2 `pi-antigravity` — DeepMind Antigravity & CodeGraph

- **Instalación:** `pi install pi-antigravity`
- **Capacidades:**
  - **`codegraph`:** Indexación semántica del árbol de llamadas y dependencias del proyecto sin ejecutar scripts externos.
  - **`gentle_review`:** Transacciones de revisión formal previas a merge con verificación estricta de integridad.

### 8.3 `pi-web-access` — Acceso Web & Verificación de Fuentes

- **Instalación:** `pi install pi-web-access`
- **Capacidades:**
  - **`web_search`:** Búsqueda en tiempo real mediante Brave, Exa, OpenAI, Perplexity o SearXNG.
  - **`fetch_content`:** Extracción limpia de páginas web, repositorios de GitHub y PDFs técnicos.
  - **`source_check`:** Validación de afirmaciones técnicas contra documentación oficial en la web.

---

## 9. Cheatsheet Unificado de Comandos

```bash
# ── Gestión de Infraestructura (omc) ──────────────────────────────────────────
./omc dev                      # Instalar agente base pi
./omc dev status               # Ver versión de pi y estado de extensiones
./omc dev update               # Actualizar pi a latest
./omc update                   # Actualización total (Homebrew + Casks + pi)

# ── Extensiones Recomendadas en Pi ────────────────────────────────────────────
pi install gentle-pi           # SDD, OpenSpec, skills y reviews
pi install gentle-engram       # Memoria persistente SQLite (~/.engram/)
pi install pi-subagents        # Subagentes en paralelo y modo /council
pi install pi-antigravity      # DeepMind Antigravity y CodeGraph
pi install pi-web-access       # Búsqueda web y chequeo de fuentes
pi install @narumitw/pi-plan-mode # Modo interactivo de planificación (/plan)

# ── Comandos Slash Nativos en Pi ──────────────────────────────────────────────
/plan <descripción>            # Iniciar planificación interactiva en memoria
/sdd-init                      # Inicializar openspec/config.yaml en el repo
/sdd-status                    # Ver estado actual del SDD y tareas pendientes
/sdd-continue                  # Avanzar a la siguiente fase lista del SDD
/council <tema>                # Convocar consejo de asesores para debatir
/skill-creation                # Crear una nueva skill modular

# ── Disparadores SDD por Lenguaje Natural ─────────────────────────────────────
"Iniciá un cambio SDD para <nombre>"          # Modo guiado secuencial (proposal -> design -> tasks)
"Creá un SDD fast-forward para <nombre>"      # Modo acelerado (genera todo en 1 paso)
```
