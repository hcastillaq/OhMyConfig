#!/usr/bin/env bash
# ==============================================================================
# DOCS — Astro Starlight documentation website manager for omc CLI (Bash 3.2+)
# ==============================================================================

cmd_docs() {
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    local docs_dir="$dotfiles_dir/apps/docs"

    source "$dotfiles_dir/cli/lib/ui.sh"

    if [ ! -d "$docs_dir" ]; then
        ui_error "No se encontró el directorio de documentación: $docs_dir"
        return 1
    fi

    if ! command -v npm >/dev/null 2>&1; then
        ui_error "npm no está disponible en PATH. Instalá Node con mise o brew."
        return 1
    fi

    local action="${1:-dev}"
    shift || true

    case "$action" in
        dev|start)
            ui_header
            ui_divider
            ui_title "⚡ Iniciando servidor local de documentación..."
            ui_dim "Directorio: $docs_dir"
            ui_dim "URL local:  http://localhost:4321/OhMyConfig/"
            ui_divider
            echo ""
            npm --prefix "$docs_dir" run dev "$@"
            ;;
        build)
            ui_header
            ui_divider
            ui_title "⚡ Compilando sitio web estático..."
            ui_dim "Directorio: $docs_dir"
            ui_dim "Salida:     $docs_dir/dist/"
            ui_divider
            echo ""
            npm --prefix "$docs_dir" run build "$@"
            ;;
        preview)
            ui_header
            ui_divider
            ui_title "⚡ Previsualizando build de documentación..."
            ui_dim "Directorio: $docs_dir"
            ui_divider
            echo ""
            npm --prefix "$docs_dir" run preview "$@"
            ;;
        install)
            ui_header
            ui_divider
            ui_title "⚡ Instalando dependencias de documentación en apps/docs..."
            ui_divider
            echo ""
            npm --prefix "$docs_dir" install "$@"
            ;;
        help|--help|-h)
            echo "Uso: omc docs [dev | build | preview | install]"
            echo ""
            echo "Subcomandos:"
            echo "  dev      Inicia el servidor de desarrollo Astro Starlight (por defecto)"
            echo "  build    Compila el sitio web estático en apps/docs/dist/"
            echo "  preview  Sirve localmente el build estático compilado"
            echo "  install  Instala o actualiza dependencias npm en apps/docs/"
            ;;
        *)
            ui_error "Acción desconocida: $action"
            echo "Uso: omc docs [dev | build | preview | install]"
            return 1
            ;;
    esac
}
