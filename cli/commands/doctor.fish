# ==============================================================================
# DOCTOR — Environment diagnostic for omc CLI
# ==============================================================================

function cmd_doctor
    set -l dotfiles_dir (cd (dirname (status filename))/../.. && pwd)

    source $dotfiles_dir/cli/lib/catalog.fish
    source $dotfiles_dir/cli/lib/ui.fish
    source $dotfiles_dir/cli/lib/brew.fish

    gum_ensure
    ui_header

    set -l profile_path "$dotfiles_dir/.omc-profile"
    set -l total_ok 0
    set -l total_missing 0

    ui_divider
    gum style --foreground "#c099ff" --bold "  ⚡ OhMyConfig — Estado del Entorno"
    ui_divider
    echo ""

    for mod in $omc_modules
        gum style --foreground "#c099ff" --bold "  "(omc_get $mod label)

        set -l tools (omc_get_list $mod tools)
        for tool_entry in $tools
            set -l parts (string split ":" $tool_entry)
            set -l type  $parts[1]
            set -l pkg   $parts[2]
            set -l bin   $parts[3]

            set -l display $pkg
            if test -n "$bin"; set display $bin; end

            switch $type
                case brew cask
                    set -l itype formula
                    if test $type = cask; set itype cask; end

                    if brew_pkg_installed $itype $pkg
                        set -l ver (brew_pkg_version $pkg)
                        gum style --foreground "#9ece6a" \
                            (printf "    ✅  %-22s %s" $display $ver)
                        set total_ok (math $total_ok + 1)
                    else
                        gum style --foreground "#f7768e" \
                            (printf "    ❌  %-22s NO INSTALADO" $display)
                        gum style --foreground "#7a88cf" \
                            "         → omc install"
                        set total_missing (math $total_missing + 1)
                    end

                case npm
                    if npm_pkg_installed $pkg
                        set -l ver (npm_pkg_version $pkg)
                        gum style --foreground "#9ece6a" \
                            (printf "    ✅  %-22s %s" $display $ver)
                        set total_ok (math $total_ok + 1)
                    else
                        gum style --foreground "#f7768e" \
                            (printf "    ❌  %-22s NO INSTALADO" $display)
                        gum style --foreground "#7a88cf" \
                            "         → omc install (seleccioná AI/Pi)"
                        set total_missing (math $total_missing + 1)
                    end
            end
        end
        echo ""
    end

    # ── Infrastructure ────────────────────────────────────────────────────────
    gum style --foreground "#c099ff" --bold "  Infraestructura"

    if command -q brew
        gum style --foreground "#9ece6a" \
            (printf "    ✅  %-22s %s" "brew" (brew --version | head -1 | awk '{print $2}'))
    else
        gum style --foreground "#f7768e" (printf "    ❌  %-22s NO INSTALADO" "brew")
    end

    if command -q gum
        gum style --foreground "#9ece6a" \
            (printf "    ✅  %-22s %s" "gum" (gum --version 2>/dev/null | string replace "gum version " ""))
    else
        gum style --foreground "#e0af68" \
            (printf "    ⚠️   %-22s NO INSTALADO  → brew install gum" "gum")
    end

    if command -q node
        gum style --foreground "#9ece6a" \
            (printf "    ✅  %-22s %s (via mise)" "node" (node --version | string replace "v" ""))
    else
        gum style --foreground "#e0af68" \
            (printf "    ⚠️   %-22s NO INSTALADO  → mise use -g node@lts" "node")
    end

    echo ""
    ui_divider

    if test -f $profile_path
        set -l pmode (grep "^deploy_mode=" $profile_path | string replace "deploy_mode=" "")
        set -l pmods (grep "^modules="     $profile_path | string replace "modules=" "")
        gum style --foreground "#7a88cf" "  Perfil: modo=$pmode  módulos=[$pmods]"
    else
        gum style --foreground "#7a88cf" "  Sin perfil guardado. Ejecutá: ./omc install"
    end

    set -l summary (printf "%d instaladas · %d faltantes" $total_ok $total_missing)
    if test $total_missing -eq 0
        gum style --foreground "#9ece6a" --bold "  ✅ $summary"
    else
        gum style --foreground "#e0af68" --bold "  ⚠️  $summary"
    end

    ui_divider
    echo ""
end
