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

-- --- 3. Guardado universal y gestión de ventanas ---
-- NOTA: El guardado universal se realiza con <C-s> (nativo de LazyVim en modos normal,
-- inserción y visual). <leader>w queda liberado para el menú nativo de Ventanas y Splits.
-- Se añade <leader>fs como alternativa directa para guardar bajo el menú de archivos:
map("n", "<leader>fs", "<cmd>w<CR>", vim.tbl_extend("force", opts, { desc = "Guardar archivo (Save)" }))

-- --- 4. Limpieza de búsqueda ---
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- --- 5. Paneles de Gestión Visual (Plugins y Extras) ---
map("n", "<leader>pl", "<cmd>Lazy<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Plugins (Lazy UI)" }))
map("n", "<leader>pm", "<cmd>Mason<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Servidores (Mason UI)" }))
map("n", "<leader>px", "<cmd>LazyExtras<CR>", vim.tbl_extend("force", opts, { desc = "Activar/Desactivar Extras (LazyExtras)" }))

-- --- 6. Acciones de Código y Comentarios Visibles (<leader>c) ---
-- Comentar y descomentar código fácilmente
map("n", "<leader>cc", "gcc", { remap = true, desc = "Comentar / descomentar línea" })
map("v", "<leader>cc", "gc", { remap = true, desc = "Comentar / descomentar selección" })
map("n", "<leader>cb", "gco", { remap = true, desc = "Añadir comentario en línea siguiente" })

-- Navegación de código y retorno accesible en menú Leader
map("n", "<leader>cD", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Ir a definición (gd)" }))
map("n", "<leader>cI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Ir a implementación / interfaz (gI)" }))
map("n", "<leader>cy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Ir a definición de tipo (gy)" }))
map("n", "<leader>ch", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Ver ayuda y tipos flotantes (Hover - K)" }))
map("n", "<leader>co", "<C-o>", vim.tbl_extend("force", opts, { desc = "Volver al punto anterior (Jump Back)" }))
map("n", "<leader>ci", "<C-i>", vim.tbl_extend("force", opts, { desc = "Avanzar de nuevo en el salto (Jump Forward)" }))

-- --- 7. Ventanas y Splits en Menú Leader (<leader>w) ---
map("n", "<leader>wh", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana izquierda" }))
map("n", "<leader>wj", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana inferior" }))
map("n", "<leader>wk", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana superior" }))
map("n", "<leader>wl", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Mover foco a ventana derecha" }))
map("n", "<leader>wv", "<C-w>v", vim.tbl_extend("force", opts, { desc = "Dividir pantalla verticalmente" }))
map("n", "<leader>ws", "<C-w>s", vim.tbl_extend("force", opts, { desc = "Dividir pantalla horizontalmente" }))
map("n", "<leader>w=", "<C-w>=", vim.tbl_extend("force", opts, { desc = "Balancear tamaño de ventanas" }))
map("n", "<leader>wx", "<C-w>x", vim.tbl_extend("force", opts, { desc = "Intercambiar ventana con siguiente (Swap)" }))

-- --- 8. Navegación de Buffers / Pestañas (<leader>b) ---
map("n", "<leader>bh", "<cmd>bprevious<cr>", vim.tbl_extend("force", opts, { desc = "Pestaña anterior (Shift+h)" }))
map("n", "<leader>bl", "<cmd>bnext<cr>", vim.tbl_extend("force", opts, { desc = "Pestaña siguiente (Shift+l)" }))
