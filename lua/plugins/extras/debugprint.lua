if not vim.g.vscode then
  return {
    "andrewferrier/debugprint.nvim",
    opts = { ... },
    -- Dependency only needed for NeoVim 0.8
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
    keys = {
      { "<leader>dbpd", "<cmd>DeleteDebugPrints<cr>", desc = "Toggle coloriser" },
    },
    -- Remove the following line to use development versions,
    -- not just the formal releases
    version = "*"
  }
end
