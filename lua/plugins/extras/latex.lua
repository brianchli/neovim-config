if not vim.g.vscode then
  return {
    "lervag/vimtex",
    init = function()
      -- Set LaTeX flavor
      vim.g.tex_flavor = 'latex'

      -- Set vimtex view method to zathura
      vim.g.vimtex_view_method = 'zathura'

      -- Disable vimtex quickfix mode
      vim.g.vimtex_quickfix_mode = 0

      -- Set conceal level to 1
      vim.cmd('set conceallevel=1')

      -- Set tex conceal options
      vim.g.tex_conceal = 'abdmg'
    end,
  }
end
