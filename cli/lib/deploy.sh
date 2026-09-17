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
            gum style --foreground "$COLOR_WARN" "    [WARN] Origen no encontrado: $src"
        else
            echo "    [WARN] Origen no encontrado: $src"
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
                gum style --foreground "$COLOR_OK" "    [LINK] $(basename "$dest") (enlace ya activo)"
            else
                echo "    [LINK] $(basename "$dest") (enlace ya activo)"
            fi
            return 0
        fi

        # Backup real file/dir if exists and not already our symlink
        if [ -e "$dest" ] && [ ! -L "$dest" ]; then
            local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
            mv "$dest" "$backup"
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_WARN" "    [BACKUP] Respaldo creado: $(basename "$backup")"
            else
                echo "    [BACKUP] Respaldo creado: $(basename "$backup")"
            fi
        elif [ -L "$dest" ]; then
            rm -f "$dest"
        fi

        ln -sf "$src" "$dest"
        if command -v gum >/dev/null 2>&1; then
            gum style --foreground "$COLOR_OK" "    [LINK] $(basename "$dest") -> $src"
        else
            echo "    [LINK] $(basename "$dest") -> $src"
        fi

    elif [ "$mode" = "copy" ]; then
        if [ -d "$src" ]; then
            if [ -d "$dest" ] && [ ! -L "$dest" ]; then
                local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
                mv "$dest" "$backup"
                if command -v gum >/dev/null 2>&1; then
                    gum style --foreground "$COLOR_WARN" "    [BACKUP] Respaldo creado: $(basename "$backup")"
                else
                    echo "    [BACKUP] Respaldo creado: $(basename "$backup")"
                fi
            elif [ -L "$dest" ]; then
                rm -f "$dest"
            fi

            mkdir -p "$dest"
            cp -R "$src/"* "$dest/" 2>/dev/null || true
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_OK" "    [COPY] $(basename "$dest")/ (copiado)"
            else
                echo "    [COPY] $(basename "$dest")/ (copiado)"
            fi

        else
            # Single file
            if [ -f "$dest" ] && [ ! -L "$dest" ]; then
                if cmp -s "$src" "$dest"; then
                    if command -v gum >/dev/null 2>&1; then
                        gum style --foreground "$COLOR_OK" "    [OK] $(basename "$dest") (sin cambios)"
                    else
                        echo "    [OK] $(basename "$dest") (sin cambios)"
                    fi
                    return 0
                fi
                local backup="${dest}.bak_$(date +%Y%m%d_%H%M%S)"
                cp "$dest" "$backup"
                if command -v gum >/dev/null 2>&1; then
                    gum style --foreground "$COLOR_WARN" "    [BACKUP] Respaldo creado: $(basename "$backup")"
                else
                    echo "    [BACKUP] Respaldo creado: $(basename "$backup")"
                fi
            elif [ -L "$dest" ]; then
                rm -f "$dest"
            fi

            cp "$src" "$dest"
            if command -v gum >/dev/null 2>&1; then
                gum style --foreground "$COLOR_OK" "    [DEPLOY] $(basename "$dest") (desplegado)"
            else
                echo "    [DEPLOY] $(basename "$dest") (desplegado)"
            fi
        fi
    fi
}

# Deploy only generated Static Noise artifacts for a module. This lets `omc update`
# refresh copied themes without overwriting unrelated user configuration.
deploy_static_noise_artifacts() {
    local mod="$1"
    local mode="$2"
    local dotfiles_dir="$3"
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local mod_dir="$dotfiles_dir/modules/$mod"

    [ ! -d "$mod_dir" ] && return 0

    for tool_dir in "$mod_dir"/*; do
        [ -d "$tool_dir" ] || continue
        local manifest="$tool_dir/manifest.sh"
        [ -f "$manifest" ] || continue

        local MODULE_NAME=""
        local MODULE_DESC=""
        local MODULE_TARGETS=()
        source "$manifest"

        for target in "${MODULE_TARGETS[@]}"; do
            local src_rel="${target%%:*}"
            [ "${src_rel#@static-noise/}" != "$src_rel" ] || continue

            local dest_rel="${target#*:}"
            local src="$STATIC_NOISE_CACHE/${src_rel#@static-noise/}"
            local dest
            if [[ "$dest_rel" == pi/* ]]; then
                dest="$HOME/.pi/agent/${dest_rel#pi/}"
            else
                dest="$config_home/$dest_rel"
            fi
            deploy_file "$src" "$dest" "$mode"
        done
    done
}

# Deploy all configuration files associated with a module
deploy_module() {
    local mod="$1"
    local mode="$2"
    local dotfiles_dir="$3"
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

    local mod_dir="$dotfiles_dir/modules/$mod"
    [ ! -d "$mod_dir" ] && return 0

    for tool_dir in "$mod_dir"/*; do
        [ ! -d "$tool_dir" ] && continue
        local manifest="$tool_dir/manifest.sh"
        if [ -f "$manifest" ]; then
            local MODULE_NAME=""
            local MODULE_DESC=""
            local MODULE_TARGETS=()
            source "$manifest"

            for target in "${MODULE_TARGETS[@]}"; do
                [ -z "$target" ] && continue
                local src_rel="${target%%:*}"
                local dest_rel="${target#*:}"
                local src
                if [[ "$src_rel" == @static-noise/* ]]; then
                    # Artefacto generado remoto; STATIC_NOISE_CACHE lo prepara install/update.
                    src="$STATIC_NOISE_CACHE/${src_rel#@static-noise/}"
                elif [ "$src_rel" = "." ] || [ -z "$src_rel" ]; then
                    src="$tool_dir"
                else
                    src="$tool_dir/$src_rel"
                fi
                local dest

                # Regla especial para Pi: sus archivos van a ~/.pi/agent/
                if [[ "$dest_rel" == pi/* ]]; then
                    local relative_to_pi="${dest_rel#pi/}"
                    dest="$HOME/.pi/agent/$relative_to_pi"
                else
                    dest="$config_home/$dest_rel"
                fi

                deploy_file "$src" "$dest" "$mode"
            done
        fi
    done
}
