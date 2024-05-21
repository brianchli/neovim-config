local doom = {
  'NTBBloodbath/doom-one.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    local cmd = vim.cmd
    vim.o.termguicolors = true
    cmd.colorscheme 'doom-one'
    -- match fold column background
    local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
  end
}

return doom;
