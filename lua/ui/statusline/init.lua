local get_opt = vim.api.nvim_get_option_value
local lib = require("ui.statusline.lib")
local utils = require("ui.utils")
local M = {}

-- DIAGNOSTIC WIDGET
--- Create a string of diagnostic information
--- @return string available diagnostics
local function get_diag_str()
  if not utils.diagnostics_available() then
    return ""
  end

  local diag_tbl = {}
  local total = vim.diagnostic.count()
  local err_total = total[1] or 0
  local warn_total = total[2] or 0

  if err_total > 0 then
    vim.list_extend(diag_tbl,
      { utils.hl_str("DiagnosticError", tostring(err_total)) })
  end

  if warn_total > 0 then
    vim.list_extend(diag_tbl,
      { utils.hl_str("DiagnosticWarn", "  " .. tostring(warn_total)) })
  end

  return #diag_tbl > 0 and "❲ " .. table.concat(diag_tbl) .. " ❳ " or ""
end

--- Get the name of the current venv in Python
--- @return string|nil name of venv or nil
--- From JDHao; see https://www.reddit.com/r/neovim/comments/16ya0fr/show_the_current_python_virtual_env_on_statusline/
local get_py_venv = function()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    local venv_name = vim.fn.fnamemodify(venv_path, ':t')
    return string.format("'.venv': %s  ", venv_name)
  end

  local conda_env = os.getenv('CONDA_DEFAULT_ENV')
  if conda_env then
    return string.format("conda: %s  ", conda_env)
  end

  return nil
end

local PAD = " "
local SEP = "%="
local TRUNC = "%<"
local SBAR = { "▔", "▀", "▆", "▅", "▄", "▃", "▂", "▁", " " }
local icon_map = {
  ["branch"] = { "DiagnosticOk", icons.general["branch"] },
  ["file"] = { "DiagnosticWarn", icons.general["file"] },
  ["fileinfo"] = { "DiagnosticInfo", icons.general["hamburger"] },
  ["nomodifiable"] = { "DiagnosticError", icons.general["lock"] },
  ["modified"] = { "Directory", "+" },
  ["readonly"] = { "DiagnosticError", icons.general["lock"] },
  ["error"] = { "DiagnosticError", icons.general["lock"] },
  ["warn"] = { "DiagnosticWarn", icons.general["lock"] },
}
local hl_ui_icons = utils.hl_icons(icon_map)
local ignore = {
  buftype = {
    acwrite = true,
    help = true,
    prompt = true,
    nofile = true,
  },
  filetype = { oil = true }
}

local ORDER = {
  "pad",
  "trunc",
  "path",
  "mod",
  "diag",
  "rec",
  "ro",
  "sep",
  "venv",
  "sep",
  "cursor_pos",
  "pad",
  "fileinfo",
  "pad",
  "scrollbar",
  "pad"
}

local function get_scrollbar()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)
  local i = math.floor((cur_line - 1) / lines * #SBAR) + 1
  return utils.hl_str("StatusLine", SBAR[i]:rep(2))
end

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
  local win = tonumber(vim.g.statusline_winid)
  if win ~= vim.api.nvim_get_current_win() then
    return ""
  end
  local fname = vim.api.nvim_buf_get_name(0)
  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local buf = vim.api.nvim_get_current_buf() -- get current buffer number
  if utils.is_ignored_buffer(buf, ignore) then
    return ""
  end
  local root = nil
  if vim.bo.buftype == "terminal" or
      vim.bo.buftype == "nofile" or
      vim.bo.buftype == "prompt" then
    fname = vim.bo.ft
  else
    root = utils.get_path_root(fname)
  end

  local parts = {
    pad = PAD,
    sep = SEP,
    trunc = TRUNC,
    rec = vim.fn.reg_recording(),
    diag = get_diag_str(),
    git_info = lib.get_path_info(),
    mod = (not get_opt("modifiable", { buf = buf_num }) and hl_ui_icons["nomodifiable"])
        or (get_opt("modified", { buf = buf_num }) and " ❲" .. hl_ui_icons["modified"] .. "❳ ")
        or " ❲–❳ ",
    path = lib.get_path_info(root, fname, hl_ui_icons),
    ro = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or "",
    scrollbar = get_scrollbar(),
    venv = vim.filetype == "python" and get_py_venv() or nil,
    cursor_pos = string.format("%d,%d", unpack(vim.api.nvim_win_get_cursor(0)))
  }

  -- turn all of these pieces into one string
  return utils.stringify(parts, ORDER)
end

return M
