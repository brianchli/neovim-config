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
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "find fuffers" },
        { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "find options" },
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
