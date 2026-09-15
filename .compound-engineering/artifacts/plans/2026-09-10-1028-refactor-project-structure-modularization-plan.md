---
title: Reestructuración Modular y Desacoplamiento de Aplicaciones - Plan
type: refactor
date: 2026-09-10
topic: project-structure-modularization
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: ce-brainstorm
execution: code
---

# Reestructuración Modular y Desacoplamiento de Aplicaciones - Plan

## Goal Capsule

**Objective:**
Reorganizar la arquitectura del repositorio OhMyConfig separando físicamente la aplicación web de documentación en `apps/docs/`, estructurando los dotfiles en paquetes co-localizados bajo `modules/<dominio>/<herramienta>` con manifiestos locales, y eliminando la duplicación de tablas entre el `README.md` y las guías canónicas, garantizando una raíz limpia y un crecimiento escalable.

**Means:**
Desacoplamiento físico en `apps/docs/` y co-localización modular bajo `modules/<dominio>/<herramienta>` con manifiestos locales (KTD1, KTD2).

**Product Authority:**
Gobierna la estructura del repositorio OhMyConfig, la organización de sus módulos, la integración de la web en Astro Starlight y las interfaces del CLI `omc`. No abarca soporte para entornos fuera de macOS ni compilación abstracta de configuraciones.

**Open Blockers:**
Ninguno. Al encontrarse el proyecto en etapa previa a v1.0 y de uso personal, se ejecuta un corte limpio sin requerir capas ni symlinks de retrocompatibilidad.

---

## Product Contract

### Summary
Reorganizar OhMyConfig en una estructura modular desacoplada: aislar la aplicación web de documentación en `apps/docs/`, transformar `config/` en módulos autónomos bajo `modules/<dominio>/<herramienta>` con sus propios manifiestos, eliminar las tablas duplicadas de atajos del `README.md` (delegando a la web como verdad canónica), y dotar al CLI de comandos unificados (`./omc docs [dev|build|preview]` y `./omc cheatsheet`).

### Problem Frame
Actualmente la raíz del repositorio alberga simultáneamente el motor de dotfiles en Bash y la totalidad de la aplicación web de Astro Starlight (`package.json`, `package-lock.json`, `astro.config.mjs`, `node_modules/`, `src/`). Esta mezcla genera la impresión errónea de que el proyecto es un paquete de Node.js, añade archivos sueltos de compilación a la raíz y obligó a utilizar un enlace simbólico frágil (`src/content/docs -> ../../documentation`) para que Starlight pudiera leer las guías. 

En paralelo, existe una severa duplicación documental: cada vez que se agrega o ajusta un atajo o alias, debe actualizarse en los dotfiles (`config/`), en `documentation/cheatsheet.md` y en una tabla de más de 80 líneas duplicada dentro de `README.md`, provocando desincronización recurrente. Finalmente, agregar una herramienta exige modificar manualmente múltiples funciones `case` acopladas en `cli/lib/catalog.sh` además de `Brewfile` y `config/`.

### Key Decisions
- **Aislamiento físico de la Web en `apps/docs/`:** `(session-settled: user-directed — chosen over monorepo raíz / submódulo git: elimina la contaminación de dependencias y scripts web en la raíz)`. Governs R1, R2, R3.
- **Reestructuración total unificada:** `(session-settled: user-directed — chosen over migración parcial por fases: aborda conjuntamente el desacoplamiento de apps/docs, la modularización de modules/ y la deduplicación documental)`. Governs R1, R4, R6, R7, R8.
- **Corte limpio sin shims de retrocompatibilidad:** `(session-settled: user-directed — chosen over shims temporales config -> modules: el proyecto es pre-1.0 y de uso personal)`. Governs R6, R7, R8.
- **Estratificación documental estricta en 3 capas:** `(session-settled: user-approved — chosen over sincronización manual o linters de diff: README es solo puerta de entrada; la web y el cheatsheet de terminal son la verdad canónica)`. Governs R4, R5, R10.
- **Preservación del estándar nativo `brew bundle`:** `(session-settled: user-approved — chosen over bucles de instalación manual en bash: mantiene un Brewfile unificado y rápido para resolver dependencias)`. Governs R7.
- **Extracción directa de atajos para el CLI:** `(session-settled: user-approved — chosen over archivos secundarios JSON/TSV: omc cheatsheet extrae datos directamente del markdown canónico para evitar una tercera fuente de verdad)`. Governs R10.

