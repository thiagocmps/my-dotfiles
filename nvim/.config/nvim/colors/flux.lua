-- ============================================================================
-- Outer Wilds
-- A Neovim colorscheme inspired by Outer Wilds.
-- Deep space background with warm campfire accents and Nomai technology.
-- ============================================================================

local c = {
	------------------------------------------------------------------
	-- Background
	------------------------------------------------------------------

	bg = "#09090b",
	bg_alt = "#111114",
	bg_light = "#1b1b20",

	------------------------------------------------------------------
	-- Foreground
	------------------------------------------------------------------
	text = "#d8d2c4",
	-- text = "#ebe7dc",
	text_dim = "#c8c3b7",
	comment = "#707c94",

	------------------------------------------------------------------
	-- Outer Wilds palette
	------------------------------------------------------------------

	fire = "#f28c28",
	ember = "#ff6d3a",

	sun = "#ffd166",

	grass = "#97c96b",

	nomai = "#59d8ff",

	deep_space = "#74a7ff",

	crystal = "#B48CFF",

	quantum = "#ff82c8",

	danger = "#ff5d62",

	selection = "#23283d",

	cursor = "#ffd166",
}

local highlights = {

	------------------------------------------------------------------
	-- Editor
	------------------------------------------------------------------

	Normal = { fg = c.text, bg = c.bg },

	NormalFloat = {
		fg = c.text,
		bg = c.bg_alt,
	},

	FloatBorder = {
		fg = c.deep_space,
		bg = c.bg_alt,
	},

	CursorLine = {
		bg = c.bg_alt,
	},

	CursorColumn = {
		bg = c.bg_alt,
	},

	ColorColumn = {
		bg = c.bg_alt,
	},

	Visual = {
		bg = c.selection,
	},

	LineNr = {
		fg = c.comment,
	},

	CursorLineNr = {
		fg = c.sun,
		bold = true,
	},

	SignColumn = {
		bg = c.bg,
	},

	VertSplit = {
		fg = c.bg_light,
	},

	WinSeparator = {
		fg = c.bg_light,
	},

	StatusLine = {
		bg = c.bg_light,
		fg = c.text,
	},

	StatusLineNC = {
		bg = c.bg_alt,
		fg = c.comment,
	},

	Pmenu = {
		bg = c.bg_alt,
		fg = c.text,
	},

	PmenuSel = {
		bg = c.nomai,
		fg = c.bg,
		bold = true,
	},

	Search = {
		bg = c.sun,
		fg = c.bg,
	},

	IncSearch = {
		bg = c.fire,
		fg = c.bg,
	},

	MatchParen = {
		bg = c.nomai,
		fg = c.bg,
		bold = true,
	},

	------------------------------------------------------------------
	-- Standard Syntax
	------------------------------------------------------------------

	Comment = {
		fg = c.comment,
		italic = true,
	},

	Constant = {
		fg = c.sun,
	},

	String = {
		fg = c.grass,
	},

	Character = {
		fg = c.grass,
	},

	Number = {
		fg = c.crystal,
	},

	Boolean = {
		fg = c.fire,
		bold = true,
	},

	Float = {
		fg = c.crystal,
	},

	Identifier = {
		fg = c.text,
	},

	Function = {
		fg = c.deep_space,
		bold = true,
	},

	Statement = {
		fg = c.fire,
	},

	Keyword = {
		fg = c.fire,
		bold = true,
	},

	Conditional = {
		fg = c.fire,
	},

	Repeat = {
		fg = c.fire,
	},

	Label = {
		fg = c.fire,
	},

	Operator = {
		fg = c.ember,
	},

	Exception = {
		fg = c.danger,
	},

	Type = {
		fg = c.quantum,
		bold = true,
	},

	StorageClass = {
		fg = c.quantum,
	},

	Structure = {
		fg = c.quantum,
	},

	Typedef = {
		fg = c.quantum,
	},

	PreProc = {
		fg = c.nomai,
	},

	Include = {
		fg = c.nomai,
	},

	Define = {
		fg = c.nomai,
	},

	Macro = {
		fg = c.nomai,
	},

	Special = {
		fg = c.nomai,
	},

	SpecialChar = {
		fg = c.nomai,
	},

	Delimiter = {
		fg = c.text_dim,
	},

	Todo = {
		bg = c.sun,
		fg = c.bg,
		bold = true,
	},

	Error = {
		fg = c.danger,
		bold = true,
	},

	ErrorMsg = {
		fg = c.danger,
	},

	WarningMsg = {
		fg = c.fire,
	},

	------------------------------------------------------------------
	-- Diagnostics
	------------------------------------------------------------------

	DiagnosticError = { fg = c.danger },
	DiagnosticWarn = { fg = c.fire },
	DiagnosticInfo = { fg = c.deep_space },
	DiagnosticHint = { fg = c.nomai },
	DiagnosticOk = { fg = c.grass },

	------------------------------------------------------------------
	-- Treesitter
	------------------------------------------------------------------

	["@comment"] = {
		fg = c.comment,
		italic = true,
	},

	["@variable"] = {
		fg = c.text,
	},

	["@variable.parameter"] = {
		fg = c.sun,
	},

	["@variable.member"] = {
		fg = c.crystal,
	},

	["@constant"] = {
		fg = c.sun,
	},

	["@constant.builtin"] = {
		fg = c.fire,
	},

	["@string"] = {
		fg = c.danger,
	},

	["@number"] = {
		fg = c.crystal,
	},

	["@boolean"] = {
		fg = c.fire,
		bold = true,
	},

	["@function"] = {
		fg = c.deep_space,
		bold = true,
	},

	["@function.builtin"] = {
		fg = c.nomai,
	},

	["@function.call"] = {
		fg = c.deep_space,
	},

	["@method"] = {
		fg = c.deep_space,
	},

	["@constructor"] = {
		fg = c.nomai,
	},

	["@type"] = {
		fg = c.quantum,
	},

	["@type.builtin"] = {
		fg = c.fire,
	},

	["@keyword"] = {
		fg = c.fire,
		bold = true,
	},

	["@keyword.return"] = {
		fg = c.fire,
		bold = true,
	},

	["@keyword.function"] = {
		fg = c.fire,
		bold = true,
	},

	["@operator"] = {
		fg = c.ember,
	},

	["@property"] = {
		fg = c.nomai,
	},

	["@field"] = {
		fg = c.nomai,
	},

	["@namespace"] = {
		fg = c.deep_space,
	},

	["@module"] = {
		fg = c.deep_space,
	},

	["@tag"] = {
		fg = c.fire,
	},

	["@tag.attribute"] = {
		fg = c.sun,
	},

	["@tag.delimiter"] = {
		fg = c.comment,
	},
}

vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "outerwilds"

for group, settings in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, settings)
end
