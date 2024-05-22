if not vim.g.vscode then
  return {
    {
      'neovim/nvim-lspconfig',
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'simrat39/rust-tools.nvim',
        'p00f/clangd_extensions.nvim',
        'SmiteshP/nvim-navic',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {
          'mrcjkb/haskell-tools.nvim',
          version = '^3', -- Recommended
          lazy = false,   -- This plugin is already lazy
        }
      },
      init = function()
        vim.o.inccommand = "split"
      end,
      priority = 950,
      config = function()
        local status, lspconfig = pcall(require, 'lspconfig')
        if status then
          local _, navic     = pcall(require, 'nvim-navic')
          local capabilities = vim.tbl_deep_extend("force",
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities(),
            {
              update_in_insert = { false },
              flags = {
                debounce_text_changes = 150,
                allow_incremental_sync = true,
              }
            }
          )

          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
            { noremap = true, silent = true, desc = "goto next diagnostic" })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
            { noremap = true, silent = true, desc = "goto prev diagnostic" })

          local ht = require('haskell-tools')

          local on_attach = function(client, bufnr)
            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions

            vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
              { noremap = true, silent = true, buffer = bufnr, desc = "goto references" })
            vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
              { noremap = true, silent = true, buffer = bufnr, desc = "goto definition" })
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
              { noremap = true, silent = true, buffer = bufnr, desc = "goto declaration" })
            vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
              { noremap = true, silent = true, buffer = bufnr, desc = "goto implementation" })
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
              { noremap = true, silent = true, buffer = bufnr, desc = "signature help" })
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,
              { noremap = true, silent = true, buffer = bufnr, desc = "add workspace folder" })
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,
              { noremap = true, silent = true, buffer = bufnr, desc = "remove workspace folder" })
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end,
              { noremap = true, silent = true, buffer = bufnr, desc = "list workspace folders" })

            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,
              { noremap = true, silent = true, buffer = bufnr, desc = "buf type definition" })
            vim.keymap.set('n', '<space>d', require('telescope.builtin').lsp_document_symbols,
              { noremap = true, silent = true, buffer = bufnr, desc = "buf document symbols" })
            vim.keymap.set('n', '<space>ds', require('telescope.builtin').lsp_dynamic_workspace_symbols,
              { noremap = true, silent = true, buffer = bufnr, desc = "buf document symbols" })
            vim.keymap.set('n', '<space>rn', function()
                return ":IncRename " .. vim.fn.expand("<cword>")
              end,
              { expr = true, noremap = true, silent = true, buffer = bufnr, desc = "buf rename" })
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,
              { noremap = true, silent = true, buffer = bufnr, desc = "code actions" })
            vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format { async = true } end,
              { noremap = true, silent = true, buffer = bufnr, desc = "format file" })

            if client.server_capabilities.documentSymbolProvider then
              navic.attach(client, bufnr)
            end

            if vim.bo.filetype == "cpp" then
              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
              local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })
              vim.api.nvim_create_autocmd({ "TextChanged", "CursorMoved" }, {
                group = group,
                buffer = bufnr,
                callback = require("clangd_extensions.inlay_hints").disable_inlay_hints
              })
            end
            if vim.bo.filetype == "hs" then
              local opts = { noremap = true, silent = true, buffer = bufnr, }

              -- 1. haskell-language-server relies heavily on codeLenses,
              --    so auto-refresh (see advanced configuration) is enabled by default
              -- 2. Hoogle search for the type signature of the definition under the cursor
              -- 3. Evaluate all code snippets
              -- 4. Toggle a GHCi repl for the current package
              -- 5. Toggle a GHCi repl for the current buffer

              vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
              vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
              vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)
              vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
              vim.keymap.set('n', '<leader>rf', function()
                ht.repl.toggle(vim.api.nvim_buf_get_name(0))
              end, opts)
              vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
            end
          end

          -- load manual configurations for some language servers
          for _, path in ipairs(vim.api.nvim_get_runtime_file('lua/lsp/*', true)) do
            local lsp, settings = loadfile(path)()
            lspconfig[lsp].setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = settings
            })
          end

          local _, clangd = pcall(require, 'clangd_extensions')
          clangd.setup({
            server = {
              on_attach = on_attach,
              capabilities = capabilities
            },
            inlay_hints = {
              only_current_line = true,
              only_current_line_autocmd = {
                "CursorHold"
              },
            }
          })

          local _, rs = pcall(require, 'rust-tools')
          rs.setup({
            server = {
              on_attach = on_attach,
              capabilities = capabilities,
            },
            inlay_hints = { only_current_line = true },
          })

          -- generic settings
          local servers = {
            'html',
            'cssls',
            'tsserver',
            'emmet_ls',
            'sqlls',
            'dockerls',
            'yamlls',
            'astro',
            'clangd',
            'jsonls',
            'zls',
            'texlab',
          }

          for _, lsp in ipairs(servers) do
            if lsp == 'emmet_ls' then
              lspconfig[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { 'javascript', 'typescript', 'astro' }
              })
            end
            lspconfig[lsp].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end
        end
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
            null_ls.builtins.code_actions.refactoring,
            null_ls.builtins.diagnostics.mypy,
            null_ls.builtins.completion.spell,
          },
        })
      end
    }
  }
end
