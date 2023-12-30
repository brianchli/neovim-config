--[[ keys.lua ]]
--This function takes in four parameters:
local map = vim.keymap.set
-- vim.g = let
-- vim.o = set
--   mode: the mode you want the key bind to apply to (e.g., insert mode, normal mode, command mode, visual mode).
--    sequence: the sequence of keys to press.
--    command: the command you want the keypresses to execute.
--    options: an optional Lua table of options to configure (e.g., silent or noremap).

-- Easy access to Lazy
map("n", "<Leader>L", ":Lazy<CR>", { noremap = true })

-- Buffer navigation
map("n", "<Leader>q", ":bdelete<CR>", { noremap = true }) -- remove current buffer

-- vim key remappings
map("n", "<leader>w", ":w<CR>", { noremap = true })     -- write file
map("v", "<leader>ii", ":norm i", { noremap = true })   -- insert
map("n", "<Leader>ch", ":nohl<CR>", { noremap = true }) -- clear highlights

-- format file
map("n", "<leader>fa", ":lua vim.lsp.buf.format{async=true}<CR>", { noremap = true })
map("n", "<C-u>", "<C-u>zz", { noremap = true })  -- half page scroll up
map("n", "<C-d>", "<C-d>zz", { noremap = true })  -- half page scroll down
map("v", "<leader>rc", ":s/", { noremap = true }) -- find and replace
map("n", "<leader>y", "\"+y", { noremap = true }) -- yank into clipboard normal mode
map("v", "<leader>y", "\"+y", { noremap = true }) -- yank into clipboard visual mode
map("n", "<leader>y", "\"+y", { noremap = true }) -- yank into universal clipboard

-- better indenting
map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })

-- Misc
-- Copy all
map("n", "<C-c>", "gg<S-v>G")
