local kanagawa = {
  'thesimonho/kanagawa-paper.nvim',
  name = 'kanagawa-paper',
  lazy = false,
  priority = 1000,
  config = function()
    local cmd = vim.cmd
    vim.o.termguicolors = true
    cmd.colorscheme 'kanagawa-paper-ink'
    -- match old column background
    local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color })

  end
}

return kanagawa;
