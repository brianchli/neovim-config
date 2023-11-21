if not vim.g.vscode then
  return {
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
    --    config = function()
    --      local status, _ = pcall(require, 'telescope')
    --      if status then
    --        local map = vim.keymap.set
    --        local telescope = require('telescope.builtin')
    --      end
    --    end
  }
end
