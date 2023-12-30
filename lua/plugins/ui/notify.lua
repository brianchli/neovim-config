if not vim.g.vscode then
  return {
    'rcarriga/nvim-notify',
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    config = function()
      local status, notify = pcall(require, 'notify')
      if status then
        local config = {
          stages = "fade",
          render = "wrapped-compact",
          fps = 100,
          timeout = 3000,
          max_height = function()
            return math.floor(vim.o.lines * 0.75)
          end,
          max_width = function()
            return math.min(65, math.floor(vim.o.columns * 0.75))
          end,
          on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
          end,
        }
        notify.setup(config)
        vim.notify = notify
      end
    end
  }
end
