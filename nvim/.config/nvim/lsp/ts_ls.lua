---@type vim.lsp.Config
return {
	init_options = {
		hostInfo = "neovim",
		tsserver = {
			path = "/home/thiago/.local/share/npm-global/lib/node_modules/typescript/lib",
		},
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
			interactiveInlayHints = true,
			includeAutomaticOptionalChainCompletions = true,
			includeCompletionsForModuleExports = true,
			includeCompletionsWithSnippetText = true,
			includeCompletionsWithInsertText = true,
			includePackageJsonAutoImports = "auto",
			preferTypeOnlyAutoImports = true,
		},
	},

	cmd = {
		"typescript-language-server",
		"--stdio",
	},

	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},

	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
			or vim.list_extend(root_markers, { ".git" })

		local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
		local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
		local project_root = vim.fs.root(bufnr, root_markers)

		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
			return
		end
		if deno_root and (not project_root or #deno_root >= #project_root) then
			return
		end

		on_dir(project_root or vim.fn.getcwd())
	end,

	handlers = {
		["textDocument/formatting"] = function(err, result, ctx)
			if err then
				vim.notify("ts_ls formatting failed: " .. err.message, vim.log.levels.ERROR)
				return
			end
			if result then
				vim.lsp.util.apply_text_edits(result, ctx.bufnr, ctx.offset_encoding or "utf-16")
			end
		end,
		["_typescript.rename"] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			vim.lsp.util.show_document({
				uri = result.textDocument.uri,
				range = {
					start = result.position,
					["end"] = result.position,
				},
			}, client.offset_encoding)
			vim.lsp.buf.rename()
			return vim.NIL
		end,
	},

	on_attach = function(_, bufnr)
		-- Auto-fix + organize imports on save (TS-specific)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll.ts", "source.organizeImports.ts" } },
					apply = true,
				})
			end,
		})
	end,
}
