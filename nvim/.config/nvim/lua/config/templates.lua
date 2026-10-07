local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("FileTemplates", { clear = true })

autocmd("BufNewFile", {
	group = "FileTemplates",
	pattern = "*",
	callback = function()
		local ext = vim.fn.expand("%:e")
		if ext ~= "" then
			-- 1. Pega o caminho absoluto do arquivo atual (ex: init.lua ou seu arquivo de autocmds)
			local current_file = debug.getinfo(1, "S").source:sub(2)
			-- 2. Extrai o diretório base da sua configuração
			local config_dir = vim.fs.dirname(current_file)
			local lua_dir = vim.fs.dirname(config_dir) -- lua
			local root_dir = vim.fs.dirname(lua_dir) -- raiz (.)

			-- 3. Procura os templates na pasta correspondente dentro do seu repositório de dotfiles
			-- Se este código estiver no seu init.lua na raiz do dotfile, ele buscará em dotfiles/templates/
			local template_path = root_dir .. "/templates/skeleton." .. ext

			if vim.fn.filereadable(template_path) == 1 then
				vim.cmd("silent! 0r " .. template_path)
			end
		end
	end,
})
