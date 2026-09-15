#!/usr/bin/env bash
# ==============================================================================
# CHEATSHEET — Terminal-first fuzzy shortcut search for omc CLI (Bash 3.2+)
# ==============================================================================

cmd_cheatsheet() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    local cheat_file="$dotfiles_dir/apps/docs/src/content/docs/cheatsheet.md"

    source "$dotfiles_dir/cli/lib/ui.sh"

    if [ ! -f "$cheat_file" ]; then
        ui_error "No se encontró el archivo canónico de atajos: $cheat_file"
        return 1
    fi

    local query="$*"

    # Extraer atajos en formato estructurado desde las tablas Markdown
    local formatted_shortcuts
    formatted_shortcuts=$(awk '
    /^## / {
        gsub(/^## [0-9]+\. /, "");
        section = $0;
    }
    /^\| \*\*/ {
        split($0, cols, "|");
        shortcut = cols[2];
        real_cmd = cols[3];
        desc = cols[4];
        gsub(/^[ \t]+|[ \t]+$/, "", shortcut);
        gsub(/^[ \t]+|[ \t]+$/, "", real_cmd);
        gsub(/^[ \t]+|[ \t]+$/, "", desc);
        gsub(/\*\*/, "", shortcut);
        gsub(/`/, "", shortcut);
        gsub(/`/, "", real_cmd);
        printf "%-26s │ %-34s │ %s\n", shortcut, desc, section;
    }' "$cheat_file")

    if [ -z "$formatted_shortcuts" ]; then
        ui_error "No se pudieron extraer atajos desde $cheat_file"
        return 1
    fi

    # Si se pasó un término de búsqueda directa (ej: ./omc cheatsheet git)
    if [ -n "$query" ]; then
        local search_pattern="$query"
        case "$query" in
            nvim|neovim) search_pattern="nvim|neovim" ;;
            zj|zellij)   search_pattern="zj|zellij" ;;
            gs|git)      search_pattern="git|lazygit" ;;
        esac

        local matches
        matches=$(echo "$formatted_shortcuts" | grep -E -i "$search_pattern" || true)
        if [ -z "$matches" ]; then
            echo ""
            ui_warn "No se encontraron atajos para: '$query'"
            echo "  Tip: Probá buscar por nombre de herramienta (git, nvim, zellij, fish) o acción."
            echo ""
            return 0
        fi
        ui_header
        ui_divider
        ui_title "⚡ Resultados para: $query"
        ui_divider
        printf "  %-26s │ %-34s │ %s\n" "Atajo / Alias" "Descripción" "Sección"
        printf "  %s\n" "──────────────────────────────────────────────────────────────────────────────────"
        echo "$matches" | while IFS= read -r line; do
            echo "  $line"
        done
        echo ""
        return 0
    fi

    # Modo interactivo con gum filter
    if command -v gum >/dev/null 2>&1; then
        ui_header
        ui_title "⚡ Buscador Interactivo de Atajos (escribí para filtrar, Enter para ver detalles):"
        echo ""
        local selected
        selected=$(echo "$formatted_shortcuts" | gum filter \
            --placeholder="Buscá por comando, atajo, herramienta o sección..." \
            --indicator="❯ " \
            --indicator.foreground="$COLOR_HEAD" \
            --match.foreground="$COLOR_HEAD" \
            --text.foreground="$COLOR_TEXT" \
            --header="Atajo / Alias              │ Descripción                        │ Sección" \
            --header.foreground="$COLOR_DIM" \
            --width=95 \
            --height=18)

        if [ -n "$selected" ]; then
            echo ""
            ui_divider
            gum style --foreground "$COLOR_HEAD" --bold "  Detalle del Atajo:"
            gum style --foreground "$COLOR_TEXT" "  $selected"
            ui_divider
            echo ""
        fi

    elif command -v fzf >/dev/null 2>&1; then
        echo "$formatted_shortcuts" | fzf \
            --header="Atajo / Alias              │ Descripción                        │ Sección" \
            --prompt="❯ " \
            --reverse

    else
        echo "$formatted_shortcuts" | less
    fi
}
