#!/usr/bin/env bash
# ==============================================================================
# UI — Tokyonight visual styling and Gum TUI primitives for omc CLI
# ==============================================================================

# Tokyonight color constants
export COLOR_HEAD="#50f5ff"
export COLOR_SEC="#c099ff"
export COLOR_OK="#9ece6a"
export COLOR_WARN="#e0af68"
export COLOR_ERR="#f7768e"
export COLOR_DIM="#7a88cf"
export COLOR_TEXT="#e0e6fc"
export COLOR_MUTED="#565f89"

ui_header() {
    if command -v gum >/dev/null 2>&1; then
        echo ""
        gum style \
            --border rounded \
            --border-foreground "$COLOR_HEAD" \
            --padding "0 2" \
            --bold \
            --foreground "$COLOR_HEAD" \
            "⚡ OhMyConfig CLI"
    else
        echo ""
        echo "⚡ OhMyConfig CLI"
    fi
}

ui_divider() {
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_DIM" "────────────────────────────────────────────────────────────────────────"
    else
        echo "────────────────────────────────────────────────────────────────────────"
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
        gum style --foreground "$COLOR_OK" "    ✅ $text"
    else
        echo "    ✅ $text"
    fi
}

ui_warn() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_WARN" "    ⚠️  $text"
    else
        echo "    ⚠️  $text"
    fi
}

ui_error() {
    local text="$1"
    if command -v gum >/dev/null 2>&1; then
        gum style --foreground "$COLOR_ERR" "    ❌ $text"
    else
        echo "    ❌ $text"
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
