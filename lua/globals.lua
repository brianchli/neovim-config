_G.icons = {
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}


_G.tools = {
  ui = {
    icons = {
      branch = "",
      bullet = "•",
      open_bullet = "○",
      file = "",
      ok = "✔",
      d_chev = "∨",
      ellipses = "…",
      node = "╼",
      document = "≡ ",
      lock = "",
      r_chev = ">",
      warning = " ",
      error = " ",
      info = "󰌶 ",
      hamburger = "󰦪 "
    },
    kind_icons = {
      Array = " 󰅪 ",
      BlockMappingPair = " 󰅩  ",
      Boolean = "   ",
      BreakStatement = " 󰙧  ",
      Call = " 󰃷 ",
      CaseStatement = " 󰨚  ",
      Class = "   ",
      Color = "   ",
      Constant = "   ",
      Constructor = " 󰆦  ",
      ContinueStatement = "   ",
      Copilot = "   ",
      Declaration = " 󰙠  ",
      Delete = " 󰩺 ",
      DoStatement = " 󰑖 ",
      Element = " 󰅩  ",
      Enum = "   ",
      EnumMember = "   ",
      Event = " ",
      Field = "   ",
      File = "  ",
      Folder = "  ",
      ForStatement = "󰑖 ",
      Function = " 󰆦  ",
      GotoStatement = " 󰁔 ",
      Identifier = " 󰀫 ",
      IfStatement = " 󰇉  ",
      Interface = "   ",
      Keyword = "   ",
      List = " 󰅪 ",
      Log = " 󰦪 ",
      Lsp = "   ",
      Macro = " 󰁌  ",
      MarkdownH1 = " 󰉫  ",
      MarkdownH2 = " 󰉬  ",
      MarkdownH3 = " 󰉭  ",
      MarkdownH4 = " 󰉮  ",
      MarkdownH5 = " 󰉯  ",
      MarkdownH6 = " 󰉰  ",
      Method = " 󰆦  ",
      Module = "   ",
      Namespace = " 󰅩  ",
      Null = " 󰢤  ",
      Number = " 󰎠  ",
      Object = " 󰅩  ",
      Operator = "   ",
      Package = " 󰆦  ",
      Pair = " 󰅪 ",
      Property = "   ",
      Reference = "   ",
      Regex = "  ",
      Repeat = " 󰑖 ",
      Return = " 󰌑  ",
      RuleSet = " 󰅩  ",
      Scope = " 󰅩  ",
      Section = " 󰅩  ",
      Snippet = "   ",
      Specifier = " 󰦪 ",
      Statement = " 󰅩  ",
      String = "   ",
      Struct = "   ",
      SwitchStatement = " 󰨙  ",
      Table = " 󰅩  ",
      Terminal = "   ",
      Text = " 󰪛  ",
      Type = "  ",
      TypeParameter = "   ",
      Unit = "  ",
      Value = "   ",
      Variable = "   ",
      WhileStatement = " 󰑖  ",
    },
  },

  nonprog_modes = {
    ["markdown"] = true,
    ["org"] = true,
    ["orgagenda"] = true,
    ["text"] = true,
  },
}
-- files and directories -----------------------------
local branch_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
tools.get_path_root = function(path)
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

-- get the name of the remote repository
tools.get_git_remote_name = function(root)
  if not root then return nil end
  if remote_cache[root] then return remote_cache[root] end

  local out = git_cmd(root, "config", "--get", "remote.origin.url")
  if not out then return nil end

  -- normalise to short repo name
  out = out:gsub(":", "/"):gsub("%.git$", ""):match("([^/]+/[^/]+)$")

  remote_cache[root] = out
  return out
end

function tools.get_git_branch(root)
  if not root then return nil end
  if branch_cache[root] then return branch_cache[root] end

  local out = git_cmd(root, "rev-parse", "--abbrev-ref", "HEAD")
  if out == "HEAD" then
    local commit = git_cmd(root, "rev-parse", "--short", "HEAD")
    commit = tools.hl_str("Comment", "(" .. commit .. ")")
    out = string.format("%s %s", out, commit)
  end

  branch_cache[root] = out

  return out
end

-- LSP -----------------------------
tools.diagnostics_available = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

  for _, cfg in pairs(clients) do
    if cfg:supports_method(diagnostics) then return true end
  end

  return false
end

-- highlighting -----------------------------
tools.hl_str = function(hl, str) return "%#" .. hl .. "#" .. str .. "%*" end

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
tools.group_number = function(num, sep)
  if num < 999 then return tostring(num) end

  num = tostring(num)
  return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
end

local tjoin = function(...)
  return vim.tbl_deep_extend("force", ...)
end

-- Return a list of all scratch buffers
local function list_scratch_buffers()
  local scratch = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local bt = vim.bo[buf].buftype
      if bt ~= "" then -- non-empty buftype means "special"
        table.insert(scratch, {
          buf = buf,
          name = vim.api.nvim_buf_get_name(buf),
          buftype = bt,
          filetype = vim.bo[buf].filetype,
        })
      end
    end
  end
  return scratch
end

local scratch_buffers = function()
  -- Example: print them
  for _, info in ipairs(list_scratch_buffers()) do
    print(string.format("buf=%d, bt=%s, ft=%s, name=%s",
      info.buf, info.buftype, info.filetype, info.name))
  end
end

_G.utils = { tjoin = tjoin, ls_scratch_buffers = scratch_buffers }
