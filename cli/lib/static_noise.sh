#!/usr/bin/env bash
# Static Noise — published adapter update helpers

static_noise_update_ghostty() {
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local theme_file="$config_home/ghostty/themes/static-noise"
    local release_url="https://github.com/hcastillaq/static-noise.ghostty/releases/latest/download/static-noise"
    local temp_file

    if ! command -v curl >/dev/null 2>&1; then
        echo "[WARN] curl no está disponible; no se pudo actualizar static-noise.ghostty."
        return 1
    fi

    temp_file="$(mktemp "${TMPDIR:-/tmp}/static-noise-ghostty.XXXXXX")" || return 1

    if ! curl -fsSL -o "$temp_file" "$release_url"; then
        rm -f "$temp_file"
        echo "[WARN] No se pudo descargar la última release de static-noise.ghostty."
        return 1
    fi

    if [ ! -s "$temp_file" ] || \
       ! grep -q '^background = ' "$temp_file" || \
       ! grep -q '^foreground = ' "$temp_file" || \
       ! grep -q '^palette = 0=' "$temp_file" || \
       ! grep -q '^palette = 15=' "$temp_file"; then
        rm -f "$temp_file"
        echo "[WARN] La release descargada de static-noise.ghostty no contiene un tema válido."
        return 1
    fi

    chmod 0644 "$temp_file"

    if ! deploy_file "$temp_file" "$theme_file" copy; then
        rm -f "$temp_file"
        return 1
    fi

    rm -f "$temp_file"
    return 0
}

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
