# AGENTS.md — OhMyConfig Context & Architecture Guide

This document provides system architecture, design invariants, configuration structure, and operational guidelines for AI coding agents working on the **OhMyConfig** repository.

---

## 1. Overview & Purpose

**OhMyConfig** is an automated, modular, and idempotent dotfiles and developer environment configuration for macOS. It replaces legacy Unix tools with high-performance modern CLI/TUI utilities (primarily built with Rust and Go), styled consistently with the **Static Noise** palette, Nerd Font icon telemetry, and integrated with terminal-based AI coding agents.

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
│       └── ui.sh                # Shared Static Noise styling & Gum UI primitives
├── README.md                    # Concise user manual, quick overview and documentation hub
├── AGENTS.md                    # AI Agent architectural context and guidelines
├── CONCEPTS.md                  # Vocabulario compartido del proyecto para orientar discusiones de dominio
├── .gitignore                   # Ignored files (.atl/, .DS_Store, .vitepress cache/dist)
├── .vitepress/
│   └── config.mjs               # VitePress site configuration (srcDir: "documentation", Static Noise theme)
├── .github/
│   └── workflows/
│       └── docs.yml             # GitHub Actions CI/CD to build & deploy docs to GitHub Pages
├── .compound-engineering/
│   ├── config.yaml              # Compound Engineering repo config (docs_root -> .compound-engineering/artifacts)
│   ├── config.example.yaml      # Current commented template for team defaults
│   └── artifacts/               # CE-owned outputs: plans, brainstorms, solutions, explainers, reports
│       └── solutions/           # Casos resueltos buscables por categoría y frontmatter (module, tags, problem_type), relevantes al implementar o depurar áreas documentadas
├── documentation/               # Modular Markdown Documentation (Pure MD without bloat)
│   ├── index.md                 # Documentation landing page
│   ├── instalacion.md           # Installation & Brewfile guide
│   ├── ai.md                    # AI ecosystem guide (pi base + recommended extensions)
│   ├── neovim.md                # Master Neovim guide
│   ├── zellij.md                # Master Zellij guide
│   ├── git.md                   # Git, Lazygit & Delta guide
│   ├── terminal.md              # Ghostty, Fish, Starship & Atuin guide
│   ├── herramientas.md          # Modern CLI/TUI tools guide
│   ├── colores.md               # Static Noise palette reference
│   └── cheatsheet.md            # Master Alias & Keymap Cheatsheet
└── config/                      # Source configuration directory (mirrors ~/.config/)
    ├── fish/
    │   ├── config.fish          # Shell aliases, wrappers, PATH, FZF/Atuin inits
    ├── ghostty/
    │   └── config               # GPU terminal config (font, theme, window blur)
    ├── starship/
    │   └── starship.toml        # Fast prompt theme with git/runtime/k8s modules
    ├── zellij/
    │   ├── config.kdl           # Zellij multiplexer settings & Static Noise palette
    │   ├── layouts/
    │   │   └── default.kdl      # 1-line layout powered by local zjstatus.wasm
    │   └── plugins/
    │       └── zjstatus.wasm    # Pre-packaged local WASM status-bar plugin
    ├── lazygit/
    │   └── config.yml           # Git TUI config, Static Noise theme & Delta integration
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
                ├── colorscheme.lua # Static Noise theme with adaptive blur/transparency
                ├── neo-tree.lua    # Clean Git status symbols without empty boxes
                ├── neogen.lua      # Intelligent docstring generator (JSDoc, TSDoc, Google)
                └── which-key.lua   # Static Noise-styled Which-Key v3 specs & Spanish groups
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
- **Ghostty**: Modern GPU-accelerated terminal emulator configured with JetBrains Mono Nerd Font, font ligatures, window blur, and Static Noise styling.
- **Fish Shell (`config/fish/config.fish`)**:
  - Environment variables: `STARSHIP_CONFIG`, `BAT_THEME`, `XDG_CONFIG_HOME`, `EDITOR`.
  - FZF Integration: Complete Static Noise color mapping with `fd` file/directory providers.
  - Atuin Integration: Database-driven shell history initialization.
  - Interactive wrappers: Yazi wrapper (`y`) that changes directory upon exit with `q`, and `cds` for `.DS_Store` sanitization.
  - Aliases & Abbreviations: Fast shortcuts for Git (`g`, `gs`, `gc`, `gl`, `glog`, `glp`, `of`), Modern CLI (`ls` -> `eza`, `cat` -> `bat`, `du` -> `dust`, `zj` -> `zellij`, `jqp`, `v` -> `nvim`), and Zoxide directory traversal (`..`, `...`, `-`).
  - Dynamic Inits: `mise`, `zoxide`, `fzf`, `atuin`, `starship`.

### 3.3 Prompt & Version Management
- **Starship (`config/starship/starship.toml`)**: Clean, reactive multi-segment prompt showing directory, git status, active language runtimes, and kubernetes context.
- **mise**: Universal polyglot runtime manager (Node, Python, Go, Rust, Java, etc.) replacing separate tools like `nvm` and `pyenv`.

