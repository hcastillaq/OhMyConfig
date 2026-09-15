-- ==============================================================================
-- ATAJOS DE TECLADO DE USUARIO (KEYMAPS)
-- ==============================================================================
-- Atajos por defecto de LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Atajos específicos y centro de control ergonómico de OhMyConfig:

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- --- 1. Navegación fluida entre splits (Control + hjkl) ---
map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Ir a split izquierdo" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Ir a split inferior" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Ir a split superior" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Ir a split derecho" }))

-- --- 2. Redimensionar splits con flechas (Control + Flechas) ---
map("n", "<C-Up>", ":resize +2<CR>", vim.tbl_extend("force", opts, { desc = "Aumentar alto de split" }))
map("n", "<C-Down>", ":resize -2<CR>", vim.tbl_extend("force", opts, { desc = "Reducir alto de split" }))
map("n", "<C-Left>", ":vertical resize -2<CR>", vim.tbl_extend("force", opts, { desc = "Reducir ancho de split" }))
map("n", "<C-Right>", ":vertical resize +2<CR>", vim.tbl_extend("force", opts, { desc = "Aumentar ancho de split" }))

-- --- 3. Guardado universal y portapapeles seguro ---
-- NOTA: El guardado universal se realiza con <C-s> (nativo de LazyVim en modos normal,
-- inserción y visual). Se mantiene <leader>fs bajo el menú de archivos:
map("n", "<leader>fs", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Guardar archivo (Save)" }))

-- Pegado no destructivo en selección visual (no sobreescribe el registro copiado)
map("x", "p", "P", vim.tbl_extend("force", opts, { desc = "Pegar sin sobreescribir portapapeles" }))

-- --- 4. Limpieza de búsqueda ---
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- --- 5. Paneles de Gestión Visual (Plugins y Extras) ---
map("n", "<leader>pl", "<cmd>Lazy<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Plugins (Lazy UI)" }))
map("n", "<leader>pm", "<cmd>Mason<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Servidores (Mason UI)" }))
map("n", "<leader>px", "<cmd>LazyExtras<CR>", vim.tbl_extend("force", opts, { desc = "Activar/Desactivar Extras (LazyExtras)" }))

-- --- 6. Menú de Búsqueda (<leader>s) ---
-- Proporciona acceso rápido a archivos, texto, símbolos y buffers
map("n", "<leader>sf", function()
  LazyVim.pick("files")()
end, vim.tbl_extend("force", opts, { desc = "Buscar archivos en proyecto" }))

map("n", "<leader>sg", function()
  LazyVim.pick("live_grep")()
end, vim.tbl_extend("force", opts, { desc = "Buscar texto en proyecto (Live Grep)" }))

map("n", "<leader>sw", function()
  LazyVim.pick("grep_word")()
end, vim.tbl_extend("force", opts, { desc = "Buscar palabra bajo cursor en proyecto" }))

map("n", "<leader>ss", function()
  LazyVim.pick("lsp_symbols")()
end, vim.tbl_extend("force", opts, { desc = "Buscar símbolos en este archivo" }))

map("n", "<leader>sS", function()
  LazyVim.pick("lsp_workspace_symbols")()
end, vim.tbl_extend("force", opts, { desc = "Buscar símbolos en todo el proyecto" }))

map("n", "<leader>sb", function()
  LazyVim.pick("buffers")()
end, vim.tbl_extend("force", opts, { desc = "Buscar buffers abiertos" }))

map("n", "<leader>s/", function()
  LazyVim.pick("lines")()
end, vim.tbl_extend("force", opts, { desc = "Buscar líneas en buffer actual" }))

map("n", "<leader>st", function()
  LazyVim.pick("todo")()
end, vim.tbl_extend("force", opts, { desc = "Buscar comentarios TODO / FIXME" }))

-- --- 7. Menú de Reemplazo (<leader>r) ---
-- Panel interactivo de Search & Replace estilo VSCode con Grug-Far
map({ "n", "v" }, "<leader>rp", function()
  local ok, grug = pcall(require, "grug-far")
  if ok then
    grug.open()
  else
    vim.notify("Grug-Far no está disponible", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Reemplazar en proyecto (Grug-Far)" }))

map("n", "<leader>rw", function()
  local ok, grug = pcall(require, "grug-far")
  if ok then
    grug.open({ prefills = { search = vim.fn.expand("<cword>") } })
  else
    vim.notify("Grug-Far no está disponible", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Reemplazar palabra actual en proyecto" }))

map("v", "<leader>rw", function()
  local ok, grug = pcall(require, "grug-far")
  if ok then
    grug.with_visual_selection()
  else
    vim.notify("Grug-Far no está disponible", vim.log.levels.WARN)
  end
end, vim.tbl_extend("force", opts, { desc = "Reemplazar selección actual en proyecto" }))

map("n", "<leader>rb", ":%s///gc<Left><Left><Left><Left>", { desc = "Reemplazar en archivo actual (confirmar)" })
map("v", "<leader>rb", ":s///gc<Left><Left><Left><Left>", { desc = "Reemplazar en selección (confirmar)" })

-- --- 8. Acciones de Código (<leader>c) ---
-- QuickFix / Code Actions
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Acciones de código (Quick Fix)" }))
map("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Renombrar símbolo en proyecto" }))
map("n", "<leader>cf", function()
  LazyVim.format({ force = true })
end, vim.tbl_extend("force", opts, { desc = "Formatear archivo de código" }))

-- Diagnósticos de proyecto en <leader>cx
map("n", "<leader>cx", function()
  if pcall(require, "trouble") then
    vim.cmd("Trouble diagnostics toggle")
  else
    LazyVim.pick("diagnostics")()
  end
end, vim.tbl_extend("force", opts, { desc = "Panel de errores y diagnósticos" }))

-- Navegación de código accesible en menú Leader
map("n", "<leader>cD", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Ir a definición (gd)" }))
map("n", "<leader>cI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Ir a implementación / interfaz (gI)" }))
map("n", "<leader>cy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Ir a definición de tipo (gy)" }))
map("n", "<leader>ch", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Ver ayuda y tipos flotantes (Hover - K)" }))
map("n", "<leader>cn", "<cmd>Neogen<cr>", vim.tbl_extend("force", opts, { desc = "Generar docstring (Neogen)" }))

-- --- 9. Ventanas y Splits en Menú Leader (<leader>w) ---
map("n", "<leader>wh", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana izquierda" }))
map("n", "<leader>wj", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana inferior" }))
map("n", "<leader>wk", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana superior" }))
map("n", "<leader>wl", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana derecha" }))
map("n", "<leader>wv", "<C-w>v", vim.tbl_extend("force", opts, { desc = "Dividir pantalla verticalmente" }))
map("n", "<leader>ws", "<C-w>s", vim.tbl_extend("force", opts, { desc = "Dividir pantalla horizontalmente" }))
map("n", "<leader>w=", "<C-w>=", vim.tbl_extend("force", opts, { desc = "Balancear tamaño de ventanas" }))
map("n", "<leader>wx", "<C-w>x", vim.tbl_extend("force", opts, { desc = "Intercambiar ventana con siguiente (Swap)" }))
