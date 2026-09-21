# AGENTS.md — OhMyConfig Context & Architecture Guide

This document provides system architecture, design invariants, configuration structure, and operational guidelines for AI coding agents working on the **OhMyConfig** repository.

---

## 1. Overview & Purpose

**OhMyConfig** is an automated, modular, and idempotent dotfiles and developer environment configuration for macOS. It replaces legacy Unix tools with high-performance modern CLI/TUI utilities (primarily built with Rust and Go), styled consistently with the **Static Noise** palette, Nerd Font icon telemetry, and integrated with terminal-based AI coding agents.

---

## 2. Repository Structure

```
OhMyConfig/
├── VERSION                      # Single Source of Truth for project version (SemVer)
├── Brewfile                     # Homebrew bundle centralizado (CLI tools, GUI apps, Nerd Fonts)
├── omc                          # Single executable CLI entry point (Bash 3.2+ & Gum TUI)
├── cli/                         # Modular CLI implementation in pure Bash
│   ├── commands/
│   │   ├── install.sh           # Interactive & automated module installer
│   │   ├── doctor.sh            # Environment diagnostic & version reporting
│   │   └── update.sh            # Centralized updater (Brew + Casks + AI npm packages)
│   └── lib/
│       ├── brew.sh              # Homebrew detection, verification & helpers
│       ├── catalog.sh           # Granular module & package definitions
│       ├── deploy.sh            # Safe symlink/copy file deployment engine (modules/ resolution)
│       └── ui.sh                # Shared Static Noise styling & Gum UI primitives
├── README.md                    # Concise user manual, quick overview and documentation hub
├── AGENTS.md                    # AI Agent architectural context and guidelines
├── CONCEPTS.md                  # Vocabulario compartido del proyecto para orientar discusiones de dominio
├── .gitignore                   # Ignored files (.atl/, .DS_Store, dist/, .astro/, node_modules/)
├── .github/
│   └── workflows/
│       └── docs.yml             # GitHub Actions CI/CD to build & deploy docs (working-dir: apps/docs)
├── .compound-engineering/
│   ├── config.yaml              # Compound Engineering repo config (docs_root -> .compound-engineering/artifacts)
│   ├── config.example.yaml      # Current commented template for team defaults
│   └── artifacts/               # CE-owned outputs: plans, brainstorms, solutions, explainers, reports
│       └── solutions/           # Casos resueltos buscables por categoría y frontmatter
├── apps/                        # Decoupled web applications
│   └── docs/                    # Astro Starlight documentation portal (fully isolated web app)
│       ├── package.json         # Documentation site dependencies (Astro + Starlight)
│       ├── astro.config.mjs     # Astro Starlight configuration (base: /OhMyConfig/, overrides)
│       ├── tsconfig.json        # TypeScript configuration for Astro & Starlight
│       └── src/
│           ├── content.config.ts # Content Layer configuration
│           ├── content/docs/    # Pure Markdown documentation (canonical SSOT)
│           ├── styles/
│           │   └── custom.css   # Static Noise theme & Expressive Code styling
│           └── components/      # Cosmic Atmosphere & Starlight component overrides
└── modules/                     # Modular co-located dotfile packages with manifest.sh
    ├── core/
    │   ├── fish/                # Shell aliases, wrappers, PATH, inits + manifest.sh
    │   ├── starship/            # Fast prompt theme + manifest.sh
    │   └── atuin/               # Shell history SQLite config + manifest.sh
    ├── terminal/
    │   ├── ghostty/             # GPU terminal config + manifest.sh
    │   └── zellij/              # Multiplexer config, layouts, local zjstatus.wasm + manifest.sh
    ├── editor/
    │   ├── nvim/                # Modular Neovim Lua IDE (LazyVim Core) + manifest.sh
    │   ├── git/                 # Modular Delta & alias configuration + manifest.sh
    │   └── lazygit/             # Git TUI config, Static Noise theme + manifest.sh
    ├── cli/
    │   └── bottom/              # System & process monitor config + manifest.sh
    └── ai/
        └── pi/                  # Pi themes, header, model-policy extensions + manifest.sh
```

---

## 3. Core Subsystems & Components

### 3.1 CLI & Deployment Engine (`./omc` & `cli/`)
- **Single Entry Point (`./omc`)**: Written in pure Bash 3.2+ with Gum TUI, providing subcommands: `install`, `doctor`, `update`, and flags `--version` (`-v`), `--help` (`-h`). Cero dependencias de shells externas.
- **Idempotency & Safety (`cli/lib/deploy.sh`)**: Compares source and destination with `cmp -s`. Creates timestamped backups (`${dest}.bak_YYYYMMDD_HHMMSS`) before overwriting modified files. Resolves dynamic sources from `modules/<domain>/<tool>/manifest.sh`.
- **Symlink Mode (`--link` / `-l`)**: Replaces configuration copies with direct symbolic links pointing to this repository (`modules/`).
- **Homebrew Automation (`cli/lib/brew.sh`)**: Automatically verifies and installs Homebrew and Gum if missing, then orchestrates formula and cask installations per module via `brew bundle`.
- **State Profile (`.omc-profile`)**: Persists active modules and deployment mode for non-destructive incremental updates and diagnostics.

