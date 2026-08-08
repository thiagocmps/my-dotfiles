local c = {
	bg = "#14141a", -- Fundo preto azulado
	fg = "#ffffff", -- Texto normal branco (como o texto selecionado)

	orange = "#e88333", --"#d75f00", -- Cor dos comandos como 'export', 'alias', 'shopt'
	st_orange = "#e04f2b",
	cyan = "#27e3e3", -- Cor das variáveis LESS_TERMCAP_*
	magenta = "#d700af", -- Símbolos, atribuições (=) e parênteses $()
	pink = "#ff5fdf", -- Conteúdo de comandos como 'tput'
	violet = "#8B86BB",
	sft_violet = "#a9a1e1",
	blue = "#005fff", -- Títulos comentados como '# Support colors in less'
	red = "#d70000", -- Avisos e saídas de erro em caminhos como '2>/dev/null'
	sft_red = "#ec5f67",
	yellow = "#d7af00", -- Valores numéricos de escape e strings secundárias
	green = "#98be65", -- Parâmetros de sucesso ou finalizações normais
}

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},

	lazy = false,
	config = function()
		local highlights = {
			NeoTreeNormal = { fg = c.fg, bg = c.bg },
			NeoTreeNormalNC = { fg = c.fg, bg = c.bg },
			NeoTreeWinSeparator = { fg = "#222230", bg = c.bg },

			NeoTreeDirectoryName = { fg = c.violet },
			NeoTreeDirectoryIcon = { fg = c.violet },
			NeoTreeFileName = { fg = c.fg },

			NeoTreeGitModified = { fg = c.orange },
			NeoTreeGitAdded = { fg = c.green },
			NeoTreeGitDeleted = { fg = c.red },
			NeoTreeGitUntracked = { fg = c.yellow },

			NeoTreeCursorLine = { fg = c.bg, bg = c.fg },
		}

		-- 2. LOOP NECESSÁRIO: Aplica as cores criadas acima diretamente na API do Neovim
		for group, settings in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, settings)
		end

		require("neo-tree").setup({
			popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
			enable_git_status = true,
			enable_diagnostics = true,
			default_components_config = {
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
				},
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
				provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
					if node.type == "file" or node.type == "terminal" then
						local success, web_devicons = pcall(require, "nvim-web-devicons")
						local name = node.type == "terminal" and "terminal" or node.name
						if success then
							local devicon, hl = web_devicons.get_icon(name)
							icon.text = devicon or icon.text
							icon.highlight = hl or icon.highlight
						end
					end
				end,
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = "*",
				highlight = "NeoTreeFileIcon",
				use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
			},
			filesystem = {
				window = {
					position = "right",
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
						ignore_files = {
							".neotreeignore",
							".ignore",
						},
					},
				},
			},
			modified = {
				symbol = "[+]",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					-- Change type
					added = "", -- or "✚"
					modified = "", -- or ""
					deleted = "✖", -- this can only be used in the git_status source
					renamed = "󰁕", -- this can only be used in the git_status source
					-- Status type
					untracked = "",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
				},
			},
			-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
			file_size = {
				enabled = true,
				width = 12, -- width of the column
				required_width = 64, -- min width of window required to show this column
			},
			type = {
				enabled = true,
				width = 10, -- width of the column
				required_width = 122, -- min width of window required to show this column
			},
			last_modified = {
				enabled = true,
				width = 20, -- width of the column
				required_width = 88, -- min width of window required to show this column
			},
			created = {
				enabled = true,
				width = 20, -- width of the column
				required_width = 110, -- min width of window required to show this column
			},
			symlink_target = {
				enabled = false,
			},
		})
	end,
}
