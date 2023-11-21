return {
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup({})
    local wk = require("which-key")
    wk.register({
      f = {
        name = "find",            -- optional group name
        a = { "Format File" },    -- create a binding with label
        f = { "Find File" },      -- create a binding with label
        h = { "Search Help" },    -- just a label. don't create any mapping
        b = { "Search buffers" }, -- just a label. don't create any mapping
      },
      t = {
        name = "git", -- optional group name
      },
      c = {
        name = "code",
        a = { "Code highlights" },
        h = { "disable search highlights" },
        b = { "search buffers" },
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
