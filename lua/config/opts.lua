-- vars.lua

local opt = vim.o -- setting vim options with lua

vim.wo.cursorline = true

-- vimscript commands
vim.g.highlights_insert_mode_enabled = false

-- disables vim file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Show diagnostic popup on cursor hover
vim.opt.updatetime = 100

-- [[ Context ]]
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.signcolumn = "yes"    -- Show the sign column
opt.laststatus = 2        -- Always show status line
opt.scrolloff = 4         -- Min num lines of context

-- [[ Filetypes ]]
opt.encoding = 'utf8'     -- String encoding to use
opt.fileencoding = 'utf8' -- File encoding to use
opt.filetype = true       -- File encoding to use

-- [[ Theme ]]
opt.syntax = "ON"        -- Allow syntax highlighting
opt.termguicolors = true -- If term supports ui color then enable

-- [[ Search ]]
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true  -- Override ignorecase if search contains capitals
opt.incsearch = true  -- Use incremental search
opt.hlsearch = true   -- Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 4     -- Size of an indent
opt.softtabstop = 4    -- Number of spaces tabs count for in insert mode
opt.tabstop = 4        -- Number of spaces tabs count for
opt.smartindent = true -- Insert indents automatically

-- [[ Splits ]]
opt.splitright = true         -- Place new window to right of current one
opt.splitbelow = true         -- Place new window below the current one

opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- [[ lsp diagnostics ]]
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
opt.pumheight = 10 -- Maximum number of entries in a popup
