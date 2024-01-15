if not vim.g.vscode then
  return {
    'norcalli/nvim-colorizer.lua',
    keys = {
      { "<leader>cs", "<cmd>ColorizerToggle<cr>", desc = "colorise hex codes" },
    },
    priority = 200,
    config = function()
      local status, colorizer = pcall(require, 'colorizer')
      if status then
        colorizer.setup()
      end
    end
  }
end
