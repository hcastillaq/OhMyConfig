-- ==============================================================================
-- ATAJOS DE TECLADO DE USUARIO (KEYMAPS)
-- ==============================================================================
-- Atajos por defecto de LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Atajos específicos de OhMyConfig:

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

-- --- 3. Guardado rápido ---
map("n", "<leader>w", ":w<CR>", vim.tbl_extend("force", opts, { desc = "Guardar archivo" }))

-- --- 4. Limpieza de búsqueda ---
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- --- 5. Paneles de Gestión Visual (Plugins y Extras) ---
map("n", "<leader>pl", "<cmd>Lazy<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Plugins (Lazy UI)" }))
map("n", "<leader>pm", "<cmd>Mason<CR>", vim.tbl_extend("force", opts, { desc = "Gestor de Servidores (Mason UI)" }))
map("n", "<leader>px", "<cmd>LazyExtras<CR>", vim.tbl_extend("force", opts, { desc = "Activar/Desactivar Extras (LazyExtras)" }))
