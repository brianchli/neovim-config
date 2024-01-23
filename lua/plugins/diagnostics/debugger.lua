if not vim.g.vscode then
  return {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        'rcarriga/nvim-dap-ui',
        "jay-babu/mason-nvim-dap.nvim",
      },
      keys = {
        { "<leader>ds",  "<cmd>lua require('dap').continue()<cr>",                                                    desc = "run or continue debug session" },
        { "<leader>db",  "<cmd>lua require('dap').toggle_breakpoint()<cr>",                                           desc = "toggle dap breakpoint" },
        { "<leader>dB",  "<cmd>lua require('dap').set_breakpoint()<cr>",                                              desc = "set breakpoint" },
        { "<leader>dlb", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", desc = "set breakpoint verbose" },
        { "<leader>do",  "<cmd>lua require('dap').step_over()<cr>",                                                   desc = "step over" },
        { "<leader>di",  "<cmd>lua require('dap').step_into()<cr>",                                                   desc = "step into" },
        { "<leader>dr",  "<cmd>lua require('dap').repl.open()<cr>",                                                   desc = "open repl" },
        { "<leader>dR",  "<cmd>lua require('dap').restart()<cr>",                                                     desc = "restart debug session" },
        {
          "<leader>dS",
          function()
            require('dap').close()
            require('dapui').close()
          end,
          desc = "stop debug session"
        },
      },
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        local icons = require('config.icons').dap
        --
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

        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end

        dap.adapters.lldb = {
          type = 'server',
          port = "${port}",
          executable = {
            command = vim.fn.stdpath('data') .. '/mason/bin/codelldb', -- adjust as needed, must be absolute path
            args = { "--port", "${port}" },
          }
        }

        local c_lang_compile_actions = function(filename, ext)
          if io.open('CmakeLists.txt') ~= nil then
            vim.notify('CmakeLists.txt found')
            local abs_dir = vim.fn.getcwd()
            local current_dir = abs_dir:match('.*[/](.*)')
            if current_dir == 'src' then
              vim.notify("cannot be in src directory")
              return nil
            end
            if vim.fn.isdirectory(abs_dir .. "/build") == 0 or vim.fn.isdirectory(abs_dir .. "/src") == 0 then
              vim.notify("build and src files must exist")
              return nil
            end
            local compile = io.popen("cmake -S . -B build/ -DCMAKE_BUILD_TYPE=Debug 2>&1 && cmake --build build/ 2>&1")
            if compile then
              local contents = compile:read('a')
              compile:close()
              vim.notify("Compilation:\n\n" .. contents .. '\n')
              return vim.fn.getcwd() .. '/build/main'
            end
          elseif io.open('Makefile') ~= nil then
            vim.notify('Makefile found')
            local compile = io.popen("make " .. filename .. " 2>&1")
            if compile then
              local contents = compile:read('a')
              compile:close()
              vim.notify("Compilation:\n\n" .. contents .. '\n')
              return vim.fn.getcwd() .. '/build/' .. filename
            end
          end
          vim.notify("No CmakeLists.txt file or Makefile found.")
          local compile_action = ''
          if ext == 'cpp' then
            compile_action = 'c++ -std=c++20 '
          else
            compile_action = 'gcc -std=c11 '
          end
          vim.notify("Compiling with " .. compile_action)
          local compile = io.popen(compile_action .. vim.fn.expand('%') .. ' -g -o ' .. filename)
          if compile then
            vim.notify("Compilation successful")
            return vim.fn.getcwd() .. '/' .. filename
          else
            vim.notify("Compilation failed")
            return nil
          end
        end

        dap.configurations.cpp = {
          {
            name = "Compile and launch executable",
            type = "lldb",
            request = "launch",
            program = function()
              local file = vim.fn.expand('%')
              local filename = file:match("(.+)[.].*$")
              if filename == nil then
                return nil
              end
              local extension = file:match(".*[.](.*)$")
              return c_lang_compile_actions(filename, extension)
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
          {
            name = "Launch executable",
            type = "lldb",
            request = "launch",
            program = function()
              local abs_dir = vim.fn.getcwd()
              local current_dir = abs_dir:match('.*[/](.*)')
              if current_dir == 'src' then
                vim.notify("cannot be in src directory")
                return nil
              end
              local filename = vim.fn.expand('%'):match("(.+)[.].*$")
              -- a file without an extension: file.<extension>
              if filename == nil then
                return nil
              end
              local extension = vim.fn.expand('%'):match(".+[.](.*)$")
              if io.open(vim.fn.getcwd() .. '/a.out') ~= nil then
                return vim.fn.getcwd() .. '/a.out'
              end
              if io.open(vim.fn.getcwd() .. '/' .. filename) ~= nil then
                return vim.fn.getcwd() .. '/' .. filename
              end
              -- compiled with make
              if io.open(vim.fn.getcwd() .. '/build/' .. filename) ~= nil then
                return vim.fn.getcwd() .. '/build/' .. filename
              end
              -- compiled with cmake
              if io.open(vim.fn.getcwd() .. '/build/main') ~= nil then
                return vim.fn.getcwd() .. '/build/main'
              end
              return vim.fn.input('Executable(' .. extension .. '):', './', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
          {
            type = "lldb",
            name = "Attach (Pick Process)",
            request = "attach",
            mode = "local",
            processId = require('dap.utils').pick_process,
          },
        }
        dap.configurations.c = dap.configurations.cpp
      end
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        "mfussenegger/nvim-dap",
        "folke/neodev.nvim",
        'theHamsta/nvim-dap-virtual-text',
      },
      keys = {
        { "<leader>.",  "<cmd>lua require('dapui').toggle()<cr>",             desc = "toggle dapui window" },
        { "<leader>..", "<cmd>lua require('dapui').open({reset = true})<cr>", desc = "reset dapui windows" },
      },
      config = function(_, opts)
        require("nvim-dap-virtual-text").setup()
        local dapui = require("dapui")
        dapui.setup(opts)
        vim.api.nvim_create_autocmd({ "QuitPre", "ExitPre" }, {
          group = vim.api.nvim_create_augroup("lazy_augroup_autoclose_dapui", { clear = true }),
          callback = function()
            require('dap').close()
            require('dapui').close()
          end,
        })
      end,
    },
  }
end
