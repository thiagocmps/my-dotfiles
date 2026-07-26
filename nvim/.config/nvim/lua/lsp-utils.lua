vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Navigation
		map("gd", vim.lsp.buf.definition, "Go to Definition")
		map("gD", vim.lsp.buf.declaration, "Go to Declaration")
		map("gr", vim.lsp.buf.references, "Go to References")
		map("gi", vim.lsp.buf.implementation, "Go to Implementation")
		map("<leader>D", vim.lsp.buf.type_definition, "Type Definition")

		-- Info
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("<leader>k", vim.lsp.buf.signature_help, "Signature Help", { "n", "i" })

		-- Actions
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("<leader>ca", vim.lsp.buf.code_action, "Code Action", "v")
		map("<leader>rn", vim.lsp.buf.rename, "Rename")
		map("<leader>qf", function()
			vim.lsp.buf.code_action({
				context = { only = { "quickfix", "source.fixAll", "source.organizeImports" } },
				apply = true,
			})
		end, "Quick Fix")

		-- Diagnostics
		map("<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
		map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
		map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
		map("<leader>dl", vim.diagnostic.setloclist, "Diagnostics to Loclist")

		-- Symbols
		map("<leader>fs", vim.lsp.buf.document_symbol, "Document Symbols")
		map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

		-- Inlay hints
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
})
