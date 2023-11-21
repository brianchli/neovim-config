if not vim.g.vscode then
  return {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      space_char_blankline = " ",
      show_current_context = true,
    },
    config = function()
      require("ibl").setup(
        {
          scope = {
            show_start = false,
          }

        }
      )
    end
  }
end
