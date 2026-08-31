# ⚡ OhMyConfig

<p align="center">
  <a href="https://hcastillaq.github.io/OhMyConfig/"><img src="https://img.shields.io/badge/📖_Documentación_Web-Online-7aa2f7?style=for-the-badge&logo=vitepress&logoColor=white" alt="Documentation"></a>
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-7dcfff?style=for-the-badge&logo=apple&logoColor=white" alt="macOS">
  <img src="https://img.shields.io/badge/Theme-Tokyonight%20Night-bb9af7?style=for-the-badge" alt="Theme">
  <img src="https://img.shields.io/badge/License-MIT-9ece6a?style=for-the-badge" alt="License">
</p>

> **Entorno de desarrollo moderno, modular e idempotente para macOS**, estilizado bajo la paleta **Tokyonight Night** con glifos **Nerd Font v3**, utilidades de última generación escritas en **Rust** y **Go**, y agentes autónomos de **IA en terminal**.

---

### 🌐 Documentación Oficial en Vivo
Toda la documentación interactiva con buscador `Cmd + K`, navegación lateral y cheatsheets está disponible en:
👉 **[https://hcastillaq.github.io/OhMyConfig/](https://hcastillaq.github.io/OhMyConfig/)**

---

## 🚀 Instalación Rápida (CLI `omc`)

```bash
# 1. Clonar repositorio
git clone https://github.com/hcastillaq/OhMyConfig.git ~/Codigos/OhMyConfig
cd ~/Codigos/OhMyConfig

# 2. Desplegar de forma interactiva (o con --all --link)
./omc install
```

* **CLI `omc`**: Instalador interactivo TUI (vía Gum) que gestiona Homebrew, paquetes de sistema, symlinks a `~/.config/`, diagnóstico (`./omc doctor`), actualizaciones (`./omc update`) y el agente de IA Pi (`./omc dev`).

---

## 📚 Guías y Documentación Modular

Cada componente del entorno cuenta con su propia guía detallada dentro de [`docs/`](./docs/):

```
OhMyConfig/
├── 🚀 Primeros Pasos
│   ├── 📦 Instalación & Brewfile ───────► docs/instalacion.md
│   └── 🤖 Ecosistema AI & Agentes ──────► docs/ai.md
│
├── 🛠️ Herramientas Centrales
│   ├── 🛠️ Neovim (Editor IDE) ──────────► docs/neovim.md
│   ├── 🪟 Zellij (Multiplexor) ─────────► docs/zellij.md
│   ├── 🐙 Git, Lazygit & Delta ─────────► docs/git.md
│   └── 🖥️ Terminal, Fish & mise ────────► docs/terminal.md
│
└── 📖 Referencia Rápida
    ├── 🧰 Catálogo Completo de Herramientas ► docs/herramientas.md
    └── ⚡ Tabla Maestra de Atajos ──────► docs/cheatsheet.md
```

| Sección | Descripción | Guía en Web | Archivo Markdown |
| :--- | :--- | :---: | :---: |
| **📦 Instalación** | Menú TUI, symlinks, respaldo y catálogo de `Brewfile` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/instalacion) | [`docs/instalacion.md`](./docs/instalacion.md) |
| **🤖 Ecosistema AI** | Pi coding agent y catálogo de extensiones recomendadas | [Ver Online](https://hcastillaq.github.io/OhMyConfig/ai) | [`docs/ai.md`](./docs/ai.md) |
| **🛠️ Neovim** | LazyVim core, LSP, autocompletado, GitLens y Neogen | [Ver Online](https://hcastillaq.github.io/OhMyConfig/neovim) | [`docs/neovim.md`](./docs/neovim.md) |
| **🪟 Zellij** | Multiplexor con foco Cyan brillante y navegación con `Alt` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/zellij) | [`docs/zellij.md`](./docs/zellij.md) |
| **🐙 Git & Diffs** | Flujo en consola, Lazygit TUI y diffs con Git-Delta | [Ver Online](https://hcastillaq.github.io/OhMyConfig/git) | [`docs/git.md`](./docs/git.md) |
| **🖥️ Terminal & Shell** | Ghostty (GPU/Blur), Fish Shell, **mise** (Runtimes) y Atuin | [Ver Online](https://hcastillaq.github.io/OhMyConfig/terminal) | [`docs/terminal.md`](./docs/terminal.md) |
| **🧰 Catálogo de CLI/TUI** | Ripgrep, Fd, Sd, Eza, Bat, Yazi, Bottom, Dust, Procs, Xh, Jq, K9s | [Ver Online](https://hcastillaq.github.io/OhMyConfig/herramientas) | [`docs/herramientas.md`](./docs/herramientas.md) |
| **⚡ Cheatsheet** | Tabla consolidada de todos los alias y atajos del entorno | [Ver Online](https://hcastillaq.github.io/OhMyConfig/cheatsheet) | [`docs/cheatsheet.md`](./docs/cheatsheet.md) |

---

## ⚡ Cheatsheet Rápido de Referencia

### 1. Ecosistema AI & Agentes de Código
* **`./omc dev`**: Instala el agente base `pi` (`@earendil-works/pi-coding-agent`).
* **`./omc dev status`**: Diagnóstico de la versión de `pi` y estado de extensiones recomendadas.
* **`./omc dev update`**: Actualiza el agente `pi` a su última versión en npm.
* **`pi`**: Inicia el agente autónomo de código en terminal.
* **`pi install gentle-pi`**: Harness SDD/OpenSpec, orquestación de subagentes y skills.
* **`pi install gentle-engram`**: Memoria episódica persistente entre sesiones (SQLite local).
* **`pi install pi-subagents`**: Delegación en paralelo y modo consejo (`/council`).
* **`pi install pi-antigravity`**: Integración con DeepMind Antigravity y CodeGraph.
* **`pi install pi-web-access`**: Búsqueda web multi-proveedor y extracción de fuentes.
* **`pi install @narumitw/pi-plan-mode`**: Modo interactivo de planificación guiada (`/plan`).

### 2. Terminal, Runtimes y Búsqueda
* **`guia`** (o `omc`): Menú interactivo de atajos en consola (`guia nvim`, `guia zj`, `guia git`, `guia search`, `guia cli`, `guia ai`).
* **`mise use -g <lang>@<ver>`**: Gestor universal de versiones (Node, Python, Go, Rust, Java).
* **`rg <patron>`**: Búsqueda ultrarrápida de texto en todo el proyecto (Ripgrep).
* **`fd <nombre>`**: Búsqueda moderna de archivos y carpetas (reemplazo de `find`).
* **`sd 'viejo' 'nuevo'`**: Reemplazo de texto directo y seguro en archivos (reemplazo de `sed`).
* **`cd <carpeta>`** / **`zi`**: Salto inteligente con Zoxide / selector interactivo FZF.
* **`Ctrl + r`**: Historial SQLite con tiempos y buscador difuso (Atuin).
* **`Ctrl + t`** / **`Alt + c`**: Búsqueda difusa de archivos / carpetas con FZF.
* **`y`**: Administrador de archivos Yazi (salta al directorio al salir con `q`).
* **`ls`** / **`ll`** / **`tree`**: Listados visuales con íconos vía Eza.
* **`cat <archivo>`**: Visor con sintaxis coloreada Tokyonight vía Bat.
* **`btm`** / **`du`**: Monitor de sistema (Bottom) / Uso visual de disco (Dust).
* **`procs --port <p>`**: Visor de procesos y puertos.
* **`xh`** / **`jqp`**: Cliente HTTP para APIs / Playground interactivo JQ.
* **`tokei`**: Conteo de líneas de código y estadísticas del proyecto.

### 3. Editor Neovim (`<Space>` = Leader)
* **`v`** / **`v <archivo>`**: Abrir Neovim con tema Tokyonight.
* **`<Space> + e`**: Abrir / Ocultar explorador de archivos lateral.
* **`Ctrl + h/j/k/l`**: Moverse fluidamente entre paneles y divisiones.
* **`Shift + l`** / **`Shift + h`**: Pestaña siguiente / anterior.
* **`<Space> + bd`**: Cerrar pestaña actual limpiamente sin dejar `[No Name]`.
* **`<Space> + w`**: Guardar archivo (`:w`).
* **`s` + 2 letras**: Salto instantáneo a cualquier palabra en pantalla (Flash).
* **`gd`** / **`K`**: Ir a definición / Ver documentación flotante (LSP).
* **`<Space> + cr`**: Renombrar variable en todo el proyecto con LSP.
* **`<Space> + sr`**: Buscar y reemplazar texto en todo el proyecto (Grug-Far).
* **`<Space> + cn`**: Generar docstrings estructurados automáticamente (Neogen).
* **`<Space> + px`**: Menú interactivo `:LazyExtras` para activar/desactivar lenguajes con `x`.

### 4. Multiplexor Zellij (`zj`)
* **`Alt + h/j/k/l`**: Mover foco entre paneles (se ilumina en Cyan hacia izquierda, abajo, arriba, derecha).
* **`Alt + [`** / **`Alt + ]`**: Pestaña anterior / siguiente al instante.
* **`Alt + 1` .. `Alt + 9`**: Saltar directo a la pestaña número N.
* **`Alt + n`**: Crear nuevo panel directamente.
* **`Alt + f`**: Maximizar / Restaurar panel activo (Pantalla completa).
* **`Alt + w`**: Alternar paneles flotantes (Floating Panes).
* **`Ctrl + h`**: **Modo Mover** para intercambiar físicamente la posición de paneles (`h/j/k/l` o `Tab`).
* **`Ctrl + p`** (Paneles) / **`Ctrl + t`** (Pestañas) / **`Ctrl + s`** (Scroll e historial) / **`Ctrl + n`** (Resize).

### 5. Git y Control de Versiones
* **`gs`** (`git status`), **`gaa`** (`git add .`), **`gc`** (`git commit`), **`gp`** (`git push`).
* **`gl`** / **`glog`**: Árboles visuales de commits coloreados con Tokyonight.
* **`glp`**: Historial detallado con diffs interactivos en Git-Delta.
* **`lg`**: Interfaz visual completa de Lazygit.
* **`of`**: Radiografía visual con telemetría del repositorio vía Onefetch.

---

## 🚀 Publicación Web Automática

La documentación completa de este repositorio se compila y publica automáticamente en **GitHub Pages** mediante **VitePress** a través de GitHub Actions:

```text
[Repositorio Local] ──(Push en docs/)──► [GitHub Actions CI/CD] ──► [GitHub Pages Web]
```

Accedé a la documentación interactiva:  
👉 **`https://hcastillaq.github.io/OhMyConfig/`**

---

## 📄 Licencia

Publicado bajo la licencia [MIT](./LICENSE) — Libre para uso personal y modificaciones.
