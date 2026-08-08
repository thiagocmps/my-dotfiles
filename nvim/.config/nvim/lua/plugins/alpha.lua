return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local sessions = require("config.sessions")

		dashboard.section.header.val = {
			[[                               __                ]],
			[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		}
		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
		}

		local function session_buttons()
			local buttons = {}
			if vim.fn.filereadable(sessions.session_file()) == 1 then
				table.insert(buttons, {
					type = "button",
					val = "  Restore this directory",
					on_press = function()
						sessions.restore_current()
					end,
					opts = { position = "center" },
				})
			end
			for _, s in ipairs(sessions.list_recent(5)) do
				table.insert(buttons, {
					type = "button",
					val = "  " .. s.name,
					on_press = function()
						sessions.restore_file(s.path)
					end,
					opts = { position = "center" },
				})
			end
			return buttons
		end
		local session_val = { { type = "text", val = "Sessions", opts = { hl = "Comment", position = "center" } } }
		for _, b in ipairs(session_buttons()) do
			table.insert(session_val, b)
		end
		dashboard.section.sessions = {
			type = "group",
			val = session_val,
			opts = { spacing = 1 },
		}

		local folders = {
			{ name = "Projetos", dir = "~/git-projects" },
			{ name = "Dotfiles", dir = "~/git-projects/my-dotfiles" },
			{ name = "Learning", dir = "~/learning" },
		}
		local folder_buttons = {}
		for _, f in ipairs(folders) do
			local dir = vim.fn.expand(f.dir)
			if vim.fn.isdirectory(dir) == 1 then
				table.insert(folder_buttons, {
					type = "button",
					val = "  " .. f.name,
					on_press = function()
						vim.cmd("cd " .. vim.fn.fnameescape(dir))
						require("neo-tree.command").toggle()
					end,
					opts = { position = "center" },
				})
			end
		end
		local folder_val = { { type = "text", val = "Folders", opts = { hl = "Comment", position = "center" } } }
		for _, b in ipairs(folder_buttons) do
			table.insert(folder_val, b)
		end
		dashboard.section.folders = {
			type = "group",
			val = folder_val,
			opts = { spacing = 1 },
		}

		dashboard.config.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.sessions,
			{ type = "padding", val = 1 },
			dashboard.section.folders,
			dashboard.section.footer,
		}

		if vim.fn.executable("fortune") == 1 then
			local handle = io.popen("fortune")
			local fortune = handle:read("*a")
			handle:close()
			dashboard.section.footer.val = fortune
		end

		dashboard.config.opts.noautocmd = true

		alpha.setup(dashboard.config)
	end,
}
