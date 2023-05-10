if not vim.g.vscode then
  return {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local status, bufferline = pcall(require, 'bufferline')
      if status then
        bufferline.setup({
          options = {
            separator_style = 'slant'
          }
        })
      end
    end
  }
end
