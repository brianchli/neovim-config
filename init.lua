if not vim.g.vscode then
  --╭──────────────────────────────────────────────────────────╮
  --│ *LEADER*                                                 │
  --│ These keybindings need to be defined before the first /  │
  --│ is called; otherwise, it will default to "\"             │
  --│                                                          │
  --╰──────────────────────────────────────────────────────────╯

  local cmd = vim.cmd
  vim.g.mapleader = ' '
  vim.g.localleader = '\\'

  -- change diagnostic signs for warnings
  cmd "sign define DiagnosticSignError text=● texthl=DiagnosticSignError"
  cmd "sign define DiagnosticSignWarn text=● texthl=DiagnosticSignWarn"
  cmd "sign define DiagnosticSignInfo text=● texthl=DiagnosticSignInfo"
  cmd "sign define DiagnosticSignHint text=● texthl=DiagnosticSignHint"

  require('conf.opts')      -- options
  require('conf.keymaps')   -- key mappings
  require('conf.autofuncs') -- functions and autocmds
  require('conf.setup')     -- plugins
end
