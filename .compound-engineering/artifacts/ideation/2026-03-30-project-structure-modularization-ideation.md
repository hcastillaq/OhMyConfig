---
date: 2026-03-30
topic: project-structure-modularization
focus: Separación por propósito/apps, limpieza de archivos sueltos en raíz y deduplicación documental
mode: repo-grounded
---

# Ideación: Reestructuración y Modularización del Repositorio OhMyConfig

## Grounding Context

### Diagnóstico del Repositorio Local
- **Contaminación en Raíz:** `package.json` ("ohmyconfig-docs"), `package-lock.json` (200KB), `astro.config.mjs`, `tsconfig.json`, `src/` y `node_modules/` residen en la raíz junto al motor Bash (`omc`, `cli/`, `Brewfile`).
- **Enlace Simbólico Frágil:** `src/content/docs -> ../../documentation` es un puente artificial para que Starlight consuma markdown ubicado en la raíz.
- **Triplicación Documental:** Los atajos se declaran en los dotfiles (`config.fish`, `config.kdl`, `keymaps.lua`), se copian a `documentation/cheatsheet.md` y se vuelven a copiar en `README.md`.
- **Acoplamiento de Rutas:** `cli/lib/deploy.sh`, `doctor.sh` y `dev.sh` asumen rígidamente la ruta física `$OMC_DIR/config/`.

### Señales Externas y Buenas Prácticas
- **Aislamiento de Aplicaciones:** Repositorios de dotfiles avanzados (ej. `sebastienrousseau/dotfiles`, GNU Stow topologies) aíslan las webs de documentación en `apps/docs/` o `website/` sin contaminar la raíz ejecutable.
- **Capa de Datos SSOT:** Definir atajos en TOML/JSON (ej. `data/shortcuts.toml`) y compilarlos o cargarlos dinámicamente con Astro Content Loaders elimina el drift.
- **Principio de Puerta de Entrada:** `README.md` actúa como vitrina y enrutador; no duplica manuales exhaustivos.
- **Preservación de Comportamiento:** La memoria institucional exige no romper contratos de alias y keymaps al mover configuraciones.

## Topic Axes

- **root-app-isolation:** Separación física de la aplicación web Astro Starlight respecto al núcleo de dotfiles de macOS.
- **config-module-topology:** Organización de las herramientas y dotfiles: co-localización de configuraciones, dependencias y metadatos.
- **ssot-doc-deduplication:** Eliminación de la redundancia entre README, guías web y dotfiles mediante una fuente de verdad única.
- **dx-deploy-contracts:** Contratos de rutas en el CLI, verificación de symlinks, comandos unificados y experiencia en terminal.

---

## Ranked Ideas

### 1. Arquitectura Limpia por Propósito: Aislamiento de la Web App en `apps/docs/`
**Description:** Mover la totalidad de la aplicación web Astro Starlight (`package.json`, `package-lock.json`, `astro.config.mjs`, `tsconfig.json`, `src/`, `node_modules/` y `dist/`) al subdirectorio dedicado `apps/docs/`. La raíz del repositorio queda 100% limpia de artefactos JavaScript/Node, preservando exclusivamente la identidad de dotfiles macOS (`omc`, `Brewfile`, `config/`, `README.md`, `LICENSE`).
**Axis:** root-app-isolation
**Basis:** `direct: package.json:1-17` declara `"name": "ohmyconfig-docs"` evidenciando que el package.json de la raíz es exclusivo del sitio web. `direct: .github/workflows/docs.yml:25-35` solo requiere añadir `working-directory: apps/docs`.
**Rationale:** Elimina la principal fuente de confusión arquitectónica: clonar un gestor de dotfiles en Bash y encontrar un `node_modules` de 250MB en la raíz. Otorga fronteras limpias y escalabilidad para añadir futuras aplicaciones o herramientas sin mezclar entornos.
**Downsides:** Requiere actualizar rutas en GitHub Actions (`docs.yml`) y actualizar scripts en documentación. Fácilmente mitigado mediante subcomandos transparentes en `omc`.
**Confidence:** 95%
**Complexity:** Medium

