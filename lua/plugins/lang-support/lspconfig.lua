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
          version = '^5', -- Recommended
          lazy = false,   -- This plugin is already lazy
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
        local status, lspconfig = pcall(require, 'lspconfig')
        if status then
          local _, navic = pcall(require, 'nvim-navic')

          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
            { noremap = true, silent = true, desc = "goto next diagnostic" })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
            { noremap = true, silent = true, desc = "goto prev diagnostic" })

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


            local highlight_group = vim.api.nvim_create_augroup("highlight word under cursor", { clear = true })
            -- highlight word
            vim.api.nvim_create_autocmd({ "CursorHold" }, {
              group = highlight_group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.document_highlight()
              end
            })

            -- clear highlights
            vim.api.nvim_create_autocmd({ "CursorMoved" }, {
              group = highlight_group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.clear_references()
              end
            })

            if vim.bo.filetype == "cpp" then
              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
              local group = vim.api.nvim_create_augroup("clangd_no_inlay_hints_in_insert", { clear = true })
              vim.api.nvim_create_autocmd({ "TextChanged", "InsertEnter" }, {
                group = group,
                buffer = bufnr,
                callback = require("clangd_extensions.inlay_hints").disable_inlay_hints
              })
            end
          end

          local capabilities = vim.tbl_deep_extend("force",
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities(),
            {
              --offsetEncoding = 'utf-16',
              update_in_insert = { false },
              flags = {
                debounce_text_changes = 150,
                allow_incremental_sync = true,
              }
            }
          )
          -- load manual configurations for some language servers
          -- NOTE: the settings table may differ depending on the lang server
          for _, path in ipairs(vim.api.nvim_get_runtime_file('lua/lsp/*', true)) do
            local lang, settings = loadfile(path)()
            lspconfig[lang].setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = settings
            })
          end

          local _, clangd = pcall(require, 'clangd_extensions')
          clangd.setup({
            server = {
              on_attach = on_attach,
              capabilities = capabilities,
            },
            inlay_hints = {
              only_current_line = true,
              only_current_line_autocmd = {
                "CursorHold"
              },
            }
          })

          local function configure_lsp(lsp, capabilities)
            if lsp == 'emmet_ls' then
              lspconfig[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                filetypes = { 'javascript', 'typescript', 'astro' }
              })
            else
              lspconfig[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
              })
            end
          end

          for _, lsp in ipairs(opts.servers) do
            configure_lsp(lsp, capabilities)
          end

          vim.g.rustaceanvim = {
            server = {
              on_attach = on_attach
            }
          }
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
          },
        })
      end
    },
  }
end
