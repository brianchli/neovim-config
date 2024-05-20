-- noicer ui
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  keys = {
    {
      "<S-Enter>",
      function() require("noice").redirect(vim.fn.getcmdline()) end,
      mode = "c",
      desc =
      "Redirect Cmdline"
    },
    {
      "<leader>snl",
      function() require("noice").cmd("last") end,
      desc =
      "Noice Last Message"
    },
    {
      "<leader>snh",
      function() require("noice").cmd("history") end,
      desc =
      "Noice History"
    },
    { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    {
      "<c-f>",
      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
      silent = true,
      expr = true,
      desc =
      "Scroll forward",
      mode = {
        "i", "n", "s" }
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup {
      presets = { inc_rename = true }
    }
  end
}
