# ==============================================================================
# DEV — AI/Pi ecosystem management (pi + gentle-pi + gentle-engram)
# ==============================================================================

set -g DEV_TOOLS \
    "@earendil-works/pi-coding-agent:pi:Pi coding agent (CLI + agente)" \
    "gentle-pi:gentle-pi:Skills, SDD, reviews y orchestrator" \
    "gentle-engram:gentle-engram:Memoria persistente entre sesiones"

function cmd_dev
    set -l subcmd $argv[1]
    set -l dotfiles_dir (cd (dirname (status filename))/../.. && pwd)

    source $dotfiles_dir/cli/lib/ui.fish
    source $dotfiles_dir/cli/lib/brew.fish

    gum_ensure

    switch $subcmd
        case install ""
            _dev_install $dotfiles_dir
        case update
            _dev_update
        case status
            _dev_status
        case '*'
            _dev_help
    end
end

# ------------------------------------------------------------------------------
# _dev_install — install all three AI/Pi tools
# ------------------------------------------------------------------------------
function _dev_install --argument-names dotfiles_dir
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  AI / Pi — Instalación del Ecosistema"
    ui_divider
    echo ""

    if not npm_ensure
        gum style --foreground "#f7768e" \
            "  ❌ npm no disponible."
        gum style --foreground "#7a88cf" \
            "     Instalá Node primero:  mise use -g node@lts"
        return 1
    end

    for entry in $DEV_TOOLS
        set -l parts   (string split ":" $entry)
        set -l pkg     $parts[1]
        set -l label   $parts[2]
        set -l desc    $parts[3]

        gum style --foreground "#7a88cf" "  $desc"

        if npm_pkg_installed $pkg
            set -l ver (npm_pkg_version $pkg)
            gum style --foreground "#9ece6a" \
                (printf "    ✅  %-18s ya instalado (%s)" $label $ver)
        else
            gum spin --spinner dot \
                --title "    Instalando $pkg..." \
                -- npm install -g $pkg
            set -l ver (npm_pkg_version $pkg)
            gum style --foreground "#9ece6a" \
                (printf "    ✅  %-18s instalado (%s)" $label $ver)
        end
        echo ""
    end

    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Ecosistema AI/Pi listo."
    echo ""
    gum style --foreground "#7a88cf" "  Próximos pasos:"
    gum style --foreground "#50f5ff" "    pi --help               → Ver comandos del agente"
    gum style --foreground "#50f5ff" "    pi install gentle-pi    → Activar skills y SDD en pi"
    gum style --foreground "#50f5ff" "    pi install gentle-engram → Activar memoria persistente"
    ui_divider
    echo ""
end

# ------------------------------------------------------------------------------
# _dev_update — update all three AI/Pi tools to latest
# ------------------------------------------------------------------------------
function _dev_update
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  AI / Pi — Actualizando Ecosistema"
    ui_divider
    echo ""

    if not npm_ensure
        gum style --foreground "#f7768e" "  ❌ npm no disponible."
        return 1
    end

    for entry in $DEV_TOOLS
        set -l parts   (string split ":" $entry)
        set -l pkg     $parts[1]
        set -l label   $parts[2]

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
                (printf "    —   %-18s no instalado  →  omc dev install" $label)
        end
    end

    echo ""
    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Actualización completada."
    ui_divider
    echo ""
end

# ------------------------------------------------------------------------------
# _dev_status — show installed versions and latest available
# ------------------------------------------------------------------------------
function _dev_status
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  AI / Pi — Estado del Ecosistema"
    ui_divider
    echo ""

    if not command -q npm
        gum style --foreground "#e0af68" "  ⚠️  npm no disponible. Node no instalado."
        echo ""
        return
    end

    for entry in $DEV_TOOLS
        set -l parts   (string split ":" $entry)
        set -l pkg     $parts[1]
        set -l label   $parts[2]
        set -l desc    $parts[3]

        if npm_pkg_installed $pkg
            set -l current (npm_pkg_version $pkg)
            set -l latest  (npm_latest_version $pkg)

            if test "$current" = "$latest"
                gum style --foreground "#9ece6a" \
                    (printf "    ✅  %-18s %s  (latest)" $label $current)
            else
                gum style --foreground "#e0af68" \
                    (printf "    ⚠️   %-18s %s  →  %s disponible" $label $current $latest)
            end
            gum style --foreground "#7a88cf" "         $desc"
        else
            gum style --foreground "#f7768e" \
                (printf "    ❌  %-18s NO INSTALADO" $label)
            gum style --foreground "#7a88cf" "         → omc dev install"
        end
        echo ""
    end

    ui_divider
    echo ""
end

# ------------------------------------------------------------------------------
# _dev_help — usage reference for omc dev
# ------------------------------------------------------------------------------
function _dev_help
    ui_header
    gum style --foreground "#c099ff" --bold "  omc dev — Gestión del Ecosistema AI/Pi"
    echo ""
    gum style --foreground "#7a88cf" "  Comandos disponibles:"
    gum style --foreground "#50f5ff" "    omc dev            " --foreground "#e0e6fc" "Instalar pi + gentle-pi + gentle-engram"
    gum style --foreground "#50f5ff" "    omc dev install    " --foreground "#e0e6fc" "Ídem instalación"
    gum style --foreground "#50f5ff" "    omc dev update     " --foreground "#e0e6fc" "Actualizar los tres a latest"
    gum style --foreground "#50f5ff" "    omc dev status     " --foreground "#e0e6fc" "Ver versiones instaladas vs latest"
    echo ""
end
