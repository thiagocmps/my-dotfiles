-- Outer Wilds (retro) ------------------------------------------------------
-- Preto quente de monitor antigo, texto cor de papel envelhecido,
-- cores dessaturadas (fogueira, Nomai, sol) para não cansar a vista.
------------------------------------------------------------------------------

local c = {
	------------------------------------------------------------------
	-- Background (marrom-preto quente, nunca preto puro)
	------------------------------------------------------------------
	bg = "#000000",
	bg_alt = "#000000",
	bg_light = "#000000",
	bg_float = "#000000",
	selection = "#000000",
	guide = "#000000",

	------------------------------------------------------------------
	-- Foreground (papel envelhecido)
	------------------------------------------------------------------
	text = "#d6cbb2",
	text_dim = "#b0a58d",
	comment = "#80745f",
	line_nr = "#5f5546",

	------------------------------------------------------------------
	-- Paleta Outer Wilds (dessaturada)
	------------------------------------------------------------------
	fire = "#e0913a", -- fogueira / âmbar de fósforo
	ember = "#d9703f", -- brasa
	sun = "#e8c46a", -- sol
	grass = "#9ab86c", -- Timber Hearth
	nomai = "#62c4cc", -- escrita Nomai
	deep_space = "#7f9fd4", -- espaço profundo
	crystal = "#b496d6", -- cristal
	quantum = "#d98fb7", -- quântico
	danger = "#e05a55", -- erros
	string = "#d9665e", -- strings (vermelho suave, distinto dos erros)

	cursor = "#e8c46a",
}

