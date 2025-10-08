if not vim.g.vscode then
  return {
    {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { -- optional cmp completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = opts.sources or {}
          table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          })
        end,
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      priority = 980,
      build = ":TSUpdate",
      lazy = false,
      dependencies = {
        'windwp/nvim-ts-autotag',                     -- for autotagging
        'nvim-treesitter/nvim-treesitter-textobjects' -- for textobjects
      },
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            "bash",
            "css",
            "html",
            "make",
            "cmake",
            "python",
            "cpp",
            "yaml",
            "regex",
            "javascript",
            "typescript",
            "toml",
            "rust",
            "zig",
            "haskell",
            "vim",
            "vimdoc",
            "lua",
            "json",
            "tsx"
          },

          highlight = {
            enable = true,
          },

          indent = {
            enable = true,
          },

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },

          autotag = {
            enable = true,
          },

          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
              },
              goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
              },
            },
          },
        })
      end,
    },
    -- set up git signs
    {
      'lewis6991/gitsigns.nvim',
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        local status, gitsigns = pcall(require, 'gitsigns')
        if status then
          local on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, { expr = true })

            map('n', '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, { expr = true })

            -- Actions
            map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = "stage hunk" })
            map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = "unstage hunk" })
            map('n', '<leader>Gs', gs.stage_buffer, { desc = 'stage buffer' })
            map('n', '<leader>Gu', gs.undo_stage_hunk, { desc = 'unstage hunk' })
            map('n', '<leader>GR', gs.reset_buffer, { desc = 'reset buffer' })
            map('n', '<leader>Gp', gs.preview_hunk, { desc = 'preview hunk' })
            map('n', '<leader>Gb', function() gs.blame_line { full = true } end,
              { desc = 'show full blame in a new buffer' })
            map('n', '<leader>Gb', gs.toggle_current_line_blame, { desc = 'toggle blame lines' })
            map('n', '<leader>Gd', gs.diffthis, { desc = 'diff old on left split' })
            map('n', '<leader>GD', function() gs.diffthis('~') end, { desc = "also diff old on left side" })
            map('n', '<leader>Gt', gs.toggle_deleted, { desc = 'toggle deleted in line' })

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end

          gitsigns.setup({
            on_attach = on_attach,
            signs = {
              add          = { text = '┃' },
              change       = { text = '┃' },
              delete       = { text = '_' },
              topdelete    = { text = '‾' },
              changedelete = { text = '~' },
              untracked    = { text = '┆' },
            },
            current_line_blame = true,
            current_line_blame_opts = {
              delay = 300,
            },
          })
        end
      end
    }

  }
end
