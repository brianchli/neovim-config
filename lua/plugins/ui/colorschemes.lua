-- load colorschemes
return {
  { 'Mofiqul/dracula.nvim',          name = 'dracula',  lazy = false },
  { 'drewtempelmeyer/palenight.vim', name = 'pale',     lazy = false },
  { 'rebelot/kanagawa.nvim',         name = 'kanagawa', lazy = false },
  { 'bluz71/vim-nightfly-colors',    name = 'nightfly', lazy = false },
  { 'olivercederborg/poimandres.nvim', name = 'poimandres', lazy = false },
  { 'Mofiqul/vscode.nvim',             name = 'vscode',     lazy = false },
  { 'p00f/alabaster.nvim',             name = 'alabaster',  lazy = false },
  {
    "yorik1984/newpaper.nvim",
    name = "newspaper",
    config = function()
      local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
      vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })

      local statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
      local question = vim.api.nvim_get_hl(0, { name = "Question" })

      -- set colors for highlighting duplicates under the cursor
      vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = statusline.bg, fg = question.fg, bold = true })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = statusline.bg, fg = question.fg, bold = true })
    end,
    lazy = false
  },
  {
    'AlexvZyl/nordic.nvim',
    name = 'nordic',
    lazy = false,
    priority = 1000,
    config = function()
      local cmd = vim.cmd
      vim.o.termguicolors = true
      cmd.colorscheme 'nordic'
      -- match fold column background
      local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
      local visual = vim.api.nvim_get_hl(0, { name = "NonText" }).fg
      local status = vim.api.nvim_get_hl(0, { name = "EndOfBuffer" }).fg

      vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color })
      vim.api.nvim_set_hl(0, "Folded", { bg = bg_color })
      vim.api.nvim_set_hl(0, "Visual", { bg = visual })

      vim.api.nvim_set_hl(0, "CursorLine", { bg = status })
      vim.api.nvim_set_hl(0, "CursorColumn", { bg = status })
    end
  }
}
