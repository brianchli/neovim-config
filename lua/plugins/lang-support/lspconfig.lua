if not vim.g.vscode then
  --- @param args vim.api.keyset.create_autocmd.callback_args
  local on_attach = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    require("fidget").notify(client.name .. " attached")
    require("lsp").apply(client, args.buf)
  end

  return {
    {
      'SmiteshP/nvim-navic',
      lazy = true,
      dependencies = {
        'neovim/nvim-lspconfig',
      }
    },
    {
      'mrcjkb/rustaceanvim',
      dependencies = {
        'neovim/nvim-lspconfig',
      },
      version = '^6', -- Recommended
      lazy = false,   -- This plugin is already lazy
      init = function()
        -- Silence the lsp log warning by providing an empty config
        vim.lsp.config["rust-analyzer"] = {};
      end
    },
    {
      'stevearc/conform.nvim',
      opts = {
        -- Map of filetype to formatters
        formatters_by_ft = {
          lua = { "stylua" },
          -- You can also customize some of the format options for the filetype
          rust = { "rustfmt" },
          python = { "ruff_format" },
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          -- Use the "*" filetype to run formatters on all filetypes.
          ["*"] = { "trim_whitespace", "trim_newlines" },
        },
        -- Set this to change the default values when calling conform.format()
        -- This will also affect the default values for format_on_save/format_after_save
        default_format_opts = {
          lsp_format = "last",
        },
        -- Set the log level. Use `:ConformInfo` to see the location of the log file.
        --log_level = vim.log.levels.DEBUG,
        log_level = vim.log.levels.ERROR,
        -- [DEBUGGING] Conform will notify you when a formatter errors
        -- notify_on_error = true,
        -- Conform will notify you when no formatters are available for the buffer
        notify_no_formatters = true,
        -- Custom formatters and overrides for built-in formatters

      },
    },
    {
      'neovim/nvim-lspconfig',
      priority = 950,
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
      },
      init = function()
        vim.o.inccommand = "split"
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

        -- Diagnostic configurations
        local diag = vim.diagnostic.severity
        -- Redefine signs for all diagnostics
        vim.diagnostic.config({
          signs = {
            text = {
              [diag.ERROR] = "●",
              [diag.WARN] = "●",
              [diag.HINT] = "●",
              [diag.INFO] = "●",
            }
          },
          -- jump to diagnostics using [d and ]d
          jump = { float = true },

          -- do the following for lsp diagnostics:
          -- 1. disable prefix (e.g. number)
          -- 2. sort from the highest severity
          -- 3. include the source where the warn/error come from
          float = { prefix = "", header = "", severity_sort = true, source = true },
        })

        local capabilities = _G.utils.tjoin(
          vim.lsp.protocol.make_client_capabilities(),
          require('cmp_nvim_lsp').default_capabilities()
        )

        vim.lsp.config('*', {
          capabilities = capabilities
        })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = on_attach,
        })
      end,
      -- manually set up lsp as lspconfig.setup({}) will be deprecated
      -- and lazy calls this under the hood using opts
      config = function()
      end

    }
  }
end
