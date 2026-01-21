if not vim.g.vscode then
  local map = vim.keymap.set
  -- Taken from:
  -- https://github.com/adibhanna/minimal-vim/blob/5cd34cc07c242b880d0cf74b14e08cd66ee6804e/lua/config/autocmds.lua#L36
  local function client_supports_method(client, method, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
      return client:supports_method(method, bufnr)
    else
      return client.supports_method(method, { bufnr = bufnr })
    end
  end

  local opt_def = function(o, ...)
    return _G.utils.tjoin({ silent = true, buffer = ... }, o)
  end

  --- @param args vim.api.keyset.create_autocmd.callback_args
  local on_attach = function(args)
    local telescope = require('telescope.builtin');
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    require("fidget").notify(client.name .. " attached")

    -- References / Definitions / Declarations / Implementations
    if client and client_supports_method(client, 'textDocument/references') then
      map('n', 'gr', telescope.lsp_references, opt_def({ desc = "goto references" }))
    end

    if client and client_supports_method(client, 'textDocument/definition') then
      map('n', 'gd', telescope.lsp_definitions, opt_def({ desc = "goto definition" }))
    end

    if client and client_supports_method(client, 'textDocument/declaration') then
      map('n', 'gD', vim.lsp.buf.declaration, opt_def({ desc = "goto declaration" }))
    end

    if client and client_supports_method(client, 'textDocument/implementation') then
      map('n', 'gI', telescope.lsp_implementations, opt_def({ desc = "goto implementation" }))
    end

    -- Signature help
    if client and client_supports_method(client, 'textDocument/signatureHelp') then
      map('n', '<C-k>', vim.lsp.buf.signature_help, opt_def({ desc = "signature help" }))
    end

    -- Type definitions
    if client and client_supports_method(client, 'textDocument/typeDefinition') then
      map('n', '<space>D', vim.lsp.buf.type_definition, opt_def({ desc = "buf type definition" }))
    end

    -- Document / Workspace symbols
    if client and client_supports_method(client, 'textDocument/documentSymbol') then
      require("nvim-navic").attach(client, args.buf)
      map('n', '<space>d', telescope.lsp_document_symbols, opt_def({ desc = "buf document symbols" }))
    end

    if client and client_supports_method(client, 'workspace/symbol') then
      map('n', '<space>ds', telescope.lsp_dynamic_workspace_symbols, opt_def({ desc = "buf workspace symbols" }))
    end

    -- Code actions / Rename
    if client and client_supports_method(client, 'textDocument/codeAction') then
      map('n', '<space>ca', vim.lsp.buf.code_action, opt_def({ desc = "code actions" }))
    end

    if client and client_supports_method(client, 'textDocument/rename') then
      map('n', '<leader>rn', vim.lsp.buf.rename, opt_def({ desc = 'LSP Rename' }))
    end

    -- Formatting
    if client and client_supports_method(client, 'textDocument/formatting') then
      map('n', '<space>F', function() vim.lsp.buf.format { async = true } end,
        opt_def({ desc = "format file" }))
    end

    -- Inlay hints
    if client and client_supports_method(client, 'textDocument/inlayHint') then
      map('n', '<space>ti', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
      end, opt_def({ desc = "toggle inlay hints" }))
    end

    -- Workspace folder operations (server must support workspaceFolders)
    if client and client.server_capabilities.workspace then
      map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt_def({ desc = "add workspace folder" }))
      map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
        opt_def({ desc = "remove workspace folder" }))
      map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        opt_def({ desc = "list workspace folders" }))
    end


    if client and client_supports_method(client, 'textDocument/documentHighlight', args.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

      -- When cursor stops moving: Highlightsall instances of the symbol under the cursor
      -- When cursor moves: Clears the highlighting
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- When LSP detaches: Clears the highlighting
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Taken from:
    -- https://github.com/adibhanna/minimal-vim/blob/5cd34cc07c242b880d0cf74b14e08cd66ee6804e/lua/config/autocmds.lua#L36
    if client and client_supports_method(client, 'textDocument/inlayHint', args.buf) then
      local original_handler = client.rpc.request;

      local inlay_hint_group = vim.api.nvim_create_augroup('lsp-inlay-hint', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = args.buf,
        group = inlay_hint_group,
        callback = function()
          if not vim.lsp.inlay_hint.is_enabled({ 0 }) then
            vim.lsp.inlay_hint.enable(true, { 0 })
          end
        end,
      })

      local last_line = nil;
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = args.buf,
        group = inlay_hint_group,
        callback = function()
          local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
          if last_line ~= nil and last_line == cursor_line then
            return
          end
          if vim.lsp.inlay_hint.is_enabled({ 0 }) then
            vim.lsp.inlay_hint.enable(false, { 0 })
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-inlay-hint-detach', { clear = true }),
        callback = function(event2)
          vim.api.nvim_clear_autocmds { group = 'lsp-inlay-hint', buffer = event2.buf }
        end,
      })

      client.rpc.request = function(methods, params, handler, ...)
        if methods ~= 'textDocument/inlayHint' then
          return original_handler(methods, params, handler, ...)
        end

        local decorator = function(err, ok)
          local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
          last_line = cursor_line
          local filtered = vim.tbl_filter(function(hint)
            return hint.position.line == cursor_line
          end, ok or {})
          return handler(err, filtered)
        end

        return original_handler(methods, params, decorator, ...)
      end
    end
  end


  return {
    {
      'SmiteshP/nvim-navic',
      dependencies = {
        'neovim/nvim-lspconfig',
      }
    },
    {
      'mrcjkb/rustaceanvim',
      dependencies = {
        'neovim/nvim-lspconfig',
      },
      version = '^6', -- Recommended
      lazy = false,   -- This plugin is already lazy
      init = function()
        -- Silence the lsp log warning by providing an empty config
        vim.lsp.config["rust-analyzer"] = {};
      end
    },
    {
      'neovim/nvim-lspconfig',
      priority = 950,
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
      },
      init = function()
        vim.o.inccommand = "split"
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

        -- Diagnostic configurations
        local diag = vim.diagnostic.severity
        -- Redefine signs for all diagnostics
        vim.diagnostic.config({
          signs = {
            text = {
              [diag.ERROR] = "●",
              [diag.WARN] = "●",
              [diag.HINT] = "●",
              [diag.INFO] = "●",
            }
          },
          -- jump to diagnostics using [d and ]d
          jump = { float = true },

          -- do the following for lsp diagnostics:
          -- 1. disable prefix (e.g. number)
          -- 2. sort from the highest severity
          -- 3. include the source where the warn/error come from
          float = { prefix = "", header = "", severity_sort = true, source = true },
        })

        local capabilities = _G.utils.tjoin(
          vim.lsp.protocol.make_client_capabilities(),
          require('cmp_nvim_lsp').default_capabilities()
        )

        vim.lsp.config('*', {
          capabilities = capabilities
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = on_attach,
        })
      end,
      -- manually set up lsp as lspconfig.setup({}) will be deprecated
      -- and lazy calls this under the hood using opts
      config = function()
      end

    }
  }
end
