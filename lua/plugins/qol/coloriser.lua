if not vim.g.vscode then
  return {
    'norcalli/nvim-colorizer.lua',
    priority = 200,
    config = function()
      local status, colorizer = pcall(require, 'colorizer')
      if status then
        colorizer.setup({
          "*", css = { rgb_fn = true }

        })
      end
    end
  }
end
