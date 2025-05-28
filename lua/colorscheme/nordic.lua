local nordic = {
  'AlexvZyl/nordic.nvim',
  name = 'nordic',
  lazy = false,
  priority = 1000,
  config = function()
    local cmd = vim.cmd
    vim.o.termguicolors = true
    cmd.colorscheme 'nordic'
    -- match fold column background
    local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local visual = vim.api.nvim_get_hl(0, { name = "NonText" }).fg
    local status = vim.api.nvim_get_hl(0, { name = "EndOfBuffer" }).fg

    vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color })
    vim.api.nvim_set_hl(0, "Folded", { bg = bg_color })
    vim.api.nvim_set_hl(0, "Visual", { bg = visual })

    vim.api.nvim_set_hl(0, "CursorLine", { bg = status })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = status })
  end
}

return nordic;
