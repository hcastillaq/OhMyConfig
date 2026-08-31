# Proposal: Refactorización de `omc` CLI a Bash Independiente de Fish

## 1. Motivación y Contexto

Actualmente, el punto de entrada `./omc` y toda la lógica modular de `cli/` (`cli/commands/*.fish` y `cli/lib/*.fish`) están implementados en **Fish Shell**. Esto genera una dependencia circular en máquinas limpias de macOS:
* macOS viene por defecto con **Zsh** y **Bash** (`/bin/bash`).
* Un usuario sin Fish no puede ejecutar `./omc install`, ya que el kernel falla con `env: fish: No such file or directory`.
* Conceptualmente, **Fish debe ser una herramienta de usuario desplegable** (módulo `core`), no el motor del instalador del sistema.

Este cambio desacopla completamente el gestor del entorno (`omc`) de la shell interactiva (`fish`), migrando la suite de CLI a Bash 3.2+ nativo con TUI Gum.

---

## 2. Objetivos (Scope)

1. **Reescritura en Bash 3.2+ Nativo:**
   * Convertir `./omc` en un ejecutable `/bin/bash` portable para macOS.
   * Migrar `cli/lib/*.fish` a `cli/lib/*.sh` (`brew.sh`, `catalog.sh`, `deploy.sh`, `ui.sh`).
   * Migrar `cli/commands/*.fish` a `cli/commands/*.sh` (`install.sh`, `doctor.sh`, `update.sh`, `dev.sh`).
   * Eliminar todos los archivos `.fish` de la carpeta `cli/`.

2. **Bootstrap Idempotente & Cero Dependencias:**
   * `./omc` verifica la presencia de Homebrew y Gum; si faltan en una máquina virgen, los instala de forma transparente antes de renderizar la TUI.

3. **Independencia de Fish como Herramienta:**
   * Fish permanece como un paquete dentro del módulo `core` (`config/fish/config.fish` y `config/fish/functions/`).
   * Si el usuario desmarca `core`, `omc` puede instalar el resto de los módulos sin requerir Fish.

4. **Separación Limpia de Atajos (`guia` vs `omc`):**
   * Renombrar `config/fish/functions/omc.fish` a `config/fish/functions/guia.fish`.
   * El nombre `omc` queda reservado exclusivamente al gestor CLI del repositorio.

5. **Actualización de Documentación:**
   * Sincronizar `README.md`, `AGENTS.md`, `docs/instalacion.md`, `docs/terminal.md` y `docs/cheatsheet.md`.

---

## 3. No-Objetivos (Non-Goals)

* **No reescribir las configs de Fish de usuario:** `config/fish/config.fish` y los alias/wrappers se mantienen intactos en Fish.
* **No crear instalador dual de cheatsheet:** `omc` se enfoca solo en instalación, diagnóstico y updates; el cheatsheet de terminal vive exclusivamente en `guia` (Fish).
* **No dar soporte a distribuciones Linux en este cambio:** El objetivo se mantiene estrictamente en macOS (Apple Silicon e Intel).

---

## 4. Criterios de Aceptación y Verificación

1. **Ejecución en Shell Limpia:**
   * `./omc --help`, `./omc doctor`, `./omc dev status` y `./omc install` deben ejecutarse correctamente desde `/bin/bash` y `/bin/zsh` sin que el binario `fish` esté en el PATH.
2. **Idempotencia y TUI:**
   * La interfaz Gum TUI mantiene idéntica estética Tokyonight (colores `#50f5ff`, `#c099ff`, `#9ece6a`, `#f7768e`).
3. **Módulo Fish Desacoplado:**
   * `config/fish/functions/guia.fish` provee `guia [nvim|zj|git|search|cli|ai]` correctamente en Fish.
4. **Verificación de Sintaxis y Linting:**
   * `bash -n omc cli/lib/*.sh cli/commands/*.sh` pasa sin errores de sintaxis.
5. **Documentación VitePress:**
   * `npx vitepress build` compila al 100% sin enlaces rotos.
