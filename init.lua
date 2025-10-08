if not vim.g.vscode then
  --╭──────────────────────────────────────────────────────────╮
  --│ *LEADER*                                                 │
  --│ These keybindings need to be defined before the first /  │
  --│ is called; otherwise, it will default to "\"             │
  --│                                                          │
  --╰──────────────────────────────────────────────────────────╯

  vim.g.mapleader = ' '
  vim.g.localleader = '\\'

  require('opts')      -- options
  require('keymaps')   -- key mappings
  require('autofuncs') -- functions and autocmds
  require('globals')

  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  local status, lazy = pcall(require, 'lazy')
  if status then
    lazy.setup({
      spec = {
        { import = 'plugins.main' },
        { import = 'plugins.ui' },
        { import = 'plugins.lang-support' },
        { import = 'plugins.styling' },
        { import = 'plugins.navigation' },
        { import = 'plugins.extras' },
        { import = 'plugins.diagnostics' },
        { import = 'plugins.file' },
      },
      checker = {
        enabled = true,
        notify = false,
      },
      change_detection = {
        notify = false
      }
    })
  end

  require("ui.statusline")

end
