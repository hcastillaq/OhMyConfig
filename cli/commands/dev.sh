#!/usr/bin/env bash
# ==============================================================================
# DEV — AI/Pi ecosystem management (pi CLI + LazyPi extension suite)
# ==============================================================================

DEV_TOOL_PKG="@earendil-works/pi-coding-agent"
DEV_TOOL_LABEL="pi"
DEV_TOOL_DESC="Pi coding agent (CLI base + agente autónomo de terminal)"

RECOMMENDED_EXTENSIONS=(
    "pi-subagents:Orquestación y delegación de subagentes en paralelo/secuencia:npm:pi-subagents"
    "pi-ask-user:Interacción modal con opciones estructuradas y confirmación:npm:pi-ask-user"
    "@narumitw/pi-plan-mode:Modo interactivo de planificación paso a paso (/plan):npm:@narumitw/pi-plan-mode"
    "pi-antigravity:Integración con DeepMind Antigravity, CodeGraph y reasoning:npm:pi-antigravity"
    "pi-memory-md:Memoria persistente offline en Markdown y control de versiones Git:git:github.com/VandeeFeng/pi-memory-md"
    "pi-web-access:Búsqueda web multi-proveedor, scraping y verificación de fuentes:npm:pi-web-access"
    "@plannotator/pi-extension:Visualización interactiva y anotación de planes de desarrollo:npm:@plannotator/pi-extension"
    "pi-interactive-shell:Ejecución interactiva de CLIs y TUIs en segundo plano:npm:pi-interactive-shell"
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
# _dev_install — install pi coding agent CLI and all LazyPi extensions
# ------------------------------------------------------------------------------
_dev_install() {
    ui_header
    ui_divider
    gum style --foreground "$COLOR_SEC" --bold "  🤖 AI / LazyPi — Instalación Completa del Ecosistema"
    ui_divider
    echo ""

    if ! npm_ensure; then
        gum style --foreground "$COLOR_ERR" "  ❌ npm no disponible."
        gum style --foreground "$COLOR_DIM" "     Instalá Node primero:  mise use -g node@lts"
        return 1
    fi

    # 1. Instalar Pi CLI base
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

    # 2. Instalar suite LazyPi de extensiones
    gum style --foreground "$COLOR_HEAD" --bold "  2. Suite de Extensiones LazyPi:"
    local pi_list_output=""
    if command -v pi >/dev/null 2>&1; then
        pi_list_output=$(pi list 2>/dev/null)
    fi

    for ext in "${RECOMMENDED_EXTENSIONS[@]}"; do
        local name desc target
        name=$(echo "$ext" | cut -d: -f1)
        desc=$(echo "$ext" | cut -d: -f2)
        target=$(echo "$ext" | cut -d: -f3-)

        if echo "$pi_list_output" | grep -q "$name"; then
            gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-26s (ya instalada)" "$name")"
        else
            gum spin --spinner dot --title "     Instalando $name..." -- pi install "$target" >/dev/null 2>&1
            gum style --foreground "$COLOR_OK" "$(printf "     ✅  %-26s (instalada)" "$name")"
        fi
        gum style --foreground "$COLOR_MUTED" "         $desc"
    done

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Ecosistema LazyPi instalado y listo para usar."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_update — update pi coding agent and all extensions to latest
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

    # 2. Actualizar extensiones de Pi
    gum style --foreground "$COLOR_HEAD" --bold "  2. Extensiones de Pi:"
    if command -v pi >/dev/null 2>&1; then
        gum spin --spinner dot --title "     Actualizando extensiones instaladas..." -- pi update >/dev/null 2>&1
        gum style --foreground "$COLOR_OK" "     ✅  Extensiones de Pi actualizadas a la última versión."
    else
        gum style --foreground "$COLOR_DIM" "     —   pi no disponible."
    fi

    echo ""
    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Actualización de LazyPi completada."
    ui_divider
    echo ""
}

# ------------------------------------------------------------------------------
# _dev_status — show installed pi version and recommended extensions status
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

    # Estado de Extensiones de Pi
    gum style --foreground "$COLOR_SEC" --bold "  Extensiones de LazyPi:"
    local pi_list_output=""
    if command -v pi >/dev/null 2>&1; then
        pi_list_output=$(pi list 2>/dev/null)
    fi

    for ext in "${RECOMMENDED_EXTENSIONS[@]}"; do
        local name desc target
        name=$(echo "$ext" | cut -d: -f1)
        desc=$(echo "$ext" | cut -d: -f2)
        target=$(echo "$ext" | cut -d: -f3-)

        if echo "$pi_list_output" | grep -q "$name"; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-26s (instalada en pi)" "$name")"
        else
            gum style --foreground "$COLOR_DIM"  "$(printf "    ○   %-26s no instalada" "$name")"
            gum style --foreground "$COLOR_WARN" "        → pi install $target"
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
    gum style --foreground "$COLOR_SEC" --bold "  omc dev — Gestión del Agente Pi & LazyPi Suite"
    echo ""
    gum style --foreground "$COLOR_DIM" "  Comandos disponibles:"
    gum style --foreground "$COLOR_HEAD" "    omc dev            " --foreground "$COLOR_TEXT" "Instalar pi y la suite completa LazyPi"
    gum style --foreground "$COLOR_HEAD" "    omc dev install    " --foreground "$COLOR_TEXT" "Ídem instalación completa"
    gum style --foreground "$COLOR_HEAD" "    omc dev update     " --foreground "$COLOR_TEXT" "Actualizar pi y todas sus extensiones a latest"
    gum style --foreground "$COLOR_HEAD" "    omc dev status     " --foreground "$COLOR_TEXT" "Ver estado de pi y extensiones instaladas"
    echo ""
}
