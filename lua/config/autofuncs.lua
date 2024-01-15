-- vim autocommands

local api = vim.api
local bufnr = api.nvim_get_current_buf()

-- utility function for creating augroups
local function augroup(name)
  return vim.api.nvim_create_augroup("lazy_augroup_" .. name, { clear = true })
end

api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = augroup('makefile'),
  desc = "Remove tab expansion during makefile editing",
  pattern = { "Makefile", "makefile" },
  callback = function()
    vim.bo.expandtab = false
  end
})

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

-- Auto format specified buffers on write
api.nvim_create_autocmd("BufWritePre", {
  group = augroup('autoformat'),
  -- removed lua and html formatting
  pattern = { '*.jsx', '*.py', '*.c', '*.rs', '*.cpp' },
  callback = function()
    vim.lsp.buf.format(nil, 200)
  end,
})

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
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})
