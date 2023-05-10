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
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function()
      local status, notify = pcall(require, 'notify')
      if status then
        local config = {
          max_width = 50,
          max_height = 100,
          timeout = 1000,
        }
        notify.setup(config)
        vim.notify = notify
      end
    end
  }
end
