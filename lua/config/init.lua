local M = {
  Local = {},
  Lazy = {}
}

---@param dir string
---@return string[]
local function fs_to_table(dir)
  local t = {}
  local path = vim.fn.stdpath("config") .. "/lua/" .. dir
  for _, sub in ipairs(vim.fn.readdir(path)) do
    local stat = vim.loop.fs_stat(path .. "/" .. sub)
    if stat and stat.type == "file" then
      if sub:sub(-4) == ".lua" and sub ~= "init.lua" then
        table.insert(t, sub:sub(0, -5))
      end
    end
    if stat and stat.type == "directory" then
      table.insert(t, sub)
    end
  end
  return t
end

---@generic T, U
---@param tbl T[]
---@param func function(T): U
---@return U[]
local function map(tbl, func)
  local t = {}
  for _, f in ipairs(tbl) do
    table.insert(t, func(f))
  end
  return t
end

---@param tbl string[]
---@param func function(string): string
---@return string[]
local function string_map(tbl, func)
  assert(type(tbl) == "table")
  assert(type(func) == "function")
  return map(tbl, func)
end

---@param tbl string[]
---@return {ok: boolean, result: any}[]
local function require_all(tbl)
  return map(tbl, function(s) return { pcall(require, s) } end)
end

local function add_prefix(prefix)
  return function(s) return prefix .. s end
end

M.Local.load = function()
  if vim.loop.os_uname().sysname == "Darwin" then
    local status_t = require_all(
      string_map(
        fs_to_table("config/local"),
        add_prefix("config.local."))
    )
    for _, res in pairs(status_t) do
      assert(res)
    end
  end
end

M.Lazy.setup = function()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  local status, lazy = pcall(require, 'lazy')
  if status then
    local base_specs = {
      { import = 'plugins.main' },
      { import = 'plugins.ui' },
    }
    local os_specs = map(
      string_map(fs_to_table("plugins"), add_prefix("plugins.")),
      function(s) return { import = s } end
    )
    lazy.setup({
      spec = utils.tjoin(
        base_specs,
        os_specs
      ),
      checker = {
        enabled = true,
        notify = false,
      },
      change_detection = {
        notify = false
      },
    })
  end
end

return M
