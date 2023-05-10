if not vim.g.vscode then
  return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'williamboman/mason.nvim',
    priority = 970,
    config = function()
      local status, lsp = pcall(require, 'mason-lspconfig')
      if status then
        lsp.setup {
          ensure_installed = {
            "lua_ls",
            "sqlls",
            "yamlls",
            "cmake",
            "dockerls",
            "tsserver",
            "ruff_lsp",
            "cssls",
            "eslint",
            "emmet_ls",
          },
          automatic_installation = true,
        }
      end
    end
  }
end
