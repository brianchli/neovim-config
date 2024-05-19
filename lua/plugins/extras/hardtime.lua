if not vim.g.vscode then
  return {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      -- Add "oil" to the disabled_filetypes
      disabled_filetypes = {
        "qf",
        "netrw",
        "NvimTree",
        "lazy",
        "mason",
        "oil",
        "harpoon",
        "help",
        "man",
        "telescope",
      },
      disable_mouse = false
    },
    config = function(_, opts)
      require("hardtime").setup(opts)
    end
  }
end
