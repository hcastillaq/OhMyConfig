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
        echo "❌ curl es necesario para descargar Static Noise desde GitHub."
        return 1
    }

    for artifact in "${artifacts[@]}"; do
        mkdir -p "$STATIC_NOISE_CACHE/$(dirname "$artifact")"
        tmp="$STATIC_NOISE_CACHE/$artifact.tmp"
        if ! curl -fsSL "$STATIC_NOISE_RAW_BASE/$artifact" -o "$tmp"; then
            rm -f "$tmp"
            echo "❌ No se pudo descargar Static Noise: $artifact"
            return 1
        fi
        mv "$tmp" "$STATIC_NOISE_CACHE/$artifact"
    done
}
