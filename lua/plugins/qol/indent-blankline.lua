if not vim.g.vscode then
  return {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    opts = {
      space_char_blankline = "",
      show_current_context = true,
    },
    config = function()
      local highlight = {
        "NonText",
      }
      require("ibl").setup {
        indent = { highlight = highlight, smart_indent_cap = true, char = "|" },
        whitespace = {
          highlight = highlight,
          remove_blankline_trail = false,
        },
        scope = {
          show_start = false
        },
      }
    end
  }
end
