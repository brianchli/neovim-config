if not vim.g.vscode then
  return {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
        },
        -- set highlighting based off set colors in nvim
        highlight = {
          'NonText',
          'Define',
          'Label',
          'Conditional',
          'Boolean',
          'DiagnosticError',
        },
      }
    end
  }
end
