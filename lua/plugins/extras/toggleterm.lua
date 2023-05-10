return {
  'akinsho/toggleterm.nvim',
  keys = {
    { "<leader>\\\\", "<cmd>ToggleTerm<cr>", desc = "Toggle term" },
  },
  config = function()
    local status, toggleterm = pcall(require, 'toggleterm')
    if status then
      toggleterm.setup({
        size = function()
          return vim.o.columns * 0.33
        end,
        direction = 'vertical',
      })
      local opts = { noremap = true }
      vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', opts)
      vim.keymap.set('t', 'q', '<C-\\><C-n><C-w><C-w>', opts)
      vim.keymap.set('t', '<esc>', '<C-d>', opts)
    end
  end
}
