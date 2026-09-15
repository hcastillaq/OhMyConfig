---
title: Delimitación de Responsabilidades del CLI y Versión SSOT - Plan
type: refactor
date: 2026-09-10
topic: cli-srp-and-version-ssot
artifact_contract: ce-unified-plan/v1
artifact_readiness: implementation-ready
product_contract_source: ce-brainstorm
execution: code
---

# Delimitación de Responsabilidades del CLI y Versión SSOT - Plan

## Goal Capsule

**Objective:**
Reestructurar el CLI `./omc` bajo el Principio de Responsabilidad Única (SRP) reduciéndolo estrictamente a la gestión e instalación de dotfiles y herramientas del sistema (`install`, `doctor`, `update`), desacoplándolo por completo de la documentación web, y estableciendo un archivo plano `VERSION` en la raíz como la única fuente de verdad consumida tanto por el CLI como por la documentación.

**Means:**
Eliminación de los subcomandos `docs`, `cheatsheet` y `dev` en `./omc`, absorción de Pi como módulo estándar `ai` en `update.sh`, y creación del archivo raíz `VERSION` consumido por Bash y Astro Starlight (KTD1, KTD2, KTD3).

**Product Authority:**
Gobierna las interfaces del CLI `omc`, la eliminación de comandos desacoplados, el flujo de actualización de paquetes y la gestión de versiones del proyecto OhMyConfig.

**Open Blockers:**
Ninguno.

---

## Product Contract

### Summary
Reducir `./omc` a un instalador y gestor puro de dotfiles con solo tres comandos (`install`, `doctor`, `update`), eliminando `omc docs` (la web se gestiona con npm en `apps/docs`), `omc cheatsheet` (la consulta vive en la web canónica) y `omc dev` (Pi se gestiona como módulo estándar `ai`). Introducir un archivo plano `VERSION` en la raíz del repositorio como Single Source of Truth para la versión, consumido por `./omc` y por `apps/docs/`.

### Problem Frame
Actualmente `./omc` asumió múltiples responsabilidades que no corresponden a un gestor de dotfiles en consola:
1. Actúa como proxy web ejecutando scripts de npm para Astro Starlight (`./omc docs`).
2. Actúa como visor y formateador de tablas Markdown (`./omc cheatsheet`).
3. Trata al agente Pi como un subsistema aislado con comandos propios (`./omc dev`), a pesar de que `ai` ya existe como módulo en `modules/ai/pi/`.
4. La versión del proyecto está duplicada en código duro: `OMC_VERSION="1.0.0"` en `./omc` y `"version": "1.0.0"` en `apps/docs/package.json`, violando el principio de fuente única de verdad.

### Key Decisions
- **CLI Purista de Entorno:** `(session-settled: user-directed — chosen over CLI orquestador híbrido: omc se limita a install, doctor, update)`. Governs R1, R2, R3, R4.
- **Integración de Pi al flujo estándar de módulos:** `(session-settled: user-directed — chosen over subcomando especializado omc dev: se elimina omc dev y update.sh actualiza los paquetes globales de ai)`. Governs R3, R4.
- **Archivo plano `VERSION` en la raíz como SSOT:** `(session-settled: user-directed — chosen over version.json o duplicación manual: leíble por Bash en 0.001s y por Node en tiempo de compilación)`. Governs R5, R6.

### Requirements

#### Delimitación del CLI (`omc`)
R1. El CLI `./omc` debe soportar única y exclusivamente tres comandos de ciclo de vida del entorno: `install`, `doctor` y `update` (además de los flags informativos `--version` y `--help`).
R2. Se deben eliminar los subcomandos `docs` y `cheatsheet`, retirando sus respectivos scripts (`cli/commands/docs.sh`, `cli/commands/cheatsheet.sh`) y limpiando la ayuda `--help`. La web de documentación se gestiona exclusivamente con herramientas web estándar dentro de `apps/docs/`.
R3. Se debe eliminar el subcomando `dev` (`cli/commands/dev.sh`). Las configuraciones y temas de Pi continúan bajo `modules/ai/pi/` y se instalan/enlazan vía `./omc install ai` (o `./omc install --all`).
R4. El comando `./omc update` debe actualizar las fórmulas de Homebrew y, de forma transparente, actualizar los paquetes globales correspondientes al módulo `ai` (`@earendil-works/pi-coding-agent`), integrando el mantenimiento en un solo comando.

#### Versión Canónica SSOT
R5. La versión del proyecto debe residir de forma exclusiva en el archivo plano `VERSION` en la raíz del repositorio, conteniendo una cadena SemVer limpia (ej: `1.0.0`).
R6. El ejecutable `./omc` debe leer la versión dinámicamente desde el archivo `VERSION`.
R7. La aplicación de documentación en `apps/docs` (vía `astro.config.mjs` o configuración de Starlight) debe leer el archivo `../../VERSION` y exponer la versión en el portal web (en el título o badge del sitio).
R8. La documentación arquitectónica (`AGENTS.md`, `README.md`) debe actualizarse para reflejar las nuevas fronteras limpias y la regla SSOT del archivo `VERSION`.

---

## Planning Contract

