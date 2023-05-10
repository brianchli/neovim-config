return {
  'williamboman/mason.nvim',
  keys = {
    { "<leader>m", "<cmd>Mason<cr>", desc = "open mason" },
  },
  config = function()
    require('mason').setup()
  end,
  priority = 950,
}
