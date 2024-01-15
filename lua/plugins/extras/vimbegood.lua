if not vim.g.vscode then
  return {
    'ThePrimeagen/vim-be-good',
    keys = {
      { "<leader>pv", "<cmd>VimBeGood<cr>", desc = "play vim be good" },
    },
    lazy = 'VeryLazy'
  }
end
