# ⚡ OhMyConfig

<p align="center">
  <a href="https://hcastillaq.github.io/OhMyConfig/"><img src="https://img.shields.io/badge/📖_Documentación_Web-Online-7aa2f7?style=for-the-badge&logo=vitepress&logoColor=white" alt="Documentation"></a>
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-7dcfff?style=for-the-badge&logo=apple&logoColor=white" alt="macOS">
  <img src="https://img.shields.io/badge/Theme-Tokyonight%20Night-bb9af7?style=for-the-badge" alt="Theme">
  <img src="https://img.shields.io/badge/License-MIT-9ece6a?style=for-the-badge" alt="License">
</p>

> **Entorno de desarrollo moderno, modular y de alto rendimiento para macOS**, estilizado bajo la paleta **Tokyonight Night** con glifos **Nerd Font v3** y utilidades de última generación escritas en **Rust** y **Go**.

---

### 🌐 Documentación Oficial en Vivo
Toda la documentación interactiva con buscador `Cmd + K`, navegación lateral y cheatsheets está disponible en:
👉 **[https://hcastillaq.github.io/OhMyConfig/](https://hcastillaq.github.io/OhMyConfig/)**

---

## 🚀 Instalación Rápida (Idempotente)

```bash
# 1. Clonar repositorio
git clone https://github.com/hcastillaq/OhMyConfig.git ~/Codigos/OhMyConfig
cd ~/Codigos/OhMyConfig

# 2. Desplegar en modo Enlaces Simbólicos (Symlinks directos a ~/.config/)
chmod +x install.sh
./install.sh -l
```

* El instalador verifica e instala automáticamente **Homebrew**, ejecuta el **Brewfile** con todas las herramientas y enlaza las configuraciones sin sobreescribir destructivamente tus archivos existentes.

---

## 📚 Guías y Documentación Modular

Cada componente del entorno cuenta con su propia guía detallada dentro de [`docs/`](./docs/):

```
OhMyConfig/
├── 🚀 Primeros Pasos
│   └── 📦 Instalación & Brewfile ───────► docs/instalacion.md
│
├── 🛠️ Herramientas Centrales
│   ├── 🛠️ Neovim (Editor IDE) ──────────► docs/neovim.md
│   ├── 🪟 Zellij (Multiplexor) ─────────► docs/zellij.md
│   ├── 🐙 Git, Lazygit & Delta ─────────► docs/git.md
│   └── 🖥️ Terminal, Fish & Starship ───► docs/terminal.md
│
└── 📖 Referencia Rápida
    ├── 🧰 Herramientas CLI / TUI ───────► docs/herramientas.md
    └── ⚡ Tabla Maestra de Atajos ──────► docs/cheatsheet.md
```

| Sección | Descripción | Guía en Web | Archivo Markdown |
| :--- | :--- | :---: | :---: |
| **📦 Instalación** | Copia con respaldo, symlinks y Brewfile | [Ver Online](https://hcastillaq.github.io/OhMyConfig/instalacion) | [`docs/instalacion.md`](./docs/instalacion.md) |
| **🛠️ Neovim** | LazyVim core, LSP, autocompletado, GitLens y Neogen | [Ver Online](https://hcastillaq.github.io/OhMyConfig/neovim) | [`docs/neovim.md`](./docs/neovim.md) |
| **🪟 Zellij** | Multiplexor con foco Cyan brillante y navegación con `Alt` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/zellij) | [`docs/zellij.md`](./docs/zellij.md) |
| **🐙 Git & Diffs** | Flujo en consola, Lazygit TUI y diffs con Git-Delta | [Ver Online](https://hcastillaq.github.io/OhMyConfig/git) | [`docs/git.md`](./docs/git.md) |
| **🖥️ Terminal & Shell** | Ghostty (GPU/Blur), Fish Shell, Starship y Atuin SQLite | [Ver Online](https://hcastillaq.github.io/OhMyConfig/terminal) | [`docs/terminal.md`](./docs/terminal.md) |
| **🧰 CLI / TUI Tools** | Eza, Bat, Yazi, Bottom, Dust, Procs, Xh, Jq, Jqp, K9s | [Ver Online](https://hcastillaq.github.io/OhMyConfig/herramientas) | [`docs/herramientas.md`](./docs/herramientas.md) |
| **⚡ Cheatsheet** | Tabla consolidada de todos los alias y atajos | [Ver Online](https://hcastillaq.github.io/OhMyConfig/cheatsheet) | [`docs/cheatsheet.md`](./docs/cheatsheet.md) |

---

## ⚡ Cheatsheet Rápido de Referencia

### 1. Terminal y Navegación
* **`v`** / **`v <archivo>`**: Abrir Neovim con tema Tokyonight.
* **`zj`**: Iniciar multiplexor Zellij con barra de 1 línea.
* **`cd <carpeta>`**: Salto inteligente con Zoxide (`..`, `...`, `-`).
* **`Ctrl + r`**: Historial inteligente con base de datos SQLite (Atuin).
* **`Ctrl + t`** / **`Alt + c`**: Búsqueda difusa de archivos / carpetas con FZF.
* **`y`**: Administrador de archivos Yazi (salta al directorio actual al salir con `q`).
* **`ls`** / **`ll`** / **`tree`**: Listados visuales con íconos vía Eza.

### 2. Editor Neovim (`<Space>` = Leader)
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

### 3. Multiplexor Zellij (`zj`)
* **`Alt + Flechas`** (o `Alt + hjkl`): Mover foco entre paneles (se ilumina en Cyan).
* **`Alt + [`** / **`Alt + ]`**: Pestaña anterior / siguiente al instante.
* **`Alt + 1` .. `Alt + 9`**: Saltar directo a la pestaña número N.
* **`Alt + t`**: Crear nueva pestaña | **`Alt + n`**: Crear nuevo panel.
* **`Alt + f`**: Maximizar / Restaurar panel activo (Pantalla completa).
* **`Ctrl + p`** (Paneles) / **`Ctrl + t`** (Pestañas) / **`Ctrl + s`** (Scroll e historial).

### 4. Git y Control de Versiones
* **`gs`** (`git status`), **`gaa`** (`git add .`), **`gc`** (`git commit`), **`gp`** (`git push`).
* **`gl`** / **`glog`**: Árboles visuales de commits coloreados con Tokyonight.
* **`glp`**: Historial detallado con diffs interactivos en Git-Delta.
* **`lg`**: Interfaz visual completa de Lazygit.
* **`of`**: Radiografía visual con telemetría del repositorio vía Onefetch.

---

## 🌐 Publicación Web Automática

La documentación completa de este repositorio se compila y publica automáticamente en **GitHub Pages** mediante **VitePress** a través de GitHub Actions:

```text
[Repositorio Local] ──(Push en docs/)──► [GitHub Actions CI/CD] ──► [GitHub Pages Web]
```

Accedé a la documentación interactiva:  
👉 **`https://hcastillaq.github.io/OhMyConfig/`**

---

## 📄 Licencia

Publicado bajo la licencia [MIT](./LICENSE) — Libre para uso personal y modificaciones.