### 3.2 Terminal & Shell Layer
- **Ghostty**: Modern GPU-accelerated terminal emulator configured with JetBrains Mono Nerd Font, font ligatures, window blur, and the published `static-noise.ghostty` release adapter.
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

### 3.6 AI Ecosystem & Coding Agents (`modules/ai/pi/` & `apps/docs/src/content/docs/ai.md`)
- **Pi Coding Agent (`pi`)**: High-performance autonomous terminal agent for code exploration, editing, testing, and execution (`@earendil-works/pi-coding-agent`).
- **Minimal Base Install**: Managed homogeneously as the `ai` module (`./omc install ai` or `./omc install --all`).
- **Optional Pi Packages**: Add capabilities only when needed with `pi install <package>` and inspect the current environment with `pi list`.
  - Current optional examples in this setup include `pi-subagents`, `pi-ask-user`, `pi-web-access`, `pi-hermes-memory`, `@ff-labs/pi-fff`, `@narumitw/pi-lsp`, `pi-antigravity`, `pi-smart-compact`, `pi-skill-dollar`, and `git:github.com/EveryInc/compound-engineering-plugin`.
- **Lifecycle Commands**: `./omc update` automatically checks and updates `@earendil-works/pi-coding-agent`. Optional packages are managed by native Pi commands (`pi list`, `pi install`, `pi remove`).
- **Project-Local Pi Resources**: `.pi/` contains only the repository-specific skills under `.pi/skills/`. The `ai` module deploys the Static Noise theme, custom TUI header, and model policy globally under `~/.pi/agent/`; project settings must not override those global resources. Run `pi --approve` or `/trust` to load the local skills.

---

## 4. Design Invariants & Conventions

1. **Static Noise Palette Consistency**:
   - Primary Background: `#141720` (or `#0F1117` for deep dark / borders / void)
   - Primary Foreground: `#E6E2D6`
   - Accents: Blue (`#83BFFF`), Cyan (`#72EAD5`), Green (`#A3D98B`), Magenta/Purple (`#C2A7FF` / `#F08BC2`), Yellow/Orange (`#EDD071` / `#F3A261`), Red (`#EF7785`), Dim/Comments (`#9299AE` / `#62697B`).
2. **Pure Documentation Principle**:
   - The documentation Markdown files reside in `apps/docs/src/content/docs/` as **pure Markdown files** without framework config bloat.
   - Documentation platform is built on **Astro + Starlight** inside `apps/docs/` with zero JavaScript on reader content, styled with the Static Noise palette and a calibrated cosmic atmosphere canvas.
   - CI/CD in `.github/workflows/docs.yml` verifies compilation with `npm run build` inside `apps/docs/` on PRs and deploys to GitHub Pages exclusively upon version tag releases (`v*`) or manual dispatch.
   - Compound Engineering artifacts are separated from user docs under `.compound-engineering/artifacts/` via `.compound-engineering/config.yaml` (`docs_root`).
3. **Zero-Friction Runtime Execution**: Runtime configs must not download assets dynamically. Published theme adapters may be refreshed explicitly by `omc install` or `omc update`; failed refreshes must preserve the previously installed file.
4. **Non-Destructive Overwrites**: Configuration installers must never silently discard user files without `.bak_` backups or user consent.
5. **Platform Scope**: Tailored for macOS (Apple Silicon `/opt/homebrew` and Intel `/usr/local`), supporting fish shell syntax.
6. **Semantic Versioning & Release Policy (`SemVer`)**:
   - **Baseline**: Starts at `v0.0.1` as the reset baseline for the current single-user project.
   - **Single Source of Truth**: The `VERSION` plain file at the repository root. Both `./omc` and `apps/docs/` consume it directly.
   - **Patch (`0.0.x`)**: Bug fixes in bash/fish scripts, design/CSS tweaks in documentation, dependency updates, or broken link repairs.
   - **Minor (`0.x.0`)**: New CLI tools added to the catalog, new optional dotfiles modules, or new capabilities in `./omc` without preserving legacy compatibility.
   - **Major (`x.0.0`)**: Breaking architectural changes (e.g. folder structure changes that break symlinks, replacing core tools like Neovim or Fish, or updates requiring manual user migrations).
   - **Git Tags**: Releases must be marked with annotated git tags (e.g. `git tag -a v0.0.1 -m "Release v0.0.1"`).

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
