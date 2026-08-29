# ==============================================================================
# INSTALL — Interactive module installer (main omc command)
# ==============================================================================

function cmd_install
    set -l args $argv
    set -l flag_all false
    set -l flag_link false

    for arg in $args
        switch $arg
            case --all -a
                set flag_all true
            case --link -l
                set flag_link true
        end
    end

    set -l dotfiles_dir (cd (dirname (status filename))/../.. && pwd)
    set -l config_dir $HOME/.config
    set -l timestamp (date +%Y%m%d_%H%M%S)

    source $dotfiles_dir/cli/lib/catalog.fish
    source $dotfiles_dir/cli/lib/ui.fish
    source $dotfiles_dir/cli/lib/brew.fish
    source $dotfiles_dir/cli/lib/deploy.fish

    ui_header
    gum_ensure
    brew_ensure

    # ── Deploy mode ───────────────────────────────────────────────────────────
    set -l deploy_mode copy
    if test $flag_link = true
        set deploy_mode symlink
    else if test $flag_all = false
        ui_section "MODO DE DESPLIEGUE"
        echo ""
        set -l choice (ui_choose_mode)
        if string match -q "Symlinks*" $choice
            set deploy_mode symlink
        end
        echo ""
    end

    # ── Module selection ──────────────────────────────────────────────────────
    set -l selected_modules

    if test $flag_all = true
        set selected_modules $omc_modules
    else
        ui_section "MÓDULOS A INSTALAR"
        echo ""

        set -l options
        for mod in $omc_modules
            set -a options (printf "%-12s %s" (omc_get $mod label) (omc_get $mod desc))
        end

        set -l chosen (gum choose \
            --no-limit \
            --cursor.foreground "#50f5ff" \
            --selected.foreground "#e0e6fc" \
            --header "  Seleccioná módulos (Space = marcar, Enter = confirmar):" \
            --header.foreground "#7a88cf" \
            $options)

        if test -z "$chosen"
            gum style --foreground "#f7768e" "  Ningún módulo seleccionado. Saliendo."
            return 1
        end

        for mod in $omc_modules
            set -l label (omc_get $mod label)
            for ch in $chosen
                if string match -q "$label *" $ch
                    set -a selected_modules $mod
                    break
                end
            end
        end
    end

    echo ""
    ui_divider
    ui_section "INSTALANDO HERRAMIENTAS"
    ui_divider
    echo ""

    # ── Install tools per selected module ────────────────────────────────────
    for mod in $selected_modules
        gum style --foreground "#c099ff" --bold "  ▸ "(omc_get $mod label)

        set -l tools (omc_get_list $mod tools)
        for tool_entry in $tools
            set -l parts (string split ":" $tool_entry)
            set -l type  $parts[1]
            set -l pkg   $parts[2]

            switch $type
                case brew
                    if brew_pkg_installed formula $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg (ya instalado)"
                    else
                        gum spin --spinner dot --title "    Instalando $pkg..." -- brew install $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg instalado"
                    end

                case cask
                    if brew_pkg_installed cask $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg (ya instalado)"
                    else
                        gum spin --spinner dot --title "    Instalando $pkg (cask)..." -- brew install --cask $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg instalado"
                    end

                case npm
                    if not npm_ensure
                        gum style --foreground "#f7768e" "    ❌ npm no disponible — instalá Node: mise use -g node@lts"
                        continue
                    end
                    if npm_pkg_installed $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg (ya instalado)"
                    else
                        gum spin --spinner dot --title "    Instalando $pkg (npm)..." -- npm install -g $pkg
                        gum style --foreground "#9ece6a" "    ✅ $pkg instalado"
                    end
            end
        end
        echo ""
    end

    # ── Deploy configs ────────────────────────────────────────────────────────
    ui_divider
    ui_section "DESPLEGANDO CONFIGURACIONES"
    ui_divider
    echo ""

    for mod in $selected_modules
        set -l configs (omc_get_list $mod configs)
        if test -z "$configs"
            continue
        end

        gum style --foreground "#c099ff" --bold "  ▸ "(omc_get $mod label)
        for rel_path in $configs
            set -l src  "$dotfiles_dir/config/$rel_path"
            set -l dest "$config_dir/$rel_path"
            if test -e $src
                deploy_config $src $dest $deploy_mode $timestamp
            end
        end
        echo ""
    end

    # ── Git delta wiring ──────────────────────────────────────────────────────
    if contains editor $selected_modules
        ui_section "GIT DELTA"
        deploy_git_delta $config_dir
        echo ""
    end

    # ── Save profile ──────────────────────────────────────────────────────────
    _save_profile $dotfiles_dir $deploy_mode $selected_modules

    # ── Done ──────────────────────────────────────────────────────────────────
    ui_divider
    gum style --foreground "#9ece6a" --bold "  ✅ Instalación completada."
    ui_divider
    echo ""

    if contains core $selected_modules
        gum style --foreground "#7a88cf" "  Pasos opcionales:"
        gum style --foreground "#7a88cf" '  1. Establecer Fish como shell por defecto:'
        gum style --foreground "#50f5ff" '     echo "$(which fish)" | sudo tee -a /etc/shells && chsh -s "$(which fish)"'
        gum style --foreground "#7a88cf" "  2. Abrí Ghostty para disfrutar el entorno completo."
        echo ""
    end
end

# ------------------------------------------------------------------------------
# _save_profile — persist selected modules and deploy mode to .omc-profile
# ------------------------------------------------------------------------------
function _save_profile --argument-names dotfiles_dir mode
    set -l mods $argv[3..]
    set -l profile_path "$dotfiles_dir/.omc-profile"
    echo "# .omc-profile — generado por omc install" > $profile_path
    echo "# Commitealo para replicar tu setup en otra máquina." >> $profile_path
    echo "deploy_mode=$mode" >> $profile_path
    echo "modules="(string join " " $mods) >> $profile_path
end