### 2. Estratificación Documental en 3 Capas: `README.md` Conciso y Verdad Canónica
**Description:** Eliminar la redundancia documental aplicando el principio de responsabilidades separadas: el `README.md` se convierte exclusivamente en la "Puerta de Entrada" (propósito, screenshot/GIF, quickstart de 2 líneas y tabla de enlaces directos a guías online); las guías en `documentation/` son la "Verdad Canónica Exhaustiva"; y `CONCEPTS.md` es el "Glosario Único de Dominio" (Static Noise tokens y semántica).
**Axis:** ssot-doc-deduplication
**Basis:** `direct: README.md:140-220` contiene 80 líneas de tablas de atajos copiadas textualmente de `documentation/cheatsheet.md:1-250`. Toda modificación actual exige sincronizar ambos archivos a mano.
**Rationale:** Un README hinchado con cheatsheets se desactualiza en semanas. Al delegar la referencia a las guías web y al cheatsheet canónico, el README queda inmune al drift técnico.
**Downsides:** El lector en GitHub debe hacer un clic para ver la tabla completa de atajos en lugar de verla en la página principal del repo. Se mitiga con un índice claro con deep-links.
**Confidence:** 95%
**Complexity:** Low

### 3. Topología de Módulos Autónomos Co-localizados (`modules/<tool>`)
**Description:** Evolucionar la carpeta plana `config/` hacia paquetes de herramientas auto-contenidos bajo `modules/` (ej: `modules/terminal/ghostty/`, `modules/editor/nvim/`). Cada módulo co-localiza sus archivos de configuración fuente, su lista de fórmulas/casks de Homebrew y su metadata descriptiva en un manifiesto local (`manifest.sh` o `module.json`), eliminando los bloques `case` gigantescos de `cli/lib/catalog.sh`.
**Axis:** config-module-topology
**Basis:** `direct: cli/lib/catalog.sh:61-120` tiene más de 60 líneas de funciones `case "$1"` hardcodeadas. Para agregar una herramienta hoy se debe tocar `Brewfile`, `catalog.sh`, `config/` y `documentation/` por separado.
**Rationale:** Sigue el principio Open-Closed: agregar una nueva herramienta consiste en crear una carpeta dentro de `modules/` sin modificar archivos centrales del CLI ni correr riesgo de conflictos en git.
**Downsides:** Refactor importante en el motor de despliegue (`deploy.sh`) y migración de rutas existentes. Requiere una fase de transición bien testeada.
**Confidence:** 85%
**Complexity:** High

### 4. Capa de Datos SSOT (`data/shortcuts.json`) para Generación de Atajos
**Description:** Centralizar la definición de atajos de teclado, aliases y comandos CLI en un archivo estructurado canónico (ej. `data/cheatsheet.json` o YAML). Mediante un Data Loader de Astro Content Collections, Starlight compila e interactúa con esta tabla en la web con filtrado y búsqueda en tiempo real, garantizando sincronización 100% libre de mantenimiento manual.
**Axis:** ssot-doc-deduplication
**Basis:** `external: ca971/dotfiles y Astro Content Loaders`. Los dotfiles avanzados extraen la metadata a TOML/JSON y generan las tablas de la documentación automáticamente.
**Rationale:** Los atajos son datos tabulares estructurados, no prosa literaria. Tratarlos como datos permite validación de esquemas (TypeScript/Zod), búsqueda interactiva en la web y exportación a terminal.
**Downsides:** Requiere escribir un pequeño componente Astro o loader para renderizar el JSON en la página `cheatsheet` de Starlight.
**Confidence:** 90%
**Complexity:** Medium

