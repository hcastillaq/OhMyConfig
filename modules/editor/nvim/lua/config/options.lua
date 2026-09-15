-- ==============================================================================
-- OPCIONES DE USUARIO (VIM.OPT)
-- ==============================================================================
-- Opciones por defecto de LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Ajustes específicos de OhMyConfig:

local opt = vim.opt

opt.number = true             -- Número de línea actual
opt.relativenumber = true     -- Números de línea relativos para saltos rápidos
opt.undofile = true           -- Historial de deshacer (undo) persistente en disco
opt.undolevels = 10000        -- Cantidad de pasos de deshacer recordados
opt.scrolloff = 8             -- Margen de 8 líneas al scrollear verticalmente
opt.sidescrolloff = 8         -- Margen de 8 columnas al scrollear horizontalmente
opt.clipboard = "unnamedplus" -- Sincronización con portapapeles del sistema
