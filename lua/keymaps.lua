--╭──────────────────────────────────────────────────────────╮
--│ *KEYMAPS*                                                │
--│ These keybindings need to be defined before the first /  │
--│ is called; otherwise, it will default to "\"             │
--│   mode: the mode you want the key bind to apply to       │
--│        (e.g., insert, normal, command, visual).          │
--│   sequence: the sequence of keys to press.               │
--│   command: the command that key presses will execute.    │
--│   options: an optional Lua table of options to configure │
--│   (e.g., silent or noremap).                             │
--│                                                          │
--╰──────────────────────────────────────────────────────────╯
--

local map = vim.keymap.set

-- Easy access to Lazy
map("n", "<Leader>L", ":Lazy<CR>", { desc = "open lazy", noremap = true })

-- Buffer navigation
map("n", "<Leader>q", ":bdelete<CR>", { desc = "quit buffer", noremap = true }) -- remove current buffer

-- vim key re-mappings
map("n", "<leader>w", ":w<CR>", { desc = "save buffer", noremap = true })            -- write file
map("v", "<leader>ii", ":norm i", { desc = "fast insert", noremap = true })          -- insert
map("n", "<Leader>ch", ":nohl<CR>", { desc = "clear highlighting", noremap = true }) -- clear highlights

-- format file
map("n", "<C-u>", "<C-u>zz", { desc = "better page up", noremap = true })                -- half page scroll up
map("n", "<C-d>", "<C-d>zz", { desc = "better page down", noremap = true })              -- half page scroll down
map("n", "<leader>y", "\"+y", { desc = "yank into clipboard (normal)", noremap = true }) -- yank into clipboard normal mode
map("v", "<leader>y", "\"+y", { desc = "yank into clipboard (visual)", noremap = true }) -- yank into clipboard visual mode

-- better indenting
map("v", "<", "<gv", { desc = "ident left", noremap = true })
map("v", ">", ">gv", { desc = "indent right", noremap = true })

-- Copy all
map("n", "<C-y>", "<cmd>:%y+<cr>", { desc = "yank entire buffer into clipboard" })

-- multi-line replace
map("v", "<leader>rp", ":s/", { desc = "regex replace text", noremap = true }) -- regex replace visual mode

-- set or unset column line highlights
map('n', '<leader>lc', function()
  local column_highlighted = vim.api.nvim_get_option_value(
    "cursorcolumn", { scope = "global" }
  )

  if column_highlighted then
    vim.wo.cursorcolumn = false
  else
    vim.wo.cursorcolumn = true
  end
end, { noremap = true, silent = true, desc = "toggle line column highlight" })

-- set or unset row line highlights
map('n', '<leader>lr', function()
  local row_highlighted = vim.api.nvim_get_option_value("cursorline",
    { scope = "global" })
  if row_highlighted then
    vim.wo.cursorline = false
  else
    vim.wo.cursorline = true
  end
end, { noremap = true, silent = true, desc = "toggle line highlight" })
