-- Keymaps global
local map = function(keys, func, desc, mode, opts)
	mode = mode or "n"
	opts = opts or {}
	opts.desc = desc
	vim.keymap.set(mode, keys, func, opts)
end

-- Movimento: pulos maiores que 5 linhas entram no jumplist
map("k", [[v:count > 5 ? "m'" . v:count . "k" : "k"]], "Jumplist up", "n", { expr = true, silent = true })
map("j", [[v:count > 5 ? "m'" . v:count . "j" : "j"]], "Jumplist down", "n", { expr = true, silent = true })

-- Indenta o arquivo inteiro e volta para onde você estava
map("<Leader>i", "gg=G<C-o>", "Indentar arquivo inteiro")

-- File explorer
map("<leader>e", "<cmd>Neotree toggle<CR>", "Toggle file explorer")

-- Telescope (carrega o plugin sob demanda)
local pick = function(name)
	return function()
		require("telescope.builtin")[name]()
	end
end
map("<C-p>", pick("find_files"), "Find files")
map("<leader>ff", pick("find_files"), "Find files")
map("<leader>fg", pick("live_grep"), "Live grep")
map("<leader>fw", pick("grep_string"), "Grep word under cursor")
map("<leader>fb", pick("buffers"), "Find buffers")
map("<leader>fh", pick("help_tags"), "Help tags")
map("<leader>fr", pick("oldfiles"), "Recent files")
map("<leader>fq", pick("diagnostics"), "Diagnostics")

-- Formatação
map("<leader>gf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, "Format buffer")

-- Live server (estilo VS Code Live Server):
--   - serve a raiz do projeto do arquivo (caminhos absolutos tipo /src/... funcionam)
--   - abre o navegador no arquivo do buffer atual (relativo à raiz)
--   - reaproveita o servidor quando é o mesmo projeto e reancora ao trocar
-- Guarda a raiz/porta do servidor rodando para reaproveitar ou parar antes de subir.
local ls_group = vim.api.nvim_create_augroup("UserLiveServer", { clear = true })
local ls_root
local ls_port
vim.api.nvim_create_autocmd("User", {
	group = ls_group,
	pattern = "LiveServerStarted",
	callback = function(ev)
		ls_root = ev.data.root
		ls_port = ev.data.port
	end,
})
vim.api.nvim_create_autocmd("User", {
	group = ls_group,
	pattern = "LiveServerStopped",
	callback = function(ev)
		if ls_root == ev.data.root then
			ls_root = nil
			ls_port = nil
		end
	end,
})

-- Sobe a partir do arquivo até achar a raiz do projeto (marcadores comuns).
local function project_root(file)
	local dir = vim.fn.fnamemodify(file, ":p:h")
	local home = vim.fn.expand("~")
	local markers = { "index.html", "package.json", ".git" }
	local cur = dir
	while cur and cur ~= "/" and cur ~= home do
		for _, marker in ipairs(markers) do
			if vim.uv.fs_stat(cur .. "/" .. marker) then
				return cur
			end
		end
		local parent = vim.fn.fnamemodify(cur, ":h")
		if parent == cur then
			break
		end
		cur = parent
	end
	return dir
end

map("<leader>ls", function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" or vim.bo.buftype ~= "" or not vim.uv.fs_stat(file) then
		return
	end
	file = vim.fn.fnamemodify(file, ":p")
	local root = project_root(file)
	local root_real = vim.uv.fs_realpath(root) or root
	local rel = file:sub(#root + 2)

	if ls_root then
		if ls_root == root_real and ls_port then
			-- Mesmo projeto: só abre o arquivo no navegador, sem reiniciar.
			vim.ui.open(("http://127.0.0.1:%d/%s"):format(ls_port, rel))
			return
		end
		vim.cmd("LiveServerStop " .. vim.fn.fnameescape(ls_root))
	end

	-- Abre o navegador no arquivo assim que o servidor subir.
	vim.api.nvim_create_autocmd("User", {
		group = ls_group,
		pattern = "LiveServerStarted",
		once = true,
		callback = function(ev)
			vim.ui.open(("http://127.0.0.1:%d/%s"):format(ev.data.port, rel))
		end,
	})
	vim.cmd("LiveServerStart " .. vim.fn.fnameescape(root))
end, "Live Server (abre o arquivo atual)")

-- Sessões
map("<leader>ss", function()
	require("config.sessions").save()
end, "Save session")
map("<leader>sr", function()
	require("config.sessions").restore_current()
end, "Restore session")

-- Preview markdown (glow)
map("<leader>mp", "<cmd>Glow<CR>", "Preview Markdown (Glow)")

-- Keymaps LSP (buffer-local, no attach)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local bmap = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Navegação
		bmap("gd", vim.lsp.buf.definition, "Go to Definition")
		bmap("gD", vim.lsp.buf.declaration, "Go to Declaration")
		bmap("gr", vim.lsp.buf.references, "Go to References")
		bmap("gi", vim.lsp.buf.implementation, "Go to Implementation")
		bmap("<leader>D", vim.lsp.buf.type_definition, "Type Definition")

		-- Info
		bmap("K", vim.lsp.buf.hover, "Hover Documentation")
		bmap("<leader>k", vim.lsp.buf.signature_help, "Signature Help", { "n", "i" })

		-- Ações
		bmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		bmap("<leader>ca", vim.lsp.buf.code_action, "Code Action", "v")
		bmap("<leader>rn", vim.lsp.buf.rename, "Rename")
		bmap("<leader>qf", function()
			vim.lsp.buf.code_action({
				context = { only = { "quickfix", "source.fixAll", "source.organizeImports" } },
				apply = true,
			})
		end, "Quick Fix")

		-- Diagnósticos
		bmap("<leader>dd", vim.diagnostic.open_float, "Line Diagnostics")
		bmap("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
		bmap("]d", vim.diagnostic.goto_next, "Next Diagnostic")
		bmap("<leader>dl", vim.diagnostic.setloclist, "Diagnostics to Loclist")

		-- Símbolos
		bmap("<leader>fs", vim.lsp.buf.document_symbol, "Document Symbols")
		bmap("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

		-- Servidor
		bmap("<leader>lr", function()
			vim.cmd("lsp restart")
		end, "Restart Server")
		bmap("<leader>lq", function()
			vim.cmd("edit " .. vim.fs.normalize(vim.lsp.get_log_path()))
		end, "Open LSP Log")

		-- Inlay hints
		bmap("<leader>uh", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, "Toggle Inlay Hints")
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Completion nativa (Neovim 0.12)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
		end

		-- ts_ls: go to source definition (TypeScript-specific)
		if client.name == "ts_ls" then
			bmap("<leader>sd", function()
				local win = vim.api.nvim_get_current_win()
				local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
				client:exec_cmd({
					command = "_typescript.goToSourceDefinition",
					title = "Go to source definition",
					arguments = { params.textDocument.uri, params.position },
				}, { bufnr = bufnr }, function(err, result)
					if err then
						vim.notify("Go to source definition failed: " .. err.message, vim.log.levels.ERROR)
						return
					end
					if not result or vim.tbl_isempty(result) then
						vim.notify("No source definition found", vim.log.levels.INFO)
						return
					end
					vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
				end)
			end, "Go to Source Definition")
		end
	end,
})
