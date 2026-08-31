# ==============================================================================
# GUÍA INTERACTIVA DE ATAJOS Y COMANDOS DE TERMINAL (GUIA / CHEAT)
# ==============================================================================

function guia --description "Guía interactiva de atajos y comandos del entorno"
    set -l cat $argv[1]
    
    set -l c_head (set_color 50f5ff --bold)
    set -l c_sec  (set_color c099ff --bold)
    set -l c_key  (set_color 50f5ff --bold)
    set -l c_txt  (set_color e0e6fc)
    set -l c_dim  (set_color 7a88cf)
    set -l c_use  (set_color e0af68 --bold)
    set -l c_res  (set_color normal)

    echo ""
    echo $c_head"⚡ OhMyConfig — Mapa de Atajos y Memoria Muscular"$c_res
    echo $c_dim"────────────────────────────────────────────────────────────────────────"$c_res

    if test -z "$cat" -o "$cat" = "all"
        echo $c_use"💡 Filtrar guía: "$c_res"guia [ai | nvim | zj | git | search | cli]"
        echo ""
        echo $c_sec"🤖  ECOSISTEMA AI & AGENTES DE CÓDIGO (PI):"$c_res
        echo "  "$c_key"omc dev"$c_res"             "$c_txt"Instalar agente base pi (npm global)"$c_res
        echo "  "$c_key"omc dev status"$c_res"      "$c_txt"Ver versión de pi y estado de extensiones recomendadas"$c_res
        echo "  "$c_key"omc dev update"$c_res"      "$c_txt"Actualizar pi a la última versión disponible en npm"$c_res
        echo "  "$c_key"pi"$c_res"                  "$c_txt"Iniciar agente de codificación autónomo en terminal"$c_res
        echo "  "$c_key"pi install <ext>"$c_res"   "$c_txt"Instalar extensiones recomendadas (subagents, plan, memory...)"$c_res
        echo ""
        echo $c_sec"🛠️  NEOVIM (Editor IDE):"$c_res
        echo "  "$c_key"<Space> + e"$c_res"       "$c_txt"Explorador de archivos (Toggle & reveal)"$c_res
        echo "  "$c_key"Ctrl + h/j/k/l"$c_res"    "$c_txt"Navegar entre ventanas divididas (splits)"$c_res
        echo "  "$c_key"Shift + l / h"$c_res"     "$c_txt"Pestaña siguiente / anterior en la barra superior"$c_res
        echo "  "$c_key"<Space> + bd"$c_res"      "$c_txt"Cerrar pestaña actual limpiamente sin [No Name]"$c_res
        echo "  "$c_key"<Space> + w"$c_res"       "$c_txt"Guardar archivo actual (:w)"$c_res
        echo "  "$c_key"<Space> + cr"$c_res"      "$c_txt"Renombrar variable/función en todo el proyecto (LSP)"$c_res
        echo "  "$c_key"<Space> + sr"$c_res"      "$c_txt"Buscar y reemplazar texto en todo el proyecto (Grug-Far)"$c_res
        echo "  "$c_key"<Space> + cn"$c_res"      "$c_txt"Generar documentación técnica inteligente (Neogen)"$c_res
        echo "  "$c_key"<Space> + px"$c_res"      "$c_txt"Activar/desactivar lenguajes con 'x' (:LazyExtras)"$c_res
        echo "  "$c_key"gd / K"$c_res"            "$c_txt"Ir a definición / Ver tipos y docs flotantes (LSP)"$c_res
        echo "  "$c_key"s + 2 letras"$c_res"      "$c_txt"Salto instantáneo a cualquier palabra en pantalla (Flash)"$c_res
        echo "  "$c_key"gcc / gc"$c_res"          "$c_txt"Comentar línea actual / bloque en modo visual"$c_res
        echo ""
        echo $c_sec"🪟  ZELLIJ (Multiplexor):"$c_res
        echo "  "$c_key"Alt + h/j/k/l"$c_res"     "$c_txt"Mover foco entre paneles (se ilumina en Cyan)"$c_res
        echo "  "$c_key"Alt + [ / ]"$c_res"       "$c_txt"Pestaña anterior / siguiente al instante"$c_res
        echo "  "$c_key"Alt + 1..9"$c_res"        "$c_txt"Saltar directo a la pestaña número 1..9"$c_res
        echo "  "$c_key"Alt + n"$c_res"           "$c_txt"Crear nuevo panel directamente"$c_res
        echo "  "$c_key"Alt + f"$c_res"           "$c_txt"Maximizar / Restaurar panel activo (Pantalla completa)"$c_res
        echo "  "$c_key"Alt + w"$c_res"           "$c_txt"Alternar paneles flotantes (Floating Panes)"$c_res
        echo "  "$c_key"Ctrl + h"$c_res"          "$c_txt"Modo Mover: cambiar posición de paneles (h/j/k/l o Tab)"$c_res
        echo "  "$c_key"Ctrl + p / t"$c_res"      "$c_txt"Modo Paneles / Modo Pestañas (Tabs)"$c_res
        echo ""
        echo $c_sec"🐙  GIT & CONTROL DE VERSIONES:"$c_res
        echo "  "$c_key"gs / gaa"$c_res"          "$c_txt"Estado de cambios (status) / Staging completo (add .)"$c_res
        echo "  "$c_key"gc / gp"$c_res"           "$c_txt"Crear commit estructurado / Subir cambios (push)"$c_res
        echo "  "$c_key"gd / glp"$c_res"          "$c_txt"Diffs coloreados con Delta (pendientes / por commit)"$c_res
        echo "  "$c_key"gl / glog"$c_res"         "$c_txt"Árbol visual de commits (rama actual / todas las ramas)"$c_res
        echo "  "$c_key"lg / of"$c_res"           "$c_txt"Interfaz visual Lazygit / Telemetría Onefetch"$c_res
        echo ""
        echo $c_sec"🔍  BÚSQUEDA Y NAVEGACIÓN EN TERMINAL:"$c_res
        echo "  "$c_key"rg <patron>"$c_res"       "$c_txt"Buscar texto adentro de archivos en milisegundos (Ripgrep)"$c_res
        echo "  "$c_key"fd <nombre>"$c_res"       "$c_txt"Buscar archivos y carpetas a toda velocidad (Fd)"$c_res
        echo "  "$c_key"sd 'old' 'new'"$c_res"    "$c_txt"Reemplazo de texto intuitivo y seguro en archivos"$c_res
        echo "  "$c_key"cd <dir> / zi"$c_res"     "$c_txt"Salto inteligente a carpetas / selector interactivo (Zoxide)"$c_res
        echo "  "$c_key".. / ... / -"$c_res"      "$c_txt"Subir 1 nivel / 2 niveles / volver al directorio previo"$c_res
        echo "  "$c_key"Ctrl + r"$c_res"          "$c_txt"Historial interactivo SQLite con tiempos y estado (Atuin)"$c_res
        echo "  "$c_key"Ctrl + t / Alt+c"$c_res"  "$c_txt"Búsqueda difusa de archivos / carpetas con FZF"$c_res
        echo "  "$c_key"y"$c_res"                 "$c_txt"Administrador de archivos Yazi (salto de directorio al salir)"$c_res
        echo ""
        echo $c_sec"📦  HERRAMIENTAS MODERNAS CLI / TUI:"$c_res
        echo "  "$c_key"ls / ll / tree"$c_res"    "$c_txt"Listados visuales con íconos vía Eza"$c_res
        echo "  "$c_key"cat <file>"$c_res"        "$c_txt"Visor con sintaxis coloreada Tokyonight vía Bat"$c_res
        echo "  "$c_key"btm / du"$c_res"          "$c_txt"Monitor interactivo (Bottom) / Uso de disco en barras (Dust)"$c_res
        echo "  "$c_key"procs"$c_res"             "$c_txt"Visor de procesos con árbol y búsqueda por puerto (--port)"$c_res
        echo "  "$c_key"xh / jqp"$c_res"          "$c_txt"Cliente HTTP veloz / Playground interactivo para JQ"$c_res
        echo "  "$c_key"tokei"$c_res"             "$c_txt"Estadísticas y conteo de líneas de código por lenguaje"$c_res
        echo "  "$c_key"lazydocker / k9s"$c_res"  "$c_txt"Paneles TUI interactivos para Docker y Kubernetes"$c_res
        echo "  "$c_key"cds"$c_res"               "$c_txt"Limpieza de archivos basura .DS_Store en macOS"$c_res
    else
        switch "$cat"
            case "ai" "pi" "lazy" "lazypi"
                echo $c_sec"🤖  ECOSISTEMA AI & AGENTES DE CÓDIGO (PI):"$c_res
                echo "  "$c_key"omc dev"$c_res"             "$c_txt"Instalar agente pi (@earendil-works/pi-coding-agent)"$c_res
                echo "  "$c_key"omc dev status"$c_res"      "$c_txt"Ver versión de pi y estado de extensiones recomendadas"$c_res
                echo "  "$c_key"omc dev update"$c_res"      "$c_txt"Actualizar pi a la última versión disponible en npm"$c_res
                echo "  "$c_key"pi"$c_res"                  "$c_txt"Iniciar sesión del coding agent en terminal"$c_res
                echo ""
                echo $c_sec"🧩  EXTENSIONES RECOMENDADAS PARA PI:"$c_res
                echo "  "$c_key"pi install npm:pi-subagents"$c_res"        "$c_txt"Orquestación de subagentes en paralelo y /council"$c_res
                echo "  "$c_key"pi install npm:pi-ask-user"$c_res"         "$c_txt"Menús interactivos y preguntas estructuradas"$c_res
                echo "  "$c_key"pi install npm:@narumitw/pi-plan-mode"$c_res" "$c_txt"Modo interactivo de planificación guiada (/plan)"$c_res
                echo "  "$c_key"pi install npm:pi-antigravity"$c_res"      "$c_txt"DeepMind Antigravity, CodeGraph y semántica"$c_res
                echo "  "$c_key"pi install git:github.com/VandeeFeng/pi-memory-md"$c_res" "$c_txt"Memoria offline persistente en Markdown + Git"$c_res
                echo "  "$c_key"pi install npm:pi-web-access"$c_res"       "$c_txt"Búsqueda web multi-proveedor y extracción de fuentes"$c_res
                echo "  "$c_key"pi install npm:@plannotator/pi-extension"$c_res" "$c_txt"Visualización y anotación de planes de código"$c_res
                echo "  "$c_key"pi install npm:pi-interactive-shell"$c_res" "$c_txt"Ejecución interactiva de CLIs y TUIs en segundo plano"$c_res
            case "nvim" "v" "vim" "editor"
                echo $c_sec"🛠️  NEOVIM — ATAJOS ESENCIALES:"$c_res
                echo "  "$c_key"<Space> + e"$c_res"       "$c_txt"Abrir/cerrar explorador de archivos lateral"$c_res
                echo "  "$c_key"Ctrl + h/j/k/l"$c_res"    "$c_txt"Moverse entre splits y ventanas divididas"$c_res
                echo "  "$c_key"Shift + l / h"$c_res"     "$c_txt"Pestaña siguiente / anterior en la barra superior"$c_res
                echo "  "$c_key"<Space> + bd"$c_res"      "$c_txt"Cerrar pestaña actual limpiamente (sin [No Name])"$c_res
                echo "  "$c_key"<Space> + w"$c_res"       "$c_txt"Guardar archivo (:w)"$c_res
                echo "  "$c_key"s + 2 letras"$c_res"      "$c_txt"Salto instantáneo a cualquier palabra en pantalla (Flash)"$c_res
                echo "  "$c_key"Ctrl + Space"$c_res"      "$c_txt"Selección incremental de código (Treesitter)"$c_res
                echo "  "$c_key"gd / K"$c_res"            "$c_txt"Ir a definición / Ver documentación y tipos (LSP)"$c_res
                echo "  "$c_key"<Space> + cr"$c_res"      "$c_txt"Renombrar variable/función en todo el proyecto (LSP)"$c_res
                echo "  "$c_key"<Space> + sr"$c_res"      "$c_txt"Buscar y reemplazar texto en todo el proyecto (Grug-Far)"$c_res
                echo "  "$c_key"<Space> + cn"$c_res"      "$c_txt"Generar docstrings automáticos (Neogen)"$c_res
                echo "  "$c_key"<Space> + px"$c_res"      "$c_txt"Menú :LazyExtras para activar lenguajes con 'x'"$c_res
                echo "  "$c_key"gcc / gc"$c_res"          "$c_txt"Comentar línea actual / bloque seleccionado"$c_res
                echo "  "$c_key"]c / [c"$c_res"           "$c_txt"Siguiente / anterior cambio de Git (GitLens)"$c_res
                echo "  "$c_key"<Space> + gp"$c_res"      "$c_txt"Vista previa flotante del Diff de Git (Preview Hunk)"$c_res
                echo "  "$c_key"u / Ctrl + r"$c_res"      "$c_txt"Deshacer persistente en disco / Rehacer"$c_res
            case "zj" "zellij" "mux"
                echo $c_sec"🪟  ZELLIJ — MULTIPLEXOR:"$c_res
                echo "  "$c_key"Alt + h/j/k/l"$c_res"     "$c_txt"Mover foco entre paneles (se ilumina en Cyan)"$c_res
                echo "  "$c_key"Alt + [ / ]"$c_res"       "$c_txt"Pestaña anterior / siguiente al instante"$c_res
                echo "  "$c_key"Alt + 1..9"$c_res"        "$c_txt"Saltar directo a la pestaña número 1..9"$c_res
                echo "  "$c_key"Alt + n"$c_res"           "$c_txt"Crear nuevo panel directamente"$c_res
                echo "  "$c_key"Alt + f"$c_res"           "$c_txt"Maximizar / Restaurar panel activo (Pantalla completa)"$c_res
                echo "  "$c_key"Alt + w"$c_res"           "$c_txt"Alternar paneles flotantes (Floating Panes)"$c_res
                echo "  "$c_key"Ctrl + h"$c_res"          "$c_txt"Modo Mover: intercambiar posición de paneles (h/j/k/l o Tab)"$c_res
                echo "  "$c_key"Ctrl + p"$c_res"          "$c_txt"Modo Paneles (n:nuevo, d:abajo, r:derecha, x:cerrar)"$c_res
                echo "  "$c_key"Ctrl + t"$c_res"          "$c_txt"Modo Pestañas (n:nueva, x:cerrar, h/l:mover, r:renombrar)"$c_res
                echo "  "$c_key"Ctrl + s"$c_res"          "$c_txt"Modo Scroll (j/k:scroll, s:buscar, e:abrir en nvim)"$c_res
                echo "  "$c_key"Ctrl + n"$c_res"          "$c_txt"Modo Resize (+/-:tamaño, hjkl:dirección)"$c_res
            case "git" "g" "lg"
                echo $c_sec"🐙  GIT & CONTROL DE VERSIONES:"$c_res
                echo "  "$c_key"gs"$c_res"                "$c_txt"Estado de archivos y cambios pendientes (status)"$c_res
                echo "  "$c_key"gaa"$c_res"               "$c_txt"Staging de todos los cambios (git add .)"$c_res
                echo "  "$c_key"gc"$c_res"                "$c_txt"Crear commit estructurado (git commit)"$c_res
                echo "  "$c_key"gd"$c_res"                "$c_txt"Ver diffs coloreados con Delta (git diff)"$c_res
                echo "  "$c_key"gl"$c_res"                "$c_txt"Árbol visual de commits de la rama activa"$c_res
                echo "  "$c_key"glog"$c_res"              "$c_txt"Árbol completo de todas las ramas locales y remotas"$c_res
                echo "  "$c_key"glp"$c_res"               "$c_txt"Historial detallado con diffs interactivos en Delta"$c_res
                echo "  "$c_key"gp"$c_res"                "$c_txt"Subir cambios a la rama remota (git push)"$c_res
                echo "  "$c_key"lg"$c_res"                "$c_txt"Interfaz TUI visual completa con Lazygit"$c_res
                echo "  "$c_key"of"$c_res"                "$c_txt"Telemetría gráfica del repositorio (Onefetch)"$c_res
            case "search" "nav" "fzf" "find"
                echo $c_sec"🔍  BÚSQUEDA Y NAVEGACIÓN EN TERMINAL:"$c_res
                echo "  "$c_key"rg <patron>"$c_res"       "$c_txt"Buscar texto adentro de archivos (Ripgrep)"$c_res
                echo "  "$c_key"rg -t <ext> <p>"$c_res"   "$c_txt"Buscar texto filtrando por tipo de archivo (ej: -t js)"$c_res
                echo "  "$c_key"fd <nombre>"$c_res"       "$c_txt"Buscar archivos y carpetas a toda velocidad (Fd)"$c_res
                echo "  "$c_key"fd -e <ext>"$c_res"       "$c_txt"Buscar archivos por extensión (ej: fd -e json)"$c_res
                echo "  "$c_key"fd -H"$c_res"             "$c_txt"Buscar incluyendo archivos ocultos (.dotfiles)"$c_res
                echo "  "$c_key"sd 'old' 'new'"$c_res"    "$c_txt"Reemplazar texto en archivos (reemplazo moderno de sed)"$c_res
                echo "  "$c_key"cd <dir> / zi"$c_res"     "$c_txt"Salto inteligente a carpetas / selector interactivo (Zoxide)"$c_res
                echo "  "$c_key".. / ... / -"$c_res"      "$c_txt"Subir 1 o 2 niveles / volver al previo"$c_res
                echo "  "$c_key"Ctrl + r"$c_res"          "$c_txt"Historial SQLite con buscador difuso (Atuin)"$c_res
                echo "  "$c_key"Ctrl + t"$c_res"          "$c_txt"Búsqueda difusa de archivos con FZF en la shell"$c_res
                echo "  "$c_key"Alt + c"$c_res"           "$c_txt"Búsqueda difusa y salto directo a carpetas con FZF"$c_res
                echo "  "$c_key"y"$c_res"                 "$c_txt"File manager Yazi (salta al directorio al salir con 'q')"$c_res
            case "cli" "tools"
                echo $c_sec"📦  HERRAMIENTAS MODERNAS CLI / TUI:"$c_res
                echo "  "$c_key"ls / ll / tree"$c_res"    "$c_txt"Listados visuales con íconos vía Eza"$c_res
                echo "  "$c_key"cat <file>"$c_res"        "$c_txt"Visor con sintaxis coloreada Tokyonight vía Bat"$c_res
                echo "  "$c_key"btm"$c_res"               "$c_txt"Monitor interactivo de CPU/RAM/Procesos (Bottom)"$c_res
                echo "  "$c_key"du / du -d 2"$c_res"      "$c_txt"Uso visual de espacio en disco en barras (Dust)"$c_res
                echo "  "$c_key"procs / --port"$c_res"    "$c_txt"Visor de procesos con árbol y búsqueda por puerto"$c_res
                echo "  "$c_key"xh"$c_res"                "$c_txt"Cliente HTTP veloz para pruebas de APIs"$c_res
                echo "  "$c_key"jqp"$c_res"               "$c_txt"Playground interactivo para filtros de JQ"$c_res
                echo "  "$c_key"tokei"$c_res"             "$c_txt"Estadísticas y conteo de líneas de código por lenguaje"$c_res
                echo "  "$c_key"lazydocker / k9s"$c_res"  "$c_txt"Paneles TUI interactivos para Docker y Kubernetes"$c_res
                echo "  "$c_key"md <file>"$c_res"         "$c_txt"Visor enriquecido de Markdown vía Glow"$c_res
                echo "  "$c_key"cds"$c_res"               "$c_txt"Limpieza de archivos basura .DS_Store en macOS"$c_res
        end
    end
    echo $c_dim"────────────────────────────────────────────────────────────────────────"$c_res
    echo $c_dim"🌐 Documentación Web: https://hcastillaq.github.io/OhMyConfig/"$c_res
    echo ""
end
