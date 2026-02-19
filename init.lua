if not vim.g.vscode then
  local configs = require('config')
  local ui = require('ui')

  local editor_conf, lazy = configs.Editor, configs.Lazy
  editor_conf.load()
  lazy.setup()

  ui.init()
  ui.statusline.render()
  ui.winbar.render()
end
