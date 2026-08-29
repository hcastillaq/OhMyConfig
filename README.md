# ⚡ OhMyConfig

> **Entorno de desarrollo moderno, modular y de alto rendimiento para macOS**, estilizado bajo la paleta **Tokyonight Night** con glifos **Nerd Font v3** y utilidades de última generación escritas en **Rust** y **Go**.

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

* El instalador verifica e instala automáticamente **Homebrew**, ejecuta el **Brewfile** con todas las herramientas y enlaza las configuraciones sin sobreescribir destructivamente tus archivos.

---

## 📚 Documentación Modular

Cada componente del entorno cuenta con su propia guía detallada e interactiva dentro de [`docs/`](./docs/):

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

| Sección | Descripción | Documento |
| :--- | :--- | :--- |
| **📦 Instalación** | Opciones de copia con respaldo, symlinks y Brewfile automatizado | [Leer Guía](./docs/instalacion.md) |
| **🛠️ Neovim** | Motor LazyVim, atajos de edición, LSP, autocompletado, GitLens y Neogen | [Leer Guía](./docs/neovim.md) |
| **🪟 Zellij** | Multiplexor con foco en Cyan de alto contraste y navegación con `Alt` | [Leer Guía](./docs/zellij.md) |
| **🐙 Git & Diffs** | Flujo rápido en consola, interfaz visual Lazygit y paginador Git-Delta | [Leer Guía](./docs/git.md) |
| **🖥️ Terminal & Shell** | Ghostty (GPU/Blur), Fish Shell interactivo, Starship y Atuin SQLite | [Leer Guía](./docs/terminal.md) |
| **🧰 CLI / TUI Tools** | Eza, Bat, Yazi, Bottom, Dust, Procs, Xh, Jq, Jqp, Lazydocker, K9s | [Leer Guía](./docs/herramientas.md) |
| **⚡ Cheatsheet** | Tabla maestra consolidada de todos los alias y atajos del entorno | [Ver Tabla](./docs/cheatsheet.md) |

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
* **`Alt + t`**: Crear nueva pestaña.
* **`Alt + n`**: Crear nuevo panel.
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

Para consultar la documentación en formato web interactivo con buscador `Cmd + K`, visitá:
👉 **`https://hcastillaq.github.io/OhMyConfig/`**

---

## 📄 Licencia

Publicado bajo la licencia [MIT](./LICENSE) — Libre para uso personal y modificaciones.