### Requirements

#### Aislamiento de la Web App (`apps/docs/`)
R1. Todos los archivos y dependencias de la aplicación web Astro Starlight (`package.json`, `package-lock.json`, `astro.config.mjs`, `tsconfig.json`, `src/`) deben residir dentro del subdirectorio dedicado `apps/docs/`.
R2. La documentación Markdown debe residir de forma nativa dentro de `apps/docs/src/content/docs/`, eliminando el enlace simbólico `src/content/docs -> ../../documentation`.
R3. El flujo de CI/CD de GitHub Actions (`.github/workflows/docs.yml`) debe ejecutar la instalación y el build configurando `working-directory: apps/docs`.

#### Deduplicación Documental
R4. El archivo `README.md` en la raíz debe actuar exclusivamente como puerta de entrada y catálogo de bienvenida: debe conservar la introducción, el quickstart de dos comandos y el índice con hipervínculos a la web de documentación, eliminando completamente las tablas extensas de atajos y cheatsheets duplicados.
R5. El archivo `CONCEPTS.md` en la raíz se mantiene como la única fuente de verdad para los tokens de la paleta Static Noise y el vocabulario compartido del dominio.

#### Topología de Módulos Autónomos (`modules/`)
R6. El directorio plano `config/` debe evolucionar hacia paquetes estructurados por dominio bajo `modules/<dominio>/<herramienta>/` (ej: `modules/terminal/ghostty/`, `modules/terminal/zellij/`, `modules/editor/nvim/`, `modules/core/fish/`), co-localizando la configuración y su metadata de despliegue.
R7. Cada módulo debe contar con un archivo de manifiesto declarativo (`manifest.sh`) que defina de forma autónoma sus rutas de destino para enlaces simbólicos (`$HOME/.config/...` o `$HOME/.pi/agent/...`), su etiqueta y descripción. La gestión de paquetes Homebrew continúa respaldada por `brew bundle` y `Brewfile` para máxima velocidad y evitar bucles lentos en Bash.

#### Contratos del Motor CLI y Experiencia en Terminal
R8. Los módulos de despliegue (`cli/lib/deploy.sh`) y diagnóstico (`cli/commands/doctor.sh`, `cli/commands/dev.sh`) deben resolver dinámicamente las rutas desde `modules/` a través de funciones centralizadas, eliminando rutas relativas fijadas a `$OMC_DIR/config/`.
R9. El ejecutable `./omc` debe incorporar el subcomando `./omc docs [dev|build|preview]` para ejecutar Astro Starlight de forma transparente delegando en `npm` dentro de `apps/docs/`.
R10. El ejecutable `./omc` debe incorporar el subcomando `./omc cheatsheet` que extrae dinámicamente los atajos desde `apps/docs/src/content/docs/cheatsheet.md` y los presenta en un buscador difuso interactivo con `gum filter` (o `fzf`) en consola sin crear archivos de datos redundantes.

### Key Flows
- **F1. Despliegue de Módulos Autónomos:** El usuario ejecuta `./omc install [modulo]` -> `cli/lib/deploy.sh` inspecciona los directorios bajo `modules/` -> lee cada `manifest.sh` -> vincula los enlaces simbólicos de forma idempotente y con respaldo. Covers R6, R7, R8.
- **F2. Servidor de Documentación Local:** El usuario ejecuta `./omc docs dev` -> `omc` valida la presencia de Node/npm -> ejecuta `npm run dev` en `apps/docs/` -> la consola sirve el sitio web localmente. Covers R1, R9.
- **F3. Búsqueda Rápida de Atajos en Consola:** El usuario ejecuta `./omc cheatsheet` -> `omc` parsea en memoria las tablas de `apps/docs/src/content/docs/cheatsheet.md` -> despliega un selector difuso interactivo con `gum filter` -> el usuario localiza el comando o keymap en milisegundos. Covers R10.

