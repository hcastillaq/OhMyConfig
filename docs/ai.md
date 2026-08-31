# 🤖 Ecosistema AI & Coding Agents (LazyPi)

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. El enfoque es modular, riguroso y minimalista: la CLI `omc` instala y mantiene el agente base (**`pi`**), complementado por la suite oficial **LazyPi** ([lazypi.org](https://lazypi.org)), el framework **Compound Engineering (CE)** y la disciplina de **Spec-Driven Development (SDD / OpenSpec)**.

---

## 1. Manifiesto & Arquitectura del Ecosistema

La filosofía de LazyPi en OhMyConfig se inspira en el modelo de LazyVim: **un núcleo preconfigurado y mantenido por la comunidad con un catálogo curado de 17 herramientas de alto rendimiento**:

1. **Cero código a ciegas:** Todo cambio se estructura mediante requerimientos claros, contratos de datos y diseño técnico antes de escribir código.
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
│   │   LazyPi Core (12 pkgs)   ││ LazyPi Optional (5 pkgs)  ││  OpenSpec SDD ││
│   │ • subagents & workflows   ││ • lsp (diagnósticos)      ││ • proposal.md ││
│   │ • ask-user & goal         ││ • interactive-shell (TUI) ││ • specs/      ││
│   │ • fff & web-access        ││ • memory-md (Git offline) ││ • design.md   ││
│   │ • simplify & ponytail     ││ • autoresearch (loops)    ││ • tasks.md    ││
│   │ • skillful & mention ($)  ││ • todos (checklist live)  ││ • docs/solut. ││
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

## 3. Arquitecturas de Software con LazyPi: DDD, Clean Architecture & TDD

El diseño de software desacoplado no solo es una buena práctica de ingeniería: **es el factor clave que permite a los agentes de IA operar con máxima precisión y mínimo consumo de tokens**.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CLEAN ARCHITECTURE / DOMAIN-DRIVEN DESIGN                │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                        1. DOMINIO (Core)                            │   │
│   │   • Entidades de Negocio, Value Objects, Domain Events              │   │
│   │   • Cero dependencias externas (sin frameworks, sin DB, sin HTTP)   │   │
│   └──────────────────────────────────┬──────────────────────────────────┘   │
│                                      │                                      │
│                                      ▼                                      │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                    2. APLICACIÓN (Casos de Uso)                     │   │
│   │   • Commands, Queries, Handlers, Interfaces de Puertos (Ports)      │   │
│   └──────────────────────────────────┬──────────────────────────────────┘   │
│                                      │                                      │
│                     ┌────────────────┴────────────────┐                     │
│                     ▼                                 ▼                     │
│   ┌──────────────────────────────────┐┌─────────────────────────────────┐   │
│   │   3. INFRAESTRUCTURA (Adapters)  ││    4. INTERFACES / UI (Drivers) │   │
│   │   • Repositorios (Postgres/Redis)││    • Controladores REST / GraphQL│  │
│   │   • SDKs de Terceros / Mensajería││    • CLI / TUI / Event Listeners │  │
│   └──────────────────────────────────┘└─────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 3.1 Domain-Driven Design (DDD) & Hexagonal Architecture

#### Estructura de Directorios Recomendada

```
src/
└── modules/
    └── billing/                         # Bounded Context: Facturación
        ├── domain/                      # 1. Capa de Dominio (Pura)
        │   ├── entities/Invoice.ts
        │   ├── value-objects/Money.ts
        │   └── events/InvoiceIssued.ts
        ├── application/                 # 2. Capa de Aplicación (Casos de Uso)
        │   ├── use-cases/CreateInvoice.ts
        │   └── ports/InvoiceRepository.ts # Interfaz de Puerto
        ├── infrastructure/              # 3. Adaptadores de Infraestructura
        │   ├── persistence/PostgresInvoiceRepo.ts
        │   └── gateways/StripePaymentGateway.ts
        └── interfaces/                  # 4. Controladores / Endpoints
            └── http/InvoiceController.ts
```

#### Cómo Sacarle el Máximo Provecho con LazyPi

1. **Aislamiento de Contexto con `fffind` / `ffgrep` (`fff`):**  
   Cuando le pedís al agente modificar una regla de negocio, solo necesita inspeccionar `domain/` y `application/`. No requiere cargar controladores ni modelos de base de datos en su contexto.
2. **Validación de la Regla de Dependencias con `codegraph` (`pi-antigravity`):**  
   Podés auditar semánticamente que la capa de `domain/` no importe nada de `infrastructure/` ni de librerías externas.
3. **Verificación de Contratos con `lsp_diagnostics` (`@narumitw/pi-lsp`):**  
   Al implementar un adaptador (`PostgresInvoiceRepo`), el diagnóstico LSP asegura que cumpla al 100% la interfaz del puerto (`InvoiceRepository`) sin errores de tipos.

#### Ejemplo de Conversación en Lenguaje Natural

> **Usuario:** *"Vamos a implementar el caso de uso `CreateInvoice` en el módulo `billing` siguiendo Clean Architecture. Primero definí la interfaz del puerto y la entidad de dominio con sus invariantes."*  
> **Pi:** Genera `domain/entities/Invoice.ts` y `application/ports/InvoiceRepository.ts` con tipado estricto, sin frameworks. Luego usa `lsp_diagnostics` para validar que no haya errores de importación.

---

### 3.2 Test-Driven Development (TDD Estricto & BDD)

El ciclo **TDD** con LazyPi garantiza que cada línea de código tenga cobertura y justificación técnica antes de escribirse.

```
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│     1. RED      │ ───►  │    2. GREEN     │ ───►  │  3. REFACTOR    │
│  Escribir test  │       │ Implementación  │       │ /ponytail audit │
│  que falle      │       │ mínima que pase │       │ /simplify       │
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

#### Cómo Ejecutar TDD con LazyPi

1. **Fase RED:** El agente crea el archivo de prueba unitaria en `tests/` y ejecuta el test con `bash` (`npm test`, `pytest`, `cargo test`), confirmando que falle por el motivo correcto.
2. **Fase GREEN:** Escribe el código de producción mínimo indispensable para pasar la prueba.
3. **Fase TRIANGULATE:** Agrega casos de borde (valores nulos, límites numéricos, cadenas vacías).
4. **Fase REFACTOR:**  
   - Ejecuta `/ponytail review` para asegurar que no se hayan introducido dependencias innecesarias.
   - Ejecuta `/simplify` para eliminar redundancias y pulir el código.

---

### 3.3 Event-Driven Architecture (EDA) & CQRS

Para arquitecturas reactivas desacopladas mediante eventos de dominio:

1. **Separación Command/Query:** Los comandos mutan el estado y emiten un evento (`InvoicePaidEvent`); las queries leen proyecciones optimizadas.
2. **Testing Asíncrono Aislado:** Se utilizan subagentes (`pi-subagents`) para simular productores y consumidores de eventos en paralelo.

---

## 4. Análisis de Eficiencia de Tokens & Context Engineering

Trabajar con Inteligencia Artificial sin arquitectura produce lo que en ingeniería llamamos **"Monolithic Prompting"** y saturación del contexto:

```
❌ ENFOQUE MONOLÍTICO TRADICIONAL (Sin Arquitectura)
┌─────────────────────────────────────────────────────────────────────────────┐
│ Prompt: "Cambiá la forma en que se cobran las facturas"                     │
│ • El agente debe leer 40 archivos de controladores, modelos, DB y vistas.   │
│ • Consumo por turno: ~65.000 tokens de contexto.                            │
│ • Resultado: Alucinaciones, pérdida de atención, lentitud y alto costo.     │
└─────────────────────────────────────────────────────────────────────────────┘

✅ ENFOQUE LAZYPI + DDD + COMPOUND ENGINEERING (Arquitectura Modular)
┌─────────────────────────────────────────────────────────────────────────────┐
│ Prompt: "$ce-work Implementar regla de descuento en Invoice.ts"             │
│ • El agente lee únicamente Invoice.ts y CreateInvoice.ts.                   │
│ • Consumo por turno: ~2.500 tokens de contexto.                             │
│ • Resultado: Precisión quirúrgica, respuesta instantánea y costo mínimo.    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 4.1 Mecanismos Clave de LazyPi para Reducir el Consumo de Tokens

1. **Aislamiento por Bounded Contexts (DDD):**  
   Al mantener límites modulares claros, el agente solo necesita interactuar con el módulo específico en el que está trabajando, reduciendo en un **80-90%** los archivos que ingresan al contexto.
2. **Búsqueda Quirúrgica con `fff` (`@ff-labs/pi-fff`) y `codegraph`:**  
   En lugar de hacer lecturas masivas de carpetas enteras, `fffind` y `ffgrep` localizan las líneas exactas en milisegundos, inyectando solo el fragmento necesario.
3. **Protección del Contexto Padre con Subagentes (`pi-subagents` / `ce-worktree`):**  
   Cuando se lanza una auditoría o un test largo, el trabajo ocurre en el contexto efímero del subagente. Al finalizar, el subagente devuelve un resumen conciso de 300 tokens al hilo principal, evitando que miles de líneas de logs de prueba inflen tu sesión.
4. **Consultas Rápidas Fuera de Historial con `/btw`:**  
   Preguntas de sintaxis o conceptos no se guardan en la conversación principal, manteniendo el historial ligero para las tareas de código reales.
5. **Poda Activa de Código Muerto con `/simplify` y `/ponytail`:**  
   Al mantener el código conciso y libre de sobreingeniería, los archivos del proyecto son naturalmente más cortos, reduciendo el costo de tokens en todas las sesiones futuras.

---

### 4.2 Matriz de Ahorro y Rendimiento

| Métrica | Sin Metodología (Ad-hoc) | Con LazyPi + DDD + CE | Impacto |
| :--- | :---: | :---: | :---: |
| **Tokens promedio por turno** | 45.000 - 80.000 tokens | 2.000 - 6.000 tokens | **-85% consumo** 📉 |
| **Velocidad de respuesta (TTFT)** | 8 - 15 segundos | 1 - 3 segundos | **4x más rápido** ⚡ |
| **Precisión en primer intento** | ~55% (requiere reintentos) | >92% (validado con specs) | **Cero re-trabajo** 🎯 |
| **Contaminación de historial** | Alta (logs de tests en chat) | Nula (aislado en subagentes) | **Sesiones limpias** 🧹 |

---

## 5. Implementación de SDD (Spec-Driven Development) con LazyPi

**Spec-Driven Development (SDD / OpenSpec)** formaliza los requerimientos antes de tocar código mediante la carpeta `openspec/changes/<nombre-del-cambio>/`:

```
openspec/
├── config.yaml          # Metadatos del stack, comandos de test y convenciones
└── changes/             # Carpeta de cambios activos o archivados
    └── sistema-auth-jwt/
        ├── proposal.md  # 1. Motivación, alcance, criterios de éxito y non-goals
        ├── specs/       # 2. Especificaciones formales y contratos de interfaces
        ├── design.md    # 3. Decisiones de arquitectura, trade-offs y diagramas
        └── tasks.md     # 4. Checklist secuencial de tareas atómicas verificables
```

### 5.1 Mapeo de Herramientas LazyPi a cada Fase de SDD

```
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   1. PROPOSAL    │ ──► │ 2. SPECS/DESIGN  │ ──► │  3. DOC REVIEW   │
│  pi-ask-user     │     │  ce-plan         │     │  ce-doc-review   │
│  ce-brainstorm   │     │  codegraph       │     │  subagents (x3)  │
└──────────────────┘     └──────────────────┘     └──────────────────┘
                                                            │
┌──────────────────┐     ┌──────────────────┐               ▼
│  6. CAPITALIZAR  │ ◄── │  5. CODE REVIEW  │ ◄── ┌──────────────────┐
│  pi-memory-md    │     │  ponytail/simpl. │     │ 4. TASKS / WORK  │
│  ce-compound     │     │  ce-code-review  │     │  ce-worktree     │
└──────────────────┘     └──────────────────┘     │  lsp_diagnostics │
                                                  │  todos widget    │
                                                  └──────────────────┘
```

---

## 6. Sistema de Skills: Descubrimiento, Invocación y Creación

Las **Skills** son unidades modulares de conocimiento procedimental empaquetadas en archivos Markdown estructurados (`SKILL.md`). Permiten que el agente ejecute protocolos complejos y repetitivos sin necesidad de extensiones pesadas en TypeScript.

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

### 6.1 Invocación con `$` y `/skill`

1. **Mención Difusa con `$` (`@zigai/pi-mention-skill`):** Escribí `$` en tu prompt para autocompletar cualquier skill (ej: `$ce-plan`, `$ce-code-review`).
2. **Expansión Directa (`pi-skillful`):** `/skill:<nombre>` para invocar la skill directamente.

### 6.2 Plantilla para Crear Nuevas Skills en `.pi/skills/`

```markdown
---
name: nombre-de-la-skill
description: "Trigger: palabra1, palabra2, disparador. Explicación concisa del protocolo."
---

# Título de la Skill

Descripción del objetivo de ingeniería que resuelve esta skill.

## Contexto y Restricciones
- **Invariante 1:** Regla estricta que no se puede violar.
- **Invariante 2:** Tecnologías o librerías obligatorias.

## Protocolo de Ejecución Paso a Paso
1. **Fase 1: Inspección y Diagnóstico:** Leer archivos con `read` o buscar con `fffind` / `ffgrep`.
2. **Fase 2: Aplicación del Cambio:** Implementar paso a paso.
3. **Fase 3: Verificación:** Ejecutar suite de tests y validar con `lsp_diagnostics`.

## Criterios de Aceptación
- [ ] Tests unitarios e integración pasan al 100%.
- [ ] Sin errores de tipos reportados por LSP.
```

---

## 7. Comandos Slash (`/`) y Menciones (`$`) de LazyPi

| Comando / Mención | Contexto | Descripción |
| :--- | :--- | :--- |
| **`/plan <desc>`** | Pi Session | Inicia el modo de planificación socrática en memoria. |
| **`/simplify`** | Pi Session | Simplifica y limpia el código modificado recientemente. |
| **`/ponytail review`** | Pi Session | Audita código buscando patrones de sobreingeniería y complejidad. |
| **`/ponytail audit`** | Pi Session | Inspección profunda de deuda técnica y dependencias. |
| **`/btw <pregunta>`** | Pi Session | Consulta rápida sin contaminar el contexto principal. |
| **`/goal <meta>`** | Pi Session | Fija un objetivo de largo plazo con control de estados. |
| **`/workflows`** | Pi Session | Abre el panel TUI interactivo para orquestar flujos de subagentes. |
| **`/fff-health`** | Pi Session | Verifica la salud y velocidad del índice de búsqueda rápida. |
| **`$skill-name`** | Pi Session | Mención difusa para autocompletar e inyectar cualquier skill en el prompt. |

---

## 8. Gestión del Ecosistema desde `omc`

La CLI `omc` administra el ciclo de vida de **Pi y LazyPi** de forma 100% nativa:

```bash
./omc dev              # Ejecuta el instalador oficial de LazyPi (Core + Optional 17 pkgs)
./omc dev status       # Muestra el estado y diagnóstico del catálogo LazyPi
./omc dev update       # Actualiza el binario de Pi y todas las extensiones instaladas
./omc dev doctor       # Chequeo de salud del entorno (Node, npm, git, auth, settings)
./omc dev remove       # Selector interactivo para desinstalar extensiones
./omc update           # Actualización total del sistema (Homebrew + Casks + Pi + LazyPi)
```
