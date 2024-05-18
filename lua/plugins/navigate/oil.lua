if not vim.g.vscode then
  return {
    'stevearc/oil.nvim',
    keys = {
      { "<leader>-", "<cmd>lua require('oil').toggle_float('.')<cr>", desc = "Browse files for editing" },
      { "-", "<cmd>Oil<cr>", desc = "Open oil in current window" },
    },
    opts = {
      float = {
        padding = 10,
        max_width = 100,
        max_height = 20,
      },
      keymaps = {
        ["q"] = "actions.close",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
end
