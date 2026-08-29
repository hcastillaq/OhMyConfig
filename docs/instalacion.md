# 🚀 Instalación — CLI `omc`

OhMyConfig incluye una CLI interactiva (`omc`) escrita en **Fish Shell puro** con interfaz TUI via **gum**. Permite seleccionar exactamente qué módulos instalar, diagnosticar el entorno, actualizar herramientas y gestionar el ecosistema AI/Pi.

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
• AI / Pi      pi · gentle-pi · gentle-engram
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

> `install.sh` sigue funcionando como alias de `./omc install --all --link` para compatibilidad con el flujo anterior.

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
  ❌  gentle-pi              NO INSTALADO  →  omc dev install
  ❌  gentle-engram          NO INSTALADO  →  omc dev install

  Infraestructura
  ✅  brew                   4.4.17
  ✅  gum                    2.0.0
  ✅  node                   22.14.0 (via mise)

  Perfil: modo=symlink  módulos=[core terminal editor search cli]
  ⚠️  33 instaladas · 2 faltantes
────────────────────────────────────────────────────────
```

---

### `omc update` — Actualización Completa

Actualiza Homebrew, todas las fórmulas/casks instalados y los paquetes npm del ecosistema AI/Pi de una sola vez.

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
  ✅  gentle-pi       2.2.0   →  2.3.0
  ✅  gentle-engram   0.1.10  (latest)

  🧹 Caché limpiado
  ✅ Actualización completada.
```

---

### `omc dev` — Ecosistema AI/Pi

Gestión específica de `pi`, `gentle-pi` y `gentle-engram` (paquetes **npm globales**).

```bash
./omc dev              # Instalar los tres (equivale a omc dev install)
./omc dev install      # Instalar pi + gentle-pi + gentle-engram
./omc dev status       # Ver versiones instaladas vs latest disponible
./omc dev update       # Actualizar los tres a latest
```

Las tres herramientas que instala:

| Herramienta | Paquete npm | Descripción |
| :--- | :--- | :--- |
| **pi** | `@earendil-works/pi-coding-agent` | Agente de código con herramientas de lectura, edición, ejecución y búsqueda |
| **gentle-pi** | `gentle-pi` | Skills, SDD/OpenSpec, reviews, orchestrator y harness de desarrollo controlado |
| **gentle-engram** | `gentle-engram` | Memoria persistente entre sesiones de trabajo con pi |

Después de instalar, activar en pi:
```bash
pi install gentle-pi
pi install gentle-engram
```

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
| **ai** | pi · gentle-pi · gentle-engram | — (npm globals) |

---

## 5. Perfil de Instalación (`.omc-profile`)

Al finalizar, `omc install` guarda un perfil local:

```toml
# .omc-profile — generado por omc install
deploy_mode=symlink
modules=core terminal editor search cli ai
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
4. **Activar el ecosistema AI/Pi:**
   ```bash
   ./omc dev
   pi install gentle-pi
   pi install gentle-engram
   ```
