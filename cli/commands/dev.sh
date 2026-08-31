#!/usr/bin/env bash
# ==============================================================================
# DEV — AI/Pi ecosystem management (pi CLI + extensiones recomendadas)
# ==============================================================================

DEV_TOOL_PKG="@earendil-works/pi-coding-agent"
DEV_TOOL_LABEL="pi"
DEV_TOOL_DESC="Pi coding agent (CLI base + agente autónomo de terminal)"

RECOMMENDED_EXTENSIONS=(
    "gentle-pi:Harness de desarrollo controlado (SDD/OpenSpec), skills y reviews:pi install gentle-pi"
    "gentle-engram:Memoria semántica y episódica persistente entre sesiones (SQLite):pi install gentle-engram"
    "pi-subagents:Orquestación y delegación de subagentes en paralelo/secuencia:pi install pi-subagents"
    "pi-antigravity:Integración con DeepMind Antigravity, CodeGraph y reasoning:pi install pi-antigravity"
    "pi-web-access:Búsqueda web multi-proveedor, scraping y verificación de fuentes:pi install pi-web-access"
    "@narumitw/pi-plan-mode:Modo interactivo de planificación paso a paso (/plan):pi install @narumitw/pi-plan-mode"
)

cmd_dev() {
    local subcmd="$1"
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    source "$dotfiles_dir/cli/lib/ui.sh"
    source "$dotfiles_dir/cli/lib/brew.sh"

    gum_ensure

    case "$subcmd" in
        install|"")
            _dev_install "$dotfiles_dir"
            ;;
        update)
            _dev_update
            ;;
        status)
            _dev_status
            ;;
        *)
            _dev_help
            ;;
    esac
}

# ------------------------------------------------------------------------------
# _dev_install — install pi coding agent CLI and show recommended extensions
# ------------------------------------------------------------------------------
_dev_install() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Instalación del Agente Base"
    ui_divider
    echo ""

    if ! npm_ensure; then
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible."
        gum style --foreground "$COLOR_DIM" "     Instalá Node primero:  mise use -g node@lts"
        return 1
    fi

    gum style --foreground "$COLOR_DIM" "  $DEV_TOOL_DESC"

    if npm_pkg_installed "$DEV_TOOL_PKG"; then
        local ver
        ver="$(npm_pkg_version "$DEV_TOOL_PKG")"
        gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s ya instalado (%s)" "$DEV_TOOL_LABEL" "$ver")"
    else
        gum spin --spinner dot --title "    Instalando $DEV_TOOL_PKG..." -- npm install -g "$DEV_TOOL_PKG"
        local ver
        ver="$(npm_pkg_version "$DEV_TOOL_PKG")"
        gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s instalado (%s)" "$DEV_TOOL_LABEL" "$ver")"
    fi
    echo ""

    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Agente Pi instalado correctamente."
    echo ""
    gum style --foreground "$COLOR_SEC" --bold "  💡 Extensiones Recomendadas para Pi:"
    gum style --foreground "$COLOR_DIM" "     Instalalas en cualquier momento con el comando de Pi indicado:"
    echo ""

    for ext in "${RECOMMENDED_EXTENSIONS[@]}"; do
        local name desc cmd
        name=$(echo "$ext" | cut -d: -f1)
        desc=$(echo "$ext" | cut -d: -f2)
        cmd=$(echo "$ext" | cut -d: -f3)

        gum style --foreground "$COLOR_HEAD" --bold "    • $name"
        gum style --foreground "$COLOR_DIM"        "      $desc"
        gum style --foreground "$COLOR_WARN"       "      → $cmd"
        echo ""
    done

    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_update — update pi coding agent to latest
