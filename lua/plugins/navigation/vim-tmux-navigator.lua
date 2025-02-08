-- https://github.com/alexghergh/nvim-tmux-navigation
if not vim.g.vscode then
  return {
    "alexghergh/nvim-tmux-navigation",
    opts = {
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
        next = "<C-Space>",
      }
    },
    config = function(_, opts)
      require('nvim-tmux-navigation').setup(opts)
    end
  }
end
