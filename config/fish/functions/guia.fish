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
        echo $c_sec"⚡️  NEOVIM (Editor IDE):"$c_res
        echo "  "$c_key"<Space> + e"$c_res"       "$c_txt"Explorador de archivos lateral (abrir / cerrar)"$c_res
        echo "  "$c_key"Ctrl + h/j/k/l"$c_res"    "$c_txt"Navegar entre ventanas divididas (splits)"$c_res
        echo "  "$c_key"Shift + l / h"$c_res"     "$c_txt"Pestaña siguiente / anterior en la barra superior"$c_res
        echo "  "$c_key"<Space> + bd"$c_res"      "$c_txt"Cerrar pestaña actual limpiamente sin [No Name]"$c_res
        echo "  "$c_key"Ctrl+s / <Space>+fs"$c_res" "$c_txt"Guardar archivo actual en disco (universal)"$c_res
        echo "  "$c_key"<Space> + w"$c_res"       "$c_txt"Menú de ventanas y splits (v:vertical, s:horizontal, d:cerrar)"$c_res
        echo "  "$c_key"<Space> + cc"$c_res"      "$c_txt"Comentar / descomentar línea o selección visual"$c_res
        echo "  "$c_key"<Space> + ca"$c_res"      "$c_txt"Menú de correcciones automáticas sugeridas (QuickFix)"$c_res
        echo "  "$c_key"<Space> + cA"$c_res"      "$c_txt"Organizar todos los imports del archivo (Source Action)"$c_res
        echo "  "$c_key"<Space> + cD / gd"$c_res" "$c_txt"Ir a definición de función/variable/clase"$c_res
        echo "  "$c_key"<Space> + co / Ctrl+o"$c_res""$c_txt"Volver al origen tras el salto (Jump Back)"$c_res
        echo "  "$c_key"<Space> + cr"$c_res"      "$c_txt"Renombrar variable/función en todo el proyecto (LSP)"$c_res
        echo "  "$c_key"<Space> + sr"$c_res"      "$c_txt"Buscar y reemplazar interactivo en todo el proyecto (Grug-Far)"$c_res
        echo "  "$c_key"<Space> + cn"$c_res"      "$c_txt"Generar documentación técnica inteligente (Neogen)"$c_res
        echo "  "$c_key"<Space> + xx"$c_res"      "$c_txt"Abrir panel con todos los errores del proyecto (Trouble)"$c_res
        echo "  "$c_key"<Space> + px"$c_res"      "$c_txt"Activar/desactivar lenguajes con 'x' (:LazyExtras)"$c_res
        echo "  "$c_key"s + 2 letras"$c_res"      "$c_txt"Salto instantáneo a cualquier palabra en pantalla (Flash)"$c_res
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
        echo $c_sec"📊  HERRAMIENTAS MODERNAS CLI / TUI:"$c_res
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
                echo $c_sec"🤖  ECOSISTEMA AI & LAZYPI (PI):"$c_res
                echo "  "$c_key"omc dev"$c_res"             "$c_txt"Instalar Pi y la suite oficial LazyPi (17 extensiones)"$c_res
                echo "  "$c_key"omc dev status"$c_res"      "$c_txt"Ver estado del catálogo LazyPi (Core + Optional)"$c_res
                echo "  "$c_key"omc dev update"$c_res"      "$c_txt"Actualizar Pi y todas las extensiones instaladas"$c_res
                echo "  "$c_key"omc dev doctor"$c_res"      "$c_txt"Diagnóstico de salud del entorno de IA"$c_res
                echo "  "$c_key"omc dev remove"$c_res"      "$c_txt"Selector interactivo para desinstalar extensiones"$c_res
                echo "  "$c_key"pi"$c_res"                  "$c_txt"Iniciar sesión del coding agent en terminal"$c_res
                echo ""
                echo $c_sec"💡  COMANDOS SLASH Y HERRAMIENTAS CLAVE:"$c_res
                echo "  "$c_key"/plan <desc>"$c_res"        "$c_txt"Modo interactivo de planificación guiada en memoria"$c_res
                echo "  "$c_key"/simplify"$c_res"           "$c_txt"Simplificar y limpiar código modificado recientemente"$c_res
                echo "  "$c_key"/ponytail review"$c_res"    "$c_txt"Auditar código buscando sobreingeniería y dependencias"$c_res
                echo "  "$c_key"/btw <pregunta>"$c_res"     "$c_txt"Consulta rápida sin contaminar el historial de chat"$c_res
                echo "  "$c_key"/workflows"$c_res"          "$c_txt"Panel TUI interactivo para orquestar subagentes"$c_res
                echo "  "$c_key"\$skill-name"$c_res"        "$c_txt"Mención difusa con '\$' para inyectar skills en el prompt"$c_res
            case "nvim" "v" "vim" "editor"
                echo $c_sec"⚡️  NEOVIM — CENTRO DE CONTROL (<Space> = Leader):"$c_res
                echo "  "$c_use"1. Explorador & Archivos:"$c_res
                echo "    "$c_key"<Space> + e"$c_res"       "$c_txt"Abrir/cerrar explorador lateral (árbol Neo-tree)"$c_res
                echo "    "$c_key"<Space> + fe / fE"$c_res" "$c_txt"Explorador en la raíz del proyecto / en carpeta actual"$c_res
                echo "    "$c_key"<Space> + ge"$c_res"      "$c_txt"Explorador de archivos modificados en Git"$c_res
                echo "    "$c_key"Ctrl+s / <Space>+fs"$c_res" "$c_txt"Guardar archivo actual en disco (universal)"$c_res
                echo "    "$c_key"<Space> + fn / fr"$c_res" "$c_txt"Crear nuevo archivo vacío / Abrir archivo reciente"$c_res
                echo "    "$c_key"<Space> + ft"$c_res"      "$c_txt"Abrir terminal flotante integrada (Ctrl + /)"$c_res
                echo ""
                echo "  "$c_use"2. Código, Comentarios & Correcciones (<Space>c):"$c_res
                echo "    "$c_key"<Space> + cc"$c_res"      "$c_txt"Comentar / descomentar línea actual o selección visual"$c_res
                echo "    "$c_key"<Space> + cb"$c_res"      "$c_txt"Añadir comentario en la línea siguiente"$c_res
                echo "    "$c_key"<Space> + ca"$c_res"      "$c_txt"Menú de correcciones automáticas sugeridas (QuickFix)"$c_res
                echo "    "$c_key"<Space> + cA"$c_res"      "$c_txt"Organizar y limpiar todos los imports del archivo"$c_res
                echo "    "$c_key"<Space> + cD / gd"$c_res" "$c_txt"Ir a definición de función/variable/clase"$c_res
                echo "    "$c_key"<Space> + cI / gI"$c_res" "$c_txt"Ir a implementación concreta de interfaz (Java/TS/Go)"$c_res
                echo "    "$c_key"<Space> + cy / gy"$c_res" "$c_txt"Ir a la definición del tipo de dato (Type Definition)"$c_res
                echo "    "$c_key"<Space> + co / Ctrl+o"$c_res""$c_txt"Volver al origen tras el salto (Jump Back)"$c_res
                echo "    "$c_key"<Space> + ci / Ctrl+i"$c_res""$c_txt"Avanzar de nuevo en el salto (Jump Forward)"$c_res
                echo "    "$c_key"<Space> + ch / K"$c_res"  "$c_txt"Ver documentación flotante / firma de tipos (Hover)"$c_res
                echo "    "$c_key"<Space> + cd"$c_res"      "$c_txt"Ver mensaje y explicación del error de la línea"$c_res
                echo "    "$c_key"<Space> + cr"$c_res"      "$c_txt"Renombrar símbolo en todo el proyecto de forma segura"$c_res
                echo "    "$c_key"<Space> + cf"$c_res"      "$c_txt"Formatear archivo según estándar del lenguaje"$c_res
                echo "    "$c_key"<Space> + cn"$c_res"      "$c_txt"Generar plantilla de docstrings inteligentes (Neogen)"$c_res
                echo "    "$c_key"<Space> + cs"$c_res"      "$c_txt"Árbol visual de símbolos y funciones del archivo"$c_res
                echo ""
                echo "  "$c_use"3. Ventanas & Splits (<Space>w):"$c_res
                echo "    "$c_key"<Space> + wh/j/k/l"$c_res""$c_txt"Mover foco a ventana izquierda / abajo / arriba / derecha"$c_res
                echo "    "$c_key"<Space> + wv"$c_res"      "$c_txt"Dividir pantalla en vertical (lado a lado)"$c_res
                echo "    "$c_key"<Space> + ws"$c_res"      "$c_txt"Dividir pantalla en horizontal (arriba y abajo)"$c_res
                echo "    "$c_key"<Space> + wd"$c_res"      "$c_txt"Cerrar la ventana activa (sin cerrar Neovim)"$c_res
                echo "    "$c_key"<Space> + wm"$c_res"      "$c_txt"Maximizar / restaurar tamaño de ventana (Zoom)"$c_res
                echo "    "$c_key"<Space> + w="$c_res"      "$c_txt"Balancear e igualar tamaño de todas las ventanas"$c_res
                echo "    "$c_key"<Space> + wx"$c_res"      "$c_txt"Intercambiar posición con la siguiente ventana (Swap)"$c_res
                echo ""
                echo "  "$c_use"4. Pestañas & Buffers (<Space>b):"$c_res
                echo "    "$c_key"<Space> + bh / bl"$c_res" "$c_txt"Pestaña anterior / siguiente (Shift + h / l)"$c_res
                echo "    "$c_key"<Space> + bd"$c_res"      "$c_txt"Cerrar pestaña actual limpiamente (sin [No Name])"$c_res
                echo "    "$c_key"<Space> + bo"$c_res"      "$c_txt"Cerrar todas las demás pestañas excepto la actual"$c_res
                echo "    "$c_key"<Space> + bb"$c_res"      "$c_txt"Alternar con la pestaña previa"$c_res
                echo "    "$c_key"<Space> + bj"$c_res"      "$c_txt"Elegir pestaña interactivamente con selector"$c_res
                echo "    "$c_key"<Space> + bp"$c_res"      "$c_txt"Fijar pestaña actual (Pin toggle)"$c_res
                echo ""
                echo "  "$c_use"5. Buscar, Reemplazar & Errores:"$c_res
                echo "    "$c_key"<Space> + sr"$c_res"      "$c_txt"Buscar y reemplazar interactivo en el proyecto (Grug-Far)"$c_res
                echo "    "$c_key"<Space> + sw"$c_res"      "$c_txt"Buscar ocurrencias de la palabra actual en archivos"$c_res
                echo "    "$c_key"<Space> + sg / /"$c_res"  "$c_txt"Buscar texto adentro de archivos (Live Grep)"$c_res
                echo "    "$c_key"<Space><Space> / ff"$c_res""$c_txt"Buscar archivo por nombre en el proyecto"$c_res
                echo "    "$c_key"<Space> + ss / sS"$c_res" "$c_txt"Buscar símbolos en el archivo / en todo el proyecto"$c_res
                echo "    "$c_key"<Space> + xx / xX"$c_res" "$c_txt"Panel Trouble con todos los errores / del archivo actual"$c_res
                echo "    "$c_key"[d / ]d"$c_res"           "$c_txt"Saltar directamente al anterior / siguiente error"$c_res
                echo ""
                echo "  "$c_use"6. Git & Control de Versiones (<Space>g):"$c_res
                echo "    "$c_key"<Space> + gg"$c_res"      "$c_txt"Abrir panel visual completo de Lazygit"$c_res
                echo "    "$c_key"<Space> + gb / gB"$c_res" "$c_txt"Git Blame en línea actual (ventana / toggle)"$c_res
                echo "    "$c_key"<Space> + gd"$c_res"      "$c_txt"Ver Diff contra HEAD en división lateral"$c_res
                echo "    "$c_key"<Space> + ghp / ghs"$c_res""$c_txt"Previsualizar cambio del bloque / Staging de bloque"$c_res
                echo "    "$c_key"]c / [c"$c_res"           "$c_txt"Saltar al siguiente / anterior cambio de Git (Hunk)"$c_res
                echo ""
                echo "  "$c_use"7. Gestión, Sesión & Utilidades:"$c_res
                echo "    "$c_key"<Space> + px / pl"$c_res" "$c_txt"Gestionar lenguajes (:LazyExtras) / Plugins (:Lazy)"$c_res
                echo "    "$c_key"<Space> + pm"$c_res"      "$c_txt"Gestionar servidores y herramientas (:Mason)"$c_res
                echo "    "$c_key"<Space> + qs / ql"$c_res" "$c_txt"Restaurar sesión del proyecto / última sesión cerrada"$c_res
                echo "    "$c_key"<Space> + qq"$c_res"      "$c_txt"Cerrar todas las ventanas y salir de Neovim"$c_res
                echo "    "$c_key"s + 2 letras"$c_res"      "$c_txt"Salto instantáneo a cualquier palabra en pantalla (Flash)"$c_res
                echo "    "$c_key"Ctrl + Space"$c_res"      "$c_txt"Modo Normal: selección sintáctica | Inserción: sugerencias"$c_res
                echo "    "$c_key"u / Ctrl + r"$c_res"      "$c_txt"Deshacer persistente en disco / Rehacer"$c_res
                echo ""
                echo $c_use"⚡ Toolchains y SDKs con mise: "$c_res$c_txt"mise use -g java@openjdk-21 | go@latest | rust@latest | php@latest"$c_res
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
                echo "  "$c_key"Alt + s"$c_res"           "$c_txt"Modo Scroll (j/k:scroll, s:buscar, e:abrir en nvim)"$c_res
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
                echo $c_sec"📊  HERRAMIENTAS MODERNAS CLI / TUI:"$c_res
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
