_G.icons = {
  general = {
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
  nonprog_modes = {
    ["markdown"] = true,
    ["org"] = true,
    ["orgagenda"] = true,
    ["text"] = true,
  },
}

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
