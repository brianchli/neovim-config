if not vim.g.vscode then
  return {
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = function()
      local function color_num_to_hex(num) return ('#%06x'):format(num) end
      require("neodim").setup({
        refresh_delay = 75,
        alpha = 0.35,
        -- blend into whatever the background color is
        blend_color = color_num_to_hex(vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg),
        hide = {
          underline = false,
          virtual_text = false,
          signs = false,
        },
        regex = {
          "[uU]nused",
          "[nN]ever [rR]ead",
          "[nN]ot [rR]ead",
        },
        priority = 128,
        disable = {},
      })
    end
  }
end
