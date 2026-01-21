local M = {}

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

return M
