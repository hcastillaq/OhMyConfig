# 📦 Instalación — CLI `omc`

OhMyConfig incluye una CLI interactiva (`omc`) escrita en **Bash 3.2+ nativo** con interfaz TUI vía **gum**. Permite seleccionar exactamente qué módulos instalar, diagnosticar el entorno, actualizar herramientas y gestionar el agente de IA Pi sin depender previamente de ninguna shell externa.

---

## 1. Primera Instalación

```bash
git clone https://github.com/hcastillaq/OhMyConfig.git ~/Codigos/OhMyConfig
cd ~/Codigos/OhMyConfig
./omc install
```

El CLI te guía con dos pantallas interactivas:

**Paso 1 — Modo de despliegue:**
```
❯ Symlinks (recomendado — cambios en repo se reflejan al instante)
  Copia con respaldo
```
Navegá con `↑ ↓` y confirmá con `Enter`.

**Paso 2 — Selección de módulos:**
```
  Seleccioná módulos (x = marcar/desmarcar, a = todos, Enter = confirmar)

• Core         Fish · Starship · mise · Atuin · Nerd Fonts
• Terminal     Ghostty · Zellij
• Editor       Neovim · Git-Delta · Lazygit · gh · Bat · Glow
• Búsqueda     rg · fd · fzf · sd · yazi · zoxide · eza · dust
• CLI / TUI    btm · procs · xh · jq · jqp · tokei · onefetch
• DevOps       lazydocker · k9s · kubectx/kubens
• AI / Pi      pi (Coding Agent en terminal)
```

| Tecla | Acción |
| :---: | :--- |
| `↑` / `↓` | Mover cursor |
| `x` | Marcar / desmarcar módulo |
| `a` | Seleccionar / deseleccionar todos |
| `Enter` | Confirmar selección e instalar |
| `q` / `Esc` | Cancelar |

---

## 2. Referencia Completa de Comandos

### `omc install` — Instalador Interactivo

```bash
./omc install                  # Menú TUI para elegir modo y módulos
./omc install --all            # Instala todos los módulos en modo copia
./omc install --all --link     # Instala todos los módulos en modo symlink
./omc install --link           # Menú de módulos pero fuerza modo symlink
```

---

### `omc doctor` — Diagnóstico del Entorno

Muestra el estado de cada herramienta instalada, su versión y qué módulos faltan. Funciona en máquinas nuevas sin necesitar perfil previo.

```bash
./omc doctor
```

Salida de ejemplo:
```
⚡ OhMyConfig — Estado del Entorno
────────────────────────────────────────────────────────
  Core
  ✅  fish                   4.0.2
  ✅  starship               1.26.0
  ✅  mise                   2024.12.0
  ✅  atuin                  18.4.0

  Editor
  ✅  nvim                   0.12.5
  ✅  delta                  0.19.2
  ✅  lazygit                0.44.1

  AI / Pi
  ✅  pi                     0.84.4

  Infraestructura
  ✅  brew                   4.4.17
  ✅  gum                    2.0.0
  ✅  node                   22.14.0 (via mise)

  Perfil: modo=symlink  módulos=[core terminal editor search cli devops ai]
  ✅ 31 instaladas · 0 faltantes
────────────────────────────────────────────────────────
```

---

### `omc update` — Actualización Completa

Actualiza Homebrew, todas las fórmulas/casks instalados y el agente `pi` (npm global) de una sola vez.

```bash
./omc update
```

```
⚡ OhMyConfig — Actualizando entorno
  ⠋ Actualizando repositorio de Homebrew...   ✅ Hecho
  ⠋ Actualizando fórmulas instaladas...       ✅ 4 paquetes actualizados
  ⠋ Actualizando casks instalados...          ✅ Hecho

  AI / Pi (npm globals)
  ✅  pi              0.84.4  (latest)

  🧹 Caché limpiado
  ✅ Actualización completada.
```

---

### `omc dev` — Gestión del Agente Pi

Instala y actualiza el agente base **`pi`**. Las extensiones recomendadas se instalan directamente con `pi install <ext>`. Para la explicación detallada de cada extensión, consultá la [Guía de AI & Agentes](./ai.md).

```bash
./omc dev              # Instala pi (equivale a omc dev install)
./omc dev install      # Instala el binario global de pi
./omc dev status       # Muestra versión de pi y estado de extensiones recomendadas
./omc dev update       # Actualiza pi a su última versión en npm
```

