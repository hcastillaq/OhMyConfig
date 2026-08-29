# ==============================================================================
# UI — gum wrappers for consistent TUI output across omc commands
# ==============================================================================

# Colors aligned with Tokyonight Night palette
set -g UI_CYAN    "#50f5ff"
set -g UI_PURPLE  "#c099ff"
set -g UI_GREEN   "#9ece6a"
set -g UI_RED     "#f7768e"
set -g UI_YELLOW  "#e0af68"
set -g UI_DIM     "#7a88cf"
set -g UI_WHITE   "#e0e6fc"

# ------------------------------------------------------------------------------
# ui_header — print the branded omc header
# ------------------------------------------------------------------------------
function ui_header
    gum style \
        --foreground "$UI_CYAN" --bold \
        --border-foreground "$UI_DIM" \
        --border normal \
        --padding "0 2" \
        "⚡ OhMyConfig CLI"
    echo ""
end

# ------------------------------------------------------------------------------
# ui_section — print a section title
# Usage: ui_section "MÓDULO CORE"
# ------------------------------------------------------------------------------
function ui_section --argument-names title
    gum style --foreground "$UI_PURPLE" --bold "  $title"
end

# ------------------------------------------------------------------------------
# ui_success — print a success line
# Usage: ui_success "fish 3.7.1"
# ------------------------------------------------------------------------------
function ui_success --argument-names msg
    gum style --foreground "$UI_GREEN" "  ✅  $msg"
end

# ------------------------------------------------------------------------------
# ui_error — print an error/missing line
# Usage: ui_error "lazydocker NO INSTALADO"
# ------------------------------------------------------------------------------
function ui_error --argument-names msg
    gum style --foreground "$UI_RED" "  ❌  $msg"
end

# ------------------------------------------------------------------------------
# ui_warn — print a warning line
# Usage: ui_warn "gum not found, installing..."
# ------------------------------------------------------------------------------
function ui_warn --argument-names msg
    gum style --foreground "$UI_YELLOW" "  ⚠️   $msg"
end

# ------------------------------------------------------------------------------
# ui_info — print a dim informational line
# Usage: ui_info "→  omc install (seleccioná DevOps)"
# ------------------------------------------------------------------------------
function ui_info --argument-names msg
    gum style --foreground "$UI_DIM" "       $msg"
end

# ------------------------------------------------------------------------------
# ui_dim — print a separator or dim line
# ------------------------------------------------------------------------------
function ui_dim --argument-names msg
    gum style --foreground "$UI_DIM" "$msg"
end

# ------------------------------------------------------------------------------
# ui_spin — run a command with a spinner and label
# Usage: ui_spin "Instalando fish..." brew install fish
# ------------------------------------------------------------------------------
function ui_spin --argument-names label
    set -l cmd $argv[2..]
    gum spin --spinner dot \
        --title "$label" \
        --show-output \
        -- $cmd
end

# ------------------------------------------------------------------------------
# ui_confirm — ask a yes/no question, returns 0 for yes
# Usage: ui_confirm "¿Continuar?" && do_thing
# ------------------------------------------------------------------------------
function ui_confirm --argument-names prompt
    gum confirm --prompt.foreground "$UI_CYAN" "$prompt"
end

# ------------------------------------------------------------------------------
# ui_choose_mode — present two options and return chosen index (0 or 1)
# Usage: set mode (ui_choose_mode)
# ------------------------------------------------------------------------------
function ui_choose_mode
    gum choose \
        --cursor.foreground "$UI_CYAN" \
        --selected.foreground "$UI_WHITE" \
        "Symlinks (recomendado — cambios en repo se reflejan al instante)" \
        "Copia con respaldo"
end

# ------------------------------------------------------------------------------
# ui_choose_modules — multi-select module picker
# Returns space-separated list of selected module names
# Usage: set selected (ui_choose_modules)
# ------------------------------------------------------------------------------
function ui_choose_modules
    source (dirname (status filename))/catalog.fish

    set -l choices
    for mod in $omc_modules
        set -l label_var  "omc_module_{$mod}_label"
        set -l desc_var   "omc_module_{$mod}_desc"
        set -l label      $$label_var
        set -l desc       $$desc_var
        set -a choices (printf "%-12s %s" "$label" "$desc")
    end

    gum choose \
        --no-limit \
        --cursor.foreground "$UI_CYAN" \
        --selected.foreground "$UI_WHITE" \
        --header "Seleccioná los módulos a instalar (x = marcar/desmarcar, a = todos, Enter = confirmar):" \
        --header.foreground "$UI_DIM" \
        $choices
end

# ------------------------------------------------------------------------------
# ui_divider — print a horizontal rule
# ------------------------------------------------------------------------------
function ui_divider
    gum style --foreground "$UI_DIM" \
        "────────────────────────────────────────────────────────────────────────"
end
