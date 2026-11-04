return {
	"barrett-ruth/live-server.nvim",
	build = "npm install -g live-server", -- or "pnpm add -g live-server"
	cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
	init = function()
		-- Como o VS Code, abrimos o navegador no arquivo do buffer (relativo à
		-- raiz do servidor). Desliga o auto-open do plugin, que sempre abre "/".
		local cfg = vim.g.live_server or {}
		cfg.browser = false
		vim.g.live_server = cfg
	end,
}
