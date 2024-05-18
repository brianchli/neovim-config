local onedark = {
  'navarasu/onedark.nvim',
  name = 'onedark',
  lazy = false,
  priority = 1000,
  dependencies = { "catppuccin/nvim" },
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
    cmd.colorscheme 'onedark'
  end
}

return onedark;
