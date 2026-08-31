#!/usr/bin/env bash
# ==============================================================================
# BREW — Homebrew, Gum and npm detection and verification helpers
# ==============================================================================

# Ensure Homebrew environment is loaded in PATH
brew_ensure_env() {
    if ! command -v brew >/dev/null 2>&1; then
        if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

# Ensure Homebrew is installed, or install it
brew_ensure() {
    brew_ensure_env
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi

    echo "⚡ Homebrew no encontrado. Instalando Homebrew oficial..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew_ensure_env

    if command -v brew >/dev/null 2>&1; then
        return 0
    else
        echo "❌ No se pudo instalar Homebrew." >&2
        return 1
    fi
}

# Ensure gum is available for TUI
gum_ensure() {
    if command -v gum >/dev/null 2>&1; then
        return 0
    fi

    brew_ensure
    echo "⚡ Instalando gum para la interfaz TUI..."
    brew install gum >/dev/null 2>&1
    return 0
}

# Check if a brew formula or cask is installed
brew_pkg_installed() {
    local itype="$1"
    local pkg="$2"

    brew_ensure_env
    if [ "$itype" = "cask" ]; then
        brew list --cask "$pkg" >/dev/null 2>&1
    else
        brew list --formula "$pkg" >/dev/null 2>&1
    fi
}

# Get installed version of a brew formula or cask
brew_pkg_version() {
    local pkg="$1"
    brew_ensure_env
    local ver
    ver=$(brew list --versions "$pkg" 2>/dev/null | head -1 | awk '{print $2}')
    if [ -z "$ver" ]; then
        brew list --cask --versions "$pkg" 2>/dev/null | head -1 | awk '{print $2}'
    else
        echo "$ver"
    fi
}

# Ensure npm is available
npm_ensure() {
    if command -v npm >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Check if a global npm package is installed
npm_pkg_installed() {
    local pkg="$1"
    npm_ensure || return 1
    npm list -g --depth=0 "$pkg" 2>/dev/null | grep -q "$pkg@"
}

# Get installed version of a global npm package
npm_pkg_version() {
    local pkg="$1"
    npm_ensure || return 1
    npm list -g --depth=0 "$pkg" 2>/dev/null | grep -o "$pkg@[^ ]*" | head -1 | sed "s|^$pkg@||"
}

# Get latest published version of an npm package
npm_latest_version() {
    local pkg="$1"
    npm_ensure || return 1
    npm view "$pkg" version 2>/dev/null
}
