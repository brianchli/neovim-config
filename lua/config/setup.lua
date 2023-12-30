-- load lazy
if not vim.g.vscode then
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
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
        { import = 'plugins.lsp' },
        { import = 'plugins.format' },
        { import = 'plugins.navigate' },
        { import = 'plugins.extras' },
        { import = 'plugins.diagnostics' },
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
end
