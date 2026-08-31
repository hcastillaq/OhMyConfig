# ==============================================================================
# DEV — AI/Pi ecosystem management (pi CLI + extensiones recomendadas)
# ==============================================================================

set -g DEV_TOOL_PKG   "@earendil-works/pi-coding-agent"
set -g DEV_TOOL_LABEL "pi"
set -g DEV_TOOL_DESC  "Pi coding agent (CLI base + agente autónomo de terminal)"

set -g RECOMMENDED_EXTENSIONS \
    "gentle-pi:Harness de desarrollo controlado (SDD/OpenSpec), skills y reviews:pi install gentle-pi" \
    "gentle-engram:Memoria semántica y episódica persistente entre sesiones (SQLite):pi install gentle-engram" \
    "pi-subagents:Orquestación y delegación de subagentes en paralelo/secuencia:pi install pi-subagents" \
    "pi-antigravity:Integración con DeepMind Antigravity, CodeGraph y reasoning:pi install pi-antigravity" \
    "pi-web-access:Búsqueda web multi-proveedor, scraping y verificación de fuentes:pi install pi-web-access" \
    "@narumitw/pi-plan-mode:Modo interactivo de planificación paso a paso (/plan):pi install @narumitw/pi-plan-mode"

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
# _dev_install — install pi coding agent CLI and show recommended extensions
# ------------------------------------------------------------------------------
function _dev_install --argument-names dotfiles_dir
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  🤖 AI / Pi — Instalación del Agente Base"
    ui_divider
    echo ""

    if not npm_ensure
        gum style --foreground "#f7768e" \
            "  ❌ npm no disponible."
        gum style --foreground "#7a88cf" \
            "     Instalá Node primero:  mise use -g node@lts"
        return 1
    end

    gum style --foreground "#7a88cf" "  $DEV_TOOL_DESC"

    if npm_pkg_installed $DEV_TOOL_PKG
        set -l ver (npm_pkg_version $DEV_TOOL_PKG)
        gum style --foreground "#9ece6a" \
            (printf "    ✅  %-18s ya instalado (%s)" $DEV_TOOL_LABEL $ver)
    else
        gum spin --spinner dot \
            --title "    Instalando $DEV_TOOL_PKG..." \
            -- npm install -g $DEV_TOOL_PKG
        set -l ver (npm_pkg_version $DEV_TOOL_PKG)
        gum style --foreground "#9ece6a" \
            (printf "    ✅  %-18s instalado (%s)" $DEV_TOOL_LABEL $ver)
    end
    echo ""

    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Agente Pi instalado correctamente."
    echo ""
    gum style --foreground "#c099ff" --bold "  💡 Extensiones Recomendadas para Pi:"
    gum style --foreground "#7a88cf" "     Instalalas en cualquier momento con el comando de Pi indicado:"
    echo ""

    for ext in $RECOMMENDED_EXTENSIONS
        set -l parts (string split ":" $ext)
        set -l name  $parts[1]
        set -l desc  $parts[2]
        set -l cmd   $parts[3]

        gum style --foreground "#50f5ff" --bold "    • $name"
        gum style --foreground "#7a88cf"        "      $desc"
        gum style --foreground "#e0af68"        "      → $cmd"
        echo ""
    end

    ui_divider
    echo ""
end

