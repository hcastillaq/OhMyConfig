-- ==============================================================================
-- TEMA VISUAL: TOKYONIGHT NIGHT (CON TRANSPARENCIA ADAPTATIVA)
-- ==============================================================================
-- Se adapta automáticamente a la transparencia y desenfoque (blur) de Ghostty.

return {
  -- 1. Indicar a LazyVim que use tokyonight-night como tema por defecto
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- 2. Configurar Tokyonight con fondo transparente y paneles integrados
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true, -- Habilita fondo transparente para heredar el de Ghostty
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "transparent", -- Exploradores y paneles laterales transparentes
        floats = "transparent",   -- Ventanas flotantes, Which-Key y Telescope transparentes
      },
      on_highlights = function(hl, c)
        -- Fondo del editor y columnas principales
        hl.Normal = { bg = "none" }
        hl.NormalNC = { bg = "none" }
        hl.NormalFloat = { bg = "none" }
        hl.FloatBorder = { fg = c.border_highlight, bg = "none" }
        hl.SignColumn = { bg = "none" }
        hl.StatusLine = { bg = "none" }
        hl.StatusLineNC = { bg = "none" }
        
        -- Paneles laterales (Neo-Tree y exploradores)
        hl.NeoTreeNormal = { bg = "none" }
        hl.NeoTreeNormalNC = { bg = "none" }
        hl.NeoTreeEndOfBuffer = { bg = "none" }
        
        -- Ventanas de búsqueda flotantes
        hl.TelescopeNormal = { bg = "none" }
        hl.TelescopeBorder = { fg = c.border_highlight, bg = "none" }
        hl.SnacksPickerNormal = { bg = "none" }
        hl.SnacksPickerNormalNC = { bg = "none" }
      end,
    },
  },
}
