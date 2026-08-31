#!/usr/bin/env bash
# ==============================================================================
# DOCTOR — Environment diagnostic for omc CLI (Bash 3.2+)
# ==============================================================================

cmd_doctor() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    source "$dotfiles_dir/cli/lib/ui.sh"
    source "$dotfiles_dir/cli/lib/brew.sh"
    source "$dotfiles_dir/cli/lib/catalog.sh"

    brew_ensure_env
    gum_ensure

    ui_header
    ui_divider
    ui_title "⚡ OhMyConfig — Estado del Entorno"
    ui_divider
    echo ""

    local total_ok=0
    local total_missing=0

    for mod in "${OMC_MODULES[@]}"; do
        local label
        label="$(get_module_label "$mod")"
        ui_title "$label"

        local tools
        tools="$(get_module_tools "$mod")"

        if [ -n "$tools" ]; then
            while IFS= read -r tool_entry; do
                [ -z "$tool_entry" ] && continue
                local type pkg bin display
                type=$(echo "$tool_entry" | cut -d: -f1)
                pkg=$(echo "$tool_entry" | cut -d: -f2)
                bin=$(echo "$tool_entry" | cut -d: -f3)
                display="$pkg"
                [ -n "$bin" ] && display="$bin"

                case "$type" in
                    brew|cask)
                        local itype="formula"
                        [ "$type" = "cask" ] && itype="cask"

                        if brew_pkg_installed "$itype" "$pkg"; then
                            local ver
                            ver="$(brew_pkg_version "$pkg")"
                            if command -v gum >/dev/null 2>&1; then
                                gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-22s %s" "$display" "$ver")"
                            else
                                printf "    ✅  %-22s %s\n" "$display" "$ver"
                            fi
                            total_ok=$((total_ok + 1))
                        else
                            if command -v gum >/dev/null 2>&1; then
                                gum style --foreground "$COLOR_ERR" "$(printf "    ❌  %-22s NO INSTALADO" "$display")"
                                gum style --foreground "$COLOR_DIM" "         → omc install"
                            else
                                printf "    ❌  %-22s NO INSTALADO\n" "$display"
                                echo "         → omc install"
                            fi
                            total_missing=$((total_missing + 1))
                        fi
                        ;;
                    npm)
                        if npm_pkg_installed "$pkg"; then
                            local ver
                            ver="$(npm_pkg_version "$pkg")"
                            if command -v gum >/dev/null 2>&1; then
                                gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-22s %s" "$display" "$ver")"
                            else
                                printf "    ✅  %-22s %s\n" "$display" "$ver"
                            fi
                            total_ok=$((total_ok + 1))
                        else
                            if command -v gum >/dev/null 2>&1; then
                                gum style --foreground "$COLOR_ERR" "$(printf "    ❌  %-22s NO INSTALADO" "$display")"
                                gum style --foreground "$COLOR_DIM" "         → omc dev install"
                            else
                                printf "    ❌  %-22s NO INSTALADO\n" "$display"
                                echo "         → omc dev install"
                            fi
                            total_missing=$((total_missing + 1))
                        fi
                        ;;
                esac
            done <<< "$tools"
        fi
        echo ""
    done

    # ── Infrastructure ────────────────────────────────────────────────────────
    ui_title "Infraestructura"

    if command -v brew >/dev/null 2>&1; then
        local brew_ver
        brew_ver=$(brew --version | head -1 | awk '{print $2}')
        if command -v gum >/dev/null 2>&1; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-22s %s" "brew" "$brew_ver")"
        else
            printf "    ✅  %-22s %s\n" "brew" "$brew_ver"
        fi
    else
        ui_error "brew NO INSTALADO"
    fi

    if command -v gum >/dev/null 2>&1; then
        local gum_ver
        gum_ver=$(gum --version 2>/dev/null | sed 's/gum version //')
        gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-22s %s" "gum" "$gum_ver")"
    else
        ui_warn "gum NO INSTALADO → brew install gum"
    fi

    if command -v node >/dev/null 2>&1; then
        local node_ver
        node_ver=$(node --version | sed 's/^v//')
        if command -v gum >/dev/null 2>&1; then
            gum style --foreground "$COLOR_OK" "$(printf "    ✅  %-22s %s (Node runtime)" "node" "$node_ver")"
        else
            printf "    ✅  %-22s %s (Node runtime)\n" "node" "$node_ver"
        fi
    else
        ui_warn "node NO INSTALADO → mise use -g node@lts"
    fi

    echo ""
    ui_divider

    local profile_file="$dotfiles_dir/.omc-profile"
    if [ -f "$profile_file" ]; then
        local pmode pmods
        pmode=$(grep "^deploy_mode=" "$profile_file" | cut -d= -f2)
        pmods=$(grep "^modules=" "$profile_file" | cut -d= -f2)
        ui_dim "Perfil: modo=$pmode  módulos=[$pmods]"
    else
        ui_dim "Sin perfil guardado. Ejecutá: ./omc install"
    fi

    local summary
    summary=$(printf "%d instaladas · %d faltantes" "$total_ok" "$total_missing")
    if [ "$total_missing" -eq 0 ]; then
        gum style --foreground "$COLOR_OK" --bold "  ✅ $summary"
    else
        gum style --foreground "$COLOR_WARN" --bold "  ⚠️  $summary"
    fi

    ui_divider
    echo ""
}
