#!/usr/bin/env bash
# ==============================================================================
# DEV — AI/Pi base management (optional packages via native pi commands)
# ==============================================================================

DEV_TOOL_PKG="@earendil-works/pi-coding-agent"
DEV_TOOL_LABEL="pi"
DEV_TOOL_DESC="Pi coding agent (CLI base + agente autónomo de terminal)"

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
# _dev_install — install Pi CLI base only
# ------------------------------------------------------------------------------
_dev_install() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Instalador Base"
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

    # 2. Desplegar configuraciones locales de Pi (.pi/themes, .pi/extensions)
    gum style --foreground "$COLOR_HEAD" --bold "  2. Configuraciones de Pi:"
    gum style --foreground "$COLOR_DIM" "     Instalando tema y extensiones (header) globales..."
    source "$dotfiles_dir/cli/lib/catalog.sh"
    source "$dotfiles_dir/cli/lib/deploy.sh"
    deploy_module "ai" "symlink" "$dotfiles_dir"
    echo ""

    gum style --foreground "$COLOR_DIM" "  Extensiones opcionales: instalalas sólo cuando las necesites con pi install <paquete>."
    if command -v pi >/dev/null 2>&1; then
        gum style --foreground "$COLOR_HEAD" --bold "  Paquetes Pi actuales:"
        pi list || true
    fi

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Pi base instalado y listo para usar."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_update — update Pi CLI base
# ------------------------------------------------------------------------------
_dev_update() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Actualizando CLI Base"
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

    # 2. Actualizar configuraciones locales de Pi
    gum style --foreground "$COLOR_HEAD" --bold "  2. Configuraciones de Pi:"
    gum style --foreground "$COLOR_DIM" "     Sincronizando tema y extensiones globales..."
    source "$dotfiles_dir/cli/lib/catalog.sh"
    source "$dotfiles_dir/cli/lib/deploy.sh"
    deploy_module "ai" "symlink" "$dotfiles_dir"
    echo ""

    gum style --foreground "$COLOR_DIM" "  Las extensiones opcionales se administran con los comandos nativos de Pi."
    gum style --foreground "$COLOR_DIM" "  Usá: pi list, pi install <paquete>, pi remove <paquete>"

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Actualización de Pi base completada."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_status — show Pi CLI version and current Pi packages
# ------------------------------------------------------------------------------
_dev_status() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / Pi — Estado del Entorno"
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

    # Paquetes Pi instalados
    gum style --foreground "$COLOR_SEC" --bold "  Paquetes Pi instalados:"
    echo ""
    if command -v pi >/dev/null 2>&1; then
        pi list || true
    else
        gum style --foreground "$COLOR_DIM" "    — pi no está disponible en PATH"
    fi

    echo ""
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_doctor — basic local health check
# ------------------------------------------------------------------------------
_dev_doctor() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🩺 AI / Pi — Diagnóstico de Salud"
    ui_divider
    echo ""

    if command -v node >/dev/null 2>&1; then
        gum style --foreground "$COLOR_OK" "  ✅ node: $(node --version)"
    else
        gum style --foreground "$COLOR_ERR" "  ❌ node no disponible"
    fi

    if command -v npm >/dev/null 2>&1; then
        gum style --foreground "$COLOR_OK" "  ✅ npm:  $(npm --version)"
    else
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible"
    fi

    if command -v pi >/dev/null 2>&1; then
        gum style --foreground "$COLOR_OK" "  ✅ pi:   $(pi --version 2>/dev/null || echo disponible)"
        echo ""
        gum style --foreground "$COLOR_HEAD" --bold "  Paquetes Pi actuales:"
        pi list || true
    else
        gum style --foreground "$COLOR_ERR" "  ❌ pi no disponible en PATH"
        gum style --foreground "$COLOR_DIM" "     → ./omc dev install"
    fi

    echo ""
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_remove — show native Pi package removal guidance
# ------------------------------------------------------------------------------
_dev_remove() {
    ui_header
    gum style --foreground "$COLOR_SEC" --bold "  omc dev remove — Paquetes opcionales de Pi"
    echo ""
    gum style --foreground "$COLOR_DIM" "  Usá los comandos nativos de Pi para desinstalar extensiones:"
    gum style --foreground "$COLOR_HEAD" "    pi list"
    gum style --foreground "$COLOR_HEAD" "    pi remove <paquete>"
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
    gum style --foreground "$COLOR_HEAD" "    omc dev            " --foreground "$COLOR_TEXT" "Instalar sólo el CLI base de Pi"
    gum style --foreground "$COLOR_HEAD" "    omc dev install    " --foreground "$COLOR_TEXT" "Instalar sólo el CLI base de Pi"
    gum style --foreground "$COLOR_HEAD" "    omc dev update     " --foreground "$COLOR_TEXT" "Actualizar sólo el CLI base de Pi"
    gum style --foreground "$COLOR_HEAD" "    omc dev status     " --foreground "$COLOR_TEXT" "Ver versión de Pi y paquetes con pi list"
    gum style --foreground "$COLOR_HEAD" "    omc dev doctor     " --foreground "$COLOR_TEXT" "Diagnóstico local de Node/npm/Pi"
    gum style --foreground "$COLOR_HEAD" "    omc dev remove     " --foreground "$COLOR_TEXT" "Ayuda para remover extensiones con pi remove"
    echo ""
    gum style --foreground "$COLOR_DIM" "  Extensiones opcionales: pi install <paquete>"
}
