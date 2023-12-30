if not vim.g.vscode then
  -- plugin
  return {
    'nvim-treesitter/nvim-treesitter',
    priority = 980,
    config = function()
      require('nvim-treesitter.configs').setup(
        {
          ensure_installed = {
            "bash",
            "css",
            "html",
            "make",
            "cmake",
            "python",
            "cpp",
            "yaml",
            "regex",
            "javascript",
            "typescript",
            "toml",
            "rust",
            "zig"
          },
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enabled = true
          }
        })
    end
  }
end
