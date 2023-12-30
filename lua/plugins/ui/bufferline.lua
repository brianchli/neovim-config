if not vim.g.vscode then
  return {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { "<leader>l", "<cmd>bnext<CR>", desc = "Go to next buffer" },
      { "<leader>h", "<cmd>bprev<CR>", desc = "Go to next buffer" },
    },
    config = function()
      local status, bufferline = pcall(require, 'bufferline')
      if status then
        bufferline.setup({
          options = {
            separator_style = 'slant',
            show_tab_indicators = false
          }
        })
      end
    end
  }
end
