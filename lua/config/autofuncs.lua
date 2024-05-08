--
--╭──────────────────────────────────────────────────────────╮
--│ Autocommands                                             │
--│                                                          │
--╰──────────────────────────────────────────────────────────╯
--

local api = vim.api
local bufnr = api.nvim_get_current_buf()

-- utility function for creating augroups
function augroup(name)
  return vim.api.nvim_create_augroup("lazy_augroup_" .. name, { clear = true })
end

-- keep tabs as tabs for certain files
api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = augroup('makefile'),
  desc = "Remove tab expansion during makefile editing",
  pattern = { "Makefile", "makefile" },
  callback = function()
    vim.bo.expandtab = false
  end
})

-- just highlight on yank..
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- use 2 spaced tabs for the specified files
api.nvim_create_autocmd("FileType", {
  group = augroup('customshift'),
  desc = "custom tab expansion",
  pattern = {
    'javascript',
    'typescript',
    'javascriptreact',
    'typescriptreact',
    'cpp',
    'c',
    'sh',
    'zsh',
    'lua',
    'css',
    'html'
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})

--
---- auto format specified buffers on write
--api.nvim_create_autocmd("BufWritePre", {
--  group = augroup('autoformat'),
--  -- removed lua, html and c (due to OS) formatting
--  pattern = { '*.jsx', '*.py', '*.rs', '*.cpp' },
--  callback = function()
--    vim.lsp.buf.format(nil, 200)
--  end,
--})
--

-- display diagnostics as hovers
api.nvim_create_autocmd("CursorHold", {
  group = augroup('diagnostic_hover'),
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      style = 'minimal',
      source = 'always',
      max_width = 200,
      title = 'test',
      pad_top = 0.1,
      pad_bottom = 1,
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "close with q" })
  end,
})

-- wrap and check for spelling in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown, text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- remove spellcheck in certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_spell"),
  pattern = { "help", "man", "checkhealth" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- auto clean tex compilation files
vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*.tex",
  group = augroup("auto_clean_tex"),
  callback = function()
    vim.cmd("VimtexStop")
    vim.cmd("VimtexClean")
  end,
})

-- add vimtex commands on enter to *.tex files
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*.tex",
  group = augroup("add_vimtex_commands"),
  callback = function()
    vim.keymap.set('n', '<leader>l<Space>', "<cmd>VimtexCompile<cr>",
      { noremap = true, silent = true, desc = "start continous latex compilation" })
    vim.keymap.set('n', '<leader>l<Enter>', "<cmd>VimtexCompileSS<cr>",
      { noremap = true, silent = true, desc = "compile latex document snapshot" })
    vim.keymap.set('n', '<leader>ls', "<cmd>VimtexStop<cr>",
      { noremap = true, silent = true, desc = "stop latex document compilation" })
    vim.keymap.set('n', '<leader>ll', "<cmd>VimtexLog<cr>",
      { noremap = true, silent = true, desc = "display latex compilation logs" })
    vim.keymap.set('n', '<leader>li', "<cmd>VimtexInfo<cr>",
      { noremap = true, silent = true, desc = "display Vimtex instance information" })
    vim.keymap.set('n', '<leader>lc', "<cmd>VimtexClear<cr>",
      { noremap = true, silent = true, desc = "clear Vimtex generated files" })
    vim.keymap.set('n', '<leader>lr', "<cmd>VimtexReload<cr>",
      { noremap = true, silent = true, desc = "reload Vimtex plugin" })
    vim.cmd("VimtexCompile")
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})
