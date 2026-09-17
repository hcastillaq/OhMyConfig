#!/usr/bin/env bash
# STATIC NOISE — Remote generated theme artifacts consumed by OhMyConfig

STATIC_NOISE_RAW_BASE="https://raw.githubusercontent.com/hcastillaq/static-noise/main/dist"
STATIC_NOISE_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyconfig/static-noise"

static_noise_prepare() {
    local artifacts=(
        "fish/static-noise-colors.fish"
        "starship/static-noise-palette.toml"
        "starship/starship.toml"
        "bottom/static-noise-colors.toml"
        "lazygit/static-noise-theme.yml"
        "delta/static-noise.gitconfig"
        "pi/static-noise-theme.json"
        "ghostty/static-noise"
        "zellij/static-noise.kdl"
        "zellij/layouts/default.kdl"
    )
    local artifact tmp

    command -v curl >/dev/null 2>&1 || {
        echo "[ERROR] curl es necesario para descargar Static Noise desde GitHub."
        return 1
    }

    for artifact in "${artifacts[@]}"; do
        mkdir -p "$STATIC_NOISE_CACHE/$(dirname "$artifact")"
        tmp="$STATIC_NOISE_CACHE/$artifact.tmp"
        if ! curl -fsSL "$STATIC_NOISE_RAW_BASE/$artifact" -o "$tmp"; then
            rm -f "$tmp"
            echo "[ERROR] No se pudo descargar Static Noise: $artifact"
            return 1
        fi
        mv "$tmp" "$STATIC_NOISE_CACHE/$artifact"
    done
}

static_noise_update_neovim() {
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local nvim_config="$config_home/nvim/lua/plugins/colorscheme.lua"

    [ -f "$nvim_config" ] || return 0

    if ! command -v nvim >/dev/null 2>&1; then
        echo "[WARN] Neovim no está instalado; no se pudo actualizar static-noise.nvim."
        return 0
    fi

    # lazy.nvim persists plugin revisions in lazy-lock.json. Updating this plugin
    # explicitly keeps Static Noise on the latest commit from its main branch.
    # Its output is suppressed so the omc TUI never leaks raw ANSI control codes.
    if ! nvim --headless '+Lazy! update static-noise.nvim' +qa >/dev/null 2>&1; then
        echo "[WARN] No se pudo actualizar static-noise.nvim mediante lazy.nvim."
        return 1
    fi

    return 0
}