Extensiones recomendadas para potenciar `pi`:

| Extensión | Comando en Pi | Rol Principal |
| :--- | :--- | :--- |
| **`pi-subagents`** | `pi install npm:pi-subagents` | Orquestación de subagentes en paralelo y delegación |
| **`pi-ask-user`** | `pi install npm:pi-ask-user` | Menús interactivos y preguntas estructuradas |
| **`@narumitw/pi-plan-mode`**| `pi install npm:@narumitw/pi-plan-mode` | Modo de planificación interactiva guiada (`/plan`) |
| **`@plannotator/pi-extension`**| `pi install npm:@plannotator/pi-extension` | Visualización interactiva y anotación de planes |
| **`pi-antigravity`** | `pi install npm:pi-antigravity` | DeepMind Antigravity, CodeGraph y semántica |
| **`pi-memory-md`** | `pi install git:github.com/VandeeFeng/pi-memory-md` | Memoria persistente offline en Markdown y control Git |
| **`pi-web-access`** | `pi install npm:pi-web-access` | Búsqueda web multi-proveedor, scraping y chequeo de fuentes |
| **`pi-interactive-shell`** | `pi install npm:pi-interactive-shell` | Ejecución interactiva de CLIs y TUIs en segundo plano |

---

### `omc --help` — Ayuda General

```bash
./omc --help
./omc -h
```

---

## 3. Modos de Despliegue

### Symlinks (Recomendado para desarrollo activo de dotfiles)
Crea enlaces simbólicos de `~/.config/` directamente a los archivos del repositorio. Cualquier edición en el repo se refleja de inmediato sin reinstalar.

```bash
./omc install --all --link
```

### Copia con Respaldo
Copia los archivos a `~/.config/`. Si existe un archivo modificado, genera un respaldo automático con timestamp (`.bak_YYYYMMDD_HHMMSS`) antes de sobrescribir. Recomendado para producción o máquinas compartidas.

```bash
./omc install --all
```

---

## 4. Módulos Disponibles

| Módulo | Herramientas | Configs desplegadas |
| :--- | :--- | :--- |
| **core** | Fish · Starship · mise · Atuin · Nerd Fonts | `fish/config.fish`, `fish/functions/`, `starship.toml`, `atuin/config.toml` |
| **terminal** | Ghostty · Zellij | `ghostty/config`, `zellij/config.kdl`, layouts, plugins |
| **editor** | Neovim · Git-Delta · Lazygit · gh · Bat · Glow | `nvim/`, `lazygit/config.yml`, `git/delta.gitconfig` |
| **search** | rg · fd · fzf · sd · yazi · zoxide · eza · dust | — (integradas en Fish) |
| **cli** | btm · procs · xh · jq · jqp · tokei · onefetch | `bottom/bottom.toml` |
| **devops** | lazydocker · k9s · kubectx/kubens | — |
| **ai** | pi (Coding Agent en terminal) | — (npm global) |

---

## 5. Perfil de Instalación (`.omc-profile`)

Al finalizar, `omc install` guarda un perfil local:

```toml
# .omc-profile — generado por omc install
deploy_mode=symlink
modules=core terminal editor search cli devops ai
```

`omc update` y `omc doctor` lo leen para saber qué módulos tenés activos. Podés commitearlo para replicar el setup exacto en otra máquina.

---

## 6. Pasos Posteriores Recomendados

1. **Establecer Fish como shell por defecto en macOS:**
   ```bash
   echo "$(which fish)" | sudo tee -a /etc/shells
   chsh -s "$(which fish)"
   ```
2. **Instalar tus runtimes con mise:**
   ```bash
   mise use -g node@lts
   mise use -g python@latest
   mise use -g go@latest
   ```
3. **Abrir Ghostty** para disfrutar del renderizado GPU y el tema Tokyonight completo.
4. **Instalar pi y la suite modular LazyPi:**
   ```bash
   ./omc dev
   pi install npm:pi-subagents
   pi install npm:pi-ask-user
   pi install npm:@narumitw/pi-plan-mode
   pi install npm:@plannotator/pi-extension
   pi install npm:pi-antigravity
   pi install git:github.com/VandeeFeng/pi-memory-md
   pi install npm:pi-web-access
   pi install npm:pi-interactive-shell
   ```
