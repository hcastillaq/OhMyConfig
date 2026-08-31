# Spec: Arquitectura del CLI `omc` en Bash

## 1. Contrato del Entry Point (`./omc`)

El ejecutable principal debe ser un script Bash ejecutable (`chmod +x omc`) con shebang `#!/usr/bin/env bash`.

### 1.1 Bootstrap y Verificaciones Previas
1. **Resolución de Directorio Base:**
   ```bash
   DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   ```
2. **Bootstrap de Homebrew:**
   * Detecta si `brew` está en el `PATH` o en `/opt/homebrew/bin/brew` (Apple Silicon) / `/usr/local/bin/brew` (Intel).
   * Si no existe, lanza la instalación oficial en modo no interactivo o interactivo con confirmación.
3. **Bootstrap de Gum TUI:**
   * Verifica si `gum` está disponible. Si falta y `brew` existe, ejecuta `brew install gum`.
4. **Dispatcher de Comandos:**
   * `install [args]`: Carga `cli/commands/install.sh` y llama a `cmd_install "$@"`.
   * `doctor`: Carga `cli/commands/doctor.sh` y llama a `cmd_doctor`.
   * `update`: Carga `cli/commands/update.sh` y llama a `cmd_update`.
   * `dev [args]`: Carga `cli/commands/dev.sh` y llama a `cmd_dev "$@"`.
   * `--help | -h | help | ""`: Muestra ayuda formateada y sale con 0.
   * `*`: Muestra error de comando desconocido y sale con 1.

---

## 2. Contrato de Librerías (`cli/lib/`)

### 2.1 `ui.sh` — Primitivas de Estilizado Tokyonight
* `ui_header`: Renderiza el banner `⚡ OhMyConfig CLI` con bordes redondeados en `#50f5ff` usando `gum style` (o fallback ANSI si gum falta).
* `ui_divider`: Línea divisoria en `#7a88cf`.
* Variables de paleta:
  * `COLOR_HEAD="#50f5ff"` (Cyan brillante)
  * `COLOR_SEC="#c099ff"` (Púrpura/Magenta)
  * `COLOR_OK="#9ece6a"` (Verde)
  * `COLOR_WARN="#e0af68"` (Amarillo/Naranja)
  * `COLOR_ERR="#f7768e"` (Rojo)
  * `COLOR_DIM="#7a88cf"` (Gris azulado)
  * `COLOR_TEXT="#e0e6fc"` (Texto claro)

### 2.2 `brew.sh` — Helpers de Homebrew y Node
* `brew_ensure`: Comprueba y garantiza la presencia de Homebrew en el PATH actualizando `eval "$(/opt/homebrew/bin/brew shellenv)"` si aplica.
* `gum_ensure`: Comprueba o instala Gum con `brew install gum`.
* `brew_pkg_installed <type> <package>`: Retorna 0 si la fórmula o cask está instalado, 1 si no.
* `brew_pkg_version <package>`: Imprime la versión instalada.
* `npm_ensure`: Comprueba si `npm` está disponible (vía mise o sistema).
* `npm_pkg_installed <package>`: Retorna 0 si el paquete global está instalado.
* `npm_pkg_version <package>`: Retorna la versión instalada.
* `npm_latest_version <package>`: Consulta `npm view <package> version`.

### 2.3 `catalog.sh` — Definición Declarativa de Módulos
Estructura de datos en Bash 3.2 (arrays indexados y funciones helper):
* Módulos soportados: `core`, `terminal`, `editor`, `search`, `cli`, `devops`, `ai`.
* Helpers:
  * `get_module_label <mod>`
  * `get_module_desc <mod>`
  * `get_module_tools <mod>`
  * `get_module_configs <mod>`

### 2.4 `deploy.sh` — Motor Idempotente de Despliegue
* `deploy_file <src> <dest> <mode>`:
  * Si `<mode>` es `symlink`: remueve destino si es archivo o symlink roto, y crea `ln -sf "$src" "$dest"`.
  * Si `<mode>` es `copy`: si destino existe y difiere (`cmp -s`), genera backup `$dest.bak_$(date +%Y%m%d_%H%M%S)` antes de copiar.
* `deploy_module <module> <mode> <dotfiles_dir>`: Despliega todas las rutas asociadas al módulo.

---

## 3. Contrato de Comandos (`cli/commands/`)

### 3.1 `install.sh`
* Flujo interactivo con `gum choose` (modo symlink vs copia) y `gum choose --no-limit` (selección de módulos).
* Soporte para flags:
  * `--all`: Omite selector de módulos e instala todos.
  * `--link` / `-l`: Fuerza modo symlinks.
* Guarda el estado en `$DOTFILES_DIR/.omc-profile` (`deploy_mode` y `modules`).

### 3.2 `doctor.sh`
* Itera sobre todos los módulos del catálogo e imprime estado (✅ instalado con versión o ❌ no instalado).
* Muestra estado de infraestructura (`brew`, `gum`, `node`).
* Imprime resumen total de instaladas vs faltantes.

### 3.3 `update.sh`
* Ejecuta `brew update`, `brew upgrade`, `brew upgrade --cask`.
* Actualiza el paquete npm global de Pi (`@earendil-works/pi-coding-agent`).
* Ejecuta `brew cleanup`.

### 3.4 `dev.sh`
* `_dev_install`: Instala `@earendil-works/pi-coding-agent` y muestra la lista de extensiones recomendadas para Pi.
* `_dev_status`: Muestra versión de `pi` instalada vs latest en npm, e inspecciona `pi list` para mostrar si las extensiones recomendadas están presentes.
* `_dev_update`: Actualiza `pi` a su última versión.

---

## 4. Contrato de la Función de Fish (`config/fish/functions/guia.fish`)
* Define la función `guia` (y alias opcional `cheat`).
* Argumentos: `guia [ai | nvim | zj | git | search | cli | all]`.
* Muestra colores Tokyonight en la terminal interactiva de Fish.
