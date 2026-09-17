#!/usr/bin/env bash
# ==============================================================================
# UI — Static Noise visual styling and Gum TUI primitives for omc CLI
# ==============================================================================

# Static Noise color constants
export COLOR_HEAD="#72EAD5"  # Cyan (Foco / Cabecera)
export COLOR_SEC="#C2A7FF"   # Purple (Estructura secundaria)
export COLOR_OK="#A3D98B"    # Green (Éxito)
export COLOR_WARN="#EDD071"  # Yellow (Advertencia)
export COLOR_ERR="#EF7785"   # Red (Error)
export COLOR_DIM="#343A4A"   # Border (Separadores y contenido sutil)
export COLOR_TEXT="#E6E2D6"  # Text (Texto principal)
export COLOR_MUTED="#9299AE" # Muted (Comentarios y notas)

ui_header() {
    if command -v gum >/dev/null 2>&1; then
        echo ""
        gum style \
            --border rounded \
            --border-foreground "$COLOR_HEAD" \
            --padding "0 2" \
            --bold \
            --foreground "$COLOR_HEAD" \
            "OhMyConfig CLI"
    else
        echo ""
        echo "OhMyConfig CLI"
    fi
}

ui_divider() {
    if command -v gum >/dev/null 2>&1; then
        printf '%s\n' "------------------------------------------------------------------------" | gum style --foreground "$COLOR_DIM"
    else
        echo "------------------------------------------------------------------------"
    fi
}

ui_title() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_SEC" --bold "  $text"
    else
        echo "  $text"
    fi
}

ui_success() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_OK" "    [OK] $text"
    else
        echo "    [OK] $text"
    fi
}

ui_warn() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_WARN" "    [!] $text"
    else
        echo "    [!] $text"
    fi
}

ui_error() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_ERR" "    [ERROR] $text"
    else
        echo "    [ERROR] $text"
    fi
}

ui_dim() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_DIM" "    $text"
    else
        echo "    $text"
    fi
}
