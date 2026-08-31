#!/usr/bin/env bash
# ==============================================================================
# DEV — AI/Pi ecosystem management via LazyPi (@tommy-ca/lazypi)
# ==============================================================================

DEV_TOOL_PKG="@earendil-works/pi-coding-agent"
DEV_TOOL_LABEL="pi"
DEV_TOOL_DESC="Pi coding agent (CLI base + agente autónomo de terminal)"
LAZYPI_RUNNER="@tommy-ca/lazypi"

cmd_dev() {
    local subcmd="$1"
    shift 2>/dev/null || true
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    source "$dotfiles_dir/cli/lib/ui.sh"
    source "$dotfiles_dir/cli/lib/brew.sh"

    gum_ensure

    case "$subcmd" in
        install|"")
            _dev_install "$@"
            ;;
        update)
            _dev_update
            ;;
        status)
            _dev_status
            ;;
        doctor)
            _dev_doctor
            ;;
        remove)
            _dev_remove "$@"
            ;;
        *)
            _dev_help
            ;;
    esac
}

# ------------------------------------------------------------------------------
# _dev_install — install pi CLI base and full LazyPi catalog
# ------------------------------------------------------------------------------
_dev_install() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / LazyPi — Instalador Oficial del Ecosistema"
    ui_divider
    echo ""

    if ! npm_ensure; then
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible."
        gum style --foreground "$COLOR_DIM" "     Instalá Node primero:  mise use -g node@lts"
        return 1
    fi

    # 1. Instalar o verificar Pi CLI base
    gum style --foreground "$COLOR_HEAD" --bold "  1. Agente Base (CLI):"
    gum style --foreground "$COLOR_DIM" "     $DEV_TOOL_DESC"

    if npm_pkg_installed "$DEV_TOOL_PKG"; then
        local ver
        ver="$(npm_pkg_version "$DEV_TOOL_PKG")"
        gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-20s ya instalado (%s)" "$DEV_TOOL_LABEL" "$ver")"
    else
        gum spin --spinner dot --title "     Instalando $DEV_TOOL_PKG..." -- npm install -g "$DEV_TOOL_PKG"
        local ver
        ver="$(npm_pkg_version "$DEV_TOOL_PKG")"
        gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-20s instalado (%s)" "$DEV_TOOL_LABEL" "$ver")"
    fi
    echo ""

    # 2. Ejecutar instalador LazyPi
    gum style --foreground "$COLOR_HEAD" --bold "  2. Catálogo Oficial LazyPi (Core + Optional):"
    echo ""
    npx --yes "$LAZYPI_RUNNER" "$@"

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Ecosistema LazyPi instalado y listo para usar."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_update — update pi CLI and run LazyPi updater
# ------------------------------------------------------------------------------
_dev_update() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / LazyPi — Actualizando Ecosistema"
    ui_divider
    echo ""

    if ! npm_ensure; then
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible."
        return 1
    fi

    # 1. Actualizar binario de Pi
    gum style --foreground "$COLOR_HEAD" --bold "  1. Agente Base (npm global):"
    if npm_pkg_installed "$DEV_TOOL_PKG"; then
        local current latest
        current="$(npm_pkg_version "$DEV_TOOL_PKG")"
        latest="$(npm_latest_version "$DEV_TOOL_PKG")"

        if [ "$current" = "$latest" ]; then
            gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-20s ya en latest (%s)" "$DEV_TOOL_LABEL" "$current")"
        else
            gum spin --spinner dot --title "     Actualizando $DEV_TOOL_LABEL $current → $latest..." -- npm install -g "$DEV_TOOL_PKG"
            gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-20s %s → %s" "$DEV_TOOL_LABEL" "$current" "$latest")"
        fi
    else
        gum style --foreground "$COLOR_DIM" "$(printf "     —   %-20s no instalado  →  omc dev install" "$DEV_TOOL_LABEL")"
    fi
    echo ""

    # 2. Actualizar extensiones con LazyPi
    gum style --foreground "$COLOR_HEAD" --bold "  2. Extensiones de LazyPi:"
    echo ""
    npx --yes "$LAZYPI_RUNNER" update

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Actualización de LazyPi completada."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_status — show Pi CLI version and LazyPi catalog status
# ------------------------------------------------------------------------------
_dev_status() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / LazyPi — Estado del Ecosistema"
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

    # Estado del catálogo LazyPi
    gum style --foreground "$COLOR_SEC" --bold "  Catálogo LazyPi Oficial:"
    echo ""
    npx --yes "$LAZYPI_RUNNER" status

    echo ""
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_doctor — health check via LazyPi doctor
# ------------------------------------------------------------------------------
_dev_doctor() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🩺 AI / LazyPi — Diagnóstico de Salud"
    ui_divider
    echo ""
    npx --yes "$LAZYPI_RUNNER" doctor
    echo ""
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_remove — remove packages via LazyPi picker
# ------------------------------------------------------------------------------
_dev_remove() {
    npx --yes "$LAZYPI_RUNNER" remove "$@"
}

# ------------------------------------------------------------------------------
# _dev_help — usage reference for omc dev
# ------------------------------------------------------------------------------
_dev_help() {
    ui_header
    gum style --foreground "$COLOR_SEC" --bold "  omc dev — Gestión del Agente Pi & LazyPi Suite"
    echo ""
    gum style --foreground "$COLOR_DIM" "  Comandos disponibles:"
    gum style --foreground "$COLOR_HEAD" "    omc dev            " --foreground "$COLOR_TEXT" "Instalar pi y la suite completa LazyPi"
    gum style --foreground "$COLOR_HEAD" "    omc dev install    " --foreground "$COLOR_TEXT" "Ídem instalador oficial"
    gum style --foreground "$COLOR_HEAD" "    omc dev update     " --foreground "$COLOR_TEXT" "Actualizar pi y todas las extensiones"
    gum style --foreground "$COLOR_HEAD" "    omc dev status     " --foreground "$COLOR_TEXT" "Ver estado del catálogo LazyPi"
    gum style --foreground "$COLOR_HEAD" "    omc dev doctor     " --foreground "$COLOR_TEXT" "Diagnóstico de salud del entorno"
    gum style --foreground "$COLOR_HEAD" "    omc dev remove     " --foreground "$COLOR_TEXT" "Selector interactivo para desinstalar extensiones"
    echo ""
}
