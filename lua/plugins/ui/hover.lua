if not vim.g.vscode then
  return {
    'lewis6991/hover.nvim',
    keys = {
      {
        "K",
        function()
          require("hover").open()
        end,
        desc = "hover.nvim (open)",
        mode = "n",
      },
      {
        "gK",
        function()
          require("hover").enter()
        end,
        desc = "hover.nvim (enter)",
        mode = "n",
      },
      {
        "<C-p>",
        function()
          require("hover").switch("previous")
        end,
        desc = "hover.nvim (previous source)",
      },
      {
        "<C-n>",
        function()
          require("hover").switch("next")
        end,
        desc = "hover.nvim (next source)",
      },
    },
    opts = {
      providers = {
        'hover.providers.diagnostic',
        'hover.providers.lsp',
        'hover.providers.man',
        'hover.providers.dictionary',
        'hover.providers.highlight',
        'hover.providers.fold_preview'
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        'hover.providers.lsp',
      },
    },
  }
end
