if not vim.g.vscode then
  return {
    -- set up mason
    {
      'williamboman/mason.nvim',
      dependencies = {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
      },
      priority = 980,
      keys = {
        {
          "<leader>M",
          "<cmd>Mason<cr>",
          desc = "open mason",
        },
      },
      opts = {
        PATH = "append",
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },

    {
      -- auto updates language server protocols installed via mason
      -- uses mason names only
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          "lua-language-server",
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
          "texlab",
          "jsonls",
          "clangd",
          "pylsp",
          "marksman",
          "harper_ls",
          "tombi",
          "rumdl",
          "gopls",
          "html"

        },
        auto_update = true,
      },
    },
    -- translation layer between mason lsp names and
    -- lspconfig names.
    {
      "mason-org/mason-lspconfig.nvim",
      priority = 970,
      dependencies = {
        { "mason-org/mason.nvim",
        },
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
          "texlab",
          "jsonls",
          "marksman",
          "harper_ls",
          "pylsp",
          "ruff",
          "lua_ls",
          "tombi",
          "rumdl",
          "gopls",
          "html"
        },
        automatic_enable = true
      }
    },
  }
end
