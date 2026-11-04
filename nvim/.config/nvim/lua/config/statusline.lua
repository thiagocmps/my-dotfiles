-- ==========================================
-- APERTURE INTERFACES | CUSTOM STATUSLINE
-- ==========================================

vim.o.laststatus = 3
vim.o.showmode = false

-- Paleta
local colors = {
	bg = "#000000",
	surface = "#000000",
	purple = "#B000FF",
	green = "#39FF14",
	white = "#FFFFFF",
	red = "#FF4444",
	yellow = "#FFD700",
	cyan = "#00D7FF",
}

-- Highlight groups/
local highlights = {
	StatusNormal = { fg = colors.bg, bg = colors.purple, bold = true },
	StatusInsert = { fg = colors.bg, bg = colors.green, bold = true },
	StatusVisual = { fg = colors.bg, bg = colors.cyan, bold = true },
	StatusReplace = { fg = colors.bg, bg = colors.red, bold = true },

	StatusLine = { fg = "#FFFFFF", bg = "#000000" },
	StatusLineNC = { fg = "#777777", bg = "#000000" },
	Normal = { fg = "#FFFFFF", bg = "#000000" },
	NormalNC = { fg = "#FFFFFF", bg = "#000000" },

	StatusFile = { fg = colors.white, bg = colors.surface },
	StatusMuted = { fg = "#777777", bg = "#000000" },
	StatusGit = { fg = colors.green, bg = colors.surface, bold = true },
	StatusLsp = { fg = colors.cyan, bg = colors.surface },
	StatusWarning = { fg = colors.yellow, bg = colors.surface },
	StatusError = { fg = colors.red, bg = colors.surface },
	StatusPosition = { fg = colors.purple, bg = colors.surface, bold = true },
}

local function set_highlights()
	for name, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

set_highlights()

-- Reaplicar após mudança de colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_highlights,
})

-- ==========================================
-- MODE
-- ==========================================

local modes = {
	n = { " NORMAL ", "StatusNormal" },
	i = { " INSERT ", "StatusInsert" },
	v = { " VISUAL ", "StatusVisual" },
	V = { " V-LINE ", "StatusVisual" },
	["\22"] = { " V-BLOCK ", "StatusVisual" },
	c = { " COMMAND ", "StatusNormal" },
	R = { " REPLACE ", "StatusReplace" },
	r = { " PROMPT ", "StatusNormal" },
	s = { " SELECT ", "StatusVisual" },
	S = { " S-LINE ", "StatusVisual" },
	t = { " TERMINAL ", "StatusInsert" },
}

local function get_mode()
	local mode = vim.api.nvim_get_mode().mode
	local info = modes[mode] or { " " .. mode:upper() .. " ", "StatusNormal" }

	return "%#" .. info[2] .. "#" .. info[1] .. "%*"
end

-- ==========================================
-- GIT
-- ==========================================

local function get_git()
	local branch = vim.b.gitsigns_head

	if not branch or branch == "" then
		return ""
	end

	return "%#StatusGit# 󰊢 " .. branch .. "%*"
end

-- ==========================================
-- LSP
-- ==========================================

local function get_lsp()
	local clients = vim.lsp.get_clients({
		bufnr = 0,
	})

	if #clients == 0 then
		return ""
	end

	return "%#StatusLsp# LSP%*"
end

-- ==========================================
-- DIAGNOSTICS
-- ==========================================

local function get_diagnostics()
	local diagnostics = vim.diagnostic.count(0)

	local errors = diagnostics[vim.diagnostic.severity.ERROR] or 0
	local warnings = diagnostics[vim.diagnostic.severity.WARN] or 0

	local result = {}

	if errors > 0 then
		table.insert(result, "%#StatusError# 󰅚 " .. errors .. "%*")
	end

	if warnings > 0 then
		table.insert(result, "%#StatusWarning# 󰀪 " .. warnings .. "%*")
	end

	return table.concat(result, " ")
end

-- ==========================================
-- FILE
-- ==========================================

local function get_file()
	local name = vim.fn.expand("%:t")

	if name == "" then
		name = "[No Name]"
	end

	local modified = vim.bo.modified and " [+]" or ""
	local readonly = vim.bo.readonly and " [RO]" or ""

	return "%#StatusFile#  " .. name .. modified .. readonly .. " %*"
end

-- ==========================================
-- FILE INFO
-- ==========================================

local function get_filetype()
	local ft = vim.bo.filetype

	if ft == "" then
		return "TEXT"
	end

	return ft:upper()
end

local function get_position()
	local line = vim.fn.line(".")
	local total = vim.fn.line("$")
	local col = vim.fn.col(".")

	local percentage = math.floor((line / math.max(total, 1)) * 100)

	return string.format(" %d:%d  %d%% ", line, col, percentage)
end

-- ==========================================
-- MAIN STATUSLINE
-- ==========================================

function MyStatusLine()
	local parts = {
		get_mode(),
		get_file(),
		"%=",

		get_git(),
		" ",
		get_lsp(),
		" ",
		get_diagnostics(),

		"%#StatusMuted# " .. get_filetype() .. " %*",
		"%#StatusPosition#" .. get_position() .. "%*",
	}

	return table.concat(parts)
end

vim.o.statusline = "%{%v:lua.MyStatusLine()%}"