### Acceptance Examples
- **AE1. Raíz Limpia:** La ejecución de `ls -la` en la raíz del repositorio no muestra `node_modules/`, `package.json`, `package-lock.json`, `.astro/`, `dist/` ni `tsconfig.json`. Covers R1.
- **AE2. Integridad de Enlaces Simbólicos:** Ejecutar `./omc install --link` y posteriormente `./omc doctor` confirma que todas las configuraciones se enlazan correctamente desde `modules/` a `$HOME/.config/` y `$HOME/.pi/agent/`. Covers R6, R8.
- **AE3. Compilación CI Exitosa:** El pipeline `.github/workflows/docs.yml` se ejecuta correctamente en GitHub Actions sin advertencias de symlinks rotos ni dependencias ausentes. Covers R2, R3.
- **AE4. README Concreto:** `README.md` no contiene cheatsheets de comandos en línea de más de 10 filas, dirigiendo al lector hacia la web canónica. Covers R4.
- **AE5. Terminal Cheatsheet sin Datos Redundantes:** Ejecutar `./omc cheatsheet` abre la interfaz de filtrado en terminal extrayendo la información directamente del markdown de Starlight sin requerir archivos TSV/JSON duplicados. Covers R10.

### Scope Boundaries
- **Incluido en este alcance:**
  - Aislamiento físico de la web en `apps/docs/`.
  - Migración y co-localización de configuraciones en `modules/<dominio>/<herramienta>/`.
  - Manifiestos de módulo locales y adaptación del motor CLI `omc`.
  - Eliminación de tablas redundantes en `README.md`.
  - Subcomandos `./omc docs` y `./omc cheatsheet`.
- **Fuera de alcance:**
  - Shims o symlinks de retrocompatibilidad hacia `config/`.
  - Compilador de AST / generadores de código multi-shell desde JSON.
  - Soporte multiplataforma (Linux, Windows).

---

## Planning Contract

### Key Technical Decisions
- **KTD1. Ubicación y frontera de la aplicación web en `apps/docs/`:** Todo el runtime de Astro, sus componentes, estilos, configuración y documentación residirán en `apps/docs/`. La raíz no contendrá archivos `.json` ni `.mjs`. Governs R1, R2.
- **KTD2. Manifiesto declarativo en `manifest.sh` por módulo:** Cada herramienta bajo `modules/<dominio>/<herramienta>/` define un `manifest.sh` compatible con Bash 3.2 que exporta una función o lista simple `MODULE_TARGETS=("fuente_relativa:destino_absoluto_o_xdg")`, sin variables globales contaminantes. Governs R6, R7.
- **KTD3. Mapeo de dominios de módulos:** Se definen los siguientes dominios funcionales: `core` (fish, starship, atuin), `terminal` (ghostty, zellij), `editor` (nvim, git, lazygit), `cli` (bottom) y `ai` (pi). Governs R6.
- **KTD4. Centralización de resolución de rutas en `cli/lib/deploy.sh`:** Se crea `get_module_source_path()` para resolver rutas físicas de dotfiles apuntando a `modules/`, permitiendo que `install.sh`, `doctor.sh` y `dev.sh` operen de forma agnóstica. Governs R8.
- **KTD5. Envoltorio transparente de npm en `cli/commands/docs.sh`:** `./omc docs` ejecuta `npm --prefix "$OMC_DIR/apps/docs"` validando previamente que Node y npm estén en PATH. Governs R9.
- **KTD6. Parser Bash ligero para `./omc cheatsheet`:** `cli/commands/cheatsheet.sh` utiliza `awk` para extraer los bloques de tabla Markdown de `apps/docs/src/content/docs/cheatsheet.md` y alimentarlos directamente a `gum filter` con estilos de la paleta Static Noise. Governs R10.