# ------------------------------------------------------------------------------
# _dev_update — update pi coding agent to latest
# ------------------------------------------------------------------------------
function _dev_update
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  🤖 AI / Pi — Actualizando Agente Pi"
    ui_divider
    echo ""

    if not npm_ensure
        gum style --foreground "#f7768e" "  ❌ npm no disponible."
        return 1
    end

    if npm_pkg_installed $DEV_TOOL_PKG
        set -l current (npm_pkg_version $DEV_TOOL_PKG)
        set -l latest  (npm_latest_version $DEV_TOOL_PKG)

        if test "$current" = "$latest"
            gum style --foreground "#9ece6a" \
                (printf "    ✅  %-18s ya en latest (%s)" $DEV_TOOL_LABEL $current)
        else
            gum spin --spinner dot \
                --title "    Actualizando $DEV_TOOL_LABEL $current → $latest..." \
                -- npm install -g $DEV_TOOL_PKG
            gum style --foreground "#9ece6a" \
                (printf "    ✅  %-18s %s → %s" $DEV_TOOL_LABEL $current $latest)
        end
    else
        gum style --foreground "#7a88cf" \
            (printf "    —   %-18s no instalado  →  omc dev install" $DEV_TOOL_LABEL)
    end

    echo ""
    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Actualización de Pi completada."
    ui_divider
    echo ""
end

# ------------------------------------------------------------------------------
# _dev_status — show installed pi version and recommended extensions status
# ------------------------------------------------------------------------------
function _dev_status
    ui_header
    ui_divider
    gum style --foreground "#c099ff" --bold "  🤖 AI / Pi — Estado del Ecosistema"
    ui_divider
    echo ""

    if not command -q npm
        gum style --foreground "#e0af68" "  ⚠️  npm no disponible. Node no instalado."
        echo ""
        return
    end

    # Estado de Pi CLI
    gum style --foreground "#c099ff" --bold "  Agente Base (npm global):"
    if npm_pkg_installed $DEV_TOOL_PKG
        set -l current (npm_pkg_version $DEV_TOOL_PKG)
        set -l latest  (npm_latest_version $DEV_TOOL_PKG)

        if test "$current" = "$latest"
            gum style --foreground "#9ece6a" \
                (printf "    ✅  %-18s %s  (latest)" $DEV_TOOL_LABEL $current)
        else
            gum style --foreground "#e0af68" \
                (printf "    ⚠️   %-18s %s  →  %s disponible" $DEV_TOOL_LABEL $current $latest)
        end
        gum style --foreground "#7a88cf" "         $DEV_TOOL_DESC"
    else
        gum style --foreground "#f7768e" \
            (printf "    ❌  %-18s NO INSTALADO" $DEV_TOOL_LABEL)
        gum style --foreground "#7a88cf" "         → omc dev install"
    end
    echo ""

    # Estado de Extensiones de Pi
    gum style --foreground "#c099ff" --bold "  Extensiones Recomendadas para Pi:"
    set -l pi_list_output ""
    if command -q pi
        set pi_list_output (pi list 2>/dev/null)
    end

    for ext in $RECOMMENDED_EXTENSIONS
        set -l parts (string split ":" $ext)
        set -l name  $parts[1]
        set -l desc  $parts[2]
        set -l cmd   $parts[3]

        set -l is_installed 0
        if string match -q "*$name*" "$pi_list_output"
            set is_installed 1
        end

        if test $is_installed -eq 1
            gum style --foreground "#9ece6a" (printf "    ✅  %-24s (instalada en pi)" $name)
        else
            gum style --foreground "#7a88cf" (printf "    ○   %-24s no instalada" $name)
            gum style --foreground "#e0af68" (printf "        → %s" $cmd)
        end
        gum style --foreground "#565f89" "        $desc"
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
    gum style --foreground "#c099ff" --bold "  omc dev — Gestión del Agente Pi"
    echo ""
    gum style --foreground "#7a88cf" "  Comandos disponibles:"
    gum style --foreground "#50f5ff" "    omc dev            " --foreground "#e0e6fc" "Instalar pi (CLI base)"
    gum style --foreground "#50f5ff" "    omc dev install    " --foreground "#e0e6fc" "Ídem instalación"
    gum style --foreground "#50f5ff" "    omc dev update     " --foreground "#e0e6fc" "Actualizar pi a latest"
    gum style --foreground "#50f5ff" "    omc dev status     " --foreground "#e0e6fc" "Ver estado de pi y extensiones"
    echo ""
end
