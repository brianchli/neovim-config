if not vim.g.vscode then
  return {
    {
      "folke/neodev.nvim",
      priority = 1000,
      config = function()
        require("neodev").setup({
          library = { plugins = { "nvim-dap-ui" }, types = true },
        })
      end
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        "mfussenegger/nvim-dap",
        "folke/neodev.nvim",
      },
      config = function()
        require('dapui').setup()
      end
    }
  }
end