### High-Level Technical Design

```text
OhMyConfig (Raíz Limpia)
├── omc                           # CLI unificado (incluye subcomandos docs y cheatsheet)
├── Brewfile                      # Fórmulas y Casks centralizadas para brew bundle
├── README.md                     # Entrada limpia con links y quickstart (sin tablas duplicadas)
├── CONCEPTS.md                   # Tokens y vocabulario de dominio
├── apps/
│   └── docs/                     # Web App Astro Starlight aislada
│       ├── package.json
│       ├── astro.config.mjs
│       ├── tsconfig.json
│       └── src/
│           ├── content/docs/     # Documentación canónica Markdown pura
│           ├── components/
│           └── styles/
├── cli/
│   ├── commands/                 # install, doctor, update, dev, docs, cheatsheet
│   └── lib/                      # brew, catalog, deploy (con soporte para modules/), ui
└── modules/                      # Paquetes co-localizados
    ├── core/
    │   ├── fish/                 # config.fish + manifest.sh
    │   ├── starship/             # starship.toml + manifest.sh
    │   └── atuin/                # config.toml + manifest.sh
    ├── terminal/
    │   ├── ghostty/              # config + manifest.sh
    │   └── zellij/               # config.kdl + layouts/ + plugins/ + manifest.sh
    ├── editor/
    │   ├── nvim/                 # init.lua + lua/ + lazyvim.json + manifest.sh
    │   ├── git/                  # delta.gitconfig + manifest.sh
    │   └── lazygit/              # config.yml + manifest.sh
    ├── cli/
    │   └── bottom/               # bottom.toml + manifest.sh
    └── ai/
        └── pi/                   # themes/ + extensions/ + manifest.sh
```

---

## Implementation Units

### U1. Aislamiento físico de la Web App en `apps/docs/` y actualización de CI/CD
- **Goal:** Mover todo el proyecto Astro Starlight a `apps/docs/`, situar la documentación Markdown nativamente en `apps/docs/src/content/docs/` eliminando el symlink frágil, y actualizar el workflow de GitHub Actions.
- **Requirements:** R1, R2, R3
- **Files:**
  - `package.json` -> mover a `apps/docs/package.json`
  - `package-lock.json` -> mover a `apps/docs/package-lock.json`
  - `astro.config.mjs` -> mover a `apps/docs/astro.config.mjs`
  - `tsconfig.json` -> mover a `apps/docs/tsconfig.json`
  - `src/` -> mover a `apps/docs/src/`
  - `documentation/` -> mover sus archivos a `apps/docs/src/content/docs/`
  - `.github/workflows/docs.yml` (actualizar `working-directory: apps/docs`)
  - `.gitignore` (actualizar para ignorar `apps/docs/node_modules/`, `apps/docs/dist/`, `apps/docs/.astro/`)
- **Approach:**
  1. Crear el directorio `apps/docs/` y `apps/docs/src/content/docs/`.
  2. Mover archivos de configuración (`package.json`, `astro.config.mjs`, etc.) a `apps/docs/`.
  3. Eliminar el symlink git `src/content/docs -> ../../documentation`.
  4. Mover todos los archivos `.md` de `documentation/` a `apps/docs/src/content/docs/` y eliminar la carpeta `documentation/` de la raíz.
  5. Ajustar en `.github/workflows/docs.yml` los pasos de `npm ci` y `npm run build` especificando `working-directory: apps/docs`.
  6. Actualizar `.gitignore`.
- **Test Scenarios:**
  - Ejecutar `npm run build --prefix apps/docs` y verificar que genera `apps/docs/dist/` sin errores de contenido ni estilos rotos.
  - Verificar que `ls -la` en la raíz del repositorio no muestra `node_modules/`, `package.json` ni `.astro/`.
- **Verification:** `npm run build --prefix apps/docs` retorna código 0.

