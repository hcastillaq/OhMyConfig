# AGENTS.md — OhMyConfig Context & Architecture Guide

This document provides system architecture, design invariants, configuration structure, and operational guidelines for AI coding agents working on the **OhMyConfig** repository.

---

## 1. Overview & Purpose

**OhMyConfig** is an automated, modular, and idempotent dotfiles and developer environment configuration for macOS. It replaces legacy Unix tools with high-performance modern CLI/TUI utilities (primarily built with Rust and Go), styled consistently with the **Tokyonight** palette, Nerd Font icon telemetry, and integrated with terminal-based AI coding agents.

---

## 2. Repository Structure

```
OhMyConfig/
├── Brewfile                     # Homebrew bundle (CLI tools, GUI apps, Nerd Fonts)
├── omc                          # Single executable CLI entry point (Bash 3.2+ & Gum TUI)
├── cli/                         # Modular CLI implementation in pure Bash
│   ├── commands/
│   │   ├── install.sh           # Interactive & automated module installer
│   │   ├── doctor.sh            # Environment diagnostic & version reporting
│   │   ├── update.sh            # Centralized updater (Brew + Casks + AI npm packages)
│   │   └── dev.sh               # AI/Pi ecosystem manager (install pi, status, update)
│   └── lib/
│       ├── brew.sh              # Homebrew detection, verification & helpers
│       ├── catalog.sh           # Granular module & package definitions
│       ├── deploy.sh            # Safe symlink/copy file deployment engine
│       └── ui.sh                # Shared Tokyonight styling & Gum UI primitives
├── README.md                    # Concise user manual, quick overview and documentation hub
├── AGENTS.md                    # AI Agent architectural context and guidelines
├── .gitignore                   # Ignored files (.atl/, .DS_Store, .vitepress cache/dist)
├── .vitepress/
│   └── config.mjs               # VitePress site configuration (srcDir: "docs", Tokyonight theme)
├── .github/
│   └── workflows/
│       └── docs.yml             # GitHub Actions CI/CD to build & deploy docs to GitHub Pages
├── docs/                        # Modular Markdown Documentation (Pure MD without bloat)
│   ├── index.md                 # Documentation landing page
│   ├── instalacion.md           # Installation & Brewfile guide
│   ├── ai.md                    # AI ecosystem guide (pi base + recommended extensions)
│   ├── neovim.md                # Master Neovim guide
│   ├── zellij.md                # Master Zellij guide
│   ├── git.md                   # Git, Lazygit & Delta guide
│   ├── terminal.md              # Ghostty, Fish, Starship & Atuin guide
│   ├── herramientas.md          # Modern CLI/TUI tools guide
│   └── cheatsheet.md            # Master Alias & Keymap Cheatsheet
└── config/                      # Source configuration directory (mirrors ~/.config/)
    ├── fish/
    │   ├── config.fish          # Shell aliases, wrappers, PATH, FZF/Atuin inits
    │   └── functions/
    │       └── guia.fish        # Interactive cheatsheet and keymap guide (guia)
    ├── ghostty/
    │   └── config               # GPU terminal config (font, theme, window blur)
    ├── starship/
    │   └── starship.toml        # Fast prompt theme with git/runtime/k8s modules
    ├── zellij/
    │   ├── config.kdl           # Zellij multiplexer settings & Tokyonight palette
    │   ├── layouts/
    │   │   └── default.kdl      # 1-line layout powered by local zjstatus.wasm
    │   └── plugins/
    │       └── zjstatus.wasm    # Pre-packaged local WASM status-bar plugin
    ├── lazygit/
    │   └── config.yml           # Git TUI config, Tokyonight theme & Delta integration
    ├── bottom/
    │   └── bottom.toml          # System & process monitor theme/layout
    ├── atuin/
    │   └── config.toml          # Intelligent shell history SQLite database config
    ├── git/
    │   └── delta.gitconfig      # Modular Delta & alias configuration (included via include.path)
    └── nvim/                    # Modular Neovim Lua IDE configuration (LazyVim Core)
        ├── init.lua             # Core entry point (options, keymaps, lazy bootstrap)
        ├── lazyvim.json         # LazyExtras enabled modules (TypeScript, Python, Docker, etc.)
        └── lua/
            ├── config/
            │   ├── options.lua  # User vim.opt settings (hybrid numbers, undo, tabs)
            │   ├── keymaps.lua  # User navigation & split mappings (<leader> = Space)
            │   ├── autocmds.lua # User event triggers and hooks
            │   └── lazy.lua     # LazyVim core bootstrap & plugin setup
            └── plugins/
                ├── colorscheme.lua # Tokyonight Night theme with adaptive blur/transparency
                ├── neo-tree.lua    # Clean Git status symbols without empty boxes
                ├── neogen.lua      # Intelligent docstring generator (JSDoc, TSDoc, Google)
                └── which-key.lua   # Tokyonight-styled Which-Key v3 specs & Spanish groups
```

