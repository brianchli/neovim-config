if not vim.g.vscode then
  return {
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.4',
      dependencies = { 'nvim-lua/plenary.nvim' },
      priority = 900,
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
        { "<leader>fm", "<cmd>Telescope man_pages<cr>",   desc = "Man Pages" },
        { "<leader>fc", "<cmd>Telescope commands<cr>",    desc = "Commands" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
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
