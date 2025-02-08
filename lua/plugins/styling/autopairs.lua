if not vim.g.vscode then
  return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  }
end
