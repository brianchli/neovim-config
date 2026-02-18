if not vim.g.vscode then
  -- These keybindings need to be defined before the first
  -- is called; otherwise, it will default to "\"

  vim.g.mapleader = ' '
  vim.g.localleader = '\\'

  local configs = require('config')
  local conf, lazy = configs.Local, configs.Lazy

  conf.load()
  lazy.setup()

  vim.cmd.colorscheme("nordic")

  local ui = require('ui')
  ui.statusline.render()
  ui.winbar.render()
end
