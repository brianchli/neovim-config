if not vim.g.vscode then
  return {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'simrat39/rust-tools.nvim',
      'p00f/clangd_extensions.nvim',
      'SmiteshP/nvim-navic',
    },
    event = { "BufReadPre", "BufNewFile" },
    priority = 950,
    config = function()
      local status, lspconfig = pcall(require, 'lspconfig')
      if status then
        local _, navic = pcall(require, 'nvim-navic')
        local lsp_capabilities = lspconfig.util.default_config
        lsp_capabilities.capabilities = vim.tbl_deep_extend(
          'force',
          lsp_capabilities.capabilities,
          require('cmp_nvim_lsp').default_capabilities())
        lsp_capabilities.update_in_insert = false
        lsp_capabilities.flags = {
          debounce_text_changes = 150,
          allow_incremental_sync = true,
        }
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end
          require("clangd_extensions.inlay_hints").setup_autocmd()
          require("clangd_extensions.inlay_hints").set_inlay_hints()
        end

        local py_settings = {
          pylsp = {
            plugins = {
              -- ruff, yapf, rope have been installed using pip
              pyflakes = { enabled = false },
              pylint = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              flake8 = { enabled = false },
              yapf = { enabled = true },
            },
          }
        }

        local lua_settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', } -- disable unused global message
            }
          }
        }

        lspconfig['pylsp'].setup({
          on_attach = on_attach,
          capabilities = lsp_capabilities,
          settings = py_settings
        })

        lspconfig['lua_ls'].setup({
          on_attach = on_attach,
          capabilities = lsp_capabilities,
          settings = lua_settings
        })

        local ruff_settings = {
          settings = {
            args = {
              '--config=' .. os.getenv('HOME') .. '/.config/nvim/lint/pyproject.toml',
            }
          }
        }

        lspconfig['ruff_lsp'].setup({
          on_attach = on_attach,
          capabilities = lsp_capabilities,
          init_options = ruff_settings,
        })
        -- enhanced capabilities for c and rust
        -- local c_capabilities = lsp_capabilities
        --c_capabilities.offsetEncoding = 'utf-16'
        local _, clangd = pcall(require, 'clangd_extensions')
        clangd.setup({
          server = {
            on_attach = on_attach,
            capabilities = lsp_capabilities
          },
        })
        local _, rs = pcall(require, 'rust-tools')
        rs.setup({
          server = {
            on_attach = on_attach,
            capabilities = lsp_capabilities,
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
        }
        for _, lsp in ipairs(servers) do
          if lsp == 'emmet_ls' then
            lspconfig[lsp].setup({
              on_attach = on_attach,
              capabilities = lsp_capabilities,
              filetypes = { 'javascript', 'typescript', 'astro' }
            })
          end
          lspconfig[lsp].setup({
            on_attach = on_attach,
            capabilities = lsp_capabilities,
          })
        end
      end
    end
  }
end
