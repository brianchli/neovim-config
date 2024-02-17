if not vim.g.vscode then
  return {
    "lervag/vimtex",
    init = function()
      -- Set vimtex view method to zathura
      vim.g.vimtex_view_method = 'zathura'

      -- Disable vimtex quickfix mode
      vim.g.vimtex_quickfix_mode = 0

      -- set different build directory
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = 'tex_build',
        out_dir = 'tex_out',
      }
    end,
  }
end
