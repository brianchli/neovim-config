return {
  'Wansmer/treesj',
  keys = {
    { "<leader>m", function() require('treesj').toggle({ split = { recursive = true } }) end, desc = "split list" },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  opts = {
    use_default_keymaps = false,
    max_join_length = 200,
  }
}
