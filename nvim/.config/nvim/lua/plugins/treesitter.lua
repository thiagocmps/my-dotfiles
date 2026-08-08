return {
	"neovim-treesitter/nvim-treesitter",
	dependencies = { "neovim-treesitter/treesitter-parser-registry" },
	lazy = false,
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").install({
			"lua",
			"vim",
			"vimdoc",
			"query",
			"python",
			"c",
			"json",
			"xml",
			"yaml",
			"javascript",
			"typescript",
			"rust",
			"markdown",
			"markdown_inline",
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"python",
				"c",
				"json",
				"xml",
				"yaml",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"markdown",
			},
			callback = function()
				vim.treesitter.start()
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