local highlights = {

	------------------------------------------------------------------
	-- Editor
	------------------------------------------------------------------

	Normal = { fg = c.text, bg = c.bg },
	NormalNC = { fg = c.text, bg = c.bg },
	NormalFloat = { fg = c.text, bg = c.bg_float },
	FloatBorder = { fg = c.fire, bg = c.bg_float },
	FloatTitle = { fg = c.sun, bg = c.bg_float, bold = true },

	Cursor = { fg = c.bg, bg = c.cursor },
	lCursor = { fg = c.bg, bg = c.cursor },
	TermCursor = { fg = c.bg, bg = c.cursor },
	CursorLine = { bg = c.bg_alt },
	CursorColumn = { bg = c.bg_alt },
	ColorColumn = { bg = c.bg_alt },
	Visual = { bg = c.selection },
	VisualNOS = { bg = c.selection },

	LineNr = { fg = c.line_nr },
	CursorLineNr = { fg = c.sun, bold = true },
	SignColumn = { bg = c.bg },
	FoldColumn = { fg = c.line_nr, bg = c.bg },
	Folded = { fg = c.comment, bg = c.bg_alt, italic = true },

	NonText = { fg = c.guide },
	EndOfBuffer = { fg = c.bg },
	Whitespace = { fg = c.guide },
	SpecialKey = { fg = c.guide },
	Conceal = { fg = c.comment },

	VertSplit = { fg = c.bg_light },
	WinSeparator = { fg = c.bg_light },
	WinBar = { fg = c.text_dim, bg = c.bg },
	WinBarNC = { fg = c.comment, bg = c.bg },

	StatusLine = { fg = c.text, bg = c.bg_light },
	StatusLineNC = { fg = c.comment, bg = c.bg_alt },
	TabLine = { fg = c.comment, bg = c.bg_alt },
	TabLineFill = { bg = c.bg_alt },
	TabLineSel = { fg = c.sun, bg = c.bg_light, bold = true },

	Pmenu = { fg = c.text, bg = c.bg_float },
	PmenuSel = { fg = c.sun, bg = c.selection, bold = true },
	PmenuSbar = { bg = c.bg_light },
	PmenuThumb = { bg = c.comment },
	WildMenu = { fg = c.bg, bg = c.sun },

	Search = { fg = c.bg, bg = c.sun },
	CurSearch = { fg = c.bg, bg = c.fire, bold = true },
	IncSearch = { fg = c.bg, bg = c.fire },
	Substitute = { fg = c.bg, bg = c.danger },
	MatchParen = { fg = c.nomai, bg = c.bg_light, bold = true, underline = true },

	Title = { fg = c.fire, bold = true },
	Directory = { fg = c.deep_space },
	Question = { fg = c.grass },
	MoreMsg = { fg = c.grass },
	ModeMsg = { fg = c.sun },
	ErrorMsg = { fg = c.danger },
	WarningMsg = { fg = c.fire },

	SpellBad = { undercurl = true, sp = c.danger },
	SpellCap = { undercurl = true, sp = c.fire },
	SpellLocal = { undercurl = true, sp = c.nomai },
	SpellRare = { undercurl = true, sp = c.crystal },

	------------------------------------------------------------------
	-- Diff / Git
	------------------------------------------------------------------

	DiffAdd = { bg = "#232b1a" },
	DiffChange = { bg = "#2b2a1b" },
	DiffDelete = { bg = "#35201d" },
	DiffText = { bg = "#403a20", bold = true },
	Added = { fg = c.grass },
	Changed = { fg = c.sun },
	Removed = { fg = c.danger },

	------------------------------------------------------------------
	-- Standard Syntax
	------------------------------------------------------------------

	Comment = { fg = c.comment, italic = true },

	Constant = { fg = c.sun },
	String = { fg = c.string },
	Character = { fg = c.string },
	Number = { fg = c.crystal },
	Float = { fg = c.crystal },
	Boolean = { fg = c.fire, bold = true },

	Identifier = { fg = c.text },
	Function = { fg = c.deep_space },

	Statement = { fg = c.fire },
	Keyword = { fg = c.fire, bold = true },
	Conditional = { fg = c.fire },
	Repeat = { fg = c.fire },
	Label = { fg = c.fire },
	Operator = { fg = c.ember },
	Exception = { fg = c.danger },

	Type = { fg = c.quantum },
	StorageClass = { fg = c.quantum },
	Structure = { fg = c.quantum },
	Typedef = { fg = c.quantum },

	PreProc = { fg = c.nomai },
	Include = { fg = c.nomai },
	Define = { fg = c.nomai },
	Macro = { fg = c.nomai },

	Special = { fg = c.nomai },
	SpecialChar = { fg = c.nomai },
	Delimiter = { fg = c.text_dim },
	Underlined = { fg = c.nomai, underline = true },

	Todo = { fg = c.bg, bg = c.sun, bold = true },
	Error = { fg = c.danger, bold = true },

	------------------------------------------------------------------
	-- Diagnostics
	------------------------------------------------------------------

	DiagnosticError = { fg = c.danger },
	DiagnosticWarn = { fg = c.fire },
	DiagnosticInfo = { fg = c.deep_space },
	DiagnosticHint = { fg = c.nomai },
	DiagnosticOk = { fg = c.grass },

	DiagnosticUnderlineError = { undercurl = true, sp = c.danger },
	DiagnosticUnderlineWarn = { undercurl = true, sp = c.fire },
	DiagnosticUnderlineInfo = { undercurl = true, sp = c.deep_space },
	DiagnosticUnderlineHint = { undercurl = true, sp = c.nomai },

	DiagnosticVirtualTextError = { fg = c.danger, bg = "#271a17" },
	DiagnosticVirtualTextWarn = { fg = c.fire, bg = "#271e15" },
	DiagnosticVirtualTextInfo = { fg = c.deep_space, bg = "#1a1e26" },
	DiagnosticVirtualTextHint = { fg = c.nomai, bg = "#16221f" },

	LspReferenceText = { bg = c.bg_light },
	LspReferenceRead = { bg = c.bg_light },
	LspReferenceWrite = { bg = c.bg_light, underline = true },

	------------------------------------------------------------------
	-- Treesitter
	------------------------------------------------------------------

	["@comment"] = { fg = c.comment, italic = true },

	["@variable"] = { fg = c.text },
	["@variable.builtin"] = { fg = c.fire, italic = true },
	["@variable.parameter"] = { fg = c.sun },
	["@variable.member"] = { fg = c.crystal },

	["@constant"] = { fg = c.sun },
	["@constant.builtin"] = { fg = c.fire },

	["@string"] = { fg = c.string },
	["@string.documentation"] = { fg = c.string },
	["@string.regexp"] = { fg = c.string },
	["@string.escape"] = { fg = c.nomai },
	["@string.special"] = { fg = c.nomai },
	["@character"] = { fg = c.string },

	["@number"] = { fg = c.crystal },
	["@boolean"] = { fg = c.fire, bold = true },

	["@function"] = { fg = c.deep_space },
	["@function.builtin"] = { fg = c.nomai },
	["@function.call"] = { fg = c.deep_space },
	["@function.method"] = { fg = c.deep_space },
	["@method"] = { fg = c.deep_space },
	["@constructor"] = { fg = c.nomai },

	["@type"] = { fg = c.quantum },
	["@type.builtin"] = { fg = c.fire },

	["@keyword"] = { fg = c.fire, bold = true },
	["@keyword.return"] = { fg = c.fire, bold = true },
	["@keyword.function"] = { fg = c.fire, bold = true },

	["@operator"] = { fg = c.ember },
	["@punctuation.delimiter"] = { fg = c.text_dim },
	["@punctuation.bracket"] = { fg = c.text_dim },

	["@property"] = { fg = c.nomai },
	["@field"] = { fg = c.nomai },
	["@attribute"] = { fg = c.nomai },
	["@namespace"] = { fg = c.deep_space },
	["@module"] = { fg = c.deep_space },

	["@tag"] = { fg = c.fire },
	["@tag.attribute"] = { fg = c.sun },
	["@tag.delimiter"] = { fg = c.comment },

	["@markup.heading"] = { fg = c.fire, bold = true },
	["@markup.strong"] = { bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.link.url"] = { fg = c.nomai, underline = true },
	["@markup.raw"] = { fg = c.sun },

	-- Semantic tokens do LSP
	["@lsp.type.string"] = { link = "@string" },
	["@lsp.type.parameter"] = { link = "@variable.parameter" },
	["@lsp.type.property"] = { link = "@property" },

	------------------------------------------------------------------
	-- Plugins comuns
	------------------------------------------------------------------

	GitSignsAdd = { fg = c.grass },
	GitSignsChange = { fg = c.sun },
	GitSignsDelete = { fg = c.danger },

	IblIndent = { fg = c.guide },
	IblScope = { fg = c.comment },

	TelescopeNormal = { fg = c.text, bg = c.bg_float },
	TelescopeBorder = { fg = c.fire, bg = c.bg_float },
	TelescopePromptTitle = { fg = c.bg, bg = c.fire, bold = true },
	TelescopeResultsTitle = { fg = c.bg, bg = c.nomai, bold = true },
	TelescopePreviewTitle = { fg = c.bg, bg = c.grass, bold = true },
	TelescopeSelection = { fg = c.sun, bg = c.selection, bold = true },
	TelescopeMatching = { fg = c.fire, bold = true },
}

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "outerwilds"

for group, settings in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, settings)
end

------------------------------------------------------------------------------
-- Cores do terminal embutido
------------------------------------------------------------------------------
vim.g.terminal_color_0 = c.bg_light
vim.g.terminal_color_1 = c.danger
vim.g.terminal_color_2 = c.grass
vim.g.terminal_color_3 = c.sun
vim.g.terminal_color_4 = c.deep_space
vim.g.terminal_color_5 = c.quantum
vim.g.terminal_color_6 = c.nomai
vim.g.terminal_color_7 = c.text
vim.g.terminal_color_8 = c.line_nr
vim.g.terminal_color_9 = c.ember
vim.g.terminal_color_10 = c.grass
vim.g.terminal_color_11 = c.fire
vim.g.terminal_color_12 = c.deep_space
vim.g.terminal_color_13 = c.crystal
vim.g.terminal_color_14 = c.nomai
vim.g.terminal_color_15 = c.text_dim
