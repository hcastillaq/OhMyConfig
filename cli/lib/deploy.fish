# ==============================================================================
# DEPLOY — Config file deployment logic (symlink and copy modes)
# Extracted from install.sh for reuse across omc commands
# ==============================================================================

# ------------------------------------------------------------------------------
# deploy_config — deploy a single config file or directory
# Usage: deploy_config <src_path> <dest_path> <symlink|copy> [timestamp]
# ------------------------------------------------------------------------------
function deploy_config --argument-names src dest mode timestamp
    set -l dest_dir (dirname $dest)

    switch $mode
        case symlink
            mkdir -p $dest_dir
            if test -L $dest
                rm -f $dest
            else if test -e $dest
                echo "  💾 Respaldo: $dest → $dest.bak_$timestamp"
                mv $dest $dest.bak_$timestamp
            end
            ln -sf $src $dest
            echo "  🔗 Enlazando: "(string replace $HOME "~" $dest)" → "(string replace $HOME "~" $src)

        case copy
            if test -d $src
                if test -L $dest
                    rm -f $dest
                end
                mkdir -p $dest
                cp -Rf $src/* $dest/
                echo "  📂 Directorio: "(string replace $HOME "~" $dest)
            else
                mkdir -p $dest_dir
                if test -L $dest
                    rm -f $dest
                else if test -f $dest
                    if not cmp -s $src $dest
                        echo "  💾 Respaldo: $dest → $dest.bak_$timestamp"
                        cp $dest $dest.bak_$timestamp
                    end
                end
                cp -f $src $dest
                echo "  📄 Copiando: "(string replace $HOME "~" $dest)
            end
    end
end

# ------------------------------------------------------------------------------
# deploy_module_configs — deploy all configs for a given module
# Usage: deploy_module_configs <module> <dotfiles_dir> <config_dir> <mode> [timestamp]
# ------------------------------------------------------------------------------
function deploy_module_configs --argument-names mod dotfiles_dir config_dir mode timestamp
    set -l configs_var "omc_module_{$mod}_configs"
    set -l configs $$configs_var

    if test -z "$configs"
        return 0
    end

    for rel_path in $configs
        set -l src "$dotfiles_dir/config/$rel_path"
        set -l dest "$config_dir/$rel_path"

        if not test -e $src
            continue
        end

        deploy_config $src $dest $mode $timestamp
    end
end

# ------------------------------------------------------------------------------
# deploy_git_delta — wire git-delta include.path safely (no user data overwrite)
# Usage: deploy_git_delta <config_dir>
# ------------------------------------------------------------------------------
function deploy_git_delta --argument-names config_dir
    set -l delta_cfg "$config_dir/git/delta.gitconfig"

    if not git config --global --get-all include.path 2>/dev/null | grep -q $delta_cfg
        git config --global --add include.path $delta_cfg
        echo "  🔗 Delta vinculado en Git: $delta_cfg"
    else
        echo "  ✅ Delta ya vinculado en Git."
    end
end
