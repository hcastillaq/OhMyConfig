#!/usr/bin/env bash
# ==============================================================================
# UPDATE — Update all installed tools (brew + npm globals) in Bash 3.2+
# ==============================================================================

cmd_update() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    source "$dotfiles_dir/cli/lib/ui.sh"
    source "$dotfiles_dir/cli/lib/brew.sh"

    brew_ensure
    gum_ensure

    ui_header
    ui_divider
    ui_title "⚡ OhMyConfig — Actualizando entorno"
    ui_divider
    echo ""

    # ── Homebrew ──────────────────────────────────────────────────────────────
    ui_title "Homebrew"
    gum spin --spinner dot --title "  Actualizando repositorio de Homebrew..." -- brew update
    ui_success "Homebrew actualizado"

    gum spin --spinner dot --title "  Actualizando fórmulas instaladas..." -- brew upgrade
    ui_success "Fórmulas actualizadas"

    gum spin --spinner dot --title "  Actualizando casks instalados..." -- brew upgrade --cask
    ui_success "Casks actualizados"
    echo ""

    # ── npm globals (AI/Pi module) ────────────────────────────────────────────
    if ! npm_ensure; then
        ui_warn "npm no disponible, omitiendo módulo AI/Pi."
    else
        ui_title "AI / Pi (npm globals)"

        local pkg="@earendil-works/pi-coding-agent"
        local label="pi"

        if npm_pkg_installed "$pkg"; then
            local current latest
            current="$(npm_pkg_version "$pkg")"
            latest="$(npm_latest_version "$pkg")"

            if [ "$current" = "$latest" ]; then
                gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s ya en latest (%s)" "$label" "$current")"
            else
                gum spin --spinner dot --title "    Actualizando $label $current → $latest..." -- npm install -g "$pkg"
                gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s %s → %s" "$label" "$current" "$latest")"
            fi
        else
            ui_dim "$(printf "    —   %-18s no instalado, omitiendo (omc dev install)" "$label")"
        fi
        echo ""
    fi

    # ── Homebrew cleanup ──────────────────────────────────────────────────────
    gum spin --spinner dot --title "  Limpiando caché de Homebrew..." -- brew cleanup
    ui_dim "🧹 Caché limpiado"
    echo ""

    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Actualización completada."
    ui_divider
    echo ""
}
