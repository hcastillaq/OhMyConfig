-- ==============================================================================
-- PERSONALIZACIÓN DE WHICH-KEY (CENTRO DE CONTROL VISUAL DE ATAJOS)
-- ==============================================================================
-- Proporciona un mapa visual estructurado en español para principiantes y
-- profesionales, abarcando búsqueda, reemplazo, código, ventanas, buffers y git.

return {
  {
    "folke/which-key.nvim",
    opts = {
      delay = 200,
      spec = {
        -- --- 1. Grupos Principales Organizados por Verbos ---
        { "<leader>s", group = "buscar (archivos, texto, símbolos)", mode = { "n", "v" } },
        { "<leader>r", group = "reemplazar (proyecto, buffer, palabra)", mode = { "n", "v" } },
        { "<leader>c", group = "código (quickfix, rename, formato, lsp)", mode = { "n", "v" } },
        { "<leader>w", group = "ventanas & splits (mover, dividir, cerrar)", mode = { "n" } },
        { "<leader>b", group = "pestañas & buffers (navegar, cerrar, fijar)", mode = { "n" } },
        { "<leader>g", group = "git & versiones (lazygit, blame, diff)", mode = { "n", "v" } },
        { "<leader>f", group = "archivos & terminal (guardar, recientes, nuevo)", mode = { "n" } },
        { "<leader>x", group = "errores & diagnósticos (trouble, quickfix)", mode = { "n", "v" } },
        { "<leader>u", group = "opciones visuales (números, wrap, temas)", mode = { "n", "v" } },
        { "<leader>p", group = "gestión de paquetes & extras (lazy, mason)", mode = { "n", "v" } },
        { "<leader>q", group = "sesión & salir de neovim", mode = { "n" } },

        -- --- 2. Explorador de Archivos ---
        { "<leader>e", desc = "Explorador de archivos lateral (Abrir/Cerrar)" },
        { "<leader>fe", desc = "Explorador de archivos (Raíz del proyecto)" },
        { "<leader>fE", desc = "Explorador de archivos (Carpeta actual)" },
        { "<leader>ge", desc = "Explorador de archivos modificados en Git" },

        -- --- 3. Buscar (<leader>s) ---
        { "<leader>sf", desc = "Buscar archivos en proyecto" },
        { "<leader>sg", desc = "Buscar texto en archivos del proyecto (Live Grep)" },
        { "<leader>sw", desc = "Buscar palabra bajo cursor en proyecto" },
        { "<leader>ss", desc = "Buscar funciones y símbolos en este archivo" },
        { "<leader>sS", desc = "Buscar símbolos en todo el proyecto" },
        { "<leader>sb", desc = "Buscar buffers / pestañas abiertas" },
        { "<leader>s/", desc = "Buscar líneas en el buffer actual" },
        { "<leader>st", desc = "Buscar comentarios TODO / FIXME en proyecto" },

        -- --- 4. Reemplazar (<leader>r) ---
        { "<leader>rp", desc = "Reemplazar en proyecto completo (Grug-Far)", mode = { "n", "v" } },
        { "<leader>rw", desc = "Reemplazar palabra o selección en proyecto", mode = { "n", "v" } },
        { "<leader>rb", desc = "Reemplazar en archivo actual con confirmación", mode = { "n", "v" } },

        -- --- 5. Acciones de Código (<leader>c) ---
        { "<leader>ca", desc = "Acciones de código / Quick Fix sugerido" },
        { "<leader>cA", desc = "Organizar todos los imports (Source Action)" },
        { "<leader>cr", desc = "Renombrar símbolo en todo el proyecto" },
        { "<leader>cf", desc = "Formatear archivo de código" },
        { "<leader>cd", desc = "Ver explicación del error de la línea" },
        { "<leader>cx", desc = "Panel de errores y diagnósticos (Trouble)" },
        { "<leader>cn", desc = "Generar plantilla de documentación (Neogen)" },
        { "<leader>cD", desc = "Ir a definición (gd)" },
        { "<leader>cI", desc = "Ir a implementación de interfaz (gI)" },
        { "<leader>cy", desc = "Ir a definición de tipo (gy)" },
        { "<leader>ch", desc = "Ver documentación y tipos flotantes (Hover - K)" },

        -- --- 6. Ventanas & Splits (<leader>w) ---
        { "<leader>wh", desc = "Mover foco a ventana izquierda" },
        { "<leader>wj", desc = "Mover foco a ventana inferior" },
        { "<leader>wk", desc = "Mover foco a ventana superior" },
        { "<leader>wl", desc = "Mover foco a ventana derecha" },
        { "<leader>wv", desc = "Dividir pantalla verticalmente (Split)" },
        { "<leader>ws", desc = "Dividir pantalla horizontalmente (Split)" },
        { "<leader>wd", desc = "Cerrar ventana activa" },
        { "<leader>wm", desc = "Maximizar / restaurar ventana (Zoom)" },
        { "<leader>w=", desc = "Balancear e igualar tamaño de ventanas" },
        { "<leader>wx", desc = "Intercambiar ventana activa con siguiente" },

        -- --- 7. Pestañas & Buffers (<leader>b) ---
        { "<leader>bd", desc = "Cerrar pestaña actual limpiamente" },
        { "<leader>bo", desc = "Cerrar todas las demás pestañas" },
        { "<leader>bb", desc = "Alternar con la pestaña previa" },
        { "<leader>bj", desc = "Elegir pestaña interactivamente (Pick)" },
        { "<leader>bp", desc = "Fijar pestaña activa (Pin toggle)" },

        -- --- 8. Git (<leader>g) ---
        { "<leader>gg", desc = "Abrir panel visual completo de Lazygit" },
        { "<leader>gb", desc = "Ver quién modificó esta línea (Git Blame)" },
        { "<leader>gB", desc = "Alternar Git Blame en línea (Toggle)" },
        { "<leader>gd", desc = "Ver Diff contra HEAD" },
        { "<leader>gl", desc = "Ver historial de commits (Git Log)" },
        { "<leader>gs", desc = "Ver estado de Git (Status)" },
        { "<leader>ghp", desc = "Previsualizar cambio de este bloque (Preview)" },
        { "<leader>ghs", desc = "Agregar cambio de este bloque al staging" },
        { "<leader>ghr", desc = "Deshacer cambios de este bloque (Reset)" },

        -- --- 9. Errores & Diagnósticos (<leader>x) ---
        { "<leader>xx", desc = "Panel con todos los errores del proyecto (Trouble)" },
        { "<leader>xX", desc = "Panel de errores del archivo actual (Trouble)" },
        { "<leader>xq", desc = "Lista QuickFix de Neovim" },
        { "<leader>xt", desc = "Lista de TODOs / FIXMEs en panel" },

        -- --- 10. Archivos, Guardado y Terminal (<leader>f) ---
        { "<leader>fs", desc = "Guardar archivo actual en disco (Save)" },
        { "<leader>fn", desc = "Crear nuevo archivo vacío" },
        { "<leader>fr", desc = "Abrir archivo reciente" },
        { "<leader>ft", desc = "Abrir terminal flotante integrada" },
      },
    },
  },
}
