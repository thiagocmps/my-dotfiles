-- Outer Wilds: The Loop ----------------------------------------------------
-- Fundo 100% preto (o vazio do espaço). Cada papel da sintaxe pertence a
-- um corpo celeste do sistema solar:
--
--   quente  = ação, tempo, fluxo de controle  (fogueira, sol, supernova)
--   frio    = estrutura, dados, nomes         (Nomai, gelo, oceano, cristal)
--   cinza   = o que fica quieto               (cinzas, poeira)
------------------------------------------------------------------------------

-- Linha do cursor: preta por padrão. Troque para true se quiser um brilho
-- bem sutil na linha atual.
local soft_cursorline = false

local c = {
	void = "#000000",

	-- Luz e cinza
	starlight = "#e6e0d0", -- texto: luz da fogueira refletida em papel
	ash = "#8d887c", -- pontuação e texto secundário (Ash Twin)
	dust = "#6c7389", -- comentários (poeira fria)
	line_nr = "#444a5e", -- números de linha
	guide = "#191c27", -- guias de indentação, separadores
	select = "#1b2236", -- seleção (noite estrelada)

	-- Quentes
	campfire = "#ff9a3c", -- keywords, fluxo de controle (Timber Hearth)
	sunlight = "#ffd479", -- constantes, parâmetros, cursor (o Sol)
	supernova = "#f2655b", -- strings (o fim do loop)
	ashtwin = "#c9a27a", -- operadores (areia da Ash Twin)

	-- Frios
	nomai = "#4fd8ee", -- funções (glifos Nomai brilhando)
	giants = "#52d6a4", -- tipos (oceano do Giant's Deep)
	hollow = "#b48cff", -- números (cristais do Brittle Hollow)
	interloper = "#9ad0ff", -- propriedades e campos (gelo do Interloper)
	eye = "#6f8cff", -- imports, macros, namespaces (Olho do Universo)
	quantum = "#ff8fd0", -- escapes e caracteres especiais (Lua Quântica)

	-- Estado
	crimson = "#ff3b5c", -- erros (distinto das strings)
	brambles = "#8fbf5a", -- ok / adicionado
}

local cursorline_bg = soft_cursorline and "#0d0e14" or c.void

local highlights = {

	------------------------------------------------------------------
	-- Editor (tudo preto; separação feita com bordas e cor de texto)
	------------------------------------------------------------------

	Normal = { fg = c.starlight, bg = c.void },
	NormalNC = { fg = c.starlight, bg = c.void },
	NormalFloat = { fg = c.starlight, bg = c.void },
	FloatBorder = { fg = c.nomai, bg = c.void },
	FloatTitle = { fg = c.sunlight, bg = c.void, bold = true },

	Cursor = { fg = c.void, bg = c.sunlight },
	lCursor = { fg = c.void, bg = c.sunlight },
	TermCursor = { fg = c.void, bg = c.sunlight },
	CursorLine = { bg = cursorline_bg },
	CursorColumn = { bg = cursorline_bg },
	ColorColumn = { bg = c.guide },
	Visual = { bg = c.select },
	VisualNOS = { bg = c.select },

	LineNr = { fg = c.line_nr },
	CursorLineNr = { fg = c.sunlight, bold = true },
	SignColumn = { bg = c.void },
	FoldColumn = { fg = c.line_nr, bg = c.void },
	Folded = { fg = c.dust, bg = c.void, italic = true },

	NonText = { fg = c.guide },
	EndOfBuffer = { fg = c.void },
	Whitespace = { fg = c.guide },
	SpecialKey = { fg = c.guide },
	Conceal = { fg = c.dust },

	VertSplit = { fg = c.guide },
	WinSeparator = { fg = c.guide },
	WinBar = { fg = c.ash, bg = c.void },
	WinBarNC = { fg = c.dust, bg = c.void },

	StatusLine = { fg = c.starlight, bg = c.void },
	StatusLineNC = { fg = c.dust, bg = c.void },
	TabLine = { fg = c.dust, bg = c.void },
	TabLineFill = { bg = c.void },
	TabLineSel = { fg = c.sunlight, bg = c.void, bold = true, underline = true, sp = c.campfire },

	Pmenu = { fg = c.starlight, bg = c.void },
	PmenuSel = { fg = c.sunlight, bg = c.select, bold = true },
	PmenuSbar = { bg = c.void },
	PmenuThumb = { bg = c.dust },
	WildMenu = { fg = c.void, bg = c.sunlight },

	Search = { fg = c.void, bg = c.sunlight },
	CurSearch = { fg = c.void, bg = c.campfire, bold = true },
	IncSearch = { fg = c.void, bg = c.campfire },
	Substitute = { fg = c.void, bg = c.crimson },
	MatchParen = { fg = c.nomai, bg = c.void, bold = true, underline = true },

	Title = { fg = c.campfire, bold = true },
	Directory = { fg = c.interloper },
	Question = { fg = c.brambles },
	MoreMsg = { fg = c.brambles },
	ModeMsg = { fg = c.sunlight },
	ErrorMsg = { fg = c.crimson },
	WarningMsg = { fg = c.campfire },

	SpellBad = { undercurl = true, sp = c.crimson },
	SpellCap = { undercurl = true, sp = c.campfire },
	SpellLocal = { undercurl = true, sp = c.nomai },
	SpellRare = { undercurl = true, sp = c.hollow },

	------------------------------------------------------------------
	-- Diff / Git (único lugar com fundo tingido, bem escuro)
	------------------------------------------------------------------

	DiffAdd = { bg = "#0a1a0e" },
	DiffChange = { bg = "#16130a" },
	DiffDelete = { bg = "#1f0a0d" },
	DiffText = { bg = "#2a230d", bold = true },
	Added = { fg = c.brambles },
	Changed = { fg = c.sunlight },
	Removed = { fg = c.crimson },

	------------------------------------------------------------------
	-- Sintaxe clássica
	------------------------------------------------------------------

	Comment = { fg = c.dust, italic = true },

	Constant = { fg = c.sunlight },
	String = { fg = c.supernova },
	Character = { fg = c.supernova },
	Number = { fg = c.hollow },
	Float = { fg = c.hollow },
	Boolean = { fg = c.campfire, bold = true },

	Identifier = { fg = c.starlight },
	Function = { fg = c.nomai },

	Statement = { fg = c.campfire },
	Keyword = { fg = c.campfire, bold = true },
	Conditional = { fg = c.campfire },
	Repeat = { fg = c.campfire },
	Label = { fg = c.campfire },
	Operator = { fg = c.ashtwin },
	Exception = { fg = c.crimson },

	Type = { fg = c.giants },
	StorageClass = { fg = c.giants },
	Structure = { fg = c.giants },
	Typedef = { fg = c.giants },

	PreProc = { fg = c.eye },
	Include = { fg = c.eye },
	Define = { fg = c.eye },
	Macro = { fg = c.eye },

	Special = { fg = c.quantum },
	SpecialChar = { fg = c.quantum },
	Delimiter = { fg = c.ash },
	Underlined = { fg = c.nomai, underline = true },

	Todo = { fg = c.void, bg = c.campfire, bold = true },
	Error = { fg = c.crimson, bold = true },

	------------------------------------------------------------------
	-- Diagnósticos (sem fundo; só cor e sublinhado ondulado)
	------------------------------------------------------------------

	DiagnosticError = { fg = c.crimson },
	DiagnosticWarn = { fg = c.campfire },
	DiagnosticInfo = { fg = c.interloper },
	DiagnosticHint = { fg = c.nomai },
	DiagnosticOk = { fg = c.brambles },

	DiagnosticUnderlineError = { undercurl = true, sp = c.crimson },
	DiagnosticUnderlineWarn = { undercurl = true, sp = c.campfire },
	DiagnosticUnderlineInfo = { undercurl = true, sp = c.interloper },
	DiagnosticUnderlineHint = { undercurl = true, sp = c.nomai },

	DiagnosticVirtualTextError = { fg = c.crimson, italic = true },
	DiagnosticVirtualTextWarn = { fg = c.campfire, italic = true },
	DiagnosticVirtualTextInfo = { fg = c.interloper, italic = true },
	DiagnosticVirtualTextHint = { fg = c.nomai, italic = true },

	LspReferenceText = { bg = c.guide },
	LspReferenceRead = { bg = c.guide },
	LspReferenceWrite = { bg = c.guide, underline = true },

	------------------------------------------------------------------
	-- Treesitter
	------------------------------------------------------------------

	["@comment"] = { fg = c.dust, italic = true },

	["@variable"] = { fg = c.starlight },
	["@variable.builtin"] = { fg = c.campfire, italic = true },
	["@variable.parameter"] = { fg = c.sunlight },
	["@variable.member"] = { fg = c.interloper },

	["@constant"] = { fg = c.sunlight },
	["@constant.builtin"] = { fg = c.campfire },

	["@string"] = { fg = c.supernova },
	["@string.documentation"] = { fg = c.supernova },
	["@string.regexp"] = { fg = c.supernova },
	["@string.escape"] = { fg = c.quantum },
	["@string.special"] = { fg = c.quantum },
	["@character"] = { fg = c.supernova },

	["@number"] = { fg = c.hollow },
	["@boolean"] = { fg = c.campfire, bold = true },

	["@function"] = { fg = c.nomai },
	["@function.call"] = { fg = c.nomai },
	["@function.builtin"] = { fg = c.nomai, bold = true },
	["@function.method"] = { fg = c.nomai },
	["@method"] = { fg = c.nomai },
	["@constructor"] = { fg = c.giants },

	["@type"] = { fg = c.giants },
	["@type.builtin"] = { fg = c.giants, italic = true },

	["@keyword"] = { fg = c.campfire, bold = true },
	["@keyword.return"] = { fg = c.campfire, bold = true },
	["@keyword.function"] = { fg = c.campfire, bold = true },
	["@keyword.import"] = { fg = c.eye },
	["@keyword.operator"] = { fg = c.ashtwin },
	["@label"] = { fg = c.campfire },

	["@operator"] = { fg = c.ashtwin },
	["@punctuation.delimiter"] = { fg = c.ash },
	["@punctuation.bracket"] = { fg = c.ash },

	["@property"] = { fg = c.interloper },
	["@field"] = { fg = c.interloper },
	["@attribute"] = { fg = c.eye },
	["@namespace"] = { fg = c.eye },
	["@module"] = { fg = c.eye },

	["@tag"] = { fg = c.campfire },
	["@tag.attribute"] = { fg = c.sunlight },
	["@tag.delimiter"] = { fg = c.ash },

	["@markup.heading"] = { fg = c.campfire, bold = true },
	["@markup.strong"] = { bold = true },
	["@markup.italic"] = { italic = true },
	["@markup.quote"] = { fg = c.dust, italic = true },
	["@markup.list"] = { fg = c.campfire },
	["@markup.link.url"] = { fg = c.nomai, underline = true },
	["@markup.raw"] = { fg = c.sunlight },

	-- Semantic tokens do LSP
	["@lsp.type.string"] = { link = "@string" },
	["@lsp.type.parameter"] = { link = "@variable.parameter" },
	["@lsp.type.property"] = { link = "@property" },

	------------------------------------------------------------------
	-- Plugins comuns
	------------------------------------------------------------------

	NeoTreeNormal = { fg = c.starlight, bg = c.void },
	NeoTreeNormalNC = { fg = c.starlight, bg = c.void },
	NeoTreeEndOfBuffer = { fg = c.void, bg = c.void },
	NeoTreeWinSeparator = { fg = c.guide, bg = c.void },
	NeoTreeFloatBorder = { fg = c.nomai, bg = c.void },
	NeoTreeCursorLine = { bg = c.select },

	NeoTreeRootName = { fg = c.sunlight, bold = true },
	NeoTreeDirectoryName = { fg = c.interloper },
	NeoTreeDirectoryIcon = { fg = c.interloper },
	NeoTreeFileName = { fg = c.starlight },
	NeoTreeDotfile = { fg = c.dust },
	NeoTreeDimText = { fg = c.dust },
	NeoTreeIndentMarker = { fg = c.guide },
	NeoTreeExpander = { fg = c.dust },

	NeoTreeGitAdded = { fg = c.brambles },
	NeoTreeGitModified = { fg = c.sunlight },
	NeoTreeGitDeleted = { fg = c.crimson },
	NeoTreeGitUntracked = { fg = c.campfire },
	NeoTreeGitIgnored = { fg = c.dust },
	NeoTreeGitConflict = { fg = c.crimson, bold = true },
	GitSignsAdd = { fg = c.brambles },
	GitSignsChange = { fg = c.sunlight },
	GitSignsDelete = { fg = c.crimson },

	IblIndent = { fg = c.guide },
	IblScope = { fg = c.dust },

	TelescopeNormal = { fg = c.starlight, bg = c.void },
	TelescopeBorder = { fg = c.nomai, bg = c.void },
	TelescopePromptTitle = { fg = c.void, bg = c.campfire, bold = true },
	TelescopeResultsTitle = { fg = c.void, bg = c.nomai, bold = true },
	TelescopePreviewTitle = { fg = c.void, bg = c.brambles, bold = true },
	TelescopeSelection = { fg = c.sunlight, bg = c.select, bold = true },
	TelescopeMatching = { fg = c.campfire, bold = true },
}

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "outerwilds-loop"

for group, settings in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, settings)
end

------------------------------------------------------------------------------
-- Cores do terminal embutido
------------------------------------------------------------------------------
vim.g.terminal_color_0 = "#1a1d29"
vim.g.terminal_color_1 = c.crimson
vim.g.terminal_color_2 = c.brambles
vim.g.terminal_color_3 = c.sunlight
vim.g.terminal_color_4 = c.eye
vim.g.terminal_color_5 = c.hollow
vim.g.terminal_color_6 = c.nomai
vim.g.terminal_color_7 = c.starlight
vim.g.terminal_color_8 = c.line_nr
vim.g.terminal_color_9 = c.supernova
vim.g.terminal_color_10 = c.giants
vim.g.terminal_color_11 = c.campfire
vim.g.terminal_color_12 = c.interloper
vim.g.terminal_color_13 = c.quantum
vim.g.terminal_color_14 = c.nomai
vim.g.terminal_color_15 = c.ash
