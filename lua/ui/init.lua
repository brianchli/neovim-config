local M = {
  statusline = {},
  winbar = {},
}

M.statusline.render = function()
  vim.o.statusline = "%!v:lua.require('ui.statusline').render()"
end

M.winbar.render = function()
  vim.o.winbar = "%!v:lua.require('ui.winbar').render()"
end

M.init = function()
  vim.cmd.colorscheme("nordic")
end

return M
