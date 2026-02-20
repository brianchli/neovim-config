local M = {
  statusline = {},
  winbar = {},
}

M.statusline.render = function()
  vim.o.statusline = "%!v:lua.require('ui.statusline').render()"
end

M.winbar.render = function()
  vim.o.winbar = "%!v:lua.require('ui.winbar').render()"
  local timer = vim.loop.new_timer()
  timer:start(0, 1000, vim.schedule_wrap(function()
    current_time = os.date("%H:%M:%S")
    vim.cmd("redrawstatus") -- only redraw statusline + winbar
  end))
end

M.init = function()
  vim.cmd.colorscheme("nordic")
end

return M
