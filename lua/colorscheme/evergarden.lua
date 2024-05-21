local evergarden = {
  'comfysage/evergarden',
  name = 'evergarden',
  lazy = false,
  priority = 1000,
  config = function()
    local cmd = vim.cmd
    vim.o.termguicolors = true
    cmd.colorscheme 'evergarden'
    -- match fold column background
    local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
    require('evergarden').setup({
      transparent_background = false,
      contrast_dark = 'hard', -- 'hard'|'medium'|'soft'
      override_terminal = true,
      style = {
        search = { reverse = false, inc_reverse = true },
        types = { italic = true },
        keyword = { italic = true },
        comment = { italic = false },
      },
      overrides = {}, -- add custom overrides
    })
  end
}

return evergarden;
