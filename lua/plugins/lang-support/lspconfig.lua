if not vim.g.vscode then
  --- @param args vim.api.keyset.create_autocmd.callback_args
  local on_attach = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    require("fidget").notify(client.name .. " attached")
    require("config.lsp").apply(client, args.buf)
  end

  local diag_format = function(diag)
    if diag.code then
      return string.format("%s: %s [%s]", diag.source, diag.message, diag.code)
    else
      return string.format("%s: %s", diag.source, diag.message)
    end
  end

  local function clear_diags()
    return {
      virtual_lines = false,
      virtual_text = false,
      underline = false,
    }
  end

  local function diag_set(t)
    return vim.tbl_deep_extend("force", clear_diags(), t)
  end

  local function virtual_text_default()
    return
    {
      virtual_text = {
        spacing = 2,
        source = false,
        prefix = "",
        current_line = true,
        format = diag_format,
      }
    }
  end

  local function reset_diag_windows()
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "nofile" and vim.api.nvim_win_get_config(win).relative ~= "" then
        vim.api.nvim_win_close(win, true)
      end
    end
  end

  local function toggle_diag_display_type()
    local lines = vim.diagnostic.config().virtual_lines
    local text = vim.diagnostic.config().virtual_text
    local underline = vim.diagnostic.config().underline
    vim.diagnostic.config((lines or text or underline)
      and clear_diags()
      or diag_set(virtual_text_default())
    )
    reset_diag_windows()
  end

  local function toggle_diag_line_variant()
    local lines = vim.diagnostic.config().virtual_lines
    local text = vim.diagnostic.config().virtual_text
    local underline = vim.diagnostic.config().underline
    vim.diagnostic.config(not text and
      diag_set(virtual_text_default())
      or diag_set({
        virtual_lines = { current_line = true, format = diag_format },
        underline = { current_line = true }
      }))
    reset_diag_windows()
  end

  local SIGNS = {
    [vim.diagnostic.severity.ERROR] = "●",
    [vim.diagnostic.severity.WARN] = "●",
    [vim.diagnostic.severity.HINT] = "●",
    [vim.diagnostic.severity.INFO] = "●",
  }

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
      'p00f/clangd_extensions.nvim',
      ft = "cpp"
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
          toml = { "tombi" },
          markdown = { "rumdl" },
          nix = { "nixfmt" },
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
      keys = {
        {
          "<Tab>",
          toggle_diag_line_variant,
          desc = "Toggle between inline diagnostic variants",
          { 'n' }
        },
        {
          "<S-Tab>",
          toggle_diag_display_type,
          desc = "Toggle floating diagnostics",
          { 'n' }
        }
      },
      init = function()
        vim.o.inccommand = "split"
        vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

        -- Redefine signs for all diagnostics
        vim.diagnostic.config({

          virtual_text = {
            spacing = 2,
            source = false,
            prefix = "",
            current_line = true,
            format = diag_format,
          },

          virtual_lines = false,
          underline = false,

          signs = {
            severity = { min = vim.diagnostic.severity.WARN },
            text = SIGNS
          },
          -- jump to diagnostics using [d and ]d
          jump = { float = true },

          -- do the following for lsp diagnostics:
          -- 1. disable prefix (e.g. number)
          -- 2. sort from the highest severity
          -- 3. include the source where the warn/error come from
          float = {
            bordered = false,
            severity_sort = true,
            source = true
          },

        })

        local capabilities = _G.utils.tjoin(
          vim.lsp.protocol.make_client_capabilities(),
          require('cmp_nvim_lsp').default_capabilities()
        )

        vim.lsp.config('*', {
          capabilities = capabilities
        })

        vim.lsp.config("html", {
          settings = {
            html = { validate = true },
            css  = { validate = true },
          },
          capabilities = capabilities,
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