### U2. Reorganización de Dotfiles hacia `modules/<dominio>/<herramienta>/` con `manifest.sh`
- **Goal:** Migrar la carpeta plana `config/` hacia paquetes co-localizados bajo `modules/` e incorporar un `manifest.sh` estándar en cada herramienta.
- **Requirements:** R6, R7
- **Files:**
  - `config/` -> `modules/{core,terminal,editor,cli,ai}/`
  - `modules/core/fish/manifest.sh`
  - `modules/core/starship/manifest.sh`
  - `modules/core/atuin/manifest.sh`
  - `modules/terminal/ghostty/manifest.sh`
  - `modules/terminal/zellij/manifest.sh`
  - `modules/editor/nvim/manifest.sh`
  - `modules/editor/git/manifest.sh`
  - `modules/editor/lazygit/manifest.sh`
  - `modules/cli/bottom/manifest.sh`
  - `modules/ai/pi/manifest.sh`
- **Approach:**
  1. Crear los directorios bajo `modules/` correspondientes a cada herramienta.
  2. Mover los archivos de configuración existentes desde `config/` a su carpeta respectiva en `modules/`.
  3. Crear un archivo `manifest.sh` estándar en cada módulo definiendo:
     ```bash
     MODULE_NAME="Nombre"
     MODULE_DESC="Descripción breve"
     # Array de pares origen_relativo:destino_xdg
     MODULE_TARGETS=(
       "config.kdl:zellij/config.kdl"
       "layouts:zellij/layouts"
       "plugins:zellij/plugins"
     )
     ```
  4. Eliminar el directorio `config/` de la raíz.
- **Test Scenarios:**
  - Comprobar que cada una de las 10 herramientas cuenta con sus configuraciones completas y su `manifest.sh`.
  - Probar que no hay pérdidas de archivos especiales (ej. `plugins/zjstatus.wasm`).
- **Verification:** `test -f modules/terminal/zellij/manifest.sh && test -f modules/editor/nvim/manifest.sh`.

### U3. Adaptación del motor CLI para resolución dinámica de rutas (`deploy.sh`, `catalog.sh`, `doctor.sh`, `dev.sh`)
- **Goal:** Actualizar las funciones de despliegue y diagnóstico para consumir los módulos bajo `modules/` en lugar de la ruta estática `config/`.
- **Requirements:** R8
- **Files:**
  - `cli/lib/catalog.sh`
  - `cli/lib/deploy.sh`
  - `cli/commands/doctor.sh`
  - `cli/commands/dev.sh`
- **Approach:**
  1. Modificar `cli/lib/catalog.sh` para mapear los módulos `(core terminal editor cli ai)` hacia las rutas en `modules/<dominio>/<herramienta>/`.
  2. Modificar `deploy_module` en `cli/lib/deploy.sh` para iterar sobre los `manifest.sh` de cada herramienta y enlazar los archivos a `$HOME/.config/` (o `$HOME/.pi/agent/` para el caso de Pi).
  3. Ajustar `cli/commands/doctor.sh` para comprobar los symlinks verificando que apuntan a `$OMC_DIR/modules/...`.
  4. Ajustar `cli/commands/dev.sh` para localizar el tema y extensiones de Pi en `$OMC_DIR/modules/ai/pi/...`.
- **Test Scenarios:**
  - Ejecutar `./omc doctor` y comprobar que evalúa correctamente los symlinks hacia `modules/`.
  - Ejecutar un despliegue de prueba con `./omc install core --copy` o `./omc install core --link` y validar los symlinks resultantes.
- **Verification:** `./omc doctor` se ejecuta sin errores de rutas no encontradas.

### U4. Implementación de subcomandos `./omc docs` y `./omc cheatsheet`
- **Goal:** Incorporar soporte para previsualizar/construir la web y consultar atajos por terminal directamente desde el CLI `omc`.
- **Requirements:** R9, R10
- **Files:**
  - `omc`
  - `cli/commands/docs.sh` (nuevo)
  - `cli/commands/cheatsheet.sh` (nuevo)
