local onedark = {
  'navarasu/onedark.nvim',
  name = 'onedark',
  lazy = false,
  priority = 1000,
  config = function()
    local cmd = vim.cmd
    vim.o.termguicolors = true
    cmd.colorscheme 'onedark'
    -- match fold column background
    local bg_color = vim.api.nvim_get_hl_by_name("EndOfBuffer", true).background
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })

  end
}

return onedark;
