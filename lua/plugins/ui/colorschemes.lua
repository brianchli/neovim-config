function init_cmp_colors()
  -- Match groups
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "String" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "String" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { link = "BlinkCmpLabelDeprecated" })
  vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "Comment" })

  -- LSP kinds → Standard highlight groups
  vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "String" })
  vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "Function" })
  vim.api.nvim_set_hl(0, "CmpItemKindFunction", { link = "Function" })
  vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { link = "Function" })

  vim.api.nvim_set_hl(0, "CmpItemKindField", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "CmpItemKindVariable", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "CmpItemKindValue", { link = "Identifier" })

  vim.api.nvim_set_hl(0, "CmpItemKindClass", { link = "Type" })
  vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "Type" })
  vim.api.nvim_set_hl(0, "CmpItemKindStruct", { link = "Type" })
  vim.api.nvim_set_hl(0, "CmpItemKindModule", { link = "Include" })
  vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { link = "Type" })

  vim.api.nvim_set_hl(0, "CmpItemKindEnum", { link = "Type" })
  vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { link = "Constant" })

  vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { link = "Keyword" })
  vim.api.nvim_set_hl(0, "CmpItemKindOperator", { link = "Operator" })

  vim.api.nvim_set_hl(0, "CmpItemKindConstant", { link = "Constant" })
  vim.api.nvim_set_hl(0, "CmpItemKindReference", { link = "Identifier" })

  vim.api.nvim_set_hl(0, "CmpItemKindFile", { link = "Directory" })
  vim.api.nvim_set_hl(0, "CmpItemKindFolder", { link = "Directory" })

  vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "Number" })
  vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { link = "Special" })
  vim.api.nvim_set_hl(0, "CmpItemKindColor", { link = "Special" })
  vim.api.nvim_set_hl(0, "CmpItemKindEvent", { link = "Special" })
end

-- load colorschemes
return {
  { 'Mofiqul/dracula.nvim',            name = 'dracula',     lazy = true },
  { 'drewtempelmeyer/palenight.vim',   name = 'pale',        lazy = true },
  { 'rebelot/kanagawa.nvim',           name = 'kanagawa',    lazy = true },
  { 'olivercederborg/poimandres.nvim', name = 'poimandres',  lazy = true },
  { 'Mofiqul/vscode.nvim',             name = 'vscode',      lazy = true },
  { 'p00f/alabaster.nvim',             name = 'alabaster',   lazy = true },
  { 'folke/tokyonight.nvim',           name = 'tokyo-night', lazy = true },
  { 'oxfist/night-owl.nvim',           name = 'night-owl',   lazy = true },
  {
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nightfly",
        callback = function()
          local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
          vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })

          local charcoal = "#25292b";
          local charcoal1 = "#1D2022";

          -- reconfigure to new background colour
          vim.api.nvim_set_hl(0, "Normal", { bg = charcoal })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = charcoal })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = charcoal })
          vim.api.nvim_set_hl(0, "FoldColumn", { bg = charcoal })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = charcoal })

          vim.api.nvim_set_hl(0, "LineNr", { fg = "#4A4D51", bg = charcoal })
          vim.api.nvim_set_hl(0, "CursorLineNr", { bg = charcoal })

          vim.api.nvim_set_hl(0, "CursorLine", { bg = charcoal })
          vim.api.nvim_set_hl(0, "CursorColumn", { bg = charcoal })

          vim.api.nvim_set_hl(0, "NormalFloat", { bg = charcoal })
          vim.api.nvim_set_hl(0, "FloatBorder", { bg = charcoal })

          vim.api.nvim_set_hl(0, "StatusLine", { bg = charcoal })
          vim.api.nvim_set_hl(0, "StatusLineNC", { bg = charcoal })
          vim.api.nvim_set_hl(0, "WinSeparator", { bg = charcoal })

          vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = charcoal })
          vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = charcoal })
          vim.api.nvim_set_hl(0, "TelescopePrompt", { bg = charcoal })
          vim.api.nvim_set_hl(0, "Folded", { bg = charcoal })
          --
          vim.api.nvim_set_hl(0, "ColorColumn", { bg = charcoal1 })

          vim.api.nvim_set_hl(0, "String", { link = "NightflyWhite" })

          -- override rainbow delimiter colours
          if vim.g.rainbow_delimiters == nil then
            vim.g.rainbow_delimiters = {
              highlight = {
                'Conditional',
                'NonText',
              },
            }
          end

          -- set colors for highlighting duplicates under the cursor
          local statusline = vim.api.nvim_get_hl(0, { name = "Search" })
          local question = vim.api.nvim_get_hl(0, { name = "Search" })
          vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = statusline.bg, fg = question.fg, bold = true })
          vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = statusline.bg, fg = question.fg, bold = true })
        end
      })
    end,
    lazy = true
  },
  {
    "yorik1984/newpaper.nvim",
    name = "newpaper",
    lazy = true,
    config = function()
      local set = vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "newpaper",
        callback = function()
          -- set colors for highlighting duplicates under the cursor
          local statusline = vim.api.nvim_get_hl(0, { name = "StatusLine" })
          local question = vim.api.nvim_get_hl(0, { name = "Question" })
          vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = statusline.bg, fg = question.fg, bold = true })
          vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = statusline.bg, fg = question.fg, bold = true })
          init_cmp_colors()
        end
      })
    end,
  },
  {
    'AlexvZyl/nordic.nvim',
    name = 'nordic',
    lazy = false,
    priority = 1000,
    config = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nordic", -- only for nordic
        callback = function()
          -- match fold column background
          local bg_color = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
          local visual = vim.api.nvim_get_hl(0, { name = "NonText" }).fg
          local status = vim.api.nvim_get_hl(0, { name = "EndOfBuffer" }).fg

          vim.api.nvim_set_hl(0, "FoldColumn", { bg = bg_color })
          vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_color })
          vim.api.nvim_set_hl(0, "Folded", { bg = bg_color })
          vim.api.nvim_set_hl(0, "Visual", { bg = visual })
          vim.api.nvim_set_hl(0, "CursorLine", { bg = status })
          vim.api.nvim_set_hl(0, "CursorColumn", { bg = status })

          local mode = vim.api.nvim_get_hl(0, { name = "ModeMsg" })
          vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = mode.fg, bg = mode.bg, bold = true })
          vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = mode.fg, bg = mode.bg, bold = true })

          -- Link cmp to nordic colours
          -- Pmenu (optional, keep if you want custom popup colors)
          vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
          vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })
          init_cmp_colors()
        end

      })
    end
  }
}