### 3.4 Terminal Multiplexer (`config/zellij/`)
- **Zellij**: Modern Rust multiplexer configured with Static Noise palette and `default_layout "default"`.
- **Active Pane High-Contrast Focus**: Active focused pane is styled in radiant Cyan (`#72EAD5`) with Blue title bar (`#83BFFF`), while inactive panes remain in subtle dark slate (`#343A4A`).
- **Direct Navigation**: Seamless pane focus switching with `Alt + hjkl` (left, down, up, right), tab switching with `Alt + [` / `Alt + ]`, and direct tab jumps with `Alt + 1..9`.
- **Move / Swap Panes (`Ctrl + h`)**: Physical pane reordering and swapping via `Ctrl + h` (Move mode) with `h/j/k/l` or `Tab`.
- **Layout & Status Bar Architecture (`layouts/default.kdl` + `plugins/zjstatus.wasm`)**:
  - Unifies **Tabs**, **Mode Indicators**, and **Contextual Command Hints** into a **single 1-line bottom bar**.
  - Uses a **local WASM plugin** (`file:~/.config/zellij/plugins/zjstatus.wasm`) to eliminate network dependencies.

### 3.5 Neovim IDE Layer (`config/nvim/`)
- **LazyVim Core Engine**: Leverages upstream-maintained plugin architecture for zero maintenance overhead.
- **User Custom Layer**:
  - `colorscheme.lua`: Configures Static Noise with adaptive transparency & blur for Ghostty.
  - `neo-tree.lua`: High-contrast, clean Git status indicators without empty box artifacts.
  - `neogen.lua`: Automated structured docstring generation (`<leader>cn`).
  - `which-key.lua`: Friendly Spanish categorization and preserved window (`<c-w>`) and buffer proxies for Which-Key v3.
  - `keymaps.lua` & `options.lua`: Seamless `Ctrl + hjkl` window navigation, persistent undo, hybrid line numbers, universal `<C-s>` saving, system clipboard integration.
  - `lazyvim.json`: Dynamic module toggling via `:LazyExtras` (`<leader>px`).

### 3.6 AI Ecosystem & Coding Agents (`cli/commands/dev.sh` & `documentation/ai.md`)
- **Pi Coding Agent (`pi`)**: High-performance autonomous terminal agent for code exploration, editing, testing, and execution (`@earendil-works/pi-coding-agent`).
- **Minimal Base Install**: `omc dev install` installs only the Pi CLI base. It does not bulk-install the LazyPi catalog or optional extensions.
- **Optional Pi Packages**: Add capabilities only when needed with `pi install <package>` and inspect the current environment with `pi list`.
  - Current optional examples in this setup include `pi-subagents`, `pi-ask-user`, `pi-web-access`, `pi-hermes-memory`, `@ff-labs/pi-fff`, `@narumitw/pi-lsp`, `pi-antigravity`, `pi-smart-compact`, `pi-skill-dollar`, and `git:github.com/EveryInc/compound-engineering-plugin`.
- **Lifecycle Commands**: `omc dev` manages the Pi base CLI (`install`, `status`, `update`, `doctor`, `remove`). Optional packages are managed by native Pi commands (`pi list`, `pi install`, `pi remove`).
- **Project-Local Pi Config**: OhMyConfig selects a native Static Noise theme and custom TUI header from `.pi/settings.json`, loading resources stored under `config/pi/themes/` and `config/pi/extensions/` via paths relative to `.pi/` (`../config/pi/...`). Run `pi --approve` or `/trust` to load them.

---

## 4. Design Invariants & Conventions

1. **Static Noise Palette Consistency**:
   - Primary Background: `#141720` (or `#0F1117` for deep dark / borders / void)
   - Primary Foreground: `#E6E2D6`
   - Accents: Blue (`#83BFFF`), Cyan (`#72EAD5`), Green (`#A3D98B`), Magenta/Purple (`#C2A7FF` / `#F08BC2`), Yellow/Orange (`#EDD071` / `#F3A261`), Red (`#EF7785`), Dim/Comments (`#9299AE` / `#62697B`).
2. **Pure Documentation Principle**:
   - The `documentation/` directory contains **only pure Markdown files** without framework config bloat.
   - VitePress configuration lives externally in `.vitepress/config.mjs` with `srcDir: "documentation"`.
   - CI/CD in `.github/workflows/docs.yml` builds and deploys to GitHub Pages automatically.
   - Compound Engineering artifacts are separated from user docs under `.compound-engineering/artifacts/` via `.compound-engineering/config.yaml` (`docs_root`).
3. **Zero-Friction Offline Execution**: Avoid dynamic external downloads inside runtime configs; bundle or locally cache required binaries/WASM plugins within the repo.
4. **Non-Destructive Overwrites**: Configuration installers must never silently discard user files without `.bak_` backups or user consent.
5. **Platform Scope**: Tailored for macOS (Apple Silicon `/opt/homebrew` and Intel `/usr/local`), supporting fish shell syntax.

<!-- BEGIN COMPOUND PI TOOL MAP -->
## Compound Engineering (Pi compatibility)

This block is added by the pi-compound-engineering package.

Pi extensions used by skills shipped by this package:
- Required for full functionality: `pi-subagents` (by nicobailon) provides the `subagent` tool used by ce-compound, ce-code-review, ce-plan, ce-compound-refresh, and other parallel-agent skills.
- Recommended: `pi-ask-user` (by edlsh) provides the `ask_user` tool; skills fall back to numbered options in chat when it is missing.

Install with:
  pi install npm:pi-subagents
  pi install npm:pi-ask-user
<!-- END COMPOUND PI TOOL MAP -->

## Compound Engineering Reporting

Write every report, summary, or handoff to the user through the `ce-noslop` skill. This applies when you are the top-level agent writing to the user, not when you are a subagent reporting to its caller. Do not apply it to code, config, verbatim quotes, or text the user asked to post as written.
