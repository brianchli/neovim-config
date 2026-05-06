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

local icon_map = {
  ["branch"] = { "DiagnosticOk", icons.general["Branch"] },
  ["file"] = { "DiagnosticWarn", icons.general["File"] },
  ["fileinfo"] = { "DiagnosticInfo", icons.general["Hamburger"] },
  ["nomodifiable"] = { "DiagnosticError", icons.general["Lock"] },
  ["modified"] = { "Directory", "+" },
  ["readonly"] = { "DiagnosticError", icons.general["Lock"] },
  ["error"] = { "DiagnosticError", icons.general["Lock"] },
  ["warn"] = { "DiagnosticWarn", icons.general["Lock"] },
  ["lines"] = { "Question", icons.general["Doc"] },
  ["words"] = { "Constant", icons.kinds["Keyword"] },
  ["chars"] = { "Conditional", icons.kinds["Text"] },
}

local hl_ui_icons = utils.hl_icons(icon_map)
local function get_vlinecount_str()
  local raw_count = vim.fn.line('.') - vim.fn.line('v')
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1
  return utils.abbrev_n(math.abs(raw_count))
end

--- get wordcount for current buffer or visual selection
--- @return string word count
local function get_fileinfo_widget(icon_t)
  local ft = get_opt("filetype", {})
  local lines = utils.abbrev_n(vim.api.nvim_buf_line_count(0))
  local wc_t = vim.fn.wordcount()
  ALIGN = "right"

  -- visual selection mode: line count, word count, and char count
  local lines = (wc_t.visual_words or wc_t.visual_words) and get_vlinecount_str() or lines
  local words = wc_t.visual_words and utils.abbrev_n(wc_t.visual_words) or utils.abbrev_n(wc_t.words)
  local chars = wc_t.visual_chars and utils.abbrev_n(wc_t.visual_chars) or utils.abbrev_n(wc_t.chars)
  local min_pad = math.max(#lines, #words, #chars)

  return table.concat({
    "#[",
    icon_t.lines,
    utils.pad_str(lines, min_pad, ALIGN),
    " ",
    "[",
    icon_t.words,
    utils.pad_str(words, min_pad, ALIGN),
    "] ",
    icon_t.chars,
    utils.pad_str(chars, min_pad, ALIGN),
    "]",
  })
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
    fileinfo = get_fileinfo_widget(hl_ui_icons),
  }
  return utils.is_ignored_buffer(buf, ignore)
      and ""
      or utils.stringify(parts, ORDER)
end

return M
