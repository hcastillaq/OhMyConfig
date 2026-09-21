# ⚡ OhMyConfig

<p align="center">
  <a href="https://hcastillaq.github.io/OhMyConfig/"><img src="https://img.shields.io/badge/⚡_Documentación_Web-Online-72EAD5?style=for-the-badge&logo=astro&logoColor=0F1117" alt="Documentation"></a>
  <img src="https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-72EAD5?style=for-the-badge&logo=apple&logoColor=0F1117" alt="macOS">
  <img src="https://img.shields.io/badge/Theme-Static%20Noise-72EAD5?style=for-the-badge" alt="Theme">
  <img src="https://img.shields.io/badge/License-MIT-9ece6a?style=for-the-badge" alt="License">
</p>

> **Entorno de desarrollo moderno, modular e idempotente para macOS**, estilizado bajo la paleta **Static Noise** con glifos **Nerd Font v3**, utilidades de última generación escritas en **Rust** y **Go**, y agentes autónomos de **IA en terminal**.

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

* **CLI `omc`**: Gestor e instalador de entorno para macOS (vía Gum y Bash 3.2+). Centraliza la instalación modular (`./omc install`), el diagnóstico de herramientas (`./omc doctor`) y la actualización del sistema (`./omc update`).

---

## 📚 Guías y Documentación Modular

Cada componente del entorno cuenta con su propia guía detallada dentro de [`apps/docs/src/content/docs/`](./apps/docs/src/content/docs/):

```
OhMyConfig/
├── 🚀 Primeros Pasos
│   ├── 📦 Instalación & Brewfile ───────► apps/docs/src/content/docs/instalacion.md
│   └── 🤖 Ecosistema AI & Agentes ──────► apps/docs/src/content/docs/ai.md
│
├── 🛠️ Herramientas Centrales
│   ├── 🛠️ Neovim (Editor IDE) ──────────► apps/docs/src/content/docs/neovim.md
│   ├── 🪟 Zellij (Multiplexor) ─────────► apps/docs/src/content/docs/zellij.md
│   ├── 🐙 Git, Lazygit & Delta ─────────► apps/docs/src/content/docs/git.md
│   └── 🖥️ Terminal, Fish & mise ────────► apps/docs/src/content/docs/terminal.md
│
└── 📖 Referencia Rápida
    ├── 🧰 Catálogo Completo de Herramientas ► apps/docs/src/content/docs/herramientas.md
    └── ⚡ Tabla Maestra de Atajos ──────► apps/docs/src/content/docs/cheatsheet.md
```

| Sección | Descripción | Guía en Web | Archivo Markdown |
| :--- | :--- | :---: | :---: |
| **📦 Instalación** | Menú TUI, symlinks, respaldo y catálogo de `Brewfile` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/instalacion) | [`apps/docs/src/content/docs/instalacion.md`](./apps/docs/src/content/docs/instalacion.md) |
| **🤖 Ecosistema AI** | Pi base y extensiones opcionales detectadas con `pi list` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/ai) | [`apps/docs/src/content/docs/ai.md`](./apps/docs/src/content/docs/ai.md) |
| **🛠️ Neovim** | LazyVim core, LSP, autocompletado, GitSigns y Neogen | [Ver Online](https://hcastillaq.github.io/OhMyConfig/neovim) | [`apps/docs/src/content/docs/neovim.md`](./apps/docs/src/content/docs/neovim.md) |
| **🪟 Zellij** | Multiplexor con foco Cyan brillante y navegación con `Alt` | [Ver Online](https://hcastillaq.github.io/OhMyConfig/zellij) | [`apps/docs/src/content/docs/zellij.md`](./apps/docs/src/content/docs/zellij.md) |
| **🐙 Git & Diffs** | Flujo en consola, Lazygit TUI y diffs con Git-Delta | [Ver Online](https://hcastillaq.github.io/OhMyConfig/git) | [`apps/docs/src/content/docs/git.md`](./apps/docs/src/content/docs/git.md) |
| **🖥️ Terminal & Shell** | Ghostty (GPU/Blur), Fish Shell, **mise** (Runtimes) y Atuin | [Ver Online](https://hcastillaq.github.io/OhMyConfig/terminal) | [`apps/docs/src/content/docs/terminal.md`](./apps/docs/src/content/docs/terminal.md) |
| **🧰 Catálogo de CLI/TUI** | Ripgrep, Fd, Sd, Eza, Bat, Yazi, Bottom, Dust, Procs, Xh, Jq, K9s | [Ver Online](https://hcastillaq.github.io/OhMyConfig/herramientas) | [`apps/docs/src/content/docs/herramientas.md`](./apps/docs/src/content/docs/herramientas.md) |
| **⚡ Cheatsheet** | Tabla consolidada de todos los alias y atajos del entorno | [Ver Online](https://hcastillaq.github.io/OhMyConfig/cheatsheet) | [`apps/docs/src/content/docs/cheatsheet.md`](./apps/docs/src/content/docs/cheatsheet.md) |

---

## ⚡ Consulta de Atajos y Comandos

Para evitar desincronización y duplicación de datos, los atajos y aliases de consola se consultan de forma centralizada y con buscador en la web oficial:

👉 **[Ver Tabla Maestra de Atajos Online](https://hcastillaq.github.io/OhMyConfig/cheatsheet)**

---

## 🛠️ Comandos de `omc`

| Comando | Acción |
| :--- | :--- |
| `./omc install` | Instalador interactivo TUI con selección modular |
| `./omc install --all --link` | Instalación completa en modo symlink (recomendado) |
| `./omc doctor` | Diagnóstico de salud del entorno, paquetes y symlinks |
| `./omc update` | Actualiza fórmulas/casks, Pi y adaptadores publicados de Static Noise |
| `./omc --version` | Muestra la versión actual desde el archivo `VERSION` |
| `./omc --help` | Muestra la ayuda de comandos |

---

## 💻 Desarrollo de la Documentación Web

La aplicación web de documentación reside en `apps/docs/` y se gestiona con herramientas estándar de Node:

```bash
cd apps/docs
npm install        # Instala dependencias del portal Astro Starlight
npm run dev        # Inicia el servidor local en http://localhost:4321/OhMyConfig/
npm run build      # Compila el sitio estático en apps/docs/dist/
```

---

