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
    -- whil
    {
      'williamboman/mason-lspconfig.nvim',
      priority = 930,
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
          "hls"
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
            'lua-language-server',
            "ruff",
            "ruff_lsp",
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
            "hls",
            "clangd",
            "prettier",
            "prettierd",
            "pylsp",
            "rust-analyzer"
          },
          auto_update = true,

        }
        -- notify that mason-tool-installer is running
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MasonToolsStartingInstall',
          callback = function()
            vim.schedule(function()
              print 'mason-tool-installer is starting'
            end)
          end,
        })
        -- notify list of packages updated by mason-tool-installer
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MasonToolsUpdateCompleted',
          callback = function(e)
            vim.schedule(function()
              if next(e.data) ~= nil then
                print("updated lsp(s): " + vim.inspect(e.data)) -- print the table that lists the programs that were installed
              end
            end)
          end,
        })
      end
    }
  }
end
