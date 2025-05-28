if not vim.g.vscode then
  return {
    -- set up mason
    {
      'williamboman/mason.nvim',
      priority = 980,
      keys = {
        { "<leader>m", "<cmd>Mason<cr>", desc = "open mason" },
      },
      config = function()
        -- enable mason and configure icons
        local mason = require('mason')
        mason.setup({
          PATH = "append",
          ui = {
            icons = {
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        })
      end
    },
    -- set up lsp integration with mason
    {
      "mason-org/mason-lspconfig.nvim",
      priority = 970,
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
      opts = {
        ensure_installed = {
          "ruff",
          "sqlls",
          "yamlls",
          "cmake",
          "dockerls",
          "astro",
          "ts_ls",
          "cssls",
          "eslint",
          "emmet_ls",
          "lua_ls",
          "zls",
          "texlab",
          "jsonls",
        },
        automatic_installation = true,
        automatic_enable = false
      }
    },
    -- auto updates language server protocols installed via mason
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      priority = 960,
      config = function()
        require('mason-tool-installer').setup {
          ensure_installed = {
            "lua-language-server",
            "cspell",
            "ruff",
            "sqlls",
            "yamlls",
            "cmake",
            "dockerfile-language-server",
            "astro",
            "ts_ls",
            "cssls",
            "eslint",
            "emmet_ls",
            "lua_ls",
            "zls",
            "texlab",
            "jsonls",
            "clangd",
            -- "prettier",
            "prettierd",
            "pylsp",
          },
          auto_update = true,

        }
      end
    }
  }
end
