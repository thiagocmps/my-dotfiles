return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server", -- or "pnpm add -g live-server"
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServer Toggle" },
	config = true,
	keys = {
		{
			"<leader>ls",
			"<cmd>LiveServerToggle<cr>",
			desc = "Toggle Live Server",
		},
	},
}
