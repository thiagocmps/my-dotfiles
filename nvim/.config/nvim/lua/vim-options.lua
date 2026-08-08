vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.scrolloff = 12
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Binários instalados via mason.nvim (stylua, prettier, biome, ...)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.opt.updatetime = 300
vim.opt.timeoutlen = 400
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.hidden = true
vim.opt.swapfile = false

-- Completion nativa (Neovim 0.12)
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.autocomplete = true
vim.opt.pumheight = 8

local sev = vim.diagnostic.severity
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = { prefix = "❱❱", suffix = "❰❰", spacing = 2 },
	signs = {
		text = {
			[sev.ERROR] = "",
			[sev.WARN] = "",
			[sev.INFO] = "",
			[sev.HINT] = "",
		},
	},
	float = { border = "rounded", source = "if_many" },
})
