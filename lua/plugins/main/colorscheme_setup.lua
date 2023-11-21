return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'macchiato',
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
        },
      })

      local cmd = vim.cmd
      vim.o.termguicolors = true
      cmd.colorscheme 'catppuccin'
      local macchiato = require("catppuccin.palettes").get_palette "macchiato"
      -- setting the outlines for highlighting the current line
      vim.api.nvim_set_hl(
        0, 'Cursor', { bg = macchiato.surface0, fg = macchiato.text }
      )
      vim.api.nvim_set_hl(
        0, 'CurSearch', { bg = macchiato.surface1, fg = macchiato.text })
    end,
    priority = 1000
  },
}
