-- ==============================================================================
-- PERSONALIZACIÓN DEL EXPLORADOR (NEO-TREE & SNACKS)
-- ==============================================================================
-- Define símbolos claros y nítidos para el estado de Git, eliminando glifos con recuadros vacíos.

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        git_status = {
          symbols = {
            -- Tipo de cambio
            added     = "+",
            modified  = "●",
            deleted   = "✖",
            renamed   = "➜",
            -- Estado de Git en el árbol
            untracked = "?",
            ignored   = "◌",
            unstaged  = "●",
            staged    = "✓",
            conflict  = "⚡",
          },
        },
      },
    },
  },
}
