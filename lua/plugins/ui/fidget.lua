if not vim.g.vscode then
  return {
    'j-hui/fidget.nvim',
    tag = "legacy",
    event = "LspAttach",
    config = function()
      local status, fidget = pcall(require, 'fidget')
      if status then
        fidget.setup()
      end
    end
  }
end
