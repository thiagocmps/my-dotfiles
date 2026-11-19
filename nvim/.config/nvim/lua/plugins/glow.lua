-- markdown preview
-- keymap: <leader> mp
return {
	"ellisonleao/glow.nvim",
	cmd = { "Glow" },
	config = function()
		require("glow").setup()
	end,
}