- **Approach:**
  1. Crear `cli/commands/docs.sh` soportando subcomandos `dev`, `build` y `preview`, invocando `npm --prefix "$OMC_DIR/apps/docs" <accion>`.
  2. Crear `cli/commands/cheatsheet.sh` que lea `apps/docs/src/content/docs/cheatsheet.md`, filtre con `awk` las tablas de atajos formateándolas como líneas legibles, y las presente con `gum filter` (con fallback a `fzf` o `less`).
  3. Registrar ambos subcomandos en `omc` y en la ayuda `--help`.
- **Test Scenarios:**
  - Ejecutar `./omc docs build` y verificar que dispara el build de Astro.
  - Ejecutar `./omc cheatsheet` y verificar que abre el menú interactivo con atajos de Neovim, Zellij, Git y Fish.
- **Verification:** `./omc docs --help` y `./omc cheatsheet` funcionan sin errores.

### U5. Limpieza de `README.md` y sincronización de documentación arquitectónica (`AGENTS.md`)
- **Goal:** Purgar las tablas duplicadas del `README.md`, actualizar el árbol de directorios de `AGENTS.md` y verificar coherencia general.
- **Requirements:** R4, R5
- **Files:**
  - `README.md`
  - `AGENTS.md`
- **Approach:**
  1. Eliminar de `README.md` la tabla de 80 líneas de cheatsheet duplicada, conservando la tabla inicial con enlaces directos a cada guía en la web online.
  2. Actualizar el árbol de arquitectura de `AGENTS.md` para documentar `apps/docs/` y `modules/`.
  3. Verificar que las referencias relativas a temas o extensiones en `.pi/settings.json` o scripts apunten a las nuevas rutas.
- **Test Scenarios:**
  - `README.md` se lee conciso, directo y sin duplicación de atajos.
  - `AGENTS.md` documenta con fidelidad la nueva estructura del proyecto.
- **Verification:** `git diff README.md` confirma la eliminación limpia de las tablas redundantes.

---

## Verification Contract

- **Verificación de la Web App:**
  ```bash
  npm run build --prefix apps/docs
  ```
  Debe compilar correctamente a `apps/docs/dist/` sin advertencias de rutas ni symlinks rotos.

- **Verificación del Motor CLI y Diagnóstico:**
  ```bash
  ./omc doctor
  ```
  Debe comprobar los estados de las herramientas apuntando a `modules/` sin lanzar excepciones de archivos inexistentes.

- **Verificación de Subcomandos Nuevos:**
  ```bash
  ./omc --help
  ./omc docs build
  ```
  Ambos comandos deben ejecutarse con código de salida 0.

- **Verificación de Raíz Limpia:**
  ```bash
  test ! -f package.json && test ! -f astro.config.mjs && test ! -d config && echo "Raiz Limpia OK"
  ```

---

## Definition of Done

- [ ] Todos los archivos web (`package.json`, `astro.config.mjs`, `src/`, documentación markdown) residen exclusivamente bajo `apps/docs/`.
- [ ] No existen enlaces simbólicos frágiles en el repositorio (eliminado `src/content/docs -> ../../documentation`).
- [ ] El pipeline de CI/CD `.github/workflows/docs.yml` está configurado con `working-directory: apps/docs`.
- [ ] El directorio `config/` ha sido reemplazado por `modules/<dominio>/<herramienta>/`, cada una con su `manifest.sh`.
- [ ] Los scripts de CLI (`catalog.sh`, `deploy.sh`, `doctor.sh`, `dev.sh`) resuelven dinámicamente las rutas hacia `modules/`.
- [ ] Los comandos `./omc docs` y `./omc cheatsheet` están operativos y documentados en `./omc --help`.
- [ ] El archivo `README.md` está desduplicado y no contiene tablas de cheatsheets en línea.
- [ ] `npm run build --prefix apps/docs` y `./omc doctor` pasan limpiamente.
