if not vim.g.vscode then
  return {
    -- set up mason
    {
      'williamboman/mason.nvim',
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
    -- translation layer between mason lsp names and
    -- lspconfig names.
    {
      "mason-org/mason-lspconfig.nvim",
      priority = 970,
      dependencies = {
        { "mason-org/mason.nvim" },
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
              "prettierd",
              "pylsp",
              "marksman",
              "harper_ls",
            },
            auto_update = true,
          },
        }
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
          "lua_ls"

        },
        
        automatic_enable = true
      }
    },
  }
end
