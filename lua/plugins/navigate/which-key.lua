return {
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup({})
    local wk = require("which-key")
    wk.register({
      f = {
        name = "find", -- optional group name
      },
      t = {
        name = "git", -- optional group name
      },
      h = {
        name = "harpoon"
      },
      c = {
        name = "code",
        a = "code highlights",
        h = "disable search highlights",
        b = "search buffers",
      },
      y = {
        name = "yank to clipboard",
      },
      q = {
        name = "close buffer",
      },
    }, { prefix = "<leader>" })
  end,
}
