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
      'williamboman/mason-lspconfig.nvim',
      priority = 970,
      opts = {
        ensure_installed = {
          "ruff_lsp",
          "ruff",
          "sqlls",
          "yamlls",
          "cmake",
          "dockerls",
          "astro",
          "tsserver",
          "cssls",
          "eslint",
          "emmet_ls",
          "lua_ls",
          "zls",
          "texlab",
          "jsonls",
          "rust_analyzer",
        },
        automatic_installation = true,
      }
    },
    -- set up dap installer integration with mason
    {
      "jay-babu/mason-nvim-dap.nvim",
      priority = 950,
      dependencies = {
        'williamboman/mason.nvim',
      },
      config = function()
        require("mason-nvim-dap").setup(
          {
            handlers = {},
            ensure_installed = { "python", "codelldb" },
          }
        )
      end
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
            "ruff_lsp",
            "sqlls",
            "yamlls",
            "cmake",
            "dockerfile-language-server",
            "astro",
            "tsserver",
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
            "rust-analyzer"
          },
          auto_update = true,

        }
      end
    }
  }
end
