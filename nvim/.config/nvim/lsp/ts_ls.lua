---@type vim.lsp.Config
return {
  init_options = {
    hostInfo = 'neovim',
    tsserver = {
      path = '/home/thiago/.local/share/npm-global/lib/node_modules/typescript/lib'
    },
    preferences = {
      includeInlayParameterNameHints = 'all',
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsForModuleExports = true,
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
      preferTypeOnlyAutoImports = true,
      importModuleSpecifierPreference = 'project-relative',
      quotePreference = 'auto',
      providePrefixAndSuffixTextForRename = true,
      allowRenameOfImportPath = true,
      includePackageJsonAutoImports = 'auto',
      interactiveInlayHints = true,
      jsxAttributeCompletionStyle = 'auto',
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true,
    },
  },

  cmd = {
    "typescript-language-server",
    "--stdio",
  },

  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },

  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
      or vim.list_extend(root_markers, { '.git' })

    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
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
    ['_typescript.rename'] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ['end'] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },

  on_attach = function(client, bufnr)
    -- Go to source definition (TS-specific)
    vim.keymap.set('n', '<leader>sd', function()
      local win = vim.api.nvim_get_current_win()
      local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
      client:exec_cmd({
        command = '_typescript.goToSourceDefinition',
        title = 'Go to source definition',
        arguments = { params.textDocument.uri, params.position },
      }, { bufnr = bufnr }, function(err, result)
        if err then
          vim.notify('Go to source definition failed: ' .. err.message, vim.log.levels.ERROR)
          return
        end
        if not result or vim.tbl_isempty(result) then
          vim.notify('No source definition found', vim.log.levels.INFO)
          return
        end
        vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
      end)
    end, { buffer = bufnr, desc = 'LSP: Go to Source Definition' })

    -- Auto-fix + organize imports + format on save (TS-specific)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({
          context = { only = { 'source.fixAll.ts', 'source.organizeImports.ts' } },
          apply = true,
        })
      end,
    })
  end,
}
