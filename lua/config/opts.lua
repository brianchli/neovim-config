--
--╭──────────────────────────────────────────────────────────╮
--│ Options                                                  │
--│                                                          │
--╰──────────────────────────────────────────────────────────╯
--

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
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

-- Show diagnostic popup on cursor hover
vim.opt.updatetime = 100

-- [[ Context ]]
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.signcolumn = "yes"    -- Show the sign column
vim.opt.laststatus = 2        -- Always show status line
vim.opt.scrolloff = 4         -- Min num lines of context

-- [[ Filetypes ]]
vim.opt.encoding = 'utf8'     -- String encoding to use
vim.opt.fileencoding = 'utf8' -- File encoding to use
vim.opt.filetype = 'on'       -- File encoding to use

-- [[ Theme ]]
vim.opt.syntax = "on"        -- Allow syntax highlighting
vim.opt.termguicolors = true -- If term supports ui color then enable

-- [[ Search ]]
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if search contains capitals
vim.opt.incsearch = true  -- Use incremental search
vim.opt.hlsearch = true   -- Highlight search matches

-- [[ Whitespace ]]
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4   -- Size of an indent
vim.opt.softtabstop = 4  -- Number of spaces tabs count for in insert mode
vim.opt.tabstop = 4      -- Number of spaces tabs count for
vim.opt.cindent = true   -- Insert indents automatically

-- [[ Splits ]]
vim.opt.splitright = true -- Place new window to right of current one
vim.opt.splitbelow = true -- Place new window below the current one


-- [[ lsp diagnostics ]]
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.opt.pumheight = 100 -- Maximum number of entries in a popup

vim.opt.wildmode = "longest,list"
vim.opt.cc = '88'

vim.opt.spell = true
vim.opt.swapfile = false

vim.opt.report = 1   -- print messages from commands
vim.opt.ruler = true -- always show current positions along the bottom
vim.opt.ttyfast = true
vim.opt.fillchars.eob = " "
vim.opt.scrolloff = 8
vim.opt.linebreak = true      -- Wrap on word boundary
vim.opt.numberwidth = 5       -- minimal number of columns to use for the line number {default 4}
vim.opt.sidescrolloff = 8     -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.iskeyword:append("-") -- treats words with `-` as single words
