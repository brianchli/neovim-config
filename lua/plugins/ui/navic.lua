return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    vim.g.navic_silence = true
    local colors = require("catppuccin.palettes").get_palette()
    -- set up icon colors and backgrounds
    local background = "#2c3043"
    local icons = colors.peach

    -- set colors
    vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = background, fg = icons })
    vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = background, fg = colors.text })
    vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = background, fg = colors.text })
  end,
  opts = function()
    return {
      separator = " > ",
      highlight = true,
      depth_limit = 5,
      depth_limit_indicator = "..",
      safe_output = true,
      icons = require("config.icons").kinds,
    }
  end,
}
