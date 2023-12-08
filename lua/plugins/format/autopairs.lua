if not vim.g.vscode then
  return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  }
  --  return {
  --    "echasnovski/mini.pairs",
  --    event = "VeryLazy",
  --    config = function(_, opts)
  --      require("mini.pairs").setup(opts)
  --    end,
  --  }
end