---

## 3. Core Subsystems & Components

### 3.1 CLI & Deployment Engine (`./omc` & `cli/`)
- **Single Entry Point (`./omc`)**: Written in pure Bash 3.2+ with Gum TUI, providing subcommands: `install`, `doctor`, `update`, and `dev`. Cero dependencias de shells externas.
- **Idempotency & Safety (`cli/lib/deploy.sh`)**: Compares source and destination with `cmp -s`. Creates timestamped backups (`${dest}.bak_YYYYMMDD_HHMMSS`) before overwriting modified files.
- **Symlink Mode (`--link` / `-l`)**: Replaces configuration copies with direct symbolic links pointing to this repository.
- **Homebrew Automation (`cli/lib/brew.sh`)**: Automatically verifies and installs Homebrew and Gum if missing, then orchestrates formula and cask installations per module.
- **State Profile (`.omc-profile`)**: Persists active modules and deployment mode for non-destructive incremental updates and diagnostics.

### 3.2 Terminal & Shell Layer
- **Ghostty**: Modern GPU-accelerated terminal emulator configured with JetBrains Mono Nerd Font, font ligatures, window blur, and Tokyonight styling.
- **Fish Shell (`config/fish/config.fish`)**:
  - Environment variables: `STARSHIP_CONFIG`, `BAT_THEME`, `XDG_CONFIG_HOME`, `EDITOR`.
  - FZF Integration: Complete Tokyonight Night color mapping with `fd` file/directory providers.
  - Atuin Integration: Database-driven shell history initialization.
  - Interactive wrappers: Yazi wrapper (`y`) that changes directory upon exit with `q`, and `cds` for `.DS_Store` sanitization.
  - Aliases & Abbreviations: Fast shortcuts for Git (`g`, `gs`, `gc`, `gl`, `glog`, `glp`, `of`), Modern CLI (`ls` -> `eza`, `cat` -> `bat`, `du` -> `dust`, `zj` -> `zellij`, `jqp`, `v` -> `nvim`), and Zoxide directory traversal (`..`, `...`, `-`).
  - Dynamic Inits: `mise`, `zoxide`, `fzf`, `atuin`, `starship`.

### 3.3 Prompt & Version Management
- **Starship (`config/starship/starship.toml`)**: Clean, reactive multi-segment prompt showing directory, git status, active language runtimes, and kubernetes context.
- **mise**: Universal polyglot runtime manager (Node, Python, Go, Rust, Java, etc.) replacing separate tools like `nvm` and `pyenv`.

### 3.4 Terminal Multiplexer (`config/zellij/`)
- **Zellij**: Modern Rust multiplexer configured with Tokyonight palette and `default_layout "default"`.
- **Active Pane High-Contrast Focus**: Active focused pane is styled in radiant Cyan (`#7dcfff`) with Blue title bar (`#7aa2f7`), while inactive panes remain in subtle dark slate (`#292e42`).
- **Direct Navigation**: Seamless pane focus switching with `Alt + hjkl` (left, down, up, right), tab switching with `Alt + [` / `Alt + ]`, and direct tab jumps with `Alt + 1..9`.
- **Move / Swap Panes (`Ctrl + h`)**: Physical pane reordering and swapping via `Ctrl + h` (Move mode) with `h/j/k/l` or `Tab`.
- **Layout & Status Bar Architecture (`layouts/default.kdl` + `plugins/zjstatus.wasm`)**:
  - Unifies **Tabs**, **Mode Indicators**, and **Contextual Command Hints** into a **single 1-line bottom bar**.
  - Uses a **local WASM plugin** (`file:~/.config/zellij/plugins/zjstatus.wasm`) to eliminate network dependencies.

