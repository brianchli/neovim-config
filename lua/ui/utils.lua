local M = {}

-- highlighting -----------------------------
local function hl_str(hl, str) return "%#" .. hl .. "#" .. str .. "%*" end

M.hl_icons = function(icon_list)
  local hl_syms = {}

  for name, list in pairs(icon_list) do
    hl_syms[name] = hl_str(list[1], list[2])
  end

  return hl_syms
end

M.pad_str = function(in_str, width, align)
  local num_spaces = width - #in_str
  if num_spaces < 1 then
    num_spaces = 1
  end

  local spaces = string.rep(" ", num_spaces)

  if align == "left" then
    return table.concat({ in_str, spaces })
  end

  return table.concat({ spaces, in_str })
end

M.is_ignored_buffer = function(buf, ignore)
  buf = buf or 0
  local bt = vim.bo[buf].buftype
  if ignore.buftype and ignore.buftype[bt] then
    return true
  end
  local ft = vim.bo[buf].filetype
  if ignore.filetype and ignore.filetype[ft] then
    return true
  end
  return false
end

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
M.get_path_root = function(path)
  if path == "" then return end

  local root = vim.b.path_root
  if root then return root end

  local root_items = {
    ".git",
  }

  root = vim.fs.root(path, root_items)
  if root == nil then return nil end
  if root then vim.b.path_root = root end
  return root
end

local function git_cmd(root, ...)
  local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()

  if job.code ~= 0 then return nil, job.stderr end
  return vim.trim(job.stdout)
end

-- files and directories -----------------------------
local branch_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

-- get the name of the remote repository
M.get_git_remote_name = function(root)
  if not root then return nil end
  if remote_cache[root] then return remote_cache[root] end

  local out = git_cmd(root, "config", "--get", "remote.origin.url")
  if not out then return nil end

  -- normalise to short repo name
  out = out:gsub(":", "/"):gsub("%.git$", ""):match("([^/]+/[^/]+)$")

  remote_cache[root] = out
  return out
end

function get_git_branch(root)
  if not root then return nil end
  if branch_cache[root] then return branch_cache[root] end

  local out = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
  if out == "HEAD" then
    local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
    commit = hl_str("Comment", "(" .. commit .. ")")
    out = string.format("%s %s", out, commit)
  end

  branch_cache[root] = out

  return out
end

-- LSP -----------------------------
M.diagnostics_available = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

  for _, cfg in pairs(clients) do
    if cfg:supports_method(diagnostics) then return true end
  end

  return false
end

M.abbrev_n = function(n)
  local n = tonumber(n) or 0
  if n >= 1e6 then
    return string.format("%.2fm", n / 1e6)
  elseif n >= 1e3 then
    return string.format("%.2fk", n / 1e3)
  else
    return tostring(n)
  end
end

M.stringify = function(parts, order)
  local out, i = {}, 1
  for _, k in ipairs(order) do
    local v = parts[k]
    if v and v ~= "" then
      out[i] = v
      i = i + 1
    end
  end
  return table.concat(out, " ")
end

M.hl_str = hl_str

return M
