# ==============================================================================
# UPDATE — Update all installed tools (brew + npm globals)
# ==============================================================================

function cmd_update
    set -l dotfiles_dir (cd (dirname (status filename))/../.. && pwd)

    source $dotfiles_dir/cli/lib/catalog.fish
    source $dotfiles_dir/cli/lib/ui.fish
    source $dotfiles_dir/cli/lib/brew.fish

    gum_ensure
    ui_header

    ui_divider
    gum style --foreground "#c099ff" --bold "  ⚡ OhMyConfig — Actualizando entorno"
    ui_divider
    echo ""

    # ── Homebrew ──────────────────────────────────────────────────────────────
    gum style --foreground "#c099ff" --bold "  Homebrew"
    gum spin --spinner dot --title "  Actualizando repositorio de Homebrew..." \
        -- brew update
    gum style --foreground "#9ece6a" "    ✅ Homebrew actualizado"

    gum spin --spinner dot --title "  Actualizando fórmulas instaladas..." \
        -- brew upgrade
    gum style --foreground "#9ece6a" "    ✅ Fórmulas actualizadas"

    gum spin --spinner dot --title "  Actualizando casks instalados..." \
        -- brew upgrade --cask
    gum style --foreground "#9ece6a" "    ✅ Casks actualizados"
    echo ""

    # ── npm globals (AI/Pi module) ────────────────────────────────────────────
    if not npm_ensure
        gum style --foreground "#e0af68" "  ⚠️  npm no disponible, omitiendo módulo AI/Pi."
    else
        gum style --foreground "#c099ff" --bold "  AI / Pi (npm globals)"

        set -l npm_tools \
            "@earendil-works/pi-coding-agent:pi" \
            "gentle-pi:gentle-pi" \
            "gentle-engram:gentle-engram"

        for entry in $npm_tools
            set -l parts  (string split ":" $entry)
            set -l pkg    $parts[1]
            set -l label  $parts[2]

            if npm_pkg_installed $pkg
                set -l current (npm_pkg_version $pkg)
                set -l latest  (npm_latest_version $pkg)

                if test "$current" = "$latest"
                    gum style --foreground "#9ece6a" \
                        (printf "    ✅  %-18s ya en latest (%s)" $label $current)
                else
                    gum spin --spinner dot \
                        --title "    Actualizando $label $current → $latest..." \
                        -- npm install -g $pkg
                    gum style --foreground "#9ece6a" \
                        (printf "    ✅  %-18s %s → %s" $label $current $latest)
                end
            else
                gum style --foreground "#7a88cf" \
                    (printf "    —   %-18s no instalado, omitiendo" $label)
            end
        end
        echo ""
    end

    # ── Homebrew cleanup ──────────────────────────────────────────────────────
    gum spin --spinner dot --title "  Limpiando caché de Homebrew..." \
        -- brew cleanup
    gum style --foreground "#7a88cf" "    🧹 Caché limpiado"
    echo ""

    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Actualización completada."
    ui_divider
    echo ""
end
