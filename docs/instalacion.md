# 🚀 Instalación — CLI `omc`

OhMyConfig incluye una CLI interactiva (`omc`) que reemplaza el instalador shell tradicional. Permite seleccionar exactamente qué módulos instalar, diagnosticar el entorno y gestionar el ecosistema de herramientas AI/Pi.

---

## 1. Primera Instalación

```bash
git clone https://github.com/hcastillaq/OhMyConfig.git ~/Codigos/OhMyConfig
cd ~/Codigos/OhMyConfig
./omc install
```

El instalador te guía con un menú TUI interactivo:

```
⚡ OhMyConfig CLI

  MODO DE DESPLIEGUE
  ❯ Symlinks (recomendado — cambios en repo se reflejan al instante)
    Copia con respaldo

  MÓDULOS A INSTALAR (Space = marcar, Enter = confirmar)
  ✅ Core         Fish · Starship · mise · Atuin · Nerd Fonts
  ✅ Terminal      Ghostty · Zellij
  ✅ Editor        Neovim · Git-Delta · Lazygit · gh · Bat · Glow
  ✅ Búsqueda      rg · fd · fzf · sd · yazi · zoxide · eza · dust
  ✅ CLI / TUI     btm · procs · xh · jq · jqp · tokei · onefetch
     DevOps        lazydocker · k9s · kubectx/kubens
     AI / Pi       pi · gentle-pi · gentle-engram
```

---

## 2. Comandos de la CLI

| Comando | Descripción |
| :--- | :--- |
| `./omc install` | Selección interactiva de módulos |
| `./omc install --all` | Instala todos los módulos sin preguntar |
| `./omc install --all --link` | Instala todo en modo symlink (flujo anterior de `install.sh`) |
| `./omc doctor` | Diagnóstico completo: versiones instaladas, faltantes, perfil activo |
| `./omc update` | Actualiza Homebrew (brew upgrade) + npm globals (ai/pi) |
| `./omc dev` | Instala pi + gentle-pi + gentle-engram |
| `./omc dev status` | Muestra versiones instaladas vs latest disponible |
| `./omc dev update` | Actualiza el ecosistema AI/Pi a latest |
| `./omc --help` | Ayuda general con listado de módulos |

---

## 3. Modos de Despliegue

### Symlinks (Recomendado para desarrollo de dotfiles)
Crea enlaces simbólicos de `~/.config/` directamente a los archivos del repositorio. Cualquier edición en el repo se refleja inmediatamente sin reinstalar.

```bash
./omc install --all --link
```

### Copia con Respaldo
Copia los archivos a `~/.config/`. Si existe un archivo modificado, genera un respaldo automático con timestamp (`.bak_YYYYMMDD_HHMMSS`) antes de sobrescribir.

```bash
./omc install --all
```

---

## 4. Módulos Disponibles

| Módulo | Herramientas | Configs desplegadas |
| :--- | :--- | :--- |
| **Core** | Fish · Starship · mise · Atuin · Nerd Fonts | `fish/config.fish`, `fish/functions/`, `starship.toml`, `atuin/config.toml` |
| **Terminal** | Ghostty · Zellij | `ghostty/config`, `zellij/config.kdl`, layouts, plugins |
| **Editor** | Neovim · Git-Delta · Lazygit · gh · Bat · Glow | `nvim/`, `lazygit/config.yml`, `git/delta.gitconfig` |
| **Búsqueda** | rg · fd · fzf · sd · yazi · zoxide · eza · dust | — (configuradas en Fish) |
| **CLI / TUI** | btm · procs · xh · jq · jqp · tokei · onefetch | `bottom/bottom.toml` |
| **DevOps** | lazydocker · k9s · kubectx/kubens | — |
| **AI / Pi** | pi · gentle-pi · gentle-engram | — (npm globals) |

---

## 5. Diagnóstico del Entorno

```bash
./omc doctor
```

```
⚡ OhMyConfig — Estado del Entorno
────────────────────────────────────────────────────────
  Core
  ✅  fish                   4.0.2
  ✅  starship               1.21.1
  ✅  mise                   2024.12.0
  ✅  atuin                  18.4.0

  AI / Pi
  ✅  pi                     0.84.4
  ❌  gentle-pi              NO INSTALADO  →  omc dev install
  ❌  gentle-engram          NO INSTALADO  →  omc dev install

  Perfil: modo=symlink  módulos=[core terminal editor search cli ai]
  ⚠️  33 instaladas · 2 faltantes
────────────────────────────────────────────────────────
```

---

## 6. Gestión del Ecosistema AI/Pi

El módulo `ai` instala y gestiona las tres herramientas del ecosistema Pi:

| Herramienta | Paquete npm | Descripción |
| :--- | :--- | :--- |
| **pi** | `@earendil-works/pi-coding-agent` | CLI del agente de código con herramientas de lectura, edición y ejecución |
| **gentle-pi** | `gentle-pi` | Skills, SDD/OpenSpec, reviews, orchestrator y harness de desarrollo |
| **gentle-engram** | `gentle-engram` | Memoria persistente entre sesiones de trabajo |

```bash
# Instalar el ecosistema completo
./omc dev

# Ver estado y versiones
./omc dev status

# Actualizar a latest
./omc dev update
```

---

## 7. Perfil de Instalación (`.omc-profile`)

Al finalizar, `omc install` guarda un perfil local con tu configuración:

```toml
# .omc-profile — generado por omc install
deploy_mode=symlink
modules=core terminal editor search cli ai
```

Este archivo documenta qué módulos tenés activos. Podés commitearlo para replicar exactamente el mismo setup en otra máquina.

---

## 8. Pasos Posteriores Recomendados

1. **Establecer Fish como shell por defecto en macOS:**
   ```bash
   echo "$(which fish)" | sudo tee -a /etc/shells
   chsh -s "$(which fish)"
   ```
2. **Instalar tus runtimes de desarrollo con mise:**
   ```bash
   mise use -g node@lts
   mise use -g python@latest
   mise use -g go@latest
   ```
3. **Abrir Ghostty** para disfrutar del renderizado GPU y el tema Tokyonight completo.
