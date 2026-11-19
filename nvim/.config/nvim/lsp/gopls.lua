return {
	cmd = { "gopls" },
	filetypes = {
		"go",
		"gomod",
		"gowork",
		"gotmpl",
	},
	root_markers = {
		"go.mod",
		"go.work",
		".git",
	},
	single_file_support = true,
	settings = {
		gopls = {
			completeUnimported = true,
			gofumpt = true,
			staticcheck = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
		},
	},
}