### 3.5 Neovim IDE Layer (`config/nvim/`)
- **LazyVim Core Engine**: Leverages upstream-maintained plugin architecture for zero maintenance overhead.
- **User Custom Layer**:
  - `colorscheme.lua`: Configures Tokyonight Night with adaptive transparency & blur for Ghostty.
  - `neo-tree.lua`: High-contrast, clean Git status indicators without empty box artifacts.
  - `neogen.lua`: Automated structured docstring generation (`<leader>cn`).
  - `which-key.lua`: Friendly Spanish categorization and preserved window (`<c-w>`) and buffer proxies for Which-Key v3.
  - `keymaps.lua` & `options.lua`: Seamless `Ctrl + hjkl` window navigation, persistent undo, hybrid line numbers, universal `<C-s>` saving, system clipboard integration.
  - `lazyvim.json`: Dynamic module toggling via `:LazyExtras` (`<leader>px`).

### 3.6 AI Ecosystem & Coding Agents (`cli/commands/dev.sh` & `docs/ai.md`)
- **Pi Coding Agent (`pi`)**: High-performance autonomous terminal agent for code exploration, editing, testing, and execution (`@earendil-works/pi-coding-agent`).
- **Official LazyPi Suite (`@tommy-ca/lazypi`)**: `omc dev` manages the base CLI and the complete 17-tool catalog (Core + Optional):
  - **Core**: `subagents`, `pi-ask-user`, `pi-skillful`, `mention-skill` (`$`), `goal`, `btw`, `context-usage`, `simplify`, `web-access`, `fff`, `dynamic-workflows`, `ponytail`.
  - **Optional**: `lsp` (real-time diagnostics), `interactive-shell` (TUI overlays), `autoresearch`, `todos`, `memory` (`pi-memory-md` Git-backed offline).
  - **Compound Engineering Suite (`ce-*`)**: Complete engineering lifecycle skills (`ce-brainstorm`, `ce-plan`, `ce-doc-review`, `ce-work`, `ce-code-review`, `ce-commit-push-pr`, `ce-compound`).
- **Lifecycle Commands**: Managed via `omc dev` (`install`, `status`, `update`, `doctor`, `remove`) and globally via `omc update`.

---

## 4. Design Invariants & Conventions

1. **Tokyonight Palette Consistency**:
   - Primary Background: `#1a1b26` (or `#15161e` for deep dark / borders)
   - Primary Foreground: `#c0caf5`
   - Accents: Blue (`#7aa2f7`), Cyan (`#7dcfff`), Green (`#9ece6a`), Magenta/Purple (`#bb9af7`), Yellow/Orange (`#e0af68` / `#ff9e64`), Red (`#f7768e`), Dim/Comments (`#565f89` / `#737aa2`).
2. **Pure Documentation Principle**:
   - The `docs/` directory contains **only pure Markdown files** without framework config bloat.
   - VitePress configuration lives externally in `.vitepress/config.mjs` with `srcDir: "docs"`.
   - CI/CD in `.github/workflows/docs.yml` builds and deploys to GitHub Pages automatically.
3. **Zero-Friction Offline Execution**: Avoid dynamic external downloads inside runtime configs; bundle or locally cache required binaries/WASM plugins within the repo.
4. **Non-Destructive Overwrites**: Configuration installers must never silently discard user files without `.bak_` backups or user consent.
5. **Platform Scope**: Tailored for macOS (Apple Silicon `/opt/homebrew` and Intel `/usr/local`), supporting fish shell syntax.
