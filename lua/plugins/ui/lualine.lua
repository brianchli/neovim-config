if not vim.g.vscode then
  return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    priority = 850,
    config = function()
      local status, ll = pcall(require, 'lualine')
      if status then
        local colors = {
          blue   = '#82aaff',
          purple = '#c792ea',
          cyan   = '#7fdbca',
          red    = '#ff5874',
          yellow = '#e3d18a',
          green  = '#98be65',
          white  = '#d6deeb'
        }
        local options = {
          icons_enabled = true,
          theme = 'nightfly',
          section_separators = { left = '', right = '' },
          component_separators = "",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        }
        local ll_b = {
          {
            "branch",
            color = {
              fg = colors.purple,
            },
          },
          {
            "diff",
            colored = true,
            diff_color = {
              added = { fg = colors.blue },
              modified = { fg = colors.cyan },
              removed = { fg = colors.red },
            }
          },
        }
        local ll_x = {
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          },
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, },
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          },
          {
            "fileformat",
            right_padding = 2,
            symbols = {
              unix = 'UNIX',
              dos = 'DOS',
              mac = 'MAC',
            },
            color = { fg = colors.white, },
          },
        }

        local ll_y = { 'encoding' }

        ll.setup {
          options = options,
          sections = {
            lualine_a = { "mode" },
            lualine_b = ll_b,
            lualine_c = {
              {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = ' ', warn = ' ', info = ' ' },
                diagnostics_colors = {
                  color_info = { fg = colors.blue },
                  color_warn = { fg = colors.cyan },
                  color_error = { fg = colors.red },
                },
                update_in_insert = true
              },
              {
                "filename",
                symbols = {
                  modified = '[+]',
                  readonly = '[-]',
                  unnamed = '[No Name]',
                  newfile = '[New]',
                },
              },
            },
            lualine_x = ll_x,
            lualine_y = ll_y,
            lualine_z = { 'location' },
          },
        }
      end
    end
  }
end
