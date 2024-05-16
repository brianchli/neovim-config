if not vim.g.vscode then
  return {
    {
      'echasnovski/mini.surround',
      version = false,
      config = function()
        require("mini.surround").setup()
      end
    },
    {
      'echasnovski/mini.comment',
      version = false,
      config = function()
        require('mini.comment').setup()
      end
    },
    {
      'echasnovski/mini.trailspace',
      version = false,
      config = function()
        require('mini.trailspace').setup()
      end
    },
  }
end
