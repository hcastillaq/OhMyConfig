# AGENTS.md — OhMyConfig Context & Architecture Guide

This document provides system architecture, design invariants, configuration structure, and operational guidelines for AI coding agents working on the **OhMyConfig** repository.

---

## 1. Overview & Purpose

**OhMyConfig** is an automated, modular, and idempotent dotfiles and developer environment configuration for macOS. It replaces legacy Unix tools with high-performance modern CLI/TUI utilities (primarily built with Rust and Go), styled consistently with the **Tokyonight** palette and Nerd Font icon telemetry.

---

## 2. Repository Structure

```
OhMyConfig/
├── Brewfile                     # Homebrew bundle (CLI tools, GUI apps, Nerd Fonts)
├── install.sh                   # Idempotent installer (copy/backup or symlink mode)
├── README.md                    # User-facing manual and command cheatsheet
├── AGENTS.md                    # AI Agent architectural context and guidelines
├── .gitignore                   # Ignored files (.atl/, .DS_Store)
└── config/                      # Source configuration directory (mirrors ~/.config/)
    ├── fish/
    │   └── config.fish          # Shell aliases, wrappers, PATH, FZF/Atuin inits
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
```

---

## 3. Core Subsystems & Components

### 3.1 Installation & Deployment Engine (`install.sh`)
- **Idempotency & Safety**: Compares source and destination with `cmp -s`. Creates timestamped backups (`${dest}.bak_YYYYMMDD_HHMMSS`) before overwriting modified files.
- **Symlink Mode (`--link` / `-l`)**: Replaces configuration copies with direct symbolic links pointing to this repository.
- **Homebrew Automation**: Automatically verifies and installs Homebrew if missing, then runs `brew bundle --file=Brewfile`.
- **Deployment Invariant**: Whenever a new configuration file or asset is added under `config/`, `install.sh` **must** be updated to deploy it to `${CONFIG_DIR}`.

### 3.2 Terminal & Shell Layer
- **Ghostty**: Modern GPU-accelerated terminal emulator configured with JetBrains Mono Nerd Font, font ligatures, window blur, and Tokyonight styling.
- **Fish Shell (`config/fish/config.fish`)**:
  - Environment variables: `STARSHIP_CONFIG`, `BAT_THEME`, `XDG_CONFIG_HOME`.
  - FZF Integration: Complete Tokyonight Night color mapping with `fd` file/directory providers.
  - Atuin Integration: Database-driven shell history initialization.
  - Interactive wrappers: Yazi wrapper (`y`) that changes directory upon exit with `q`, and `cds` for `.DS_Store` sanitization.
  - Aliases & Abbreviations: Fast shortcuts for Git (`g`, `gs`, `gc`, `gl`, `glog`, `glp`, `of`), Modern CLI (`ls` -> `eza`, `cat` -> `bat`, `du` -> `dust`, `zj` -> `zellij`, `jqp`), and Zoxide directory traversal (`..`, `...`, `-`).
  - Dynamic Inits: `mise`, `zoxide`, `fzf`, `atuin`, `starship`.

### 3.3 Prompt & Version Management
- **Starship (`config/starship/starship.toml`)**: Clean, reactive multi-segment prompt showing directory, git status, active language runtimes, and kubernetes context.
- **mise**: Universal polyglot runtime manager (Node, Python, Go, Rust, Java, etc.) replacing separate tools like `nvm` and `pyenv`.

### 3.4 Terminal Multiplexer (`config/zellij/`)
- **Zellij**: Modern Rust multiplexer configured with Tokyonight palette and `default_layout "default"`.
- **Layout & Status Bar Architecture (`layouts/default.kdl` + `plugins/zjstatus.wasm`)**:
  - Unifies **Tabs**, **Mode Indicators**, and **Contextual Command Hints** into a **single 1-line bottom bar**.
  - Uses a **local WASM plugin** (`file:~/.config/zellij/plugins/zjstatus.wasm`) to eliminate network dependencies and bypass untrusted download confirmation prompts.
  - Active tabs render as high-contrast badges (`#3d59a1` deep blue + `#7aa2f7` Tokyonight blue text).
  - Mode switches (`Pane`, `Tab`, `Resize`, `Scroll`, `Session`, `Move`, `Search`) dynamically render semantic, color-coded shortcut hints.

### 3.5 TUI & Diagnostics Toolchain
- **lazygit**: Visual Git TUI integrated with `git-delta` side-by-side diffs and Tokyonight UI colors.
- **bottom (`btm`)**: Graphical system/process monitor.
- **atuin**: SQLite indexed history search with duration, exit codes, and fuzzy search.
- **yazi**: Asynchronous file manager with preview support.
- **onefetch (`of`)**: Git repo code and telemetry visualizer.
- **sd**: Modern expression-based in-place text replacement.
- **xh**, **jq**, **jqp**: HTTP API client, JSON stream transformer, and interactive TUI playground.
- **lazydocker**, **k9s**, **kubectx/kubens**: Container and Kubernetes live cluster telemetry.

---

## 4. Design Invariants & Conventions

1. **Tokyonight Palette Consistency**:
   - Primary Background: `#1a1b26` (or `#15161e` for deep dark / borders)
   - Primary Foreground: `#c0caf5`
   - Accents: Blue (`#7aa2f7`), Cyan (`#7dcfff`), Green (`#9ece6a`), Magenta/Purple (`#bb9af7`), Yellow/Orange (`#e0af68` / `#ff9e64`), Red (`#f7768e`), Dim/Comments (`#565f89` / `#737aa2`).
2. **Zero-Friction Offline Execution**: Avoid dynamic external downloads inside runtime configs; bundle or locally cache required binaries/WASM plugins within the repo.
3. **Non-Destructive Overwrites**: Configuration installers must never silently discard user files without `.bak_` backups or user consent.
4. **Platform Scope**: Tailored for macOS (Apple Silicon `/opt/homebrew` and Intel `/usr/local`), supporting fish shell syntax.
