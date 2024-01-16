if not vim.g.vscode then
  return {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        'rcarriga/nvim-dap-ui',
      },
      keys = {
        { "<leader>R", "<cmd>lua require('dap').continue()<cr>",          desc = "continue debug session" },
        { "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "toggle dap breakpoint" },
        { "<leader>o", "<cmd>lua require('dap').step_over()<cr>",         desc = "step over" },
        { "<leader>i", "<cmd>lua require('dap').step_into()<cr>",         desc = "step into" },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        local icons = require('config.icons').dap
        vim.fn.sign_define('DapBreakpoint',
          { text = icons.Breakpoint, texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition',
          { text = icons.Breakpoint, texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected',
          {
            text = icons.BreakpointRejected[1],
            texthl = 'DapBreakpoint',
            linehl = 'DapBreakpoint',
            numhl =
            'DapBreakpoint'
          })
        vim.fn.sign_define('DapLogPoint', {
          text = icons.Stopped[1],
          texthl = 'DapLogPoint',
          linehl = 'DapLogPoint',
          numhl =
          'DapLogPoint'
        })
        vim.fn.sign_define('DapStopped',
          { text = icons.Stopped[1], texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        "mfussenegger/nvim-dap",
        "folke/neodev.nvim",
      },
      keys = {
        { "<leader>.", "<cmd>lua require('dapui').toggle()<cr>", desc = "open dap ui" },
      },
      config = function(_, opts)
        local dapui = require("dapui")
        dapui.setup(opts)
      end,
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require("nvim-dap-virtual-text").setup()
      end
    }
  }
end
