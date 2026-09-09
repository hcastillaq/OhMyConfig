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

Cada componente del entorno cuenta con su propia guía detallada dentro de [`documentation/`](./documentation/):

```
OhMyConfig/
├── 🚀 Primeros Pasos
│   ├── 📦 Instalación & Brewfile ───────► documentation/instalacion.md
│   └── 🤖 Ecosistema AI & Agentes ──────► documentation/ai.md
│
├── 🛠️ Herramientas Centrales
│   ├── 🛠️ Neovim (Editor IDE) ──────────► documentation/neovim.md
│   ├── 🪟 Zellij (Multiplexor) ─────────► documentation/zellij.md
│   ├── 🐙 Git, Lazygit & Delta ─────────► documentation/git.md
│   └── 🖥️ Terminal, Fish & mise ────────► documentation/terminal.md
│
└── 📖 Referencia Rápida
    ├── 🧰 Catálogo Completo de Herramientas ► documentation/herramientas.md
    └── ⚡ Tabla Maestra de Atajos ──────► documentation/cheatsheet.md
```

| Sección | Descripción | Guía en Web | Archivo Markdown |
| :--- | :--- | :---: | :---: |
| **📦 Instalación** | Menú TUI, symlinks, respaldo y catálogo de `Brewfile` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/instalacion) | [`documentation/instalacion.md`](./documentation/instalacion.md) |
| **🤖 Ecosistema AI** | Pi base y extensiones opcionales detectadas con `pi list` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/ai) | [`documentation/ai.md`](./documentation/ai.md) |
| **🛠️ Neovim** | LazyVim core, LSP, autocompletado, GitLens y Neogen | [Ver Online](https://hcastillaq.github.io/OhMyConfig/neovim) | [`documentation/neovim.md`](./documentation/neovim.md) |
| **🪟 Zellij** | Multiplexor con foco Cyan brillante y navegación con `Alt` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/zellij) | [`documentation/zellij.md`](./documentation/zellij.md) |
| **🐙 Git & Diffs** | Flujo en consola, Lazygit TUI y diffs con Git-Delta | [Ver Online](https://hcastillaq.github.io/OhMyConfig/git) | [`documentation/git.md`](./documentation/git.md) |
| **🖥️ Terminal & Shell** | Ghostty (GPU/Blur), Fish Shell, **mise** (Runtimes) y Atuin | [Ver Online](https://hcastillaq.github.io/OhMyConfig/terminal) | [`documentation/terminal.md`](./documentation/terminal.md) |
| **🧰 Catálogo de CLI/TUI** | Ripgrep, Fd, Sd, Eza, Bat, Yazi, Bottom, Dust, Procs, Xh, Jq, K9s | [Ver Online](https://hcastillaq.github.io/OhMyConfig/herramientas) | [`documentation/herramientas.md`](./documentation/herramientas.md) |
| **⚡ Cheatsheet** | Tabla consolidada de todos los alias y atajos del entorno | [Ver Online](https://hcastillaq.github.io/OhMyConfig/cheatsheet) | [`documentation/cheatsheet.md`](./documentation/cheatsheet.md) |

---

## ⚡ Cheatsheet Rápido de Referencia

### 1. Ecosistema AI & Pi
* **`./omc dev`**: Instala sólo el CLI base de Pi.
* **`./omc dev status`**: Muestra versión de Pi y paquetes actuales con `pi list`.
* **`./omc dev update`**: Actualiza sólo el binario base de Pi.
* **`./omc dev doctor`**: Chequeo local de Node/npm/Pi.
* **`pi list`**: Lista extensiones instaladas.
* **`pi install <paquete>`**: Instala una extensión opcional bajo demanda.
* **`pi`**: Inicia el agente autónomo de código en terminal.

### 2. Terminal, Runtimes y Búsqueda
* **`guia`**: Menú interactivo de atajos en consola (`guia nvim`, `guia zj`, `guia git`, `guia search`, `guia cli`, `guia ai`).
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
* **`Ctrl + s`**: Guardar archivo actual en cualquier modo (normal o inserción).
* **`<Space> + w`**: Menú de ventanas y divisiones (splits: horizontal, vertical, cerrar).
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
