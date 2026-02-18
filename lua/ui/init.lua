local M = {
  statusline = {},
  winbar = {},
}
M.statusline.render = function()
  require('ui.statusline').render()
end

M.winbar.render = function()
  require('ui.winbar').render()
end

return M
