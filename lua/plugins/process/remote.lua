if not vim.g.vscode then
  return {
    -- "amitds1997/remote-nvim.nvim",
    "brianchli/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    branch = "feature.lazy-installation",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- For standard functions
      "MunifTanjim/nui.nvim",          -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
    },
    config = true,
  }
end
