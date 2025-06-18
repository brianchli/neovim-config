if not vim.g.vscode then
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
          local opt_def = function(o)
            return _G.utils.tjoin({ silent = true, buffer = args.buf }, o)
          end

          vim.keymap.set('n', 'gr', telescope.lsp_references
          , opt_def({ desc = "goto references" })
          )

          vim.keymap.set('n', 'gd', telescope.lsp_definitions,
            opt_def({ desc = "goto definition" }))

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            opt_def({ desc = "goto declaration" }))

          vim.keymap.set('n', 'gI', telescope.lsp_implementations,
            opt_def({ desc = "goto implementation" }))

          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
            opt_def({ desc = "signature help" }))

          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
            opt_def({ desc = "add workspace folder" }))

          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
            opt_def({ desc = "remove workspace folder" }))

          vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            opt_def({ desc = "list workspace folders" }))

          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
            opt_def({ desc = "buf type definition" }))

          vim.keymap.set('n', '<space>d', telescope.lsp_document_symbols,
            opt_def({ desc = "buf document symbols" }))

          vim.keymap.set('n', '<space>ds', telescope.lsp_dynamic_workspace_symbols,
            opt_def({ desc = "buf document symbols" }))

          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,
            opt_def({ desc = "code actions" }))

          vim.keymap.set('n', '<space>F',
            function() vim.lsp.buf.format { async = true } end,
            opt_def({ desc = "format file" }))

          vim.keymap.set('n', '<space>ti',
            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 }) end,
            opt_def({ desc = "toggle inlay hints" }))
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
        local custom_configurations = { "lua_ls", "ruff", "pylsp" };
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

        local _, clangd = pcall(require, 'clangd_extensions')
        clangd.setup({
          server = {
            on_attach = on_attach,
            capabilities = _G.utils.tjoin(capabilities,
              {
                update_in_insert = { false },
                flags = {
                  debounce_text_changes = 150,
                  allow_incremental_sync = true,
                }
              })
          }
        })
      end

    },
    {
      'nvimtools/none-ls.nvim',
      priority = 900,
      config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
          sources = {
            null_ls.builtins.code_actions.proselint,
          },
        })
      end
    },
  }
end