### 5. Motor de Abstracción de Rutas y Comandos Proxy `omc docs`
**Description:** Crear una función centralizada `omc_resolve_path()` en `cli/lib/deploy.sh` que desacople el CLI de la ubicación física de los archivos. Complementariamente, incorporar el subcomando `omc docs [dev|build|preview]` en el ejecutable principal, permitiendo ejecutar y previsualizar la documentación web sin tener que entrar en subcarpetas ni gestionar npm manualmente.
**Axis:** dx-deploy-contracts
**Basis:** `direct: omc:9-14` define `OMC_DIR`, mientras que `doctor.sh:40-75` y `dev.sh:35-45` concatenan `$OMC_DIR/config/...` de forma dispersa. Si `config/` se renombra o mueve, los comandos fallan silenciosamente.
**Rationale:** Proporciona tolerancia a cambios arquitectónicos futuros. La interfaz de usuario de `omc` permanece constante y ergonómica incluso cuando la estructura de directorios interna evoluciona.
**Downsides:** Mínimo. Solo requiere envolver llamadas npm con verificación de dependencias (Node/npm instalados).
**Confidence:** 95%
**Complexity:** Medium

### 6. Desmantelamiento del Symlink en Astro vía Content Collections Nativas
**Description:** Eliminar el enlace simbólico del repositorio `src/content/docs -> ../../documentation`. Al mover la web a `apps/docs/`, los archivos markdown de documentación se ubican de forma estándar dentro de `apps/docs/src/content/docs/` (o se leen con el loader nativo de Astro v5), eliminando los problemas de sincronización en Git worktrees, entornos CI y sistemas de archivos multiplataforma.
**Axis:** root-app-isolation
**Basis:** `direct: src/content.config.ts:1-10` utiliza `docsLoader()` de Starlight pero depende de un symlink en disco para encontrar los archivos en la raíz.
**Rationale:** Los symlinks en árboles de git rastreados son fuente conocida de errores en despliegues y herramientas de análisis estático. La configuración canónica de Astro simplifica el build y el caching.
**Downsides:** Mueve los archivos `.md` de documentación dentro de la carpeta de la app `apps/docs/`. Requiere actualizar referencias en `AGENTS.md`.
**Confidence:** 90%
**Complexity:** Low

### 7. Visor Interactivo Rápido en Terminal con Gum (`omc cheatsheet`)
**Description:** Añadir el comando `./omc cheatsheet` que consume los datos de atajos y abre un buscador difuso interactivo mediante `gum filter` o `fzf` directamente en la terminal. Los usuarios de OhMyConfig pueden consultar cualquier atajo de Neovim, Zellij, Git o Fish en menos de 100 milisegundos sin abandonar su entorno de consola.
**Axis:** dx-deploy-contracts
**Basis:** `direct: cli/lib/ui.sh:1-40` ya encapsula los estilos y componentes interactivos de Gum con la paleta Static Noise. Solo falta cablear la fuente de datos a un selector difuso.
**Rationale:** OhMyConfig es una suite terminal-first. Forzar a abrir un navegador web para consultar atajos de consola contradice la filosofía de productividad del proyecto.
**Downsides:** Muy bajo. Aprovecha dependencias ya instaladas y empaquetadas (Gum / FZF).
**Confidence:** 85%
**Complexity:** Low

---

## Rejection Summary

| # | Idea | Reason Rejected |
|---|------|-----------------|
| R1 | Monorepo estricto con Turborepo / pnpm workspaces | Sobre-ingeniería excesiva para un proyecto donde el 80% del código es Bash y configuraciones de terminal. |
| R2 | Generador AST completo de dotfiles (Compilador IR) | Riesgo de fragilidad: compilar Fish/Lua desde un AST común rompe la expresividad nativa de cada herramienta. |
| R3 | Linter de documentación en CI para chequear sincronización | Reactivo en lugar de preventivo. Generar la documentación desde datos (Idea 4) hace innecesario un linter de diffs. |
| R4 | Submódulo Git separado para el sitio web | Introduce fricción de sincronización en commits y despliegues frente a un subdirectorio `apps/docs/` en el mismo repo. |
| R5 | Fragmentación de Brewfile en 15 micro-archivos .brew | Añade dispersión de archivos sueltos innecesaria sin resolver el problema de empaquetado del catálogo. |
| R6 | Eliminación total del sitio web en favor de manpages | El sitio web Astro Starlight ofrece un escaparate visual y de adopción clave para el proyecto público. |
| R7 | Auto-generación de cheatsheet parseando comentarios de código | Frágil: depende de formatos de comentarios no estándar en lenguajes heterogéneos (KDL, Lua, Fish, Gitconfig). |
