# Design: Refactorización de `omc` a Bash Nativo

## 1. Decisiones de Arquitectura

### 1.1 Compatibilidad con Bash 3.2 de macOS
* **Contexto:** macOS incluye por defecto `/bin/bash` versión 3.2.57 debido a la licencia GPLv3 de versiones posteriores de Bash.
* **Decisión:** Todo el código en `omc` y `cli/` debe escribirse respetando las limitaciones de Bash 3.2:
  * **No usar arrays asociativos** (`declare -A`, introducidos en Bash 4.0).
  * En su lugar, usar arrays indexados estándar (`array=(...)`), cadenas delimitadas por dos puntos (`tool="type:pkg:bin"`), o funciones selectoras con `case/switch`.
  * Usar sintaxis estándar de funciones POSIX/Bash: `function_name() { ... }`.
  * Evitar expansiones de parámetros exclusivas de Bash 4+.

### 1.2 Estrategia de Bootstrap y Auto-Instalación
```text
                  [Ejecutar ./omc <comando>]
                              │
                              ▼
            ┌───────────────────────────────────┐
            │   ¿Está Homebrew en el PATH?      │
            └─────────────────┬─────────────────┘
                     SÍ       │      NO
                     ┌────────┴────────┐
                     ▼                 ▼
          [Eval brew shellenv]   [Instalar Homebrew oficial]
                     │                 │
                     └────────┬────────┘
                              │
                              ▼
            ┌───────────────────────────────────┐
            │   ¿Está 'gum' en el PATH?         │
            └─────────────────┬─────────────────┘
                     SÍ       │      NO
                     ┌────────┴────────┐
                     ▼                 ▼
             [Continuar flujo]   [brew install gum]
                              │
                              ▼
            [Ejecutar subcomando solicitado con Gum TUI]
```

### 1.3 Separación de Responsabilidades: CLI vs Dotfiles
* **`cli/` (Entorno de Ejecución):**
  * Scripts en Bash (`*.sh`).
  * No forman parte de las configuraciones de usuario que se copian a `~/.config/`.
  * Su único trabajo es gestionar el ciclo de vida del entorno.
* **`config/` (Configuraciones de Usuario):**
  * `config/fish/`: Configuración pura de la shell Fish (`config.fish`, `functions/guia.fish`).
  * `config/ghostty/`, `config/nvim/`, `config/zellij/`, `config/starship/`, etc.
  * Son totalmente independientes del instalador.

---

## 2. Manejo de Errores y Casos Borde

1. **Terminal sin soporte TTY (ej: CI / pipelines):**
   * En pipelines automatizados (como `install --all --link`), `omc` no interactúa con TUI y ejecuta la instalación secuencial limpia.
2. **Apple Silicon vs Intel Homebrew Prefix:**
   * Apple Silicon: `/opt/homebrew/bin/brew`.
   * Intel: `/usr/local/bin/brew`.
   * `cli/lib/brew.sh` verifica ambas rutas antes de fallar.
3. **Copia Segura sin Pérdida de Datos:**
   * En modo copia, `deploy_file` utiliza `cmp -s` para detectar si el archivo en destino difiere del origen. Si difiere, genera un respaldo timestamped `.bak_YYYYMMDD_HHMMSS`.
   * En modo symlink, reemplaza symlinks rotos o preexistentes de forma atómica (`ln -sf`).

---

## 3. Plan de Migración y Limpieza

1. **Creación de nuevos archivos en Bash:**
   * `cli/lib/ui.sh`, `cli/lib/brew.sh`, `cli/lib/catalog.sh`, `cli/lib/deploy.sh`.
   * `cli/commands/install.sh`, `cli/commands/doctor.sh`, `cli/commands/update.sh`, `cli/commands/dev.sh`.
   * Reescritura del entry point `./omc` en Bash.
2. **Renombrado en Fish:**
   * Mover `config/fish/functions/omc.fish` $\rightarrow$ `config/fish/functions/guia.fish`.
3. **Limpieza:**
   * Eliminar todos los archivos `.fish` de `cli/commands/` y `cli/lib/`.
4. **Verificación:**
   * Correr `bash -n` en todos los scripts de Bash.
   * Probar `./omc --help`, `./omc doctor`, `./omc dev status`.
   * Compilar documentación VitePress (`npx vitepress build`).
