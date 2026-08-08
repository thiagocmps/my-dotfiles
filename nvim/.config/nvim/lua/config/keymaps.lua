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
map("<leader>e", function()
	require("neo-tree.command").toggle()
end, "Toggle file explorer")

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

-- Live server
map("<leader>ls", function()
	require("lazy").load({ plugins = { "live-server.nvim" } })
	vim.cmd("LiveServerToggle")
end, "Toggle Live Server")

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
		bmap("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
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
