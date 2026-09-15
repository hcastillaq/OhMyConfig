-- ==============================================================================
-- TEMA VISUAL: STATIC NOISE (CONFIGURACIÓN LAZYVIM)
-- ==============================================================================

return {
  {
    "hcastillaq/static-noise.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "static-noise",
    },
  },
}
