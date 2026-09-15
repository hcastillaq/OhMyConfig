-- ==============================================================================
-- COLORSCHEME: STATIC NOISE
-- ==============================================================================

local p = {
  void = "#0F1117",
  base = "#141720",
  raised = "#1B1F2A",
  overlay = "#202532",
  selection = "#252A38",
  border = "#343A4A",
  borderFocus = "#72EAD5",
  text = "#E6E2D6",
  textSoft = "#C9C8C2",
  muted = "#9299AE",
  disabled = "#62697B",
  cyan = "#72EAD5",
  blue = "#83BFFF",
  purple = "#C2A7FF",
  pink = "#F08BC2",
  green = "#A3D98B",
  yellow = "#EDD071",
  orange = "#F3A261",
  red = "#EF7785",
  cyanDim = "#193C3B",
  blueDim = "#20344D",
  purpleDim = "#332B4D",
  pinkDim = "#48283D",
  greenDim = "#293B2C",
  yellowDim = "#443B25",
  orangeDim = "#493124",
  redDim = "#48262E",
}

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "static-noise"
vim.o.termguicolors = true

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor Base (Transparente para heredar Ghostty)
hl("Normal", { fg = p.text, bg = "none" })
hl("NormalNC", { fg = p.textSoft, bg = "none" })
hl("NormalFloat", { fg = p.text, bg = "none" })
hl("FloatBorder", { fg = p.borderFocus, bg = "none" })
hl("FloatTitle", { fg = p.cyan, bold = true, bg = "none" })
hl("Cursor", { fg = p.void, bg = p.cyan })
hl("CursorLine", { bg = p.selection })
hl("CursorLineNr", { fg = p.cyan, bold = true })
hl("LineNr", { fg = p.disabled })
hl("SignColumn", { bg = "none" })
hl("ColorColumn", { bg = p.selection })
hl("VertSplit", { fg = p.border, bg = "none" })
hl("WinSeparator", { fg = p.border, bg = "none" })
hl("StatusLine", { fg = p.text, bg = "none" })
hl("StatusLineNC", { fg = p.muted, bg = "none" })

-- Visual Selection y Búsqueda
hl("Visual", { fg = p.text, bg = p.cyanDim })
hl("VisualNOS", { fg = p.text, bg = p.cyanDim })
hl("Search", { fg = p.yellow, bg = p.yellowDim })
hl("IncSearch", { fg = p.void, bg = p.cyan, bold = true })
hl("CurSearch", { fg = p.void, bg = p.cyan, bold = true })

-- Pmenu (Autocompletado)
hl("Pmenu", { fg = p.text, bg = p.raised })
hl("PmenuSel", { fg = p.cyan, bg = p.cyanDim, bold = true })
hl("PmenuSbar", { bg = p.overlay })
hl("PmenuThumb", { bg = p.border })

-- Sintaxis Estándar
hl("Comment", { fg = p.muted, italic = true })
hl("Constant", { fg = p.orange })
hl("String", { fg = p.green })
hl("Character", { fg = p.green })
hl("Number", { fg = p.orange })
hl("Boolean", { fg = p.orange, bold = true })
hl("Float", { fg = p.orange })
hl("Identifier", { fg = p.text })
hl("Function", { fg = p.blue, italic = true })
hl("Statement", { fg = p.pink, italic = true })
hl("Conditional", { fg = p.pink, italic = true })
hl("Repeat", { fg = p.pink, italic = true })
hl("Label", { fg = p.pink })
hl("Operator", { fg = p.cyan })
hl("Keyword", { fg = p.pink, italic = true })
hl("Exception", { fg = p.pink, bold = true })
hl("PreProc", { fg = p.purple })
hl("Include", { fg = p.pink, italic = true })
hl("Type", { fg = p.purple })
hl("StorageClass", { fg = p.purple })
hl("Structure", { fg = p.purple })
hl("Special", { fg = p.cyan })
hl("SpecialChar", { fg = p.cyan })
hl("Underlined", { underline = true })
hl("Error", { fg = p.red, bold = true })
hl("Todo", { fg = p.yellow, bold = true })

-- Treesitter
hl("@variable", { fg = p.text })
hl("@variable.builtin", { fg = p.cyan })
hl("@variable.parameter", { fg = p.textSoft })
hl("@function", { fg = p.blue, italic = true })
hl("@function.builtin", { fg = p.blue })
hl("@function.call", { fg = p.blue })
hl("@method", { fg = p.blue })
hl("@keyword", { fg = p.pink, italic = true })
hl("@keyword.function", { fg = p.pink, italic = true })
hl("@keyword.return", { fg = p.pink, italic = true })
hl("@string", { fg = p.green })
hl("@number", { fg = p.orange })
hl("@boolean", { fg = p.orange, bold = true })
hl("@type", { fg = p.purple })
hl("@type.builtin", { fg = p.purple })
hl("@property", { fg = p.yellow })
hl("@constructor", { fg = p.purple })
hl("@operator", { fg = p.cyan })
hl("@punctuation.delimiter", { fg = p.muted })
hl("@punctuation.bracket", { fg = p.textSoft })

-- Diagnósticos LSP
hl("DiagnosticError", { fg = p.red })
hl("DiagnosticWarn", { fg = p.yellow })
hl("DiagnosticInfo", { fg = p.blue })
hl("DiagnosticHint", { fg = p.cyan })
hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.cyan })

-- Git Signos y Diffs
hl("GitSignsAdd", { fg = p.green })
hl("GitSignsChange", { fg = p.orange })
hl("GitSignsDelete", { fg = p.red })
hl("DiffAdd", { bg = p.greenDim })
hl("DiffChange", { bg = p.orangeDim })
hl("DiffDelete", { bg = p.redDim })
hl("DiffText", { bg = p.blueDim })

-- Neo-tree & Snacks / Telescope
hl("NeoTreeNormal", { fg = p.text, bg = "none" })
hl("NeoTreeNormalNC", { fg = p.muted, bg = "none" })
hl("NeoTreeEndOfBuffer", { fg = p.border, bg = "none" })
hl("NeoTreeRootName", { fg = p.cyan, bold = true })
hl("NeoTreeDirectoryName", { fg = p.blue })
hl("NeoTreeDirectoryIcon", { fg = p.blue })
hl("NeoTreeGitAdded", { fg = p.green })
hl("NeoTreeGitModified", { fg = p.orange })
hl("NeoTreeGitDeleted", { fg = p.red })
hl("TelescopeNormal", { fg = p.text, bg = "none" })
hl("TelescopeBorder", { fg = p.borderFocus, bg = "none" })
hl("SnacksPickerNormal", { fg = p.text, bg = "none" })
hl("SnacksPickerNormalNC", { fg = p.textSoft, bg = "none" })
hl("WhichKey", { fg = p.cyan })
hl("WhichKeyGroup", { fg = p.purple })
hl("WhichKeyDesc", { fg = p.text })
