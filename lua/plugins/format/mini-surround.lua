if not vim.g.vscode then
  return {
    'echasnovski/mini.surround',
    version = false,
    config = function()
      require("mini.surround").setup()
    end
  }
end
