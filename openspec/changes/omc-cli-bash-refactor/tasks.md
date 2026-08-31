# Tasks: Refactorización de `omc` CLI a Bash

- [x] 1. **Librerías Base en Bash (`cli/lib/*.sh`)**
  - [x] 1.1 Crear `cli/lib/ui.sh` con variables de paleta Tokyonight, `ui_header`, `ui_divider` y helpers de Gum TUI.
  - [x] 1.2 Crear `cli/lib/brew.sh` con detección de prefijos Homebrew (`/opt/homebrew` y `/usr/local`), `brew_ensure`, `gum_ensure`, verificación de paquetes e inspección de `npm`.
  - [x] 1.3 Crear `cli/lib/catalog.sh` con definición declarativa de módulos (`core`, `terminal`, `editor`, `search`, `cli`, `devops`, `ai`) y funciones selectoras compatibles con Bash 3.2.
  - [x] 1.4 Crear `cli/lib/deploy.sh` con `deploy_file` (soporte seguro para `symlink` y `copy` con respaldo timestamped) y `deploy_module`.

- [x] 2. **Comandos del CLI en Bash (`cli/commands/*.sh`)**
  - [x] 2.1 Crear `cli/commands/install.sh` con selector interactivo TUI (Gum) de modo y módulos, soporte para `--all` y `--link`, y guardado de `.omc-profile`.
  - [x] 2.2 Crear `cli/commands/doctor.sh` con iteración sobre el catálogo, verificación de infraestructura (`brew`, `gum`, `node`) y reporte consolidado.
  - [x] 2.3 Crear `cli/commands/update.sh` con actualización de Homebrew, fórmulas, casks y paquete npm global de `pi`.
  - [x] 2.4 Crear `cli/commands/dev.sh` con instalación del agente base `pi`, diagnóstico de extensiones recomendadas vía `pi list` y actualización a latest.

- [x] 3. **Entry Point & Desacoplamiento de Fish**
  - [x] 3.1 Reemplazar `./omc` con el script ejecutable en `/bin/bash` que implementa bootstrap automático de Homebrew/Gum y dispatcher de comandos.
  - [x] 3.2 Renombrar `config/fish/functions/omc.fish` a `config/fish/functions/guia.fish` con la función `guia` (y alias `cheat`), eliminando `omc.fish`.
  - [x] 3.3 Eliminar todos los archivos `.fish` obsoletos dentro de `cli/lib/` y `cli/commands/`.

- [x] 4. **Verificación & Documentación**
  - [x] 4.1 Validar sintaxis con `bash -n omc cli/lib/*.sh cli/commands/*.sh`.
  - [x] 4.2 Probar ejecución de `./omc --help`, `./omc doctor`, `./omc dev status` en Bash.
  - [x] 4.3 Sincronizar documentación (`README.md`, `AGENTS.md`, `docs/instalacion.md`, `docs/terminal.md`, `docs/cheatsheet.md`).
  - [x] 4.4 Compilar sitio VitePress (`npx vitepress build`) y verificar que pase sin errores.
