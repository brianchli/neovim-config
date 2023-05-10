if not vim.g.vscode then
  return {
    "folke/twilight.nvim",
    keys = {
      { "<leader>tw", "<cmd>Twilight<cr>", desc = "toggle twilight" },
    },
    config = function()
      require("twilight").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        context = 75, -- amount of lines we will try to show around the current line
      }
    end
  }
end
