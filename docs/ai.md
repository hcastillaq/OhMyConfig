# 🤖 Ecosistema AI & Coding Agents (Pi & LazyPi)

OhMyConfig integra un entorno de **ingeniería de software asistida por Inteligencia Artificial y agentes autónomos de código** directamente en la terminal. Esta guía explica qué herramientas componen el stack, cómo reducen el consumo de tokens y cómo aplicar metodologías de desarrollo, patrones de arquitectura y skills personalizadas.

---

## 1. ¿Qué es Pi?

**`pi`** (`@earendil-works/pi-coding-agent`) es el motor de ejecución autónomo y CLI de desarrollo en terminal.

### Características Principales:
* **Velocidad Nativa:** Diseñado para terminales modernas con arranque instantáneo e interfaz interactiva TUI.
* **Soporte Poly-Model:** Conexión nativa con Anthropic Claude, OpenAI, DeepMind Gemini, Kimi, xAI y modelos locales vía Ollama.
* **Capacidades de Sistema:** Ejecuta herramientas para leer, buscar (`grep`, `find`), inspeccionar y editar código (`edit`, `write`), y correr comandos de consola (`bash`).
* **Instalación Centralizada:** Gestionado y actualizado a través de la CLI `omc` (`./omc dev`).

---

## 2. ¿Qué es LazyPi?

