#!/usr/bin/env bash
# ==============================================================================
# INSTALL — Interactive and automated module installer for omc CLI (Bash 3.2+)
# ==============================================================================

cmd_install() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

    source "$dotfiles_dir/cli/lib/ui.sh"
    source "$dotfiles_dir/cli/lib/brew.sh"
    source "$dotfiles_dir/cli/lib/catalog.sh"
    source "$dotfiles_dir/cli/lib/deploy.sh"

    brew_ensure
    gum_ensure

    local flag_all=0
    local flag_link=0

    for arg in "$@"; do
        case "$arg" in
            --all)       flag_all=1 ;;
            --link|-l)   flag_link=1 ;;
        esac
    done

    ui_header
    ui_divider
    ui_title "Instalador de Entorno de Desarrollo"
    ui_divider
    echo ""

    # ── Step 1: Deployment Mode ───────────────────────────────────────────────
    local deploy_mode="symlink"

    if [ "$flag_link" -eq 1 ]; then
        deploy_mode="symlink"
        ui_dim "Modo forzado por flag: Enlaces Simbólicos (symlinks)"
        echo ""
    elif [ "$flag_all" -eq 1 ]; then
        deploy_mode="symlink"
        ui_dim "Modo por defecto: Enlaces Simbólicos (symlinks)"
        echo ""
    else
        echo "  ¿Cómo querés desplegar las configuraciones en ~/.config/?"
        echo ""
        local choice
        choice=$(gum choose \
            --cursor="❯ " \
            --cursor.foreground="$COLOR_HEAD" \
            --selected.foreground="$COLOR_HEAD" \
            "Symlinks (recomendado — cambios en repo se reflejan al instante)" \
            "Copia con respaldo (archivos copiados con backup timestamped)")

        if [ -z "$choice" ]; then
            echo ""
            ui_warn "Instalación cancelada."
            return 1
        fi

        if echo "$choice" | grep -q "^Symlinks"; then
            deploy_mode="symlink"
        else
            deploy_mode="copy"
        fi
        echo ""
    fi

    # ── Step 2: Module Selection ──────────────────────────────────────────────
    local selected_modules=()

    if [ "$flag_all" -eq 1 ]; then
        selected_modules=("${OMC_MODULES[@]}")
        ui_dim "Instalando todos los módulos (--all)"
        echo ""
    else
        echo "  Seleccioná los módulos a instalar (espacio = marcar, enter = confirmar):"
        echo ""

        local options=()
        for mod in "${OMC_MODULES[@]}"; do
            local label
            local desc
            label="$(get_module_label "$mod")"
            desc="$(get_module_desc "$mod")"
            options+=("$(printf "%-12s │ %s" "$label" "$desc")")
        done

        local chosen
        chosen=$(printf "%s\n" "${options[@]}" | gum choose \
            --no-limit \
            --cursor="❯ " \
            --cursor.foreground="$COLOR_HEAD" \
            --selected.foreground="$COLOR_OK" \
            --height=12)

        if [ -z "$chosen" ]; then
            echo ""
            ui_warn "No se seleccionó ningún módulo. Cancelando."
            return 1
        fi

        for mod in "${OMC_MODULES[@]}"; do
            local label
            label="$(get_module_label "$mod")"
            if echo "$chosen" | grep -q "^$label "; then
                selected_modules+=("$mod")
            fi
        done
        echo ""
    fi

    # ── Step 3: Install Packages & Deploy Configs ──────────────────────────────
    for mod in "${selected_modules[@]}"; do
        local label
        label="$(get_module_label "$mod")"
        ui_title "Módulo: $label"

        # 3.1 Packages
        local tools
        tools="$(get_module_tools "$mod")"

        if [ -n "$tools" ]; then
            while IFS= read -r tool_entry; do
                [ -z "$tool_entry" ] && continue
                local type pkg bin
                type=$(echo "$tool_entry" | cut -d: -f1)
                pkg=$(echo "$tool_entry" | cut -d: -f2)
                bin=$(echo "$tool_entry" | cut -d: -f3)
                [ -z "$bin" ] && bin="$pkg"

                case "$type" in
                    brew)
                        if brew_pkg_installed formula "$pkg"; then
                            local ver
                            ver="$(brew_pkg_version "$pkg")"
                            ui_success "$bin ya instalado ($ver)"
                        else
                            gum spin --spinner dot --title "    Instalando $pkg..." -- brew install "$pkg"
                            local ver
                            ver="$(brew_pkg_version "$pkg")"
                            ui_success "$bin instalado ($ver)"
                        fi
                        ;;
                    cask)
                        if brew_pkg_installed cask "$pkg"; then
                            local ver
                            ver="$(brew_pkg_version "$pkg")"
                            ui_success "$bin ya instalado ($ver)"
                        else
                            gum spin --spinner dot --title "    Instalando $pkg (cask)..." -- brew install --cask "$pkg"
                            local ver
                            ver="$(brew_pkg_version "$pkg")"
                            ui_success "$bin instalado ($ver)"
                        fi
                        ;;
                    npm)
                        if npm_pkg_installed "$pkg"; then
                            local ver
                            ver="$(npm_pkg_version "$pkg")"
                            ui_success "$bin ya instalado ($ver)"
                        else
                            if npm_ensure; then
                                gum spin --spinner dot --title "    Instalando $pkg (npm)..." -- npm install -g "$pkg"
                                local ver
                                ver="$(npm_pkg_version "$pkg")"
                                ui_success "$bin instalado ($ver)"
                            else
                                ui_warn "npm no disponible. Instalá Node primero (mise use -g node@lts)"
                            fi
                        fi
                        ;;
                esac
            done <<< "$tools"
        fi

        # 3.2 Configurations
        deploy_module "$mod" "$deploy_mode" "$dotfiles_dir"
        echo ""
    done

    # ── Step 4: Post-Install Actions ──────────────────────────────────────────
    # Neovim LazyVim setup
    local has_editor=0
    for m in "${selected_modules[@]}"; do
        [ "$m" = "editor" ] && has_editor=1
    done

    if [ "$has_editor" -eq 1 ]; then
        local lazyvim_starter="$HOME/.config/nvim/lazyvim.json"
        if [ ! -f "$lazyvim_starter" ]; then
            mkdir -p "$HOME/.config/nvim"
            echo '{"extras":[]}' > "$lazyvim_starter"
        fi
    fi

    # ── Step 5: Save Profile ──────────────────────────────────────────────────
    local profile_file="$dotfiles_dir/.omc-profile"
    local mods_str="${selected_modules[*]}"
    cat > "$profile_file" << EOF
# .omc-profile — generado por omc install
deploy_mode=$deploy_mode
modules=$mods_str
EOF

    ui_divider
    gum style --foreground "$COLOR_OK" --bold "  ✅ Instalación completada con éxito."
    echo ""
    ui_dim "Perfil guardado en: $profile_file"
    echo ""
    ui_dim "Próximos pasos recomendados:"
    echo "    1. Establecer Fish como shell predeterminada:"
    echo "       echo \"\$(which fish)\" | sudo tee -a /etc/shells && chsh -s \"\$(which fish)\""
    echo "    2. Instalar runtimes con mise: mise use -g node@lts"
    echo "    3. Iniciar el agente Pi: pi"
    ui_divider
    echo ""
}
