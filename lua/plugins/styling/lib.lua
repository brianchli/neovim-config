if not vim.g.vscode then
  return {
    {
      'echasnovski/mini.surround',
      version = false,
      lazy = true,
      opts = {}
    },
    {
      'echasnovski/mini.comment',
      version = false,
      lazy = true,
      opts = {}
    },
    {
      'echasnovski/mini.trailspace',
      version = false,
      lazy = true,
      opts = {}
    },
    {
      'echasnovski/mini.icons',
      version = '*',
      lazy = true,
      opts = {}
    },
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      lazy = true,
      opts = {}
    }

  }
end
