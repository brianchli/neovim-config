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

local function escape_str(str)
  local output = str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
  return output
end

-- PATH WIDGET
--- Create a string containing info for the current git branch
--- @return string: branch info
M.get_path_info = function(root, fname, icon_tbl)
  local file_name = vim.fn.fnamemodify(fname, ":t")

  local file_icon, icon_hl = require('mini.icons').get('file', file_name)
  file_icon = file_name ~= "" and utils.hl_str(icon_hl, file_icon) or ""

  local file_icon_name = table.concat({ file_name })

  if vim.bo.buftype == "help" then
    return table.concat({ icon_tbl["file"], file_icon_name })
  end

  local remote = utils.get_git_remote_name(root)
  local branch = get_git_branch(root)
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

return M
