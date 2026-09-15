-- ==============================================================================
-- GENERADOR DE DOCUMENTACIÓN INTELIGENTE: NEOGEN
-- ==============================================================================
-- Analiza el AST de Treesitter y genera docstrings estructurados (JSDoc, TSDoc,
-- Google Docstrings, LuaDoc) con parámetros, tipos y retornos automáticamente.

return {
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate()
        end,
        desc = "Generar documentación de función/método",
      },
      {
        "<leader>cnc",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Generar documentación de clase",
      },
      {
        "<leader>cnt",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Generar documentación de tipo / interfaz",
      },
      {
        "<leader>cnF",
        function()
          require("neogen").generate({ type = "file" })
        end,
        desc = "Generar encabezado de archivo",
      },
    },
    opts = {
      snippet_engine = "nvim", -- Usa el motor de snippets nativo de Neovim
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua", -- Genera ---@param, ---@return
          },
        },
        python = {
          template = {
            annotation_convention = "google_docstrings", -- Genera Args:, Returns:
          },
        },
        typescript = {
          template = {
            annotation_convention = "tsdoc", -- Genera @param, @returns
          },
        },
        typescriptreact = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
        javascript = {
          template = {
            annotation_convention = "jsdoc",
          },
        },
        javascriptreact = {
          template = {
            annotation_convention = "jsdoc",
          },
        },
      },
    },
  },
}
