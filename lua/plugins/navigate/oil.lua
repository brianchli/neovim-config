if not vim.g.vscode then
  return {
    'stevearc/oil.nvim',
    keys = {
      { "<leader>tt", "<cmd>lua require('oil').toggle_float('.')<cr>", desc = "Browse files for editing" },
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
