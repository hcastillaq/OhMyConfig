#!/usr/bin/env bash
# ==============================================================================
# DEPLOY — Safe file deployment engine (symlink or copy with backup)
# ==============================================================================

# Deploy a single file or directory safely
deploy_file() {
    local src="$1"
    local dest="$2"
    local mode="$3"

    if [ ! -e "$src" ]; then
        if command -v gum >/dev/null 2>&1; then
            gum style --foreground "$COLOR_WARN" "    ⚠️  Origen no encontrado: $src"
        else
            echo "    ⚠️  Origen no encontrado: $src"
        fi
        return 1
    fi

    # Ensure parent directory exists
    local dest_dir
    dest_dir="$(dirname "$dest")"
    mkdir -p "$dest_dir"

    if [ "$mode" = "symlink" ]; then
        # Check if already a symlink pointing to the same source
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_OK" "    🔗 $(basename "$dest") (enlace ya activo)"
            else
                echo "    🔗 $(basename "$dest") (enlace ya activo)"
            fi
            return 0
        fi

        # Backup real file/dir if exists and not already our symlink
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
            mv "$dest" "$backup"
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_WARN" "    📦 Respaldo creado: $(basename "$backup")"
            else
                echo "    📦 Respaldo creado: $(basename "$backup")"
            fi
        elif [ -L "$dest" ]; then
            rm -f "$dest"
        fi

        ln -sf "$src" "$dest"
        if command -v gum >/dev/null 2>&1; then
            gum style --foreground "$COLOR_OK" "    🔗 $(basename "$dest") → $src"
        else
            echo "    🔗 $(basename "$dest") → $src"
        fi

    elif [ "$mode" = "copy" ]; then
        if [ -d "$src" ]; then
            if [ -d "$dest" ] && [ ! -L "$dest" ]; then
                local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
                mv "$dest" "$backup"
                if command -v gum >/dev/null 2>&1; then
                    gum style --foreground "$COLOR_WARN" "    📦 Respaldo creado: $(basename "$backup")"
                else
                    echo "    📦 Respaldo creado: $(basename "$backup")"
                fi
            elif [ -L "$dest" ]; then
                rm -f "$dest"
            fi

            mkdir -p "$dest"
            cp -R "$src/"* "$dest/" 2>/dev/null || true
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_OK" "    📁 $(basename "$dest")/ (copiado)"
            else
                echo "    📁 $(basename "$dest")/ (copiado)"
            fi

        else
            # Single file
            if [ -f "$dest" ] && [ ! -L "$dest" ]; then
                if cmp -s "$src" "$dest"; then
                    if command -v gum >/dev/null 2>&1; then
                        gum style --foreground "$COLOR_OK" "    📄 $(basename "$dest") (sin cambios)"
                    else
                        echo "    📄 $(basename "$dest") (sin cambios)"
                    fi
                    return 0
                fi
                local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
                cp "$dest" "$backup"
                if command -v gum >/dev/null 2>&1; then
                    gum style --foreground "$COLOR_WARN" "    📦 Respaldo creado: $(basename "$backup")"
                else
                    echo "    📦 Respaldo creado: $(basename "$backup")"
                fi
            elif [ -L "$dest" ]; then
                rm -f "$dest"
            fi

            cp "$src" "$dest"
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_OK" "    📄 $(basename "$dest") (desplegado)"
            else
                echo "    📄 $(basename "$dest") (desplegado)"
            fi
        fi
    fi
}

# Deploy all configuration files associated with a module
deploy_module() {
    local mod="$1"
    local mode="$2"
    local dotfiles_dir="$3"
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

    local configs
    configs="$(get_module_configs "$mod")"
    [ -z "$configs" ] && return 0

    while IFS= read -r rel_path; do
        [ -z "$rel_path" ] && continue
        local src="$dotfiles_dir/config/$rel_path"
        local dest="$config_home/$rel_path"
        deploy_file "$src" "$dest" "$mode"
    done <<< "$configs"
}
