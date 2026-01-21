local get_opt = vim.api.nvim_get_option_value
-- Code taken from:
-- https://github.com/mcauley-penney/nvim/blob/main/lua/ui/statusline.lua
-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
--
local utils = require("ui.utils")
local M = {}

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

local PAD = " "
local SEP = "%="
local TRUNC = "%<"
local SBAR = { "▔", "▀", "▆", "▅", "▄", "▃", "▂", "▁", " " }

local icons = tools.ui.icons
local icon_map = {
  ["branch"] = { "DiagnosticOk", icons["branch"] },
  ["file"] = { "DiagnosticWarn", icons["file"] },
  ["fileinfo"] = { "DiagnosticInfo", icons["hamburger"] },
  ["nomodifiable"] = { "DiagnosticError", icons["lock"] },
  ["modified"] = { "Directory", "+" },
  ["readonly"] = { "DiagnosticError", icons["lock"] },
  ["error"] = { "DiagnosticError", icons["lock"] },
  ["warn"] = { "DiagnosticWarn", icons["lock"] },
}

local function hl_icons(icon_list)
  local hl_syms = {}

  for name, list in pairs(icon_list) do
    hl_syms[name] = tools.hl_str(list[1], list[2])
  end

  return hl_syms
end

local hl_ui_icons = hl_icons(icon_map)
local function escape_str(str)
  local output = str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
  return output
end



local function stringify(parts)
  local out, i = {}, 1
  for _, k in ipairs(ORDER) do
    local v = parts[k]
    if v and v ~= "" then
      out[i] = v
      i = i + 1
    end
  end
  return table.concat(out, " ")
end

local function get_path_parts(path)
  local parts = {}

  -- This is only compatible for MacOS and Linux
  for str in string.gmatch(path, "[^/]+") do
    table.insert(parts, str)
  end

  return parts
end

local function get_partial_path_of_len_n(parts, n)
  return #parts >= n and
      " ~/../" .. table.concat(parts, "/", #parts - n + 1) .. "/"
      or " ~/../" .. table.concat(parts, "/") .. "/"
end


-- PATH WIDGET
--- Create a string containing info for the current git branch
--- @return string: branch info
local function get_path_info(root, fname, icon_tbl)
  local file_name = vim.fn.fnamemodify(fname, ":t")

  local file_icon, icon_hl = require('mini.icons').get('file', file_name)
  file_icon = file_name ~= "" and tools.hl_str(icon_hl, file_icon) or ""

  local file_icon_name = table.concat({ file_name })

  if vim.bo.buftype == "help" then
    return table.concat({ icon_tbl["file"], file_icon_name })
  end

  local remote = tools.get_git_remote_name(root)
  local branch = tools.get_git_branch(root)
  local dir_path = vim.fn.fnamemodify(fname, ":h") .. "/"

  -- FIXME: how much we show should depend on how long
  -- the total statusline string is, not just the len
  -- of the directory itself
  local win_width = vim.api.nvim_win_get_width(0)
  local repo_info = ""
  if remote and branch then
    dir_path = string.gsub(dir_path, escape_str(root) .. "/", " ")
    repo_info = table.concat({
      icon_tbl["branch"],
      ' ',
      remote,
      ':',
      branch,
      ' ',
    })
  end

  local parts = get_path_parts(dir_path)
  dir_path = (#dir_path / win_width >= 0.90 or #parts > 4) and get_partial_path_of_len_n(parts, 2) or dir_path
  return table.concat({
    repo_info,
    " ",
    #repo_info > 0 and file_icon or " ",
    #dir_path > 0 and dir_path or " ",
    file_icon_name
  })
end

-- DIAGNOSTIC WIDGET
--- Create a string of diagnostic information
--- @return string available diagnostics
local function get_diag_str()
  if not tools.diagnostics_available() then
    return ""
  end

  local diag_tbl = {}
  local total = vim.diagnostic.count()
  local err_total = total[1] or 0
  local warn_total = total[2] or 0

  if err_total > 0 then
    vim.list_extend(diag_tbl,
      { tools.hl_str("DiagnosticError", tostring(err_total)) })
  end

  if warn_total > 0 then
    vim.list_extend(diag_tbl,
      { tools.hl_str("DiagnosticWarn", "  " .. tostring(warn_total)) })
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

local function get_scrollbar()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)
  local i = math.floor((cur_line - 1) / lines * #SBAR) + 1
  return tools.hl_str("StatusLine", SBAR[i]:rep(2))
end

local ignore = {
  buftype = {
    acwrite = true,
    help = true,
    prompt = true,
  },
  filetype = { oil = true }
}

--- Creates statusline
--- @return string statusline text to be displayed
M.render = function()
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
    root = tools.get_path_root(fname)
  end

  local parts = {
    rec = vim.fn.reg_recording(),
    diag = get_diag_str(),
    git_info = get_path_info(),
    mod = (not get_opt("modifiable", { buf = buf_num }) and hl_ui_icons["nomodifiable"])
        or (get_opt("modified", { buf = buf_num }) and " ❲" .. hl_ui_icons["modified"] .. "❳ ")
        or " ❲–❳ ",
    pad = PAD,
    path = get_path_info(root, fname, hl_ui_icons),
    ro = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or "",
    scrollbar = get_scrollbar(),
    sep = SEP,
    trunc = TRUNC,
    venv = vim.filetype == "python" and get_py_venv() or nil,
    cursor_pos = string.format("%d,%d", unpack(vim.api.nvim_win_get_cursor(0)))
  }

  -- turn all of these pieces into one string
  return stringify(parts)
end

vim.o.statusline = "%!v:lua.require('ui.statusline').render()"

return M
