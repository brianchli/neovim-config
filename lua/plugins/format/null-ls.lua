if not vim.g.vscode then
  return {
    'jose-elias-alvarez/null-ls.nvim',
    priority = 700,
    config = function()
      local status, null_ls = pcall(require, 'null-ls')
      if status then
        local formatting = null_ls.builtins.formatting
        local sources = {
          --  FORMATTING
          formatting.prettierd,
          formatting.isort.with({
            extra_args = {
              '--settings',
              '/Users/brianli/.config/lintconfig/pyproject.toml'
            }
          }),
          formatting.eslint_d,
        }
        local on_attach = function(_, bufnr)
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
        end

        null_ls.setup({
          sources = sources,
          debounce = 100,
          on_attach = on_attach,
          diagnostics_format = "[#{c}] #{m} (#{s})"
        })
      end
    end
  }
end
