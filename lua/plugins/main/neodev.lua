if not vim.g.vscode then
  return {
    "folke/neodev.nvim",
    opts = {},
    priority = 1000,
    config = function()
      require('neodev').setup()
    end
  }
end
