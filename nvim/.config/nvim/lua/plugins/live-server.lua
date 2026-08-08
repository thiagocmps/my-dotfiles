return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server", -- or "pnpm add -g live-server"
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
}
