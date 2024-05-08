if not vim.g.vscode then
  return {
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim', },
      priority = 900,
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "find files" },
        { "<leader>fm", "<cmd>Telescope man_pages<cr>",   desc = "find man page" },
        { "<leader>fc", "<cmd>Telescope commands<cr>",    desc = "find command" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "find help tags" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "find buffers" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "find options" },
        { "<leader>fg", "<cmd>Telescope git_commits<cr>", desc = "find commits" },
        { "<leader>fG", "<cmd>Telescope git_bcommits<cr>", desc = "find commits with diff in current buffer" },
        { "<leader>f?", "<cmd>Telescope builtin<cr>", desc = "find telescope builtins" },
        { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "find substring" },
      },
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
      config = function()
        local _ = require('telescope')
        local actions = require('telescope.actions')
        require("telescope").setup({
          defaults = {
            prompt_prefix = " " .. require('config.icons').dap.Stopped[1],
            mappings = {
              i = {
                ["<esc>"] = actions.close
              },
            },
            path_display = { truncate = 3 }
          },
          pickers = {
            commands = {
              layout_strategy = "center",
              layout_config = { width = 0.80 }
            },
            man_pages = {
              previewer = false,
              layout_strategy = "center",
            },
            help_tags = {
              previewer = false,
              layout_strategy = "center",
            },
            vim_options = {
              layout_strategy = "center",
              layout_config = { width = 0.80 }
            }

          },
          extensions = {
            ["ui-select"] = {
              require('telescope.themes').get_dropdown {}

            }
          }
        })
        require('telescope').load_extension('ui-select')
      end
    },
  }
end
