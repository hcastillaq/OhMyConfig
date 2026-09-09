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
      on_colors = function(c)
        -- Overdrive Colors (Alto Contraste y Vivacidad)
        c.bg = "#13141c"
        c.bg_dark = "#0f1016"
        c.bg_float = "#181a24"
        c.bg_highlight = "#222638"
        c.bg_popup = "#181a24"
        c.bg_search = "#50f5ff"
        c.bg_sidebar = "#0f1016"
        c.bg_statusline = "#13141c"
        c.bg_visual = "#354b8a"
        c.border = "#222638"
        c.border_highlight = "#7dcfff"
        c.fg = "#c0caf5"
        c.fg_dark = "#7a88cf"
        c.fg_float = "#c0caf5"
        c.fg_gutter = "#7a88cf"
        c.fg_sidebar = "#7a88cf"
        c.blue = "#7aa2f7"
        c.cyan = "#7dcfff"
        c.green = "#9ece6a"
        c.magenta = "#bb9af7"
        c.orange = "#ff9e64"
        c.purple = "#bb9af7"
        c.red = "#f7768e"
        c.yellow = "#e0af68"
        c.comment = "#9aa5ce"
      end,
      on_highlights = function(hl, c)
        -- Fondo del editor y columnas principales
        hl.Normal = { bg = "none" }
        hl.NormalNC = { bg = "none" }
        hl.NormalFloat = { bg = "none" }
        hl.FloatBorder = { fg = c.border_highlight, bg = "none" }
        hl.SignColumn = { bg = "none" }
        hl.StatusLine = { bg = "none" }
        hl.StatusLineNC = { bg = "none" }

        -- Selección legible sobre el fondo transparente de Ghostty
        hl.Visual = { fg = "#ffffff", bg = "#354b8a" }
        hl.VisualNOS = { fg = "#ffffff", bg = "#354b8a" }
        
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