**LazyPi** ([lazypi.org](https://lazypi.org)) es la distribución curada y preconfigurada para el agente Pi, inspirada en la filosofía modular de LazyVim. En lugar de instalar herramientas dispersas, LazyPi agrupa **17 extensiones oficiales de alto rendimiento** organizadas en dos niveles:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            CATÁLOGO LAZYPI (17/17)                          │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                      1. LAZYPI CORE (12 pkgs)                       │   │
│   │   • subagents          • pi-ask-user        • pi-skillful           │   │
│   │   • mention-skill ($)  • goal               • btw                   │   │
│   │   • context-usage      • simplify           • web-access            │   │
│   │   • fff                • dynamic-workflows  • ponytail              │   │
│   └──────────────────────────────────┬──────────────────────────────────┘   │
│                                      │                                      │
│                                      ▼                                      │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                    2. LAZYPI OPTIONAL (5 pkgs)                      │   │
│   │   • lsp (diagnósticos) • interactive-shell  • autoresearch          │   │
│   │   • todos (live task)  • memory (Markdown Git offline)              │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.1 Herramientas que Brinda LazyPi

| Herramienta | Paquete | Comando / Interacción | Propósito y Valor |
| :--- | :--- | :--- | :--- |
| **`subagents`** | `pi-subagents` | `subagent` tool / `/council` | Ejecuta subagentes aislados en paralelo sobre *git worktrees* independientes. |
| **`pi-ask-user`** | `pi-ask-user` | `ask_user` tool | Despliega menús interactivos modales antes de decisiones críticas de diseño. |
| **`pi-skillful`** | `pi-skillful` | `/skill:<nombre>` | Descubre, oculta e invoca skills modulares por encima del root de git. |
| **`mention-skill`**| `@zigai/pi-mention-skill` | `$nombre-skill` | Autocompletado difuso con `$` para inyectar cualquier skill en el prompt. |
| **`goal`** | `@narumitw/pi-goal` | `/goal` | Seguimiento y control de objetivos de largo plazo con compuertas de parada. |
| **`btw`** | `@narumitw/pi-btw` | `/btw <pregunta>` | Consultas rápidas al margen sin contaminar el historial de chat principal. |
| **`context-usage`**| `pi-context-usage` | Barra de estado | Visualizador del consumo de tokens y presupuesto de contexto en tiempo real. |
| **`simplify`** | `pi-simplify` | `/simplify` | Pule y simplifica código reciente eliminando dead code y sobreingeniería. |
| **`web-access`** | `pi-web-access` | `web_search`, `source_check`| Búsqueda web multi-proveedor (Brave, Exa, Perplexity) y extracción de fuentes. |
| **`fff`** | `@ff-labs/pi-fff` | `fffind`, `ffgrep` | Búsqueda difusa ultrarrápida de archivos y símbolos (*Fast Fuzzy Finder*). |
| **`dynamic-workflows`**| `@quintinshaw/pi-dynamic-workflows`| `/workflows` | Panel interactivo TUI para orquestar subagentes y calcular costos de tokens. |
| **`ponytail`** | `@dietrichgebert/ponytail` | `/ponytail review` | Guardián de disciplina de código minimalista y librerías estándar (*stdlib-first*). |
| **`lsp`** | `@narumitw/pi-lsp` | `lsp_diagnostics`, `lsp_fix` | Diagnóstico de errores de sintaxis, tipos y linting en vivo con Language Servers. |
| **`interactive-shell`**| `pi-interactive-shell`| `interactive_shell` | Ejecución supervisada o desatendida (*hands-free*) de TUIs y CLIs en background. |
| **`autoresearch`** | `pi-autoresearch` | `autoresearch-create` | Bucles autónomos de experimentación y optimización métrica con hooks. |
| **`todos`** | `pi-manage-todo-list`| `manage_todo_list` | Widget interactivo de checklist de tareas persistente en la sesión. |
| **`memory`** | `pi-memory-md` | `memory_search`, `tape_handoff`| Memoria semántica y episódica offline persistente en Markdown versionada en Git. |

---

## 3. Esquema de Ayuda al Desarrollo y Minimización de Tokens

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

### 3.1 Matriz de Ahorro y Rendimiento

| Métrica | Sin LazyPi (Enfoque Ad-hoc) | Con LazyPi + Context Engineering | Beneficio |
| :--- | :---: | :---: | :---: |
| **Tokens consumidos por turno** | 40.000 - 75.000 tokens | 1.500 - 4.500 tokens | **-85% consumo** 📉 |
| **Tiempo de respuesta (TTFT)** | 8 - 15 segundos | 1 - 3 segundos | **4x más rápido** ⚡ |
| **Tasa de éxito en 1er intento**| ~50% (requiere reintentos) | >90% (precisión contextual) | **Cero re-trabajo** 🎯 |
| **Contaminación del chat** | Alta (cientos de líneas de logs)| Nula (resúmenes estructurados) | **Contexto limpio** 🧹 |

---

## 4. Guías de Implementación: Patrones de Inteligencia Artificial

---

### 4.1 Spec-Driven Development (SDD / OpenSpec)

**Principio:** Las especificaciones formales y el diseño de arquitectura deben existir en disco antes de escribir código de producción.

```
openspec/
└── changes/
    └── sistema-pagos-stripe/
        ├── proposal.md   # Problema, motivación, límites y non-goals
        ├── specs/        # Contratos de datos e interfaces
        ├── design.md     # Decisiones de arquitectura, diagramas y trade-offs
        └── tasks.md      # Checklist atómico de tareas verificables
```

#### Flujo en Lenguaje Natural con LazyPi:
1. **Propuesta:** *"Iniciá un cambio SDD para `sistema-pagos-stripe`. Redactá `proposal.md` acordando el alcance con `pi-ask-user`."*
2. **Diseño:** *"Generá las especificaciones en `specs/` y el documento de arquitectura `design.md` con un diagrama Mermaid."*
3. **Auditoría:** *"Auditá el diseño con subagentes antes de programar (`$ce-doc-review`)."*
4. **Tareas:** *"Creá `tasks.md`, abrí un worktree (`$ce-worktree`) y ejecutá tarea por tarea con tests."*

---

### 4.2 Compound Engineering (CE)

**Principio:** El código es un pasivo; el conocimiento acumulado es el activo. Estructura el trabajo en 7 etapas donde cada paso valida al anterior:

```
1. Brainstorm ($ce-brainstorm) ──► 2. Tech Plan ($ce-plan) ──► 3. Doc Review ($ce-doc-review)
                                                                           │
6. Capitalizar ($ce-compound) ◄── 5. Commit & PR ($ce-commit-push-pr) ◄── 4. Ejecución ($ce-work)
```

#### Ejemplo de Interacción en Lenguaje Natural:
* *"Hagamos un brainstorm sobre cómo agregar soporte para múltiples temas en la TUI"* $\rightarrow$ activa `ce-brainstorm`.
* *"Armá el plan técnico de arquitectura"* $\rightarrow$ activa `ce-plan`.
* *"Hacé un code review exhaustivo antes de commitear"* $\rightarrow$ activa `ce-code-review`.
* *"Guardá esta solución en docs/solutions/"* $\rightarrow$ activa `ce-compound`.

---

## 5. Guías de Implementación: Patrones de Arquitectura de Software

---

### 5.1 Domain-Driven Design (DDD) & Clean / Hexagonal Architecture

**Principio:** Aislar la lógica de negocio pura de frameworks, bases de datos y controladores HTTP.

```
src/modules/billing/
├── domain/                      # 1. DOMINIO PURO (Entidades, Value Objects, Eventos)
│   ├── entities/Invoice.ts
│   └── value-objects/Money.ts
├── application/                 # 2. APLICACIÓN (Casos de Uso y Puertos/Interfaces)
│   ├── use-cases/CreateInvoice.ts
│   └── ports/InvoiceRepository.ts # Interfaz de Puerto
├── infrastructure/              # 3. INFRAESTRUCTURA (Adaptadores de DB, APIs externas)
│   ├── persistence/PostgresInvoiceRepo.ts
│   └── gateways/StripeGateway.ts
└── interfaces/                  # 4. ENTRADA / UI (Controladores REST, CLI)
    └── http/InvoiceController.ts
```

#### Cómo Sacarle Provecho con LazyPi:
* **Aislamiento de Tokens:** Al pedir cambios de dominio, Pi solo lee `domain/` y `application/` (~2.000 tokens en vez de 45.000).
* **Validación de Regla de Dependencia:** `codegraph` (`pi-antigravity`) verifica que `domain/` nunca importe de `infrastructure/`.
* **Contratos Estrictos:** `lsp_diagnostics` valida que los adaptadores cumplan 100% las interfaces de los puertos.

---

### 5.2 Test-Driven Development (TDD Estricto)

**Principio:** No escribir una sola línea de código de producción sin una prueba automatizada fallida previa.

```
┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
│      1. RED      │ ───►  │     2. GREEN     │ ───►  │   3. REFACTOR    │
│  Crear test que  │       │ Implementación   │       │ /ponytail audit  │
│  falle en bash   │       │ mínima que pase  │       │ /simplify        │
└──────────────────┘       └──────────────────┘       └──────────────────┘
```

#### Flujo de Ejecución con LazyPi:
1. **RED:** Pi escribe el archivo de test en `tests/` y ejecuta el comando de pruebas en `bash` (`npm test`, `pytest`, `cargo test`), confirmando que falle en rojo.
2. **GREEN:** Implementa el código mínimo indispensable para que la prueba pase a verde.
3. **TRIANGULATE:** Añade pruebas para casos límite (cadenas vacías, nulos, desbordes).
4. **REFACTOR:** Ejecuta `/ponytail review` (asegura librerías estándar) y `/simplify` (pule dead code).

---

## 6. Sistema de Skills: Cómo Funcionan y Cómo Crearlas

Las **Skills** son unidades modulares de conocimiento procedimental empaquetadas en archivos Markdown estructurados (`SKILL.md`). Permiten que el agente ejecute protocolos complejos con rigor sin necesidad de escribir extensiones en TypeScript.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             ANATOMÍA DE UNA SKILL                           │
│                                                                             │
│   SKILL.md                                                                  │
│   ├── Frontmatter YAML (name, description con triggers)                     │
│   ├── Contexto e Invariantes (Reglas estrictas y límites)                   │
│   ├── Protocolo Paso a Paso (Instrucciones operativas para el LLM)          │
│   └── Criterios de Aceptación (Checklist de verificación verificable)       │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6.1 Invocación de Skills en LazyPi
* **Mención Difusa con `$` (`@zigai/pi-mention-skill`):** Escribí `$` en tu prompt para autocompletar cualquier skill (ej: `$ce-plan`, `$ce-code-review`).
* **Expansión Directa (`pi-skillful`):** Escribí `/skill:<nombre>` para invocar la skill directamente.

---

### 6.2 Ejemplos Prácticos de Creación de Skills

#### Ejemplo A: Skill Basada en Patrones de Git (Conventional Commits & Staging Limpio)

Guardada en `.pi/skills/git-clean-commit/SKILL.md`:

```markdown
---
name: git-clean-commit
description: "Trigger: commit, guardar cambios, crear commit, git commit. Inspecciona el staging y redacta commits atómicos con Conventional Commits."
---

# Git Clean Commit Protocol

Esta skill garantiza que los commits sean atómicos, explicativos y sigan Conventional Commits.

## Contexto y Restricciones
- Nunca hacer `git add .` ni `git add -A` a ciegas.
- Verificar que no existan archivos de credenciales (`.env`, certificados).
- Formato obligatorio: `tipo(ámbito): descripción imperativa en minúsculas`.

## Protocolo Paso a Paso
1. **Inspección:** Ejecutar `git status` y `git diff` para clasificar cambios lógicos.
2. **Staging Selectivo:** Agregar archivos específicos con `git add <archivo1> <archivo2>`.
3. **Redacción:** Redactar mensaje con `feat`, `fix`, `refactor`, `docs`, `style` o `chore`.
4. **Confirmación:** Ejecutar `git commit` y verificar con `git status`.

## Criterios de Aceptación
- [ ] Staging realizado archivo por archivo.
- [ ] Mensaje de commit en modo imperativo y bajo 72 caracteres en la primera línea.
```

---

#### Ejemplo B: Skill Basada en TDD Estricto (Test-Driven Enforcer)

Guardada en `.pi/skills/tdd-enforcer/SKILL.md`:

```markdown
---
name: tdd-enforcer
description: "Trigger: tdd, test first, crear feature con tdd, programar con pruebas. Aplica el ciclo estricto Red-Green-Refactor."
---

# Strict TDD Enforcer Protocol

Protocolo obligatorio para desarrollo guiado por pruebas.

## Invariantes
- Prohibido crear código de producción sin un test fallido previo.
- Cada prueba debe verificar un único comportamiento.

## Protocolo Paso a Paso
1. **Fase RED:** Escribir el test en `tests/` y correr la suite con `bash`. Demostrar el fallo.
2. **Fase GREEN:** Escribir la implementación mínima en `src/` hasta que el test pase.
3. **Fase TRIANGULATE:** Agregar pruebas de borde (edge cases).
4. **Fase REFACTOR:** Ejecutar `/simplify` para pulir la implementación sin romper tests.

## Criterios de Aceptación
- [ ] Suite de pruebas pasando al 100% en verde.
- [ ] Coberura completa de casos válidos y de error.
```

---

#### Ejemplo C: Skill Basada en Principios Clean Code (SOLID, KISS, DRY)

Guardada en `.pi/skills/clean-code-guardian/SKILL.md`:

```markdown
---
name: clean-code-guardian
description: "Trigger: clean code, refactor solid, revisar principios, kiss, dry, solid. Audita código aplicando principios de diseño limpio."
---

# Clean Code Guardian Protocol

Auditoría y refactorización orientada a la simplicidad y bajo acoplamiento.

## Principios a Auditar
1. **Single Responsibility (SRP):** Cada clase/módulo debe tener una única razón para cambiar.
2. **KISS (Keep It Simple, Stupid):** Evitar sobreingeniería, capas abstractas prematuras o genéricos innecesarios.
3. **DRY (Don't Repeat Yourself):** Extraer lógica de negocio duplicada a funciones puras reutilizables.
4. **Dependency Inversion (DIP):** Depender de abstracciones (interfaces/puertos), no de implementaciones concretas.

## Protocolo Paso a Paso
1. **Inspección:** Leer el archivo con `read` o buscar llamadas con `codegraph`.
2. **Diagnóstico:** Identificar funciones de más de 30 líneas o módulos con múltiples responsabilidades.
3. **Refactorización Segura:** Aplicar refactors pequeños ejecutando tests y `lsp_diagnostics` tras cada cambio.
4. **Poda Final:** Correr `/ponytail review` y `/simplify`.

## Criterios de Aceptación
- [ ] Funciones cortas con nombres descriptivos.
- [ ] Cero duplicación de lógica de negocio.
- [ ] Sin advertencias de tipos en `lsp_diagnostics`.
```

---

## 7. Referencia Rápida de Comandos y Atajos

```bash
# ── Gestión de Infraestructura (omc) ──────────────────────────────────────────
./omc dev                      # Instalar Pi y el catálogo oficial completo de LazyPi
./omc dev status               # Ver estado del catálogo de 17 extensiones
./omc dev update               # Actualizar Pi y todas las extensiones instaladas
./omc dev doctor               # Diagnóstico de salud del entorno de IA
./omc dev remove               # Selector interactivo para desinstalar extensiones
./omc update                   # Actualización total (Homebrew + Casks + Pi + LazyPi)

# ── Comandos Slash Nativos en Sesión de Pi ────────────────────────────────────
/plan <descripción>            # Modo de planificación socrática en memoria
/simplify                      # Simplificar y limpiar código modificado recientemente
/ponytail review               # Auditar código buscando sobreingeniería y dependencias
/ponytail audit                # Inspección profunda de deuda técnica
/btw <pregunta>                # Consulta rápida sin contaminar el historial de chat
/goal <meta>                   # Fijar objetivo de largo plazo con control de estados
/workflows                     # Panel TUI interactivo para orquestar subagentes
/fff-health                    # Verificar la salud del índice de búsqueda rápida

# ── Invocación de Skills con Mención Difusa ───────────────────────────────────
$git-clean-commit              # Inyectar protocolo de commit convencional
$tdd-enforcer                  # Inyectar ciclo estricto Red-Green-Refactor
$clean-code-guardian           # Inyectar auditoría de principios SOLID/KISS/DRY
$ce-plan                       # Inyectar planificación técnica de arquitectura
$ce-code-review                # Inyectar revisión de código multi-agente
```
