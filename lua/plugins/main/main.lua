if not vim.g.vscode then
  return {
    {
      {
        "folke/lazydev.nvim",
        priority = 1000,
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim",        words = { "Snacks" } },
            { path = "lazy.nvim",          words = { "LazyVim" } },
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
            "tsx",
            "go"
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
    -- use git signs snippet from lazy nvim with some modifications
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        signs = {
          add                     = { text = '┃' },
          change                  = { text = '┃' },
          delete                  = { text = '_' },
          topdelete               = { text = '‾' },
          changedelete            = { text = '~' },
          untracked               = { text = '┆' },
          current_line_blame      = true,
          current_line_blame_opts = {
            delay = 300,
          },
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
          end

          -- stylua: ignore start
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, "Next Hunk")
          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, "Prev Hunk")
          map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
          map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
          map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
          map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
          map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
          map("n", "<leader>ghd", gs.diffthis, "Diff This")
          map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      },
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        dim = { enabled = false },
        image = { enabled = false },

        bigfile = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        words = { enabled = true },
        win = { enabled = true },
        terminal = { enabled = true },
        styles = {
          notification = {
            wo = { wrap = true } -- Wrap notifications
          },
          terminal = {
            bo = {
              filetype = "snacks_terminal",
            },
            wo = {},
            stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
            keys = {
              q = "hide",
              gf = function(self)
                local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
                if f == "" then
                  Snacks.notify.warn("No file under cursor")
                else
                  self:hide()
                  vim.schedule(function()
                    vim.cmd("e " .. f)
                  end)
                end
              end,
              term_normal = {
                "<esc>",
                function(self)
                  self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                  if self.esc_timer:is_active() then
                    self.esc_timer:stop()
                    Snacks.terminal()
                  else
                    self.esc_timer:start(200, 0, function() end)
                    return "<esc>"
                  end
                end,
                mode = "t",
                expr = true,
                desc = "Double escape to normal mode",
              },
            },
          },
        }
      },
      keys = {
        -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
        { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
        -- find
        { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
        { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
        { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
        { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
        -- git
        { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
        { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
        { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
        { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
        { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
        { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
        { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
        -- gh
        { "<leader>gi",      function() Snacks.picker.gh_issue() end,                                desc = "GitHub Issues (open)" },
        { "<leader>gI",      function() Snacks.picker.gh_issue({ state = "all" }) end,               desc = "GitHub Issues (all)" },
        { "<leader>gp",      function() Snacks.picker.gh_pr() end,                                   desc = "GitHub Pull Requests (open)" },
        { "<leader>gP",      function() Snacks.picker.gh_pr({ state = "all" }) end,                  desc = "GitHub Pull Requests (all)" },
        -- Grep
        { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
        { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
        { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word",   mode = { "n", "x" } },
        -- search
        { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
        { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
        { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
        { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
        { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
        { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
        { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
        { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
        { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
        { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
        { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
        { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
        { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
        { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
        { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
        { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
        { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
        { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
        { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
        { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
        { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
        -- LSP
        { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
        { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
        { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                       desc = "References" },
        { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
        { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
        { "gai",             function() Snacks.picker.lsp_incoming_calls() end,                      desc = "C[a]lls Incoming" },
        { "gao",             function() Snacks.picker.lsp_outgoing_calls() end,                      desc = "C[a]lls Outgoing" },
        { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
        -- Other
        { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
        { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
        { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
        { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
        { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
        { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",                 mode = { "n", "v" } },
        { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
        { "\\",              function() Snacks.terminal() end,                                       desc = "Toggle Terminal",            mode = { "n", "t" } },
        { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",             mode = { "n", "t" } },
        { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",             mode = { "n", "t" } },
        {
          "<leader>N",
          desc = "Neovim News",
          function()
            Snacks.win({
              file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
              width = 0.6,
              height = 0.6,
              wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
              },
            })
          end,
        },

      },
      init = function()
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end

            -- Override print to use snacks for `:=` command
            if vim.fn.has("nvim-0.11") == 1 then
              vim._print = function(_, ...)
                dd(...)
              end
            else
              vim.print = _G.dd
            end

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
            Snacks.toggle.diagnostics():map("<leader>tD")
            Snacks.toggle.line_number():map("<leader>tl")
            Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
                :map("<leader>tc")
            Snacks.toggle.treesitter():map("<leader>tT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
              "<leader>tb")
            Snacks.toggle.inlay_hints():map("<leader>th")
            Snacks.toggle.indent():map("<leader>tg")
          end,
        })
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    }
  }
end
