return {
  'folke/which-key.nvim',
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup({})

    -- NOTE: Fix this later
    --    local custom_mappings = {
    --      { "<leader>c",  group = "code" },
    --      { "<leader>ca", desc = "code highlights" },
    --      { "<leader>cb", desc = "search buffers" },
    --      { "<leader>ch", desc = "disable search highlights" },
    --      { "<leader>f",  group = "find" },
    --      { "<leader>h",  group = "harpoon" },
    --      { "<leader>q",  group = "close buffer" },
    --      { "<leader>t",  group = "git" },
    --      { "<leader>y",  group = "yank to clipboard" },
    --    }
    -- wk.register(custom_mappings)
  end,
}
