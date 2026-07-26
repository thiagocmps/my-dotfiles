return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",

	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {
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
			},
			autoinstall = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
