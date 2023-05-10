if not vim.g.vscode then
  return {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.api.nvim_set_option('cursorline', true)
      vim.opt.list = true
      vim.opt.listchars:append "space: "
      vim.opt.listchars:append "eol: "
      local cmd = vim.cmd
      cmd [[highlight IndentBlanklineContextChar guifg=#6e738d gui=nocombine]]
      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
      }
    end
  }
end