### Key Technical Decisions
- **KTD1. Eliminación de comandos acoplados:** Borrar `cli/commands/docs.sh`, `cli/commands/cheatsheet.sh` y `cli/commands/dev.sh`. Limpiar el enrutador `case "$CMD"` en `./omc`. Governs R1, R2, R3.
- **KTD2. Actualización de paquetes de IA en `cli/commands/update.sh`:** Incorporar en `update.sh` la actualización de `@earendil-works/pi-coding-agent` vía npm global junto con `brew update && brew upgrade`, manteniendo `omc update` como la única rutina de mantenimiento del sistema. Governs R4.
- **KTD3. Lectura de `VERSION` en Bash 3.2:** En `./omc`, leer la versión con:
  ```bash
  OMC_VERSION="$(tr -d ' \n\r' < "$DOTFILES_DIR/VERSION" 2>/dev/null || echo "1.0.0")"
  ```
  Garantiza lectura en milisegundos sin subshell pesada ni dependencias externas. Governs R5, R6.
- **KTD4. Lectura de `VERSION` en Astro Starlight (`apps/docs`):** En `apps/docs/astro.config.mjs`:
  ```javascript
  import fs from 'node:fs';
  const version = fs.readFileSync(new URL('../../VERSION', import.meta.url), 'utf-8').trim();
  ```
  Exponer `title: `OhMyConfig v${version}`` o badge en Starlight. Governs R7.

---

## Implementation Units

### U1. Creación del archivo `VERSION` y consumo en `./omc`
- **Goal:** Crear `VERSION` en la raíz y hacer que `./omc` lo lea dinámicamente.
- **Requirements:** R5, R6
- **Files:**
  - `VERSION` (nuevo)
  - `omc`
- **Approach:**
  1. Crear archivo `VERSION` con contenido `1.0.0`.
  2. Modificar `./omc` para leer `OMC_VERSION` desde `VERSION`.
- **Verification:** `./omc --version` imprime `⚡ OhMyConfig (omc) v1.0.0`.

### U2. Consumo de `VERSION` en `apps/docs/`
- **Goal:** Hacer que la documentación web consuma la versión canónica desde `VERSION`.
- **Requirements:** R7
- **Files:**
  - `apps/docs/astro.config.mjs`
- **Approach:**
  1. Leer `../../VERSION` en `apps/docs/astro.config.mjs`.
  2. Inyectar la versión en el título del sitio de Starlight: `title: `OhMyConfig v${version}``.
- **Verification:** `npm run build --prefix apps/docs` compila sin errores mostrando la versión.

### U3. Simplificación del CLI: Eliminación de `docs.sh`, `cheatsheet.sh`, `dev.sh` y unificación en `update.sh`
- **Goal:** Purgar comandos fuera de scope y absorber la actualización de IA en `update.sh`.
- **Requirements:** R1, R2, R3, R4
- **Files:**
  - `omc`
  - `cli/commands/update.sh`
  - `cli/commands/docs.sh` (eliminar)
  - `cli/commands/cheatsheet.sh` (eliminar)
  - `cli/commands/dev.sh` (eliminar)
- **Approach:**
  1. Eliminar `cli/commands/docs.sh`, `cli/commands/cheatsheet.sh` y `cli/commands/dev.sh`.
  2. Actualizar `cli/commands/update.sh` para comprobar si `pi` está instalado y actualizarlo automáticamente con `npm install -g @earendil-works/pi-coding-agent@latest`.
  3. Limpiar `./omc` para aceptar exclusivamente: `install`, `doctor`, `update`, `--version`, `--help`.
- **Verification:** `./omc --help` muestra únicamente los 3 comandos estándar.

### U4. Sincronización de `README.md` y `AGENTS.md`
- **Goal:** Actualizar la documentación para reflejar el CLI simplificado, la gestión de la web en `apps/docs` y la regla SSOT de `VERSION`.
- **Requirements:** R8
- **Files:**
  - `README.md`
  - `AGENTS.md`
- **Approach:**
  1. Actualizar la tabla de comandos de `README.md` (solo `install`, `doctor`, `update`).
  2. Indicar que la web de documentación se desarrolla con `cd apps/docs && npm run dev`.
  3. Actualizar `AGENTS.md` reflejando la existencia de `VERSION` y la arquitectura pura del CLI.
- **Verification:** Lectura e inspección visual de `README.md` y `AGENTS.md`.

---

## Verification Contract

- **Verificación de Versión Unificada:**
  ```bash
  echo "1.0.0" > VERSION
  test "$(./omc --version | awk '{print $3}' | tr -d 'v')" = "$(cat VERSION)"
  ```
- **Verificación de Comandos del CLI:**
  ```bash
  ./omc --help   # Debe listar solo install, doctor, update
  ./omc doctor   # Diagnóstico completo
  ```
- **Verificación de Build de Documentación:**
  ```bash
  npm run build --prefix apps/docs
  ```

---

## Definition of Done

- [ ] Existe el archivo plano `VERSION` en la raíz con la versión canónica.
- [ ] `./omc` lee la versión desde `VERSION`.
- [ ] `apps/docs/astro.config.mjs` lee la versión desde `../../VERSION`.
- [ ] Se eliminaron `cli/commands/docs.sh`, `cli/commands/cheatsheet.sh` y `cli/commands/dev.sh`.
- [ ] `./omc` solo expone `install`, `doctor` y `update`.
- [ ] `update.sh` actualiza Homebrew y paquetes globales del módulo `ai`.
- [ ] `README.md` y `AGENTS.md` están actualizados.
- [ ] Todos los tests del Verification Contract pasan exitosamente.
