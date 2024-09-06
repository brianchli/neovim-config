if not vim.g.vscode then
  return {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function()
      -- require('symbol-usage').setup()
      --      vim.api.nvim_create_autocmd({ "InsertLeave", }, {
      --        group = augroup('autoupdate-symbol-usage'),
      --        desc = "updates symbols upon leaving insert mode",
      --        pattern = {
      --          "cpp",
      --          "py",
      --          "c",
      --          "lua"
      --        },
      --        callback = function()
      --          vim.fn('lua require("symbol-usage").refresh()"')
      --        end
      --      })
    end
  }
end
