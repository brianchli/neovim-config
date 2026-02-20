local get_opt = vim.api.nvim_get_option_value
local utils = require("ui.utils")

local M = {}

local ORDER = {
  "pad",
  "pad",
  "trunc",
  "navic",
  "sep",
  "fileinfo",
  "pad"
}

local PAD = " "
local SEP = "%="
local TRUNC = "%<"

local icons = icons.general
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

local hl_ui_icons = utils.hl_icons(icon_map)
local function get_vlinecount_str()
  local raw_count = vim.fn.line('.') - vim.fn.line('v')
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1
  return utils.group_number(math.abs(raw_count), ',')
end

--- Get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_widget(icon_tbl)
  local ft = get_opt("filetype", {})
  local lines = utils.group_number(vim.api.nvim_buf_line_count(0), ',')

  local wc_table = vim.fn.wordcount()
  if not wc_table.visual_words or not wc_table.visual_chars then
    -- Normal mode word count and file info
    return table.concat({
      icon_tbl.fileinfo,
      '  ',
      lines,
      " l ",
      utils.group_number(wc_table.words, ','),
      " w"
    })
  else
    -- Visual selection mode: line count, word count, and char count
    return table.concat({
      utils.hl_str("DiagnosticInfo", '‹›'),
      '  ',
      get_vlinecount_str(),
      " l ",
      utils.group_number(wc_table.visual_words, ','),
      " w ",
      utils.group_number(wc_table.visual_chars, ','),
      " c"
    })
  end
end

-- Customized navic.get_location() that combines namespaces into a single string.
-- Example: `adam::bob::charlie > foo` is transformed into `a::b::charlie > foo`
local function navic_format(f, data)
  local new_data = {}
  local cur_ns = nil
  local ns_comps = {}

  for _, comp in ipairs(data or {}) do
    if comp.type == "Namespace" then
      cur_ns = comp
      table.insert(ns_comps, comp.name)
    else
      -- On the first non-namespace component $c$, collect
      -- previous NS components into a single one and
      -- insert it in front of $c$.
      if cur_ns ~= nil then
        -- Concatenate name and insert
        local num_comps = #ns_comps
        local comb_name = ""
        for idx = 1, num_comps do
          local ns_name = ns_comps[idx]

          -- No "::" in front of first component
          local join = (idx == 1) and "" or "::"

          if idx ~= num_comps then
            comb_name = comb_name .. join .. ns_name:sub(1, 1)
          else
            comb_name = comb_name .. join .. ns_name
          end
        end

        cur_ns.name = comb_name
        table.insert(new_data, cur_ns)
        cur_ns = nil
      end

      table.insert(new_data, comp)
    end
  end

  return f(new_data)
end

local ignore = {
  buftype = {
    acwrite = true,
    help = true,
    prompt = true,
    nofile = true,
  },
  filetype = { oil = true }
}

M.render = function()
  local win = tonumber(vim.g.statusline_winid)
  if win ~= vim.api.nvim_get_current_win() then
    return ""
  end
  local buf = vim.api.nvim_get_current_buf()
  local status, navic = pcall(require, 'nvim-navic')
  local parts = {
    pad = PAD,
    sep = SEP,
    trunc = TRUNC,
    navic = (status and navic.is_available()) and
        navic_format(navic.format_data, navic.get_data())
        or "",
    fileinfo = get_fileinfo_widget(hl_ui_icons)
  }
  return utils.is_ignored_buffer(buf, ignore)
      and ""
      or utils.stringify(parts, ORDER)
end

return M
