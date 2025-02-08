if not vim.g.vscode then
  return {
    -- color scheme
    loadfile(vim.fn.stdpath('config') .. '/lua/colorscheme/onedark.lua')(),
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- Library paths can be absolute
          "~/projects/my-awesome-lib",
          -- Or relative, which means they will be resolved from the plugin dir.
          "lazy.nvim",
          -- It can also be a table with trigger words / mods
          -- Only load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library",        words = { "vim%.uv" } },
          -- always load the LazyVim library
          "LazyVim",
          -- Only load the lazyvim library when the `LazyVim` global is found
          { path = "LazyVim",                   words = { "LazyVim" } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `justinsgithub/wezterm-types` to be installed
          { path = "wezterm-types",             mods = { "wezterm" } },
          -- Load the xmake types when opening file named `xmake.lua`
          -- Needs `LelouchHe/xmake-luals-addon` to be installed
          { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
        },
        -- always enable unless `vim.g.lazydev_enabled = false`
        -- This is the default
        enabled = function(root_dir)
          return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
        end,
        -- disable when a .luarc.json file is found
        enabled = function(root_dir)
          return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
        end,
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      priority = 980,
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter.configs').setup(
          {
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
              "vimdoc"
            },

            highlight = {
              enable = true
            },
            indent = {
              enable = true
            },
            incremental_selection = {
              enabled = true
            }
          })
      end
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
