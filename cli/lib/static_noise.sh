#!/usr/bin/env bash
# Static Noise — Neovim adapter update helper

static_noise_update_neovim() {
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local nvim_config="$config_home/nvim/lua/plugins/colorscheme.lua"

    [ -f "$nvim_config" ] || return 0

    if ! command -v nvim >/dev/null 2>&1; then
        echo "[WARN] Neovim no está instalado; no se pudo actualizar static-noise.nvim."
        return 0
    fi

    # The plugin spec selects the latest stable SemVer release. lazy.nvim keeps
    # the exact resolved revision in lazy-lock.json for reproducible installs.
    if ! nvim --headless '+Lazy! update static-noise.nvim' +qa >/dev/null 2>&1; then
        echo "[WARN] No se pudo actualizar static-noise.nvim mediante lazy.nvim."
        return 1
    fi

    return 0
}