# ------------------------------------------------------------------------------
_dev_update() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Actualizando Agente Pi"
    ui_divider
    echo ""

    if ! npm_ensure; then
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible."
        return 1
    fi

    if npm_pkg_installed "$DEV_TOOL_PKG"; then
        local current latest
        current="$(npm_pkg_version "$DEV_TOOL_PKG")"
        latest="$(npm_latest_version "$DEV_TOOL_PKG")"

        if [ "$current" = "$latest" ]; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s ya en latest (%s)" "$DEV_TOOL_LABEL" "$current")"
        else
            gum spin --spinner dot --title "    Actualizando $DEV_TOOL_LABEL $current → $latest..." -- npm install -g "$DEV_TOOL_PKG"
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s %s → %s" "$DEV_TOOL_LABEL" "$current" "$latest")"
        fi
    else
        gum style --foreground "$COLOR_DIM" "$(printf "    —   %-18s no instalado  →  omc dev install" "$DEV_TOOL_LABEL")"
    fi

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Actualización de Pi completada."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_status — show installed pi version and recommended extensions status
# ------------------------------------------------------------------------------
_dev_status() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Estado del Ecosistema"
    ui_divider
    echo ""

    if ! command -v npm >/dev/null 2>&1; then
        gum style --foreground "$COLOR_WARN" "  ⚠️  npm no disponible. Node no instalado."
        echo ""
        return
    fi

    # Estado de Pi CLI
    gum style --foreground "$COLOR_SEC" --bold "  Agente Base (npm global):"
    if npm_pkg_installed "$DEV_TOOL_PKG"; then
        local current latest
        current="$(npm_pkg_version "$DEV_TOOL_PKG")"
        latest="$(npm_latest_version "$DEV_TOOL_PKG")"

        if [ "$current" = "$latest" ]; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-18s %s  (latest)" "$DEV_TOOL_LABEL" "$current")"
        else
            gum style --foreground "$COLOR_WARN" "$(printf "    ⚠️   %-18s %s  →  %s disponible" "$DEV_TOOL_LABEL" "$current" "$latest")"
        fi
        gum style --foreground "$COLOR_DIM" "         $DEV_TOOL_DESC"
    else
        gum style --foreground "$COLOR_ERR" "$(printf "    ❌  %-18s NO INSTALADO" "$DEV_TOOL_LABEL")"
        gum style --foreground "$COLOR_DIM" "         → omc dev install"
    fi
    echo ""

    # Estado de Extensiones de Pi
    gum style --foreground "$COLOR_SEC" --bold "  Extensiones Recomendadas para Pi:"
    local pi_list_output=""
    if command -v pi >/dev/null 2>&1; then
        pi_list_output=$(pi list 2>/dev/null)
    fi

    for ext in "${RECOMMENDED_EXTENSIONS[@]}"; do
        local name desc cmd
        name=$(echo "$ext" | cut -d: -f1)
        desc=$(echo "$ext" | cut -d: -f2)
        cmd=$(echo "$ext" | cut -d: -f3)

        if echo "$pi_list_output" | grep -q "$name"; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-24s (instalada en pi)" "$name")"
        else
            gum style --foreground "$COLOR_DIM"  "$(printf "    ○   %-24s no instalada" "$name")"
            gum style --foreground "$COLOR_WARN" "        → $cmd"
        fi
        gum style --foreground "$COLOR_MUTED" "        $desc"
        echo ""
    done

    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_help — usage reference for omc dev
# ------------------------------------------------------------------------------
_dev_help() {
    ui_header
    gum style --foreground "$COLOR_SEC" --bold "  omc dev — Gestión del Agente Pi"
    echo ""
    gum style --foreground "$COLOR_DIM" "  Comandos disponibles:"
    gum style --foreground "$COLOR_HEAD" "    omc dev            " --foreground "$COLOR_TEXT" "Instalar pi (CLI base)"
    gum style --foreground "$COLOR_HEAD" "    omc dev install    " --foreground "$COLOR_TEXT" "Ídem instalación"
    gum style --foreground "$COLOR_HEAD" "    omc dev update     " --foreground "$COLOR_TEXT" "Actualizar pi a latest"
    gum style --foreground "$COLOR_HEAD" "    omc dev status     " --foreground "$COLOR_TEXT" "Ver estado de pi y extensiones"
    echo ""
}
