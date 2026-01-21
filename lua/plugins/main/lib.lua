-- lazy loading of core library modules
if not vim.g.vscode then
  return {
    { "nvim-lua/plenary.nvim", lazy = true },
  }
end
