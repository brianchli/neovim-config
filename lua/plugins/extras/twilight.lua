if not vim.g.vscode then
  return {
    "folke/twilight.nvim",
    keys = {
      { "<leader>tw", "<cmd>Twilight<cr>", desc = "toggle twilight" },
    },
    config = function(_, opts)
      require("twilight").setup(opts)
    end
  }
end
