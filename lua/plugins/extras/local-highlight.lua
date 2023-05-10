if not vim.g.vscode then
  return {
    'tzachar/local-highlight.nvim',
    config = function()
      require('local-highlight').setup({
        hlgroup = "Cursor",
        cw_hlgroup = "CurSearch"
      })
    end
  }
end
