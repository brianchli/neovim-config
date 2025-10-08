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


  return {
    {
      'neovim/nvim-lspconfig',
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'p00f/clangd_extensions.nvim',
        'SmiteshP/nvim-navic',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
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
        }
      },
      init = function()
        vim.o.inccommand = "split"
      end,
      priority = 950,
      opts = function()
        return {
          servers = {
            'html',
            'cssls',
            'ts_ls',
            'emmet_ls',
            'sqlls',
            'dockerls',
            'yamlls',
            'astro',
            'jsonls',
            'zls',
            'texlab',
            'clangd',
            "marksman",
          }
        };
      end,
      config = function(_, opts)
        local on_attach = function(args)
          local status, fidget = pcall(require, "fidget")
          if status then
            fidget.notify("Custom on attach loaded")
          else
            vim.notify("Custom on attach loaded")
          end

          local telescope = require('telescope.builtin');
          map('n', 'gr', telescope.lsp_references, opt_def({ desc = "goto references" }))
          map('n', 'gd', telescope.lsp_definitions, opt_def({ desc = "goto definition" }))
          map('n', 'gD', vim.lsp.buf.declaration, opt_def({ desc = "goto declaration" }))
          map('n', 'gI', telescope.lsp_implementations, opt_def({ desc = "goto implementation" }))
          map('n', '<C-k>', vim.lsp.buf.signature_help, opt_def({ desc = "signature help" }))
          map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opt_def({ desc = "add workspace folder" }))
          map('n', '<space>D', vim.lsp.buf.type_definition, opt_def({ desc = "buf type definition" }))
          map('n', '<space>d', telescope.lsp_document_symbols, opt_def({ desc = "buf document symbols" }))
          map('n', '<space>ds', telescope.lsp_dynamic_workspace_symbols, opt_def({ desc = "buf workspace symbols" }))
          map('n', '<space>ca', vim.lsp.buf.code_action, opt_def({ desc = "code actions" }))
          map('n', '<leader>rn', vim.lsp.buf.rename, opt_def({ desc = 'LSP Rename' }))
          map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
            opt_def({ desc = "remove workspace folder" }))
          map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            opt_def({ desc = "list workspace folders" }))
          map('n', '<space>F', function() vim.lsp.buf.format { async = true } end,
            opt_def({ desc = "format file" }))
          map('n', '<space>ti', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 }) end,
            opt_def({ desc = "toggle inlay hints" }))


          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client_supports_method(client, 'textDocument/documentHighlight', args.buf) then
            -- update colors to differentiate
            vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "StatusLine", bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "StatusLine", bold = true })

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


        -- General lsp settings

        -- enable inlay hints
        vim.lsp.inlay_hint.enable(true, { 0 })

        local capabilities = _G.utils.tjoin(
          vim.lsp.protocol.make_client_capabilities(),
          require('cmp_nvim_lsp').default_capabilities()
        )

        -- Configurations defined in nvim/lsp
        local custom_configurations = { "lua_ls", "ruff", "pylsp", };
        for _, lsp in ipairs(custom_configurations) do
          vim.lsp.enable(lsp)
          vim.lsp.config[lsp].capabilities = capabilities
        end

        for _, lsp in ipairs(opts.servers) do
          vim.lsp.enable(lsp)
          vim.lsp.config[lsp].capabilities = capabilities
        end

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = on_attach,
        })

        -- local _, _ = pcall(require, 'clangd_extensions')
      end

    },
  }
end
