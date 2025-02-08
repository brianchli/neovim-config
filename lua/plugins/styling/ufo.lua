if not vim.g.vscode then
  return {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async',
      {
        "luukvbaal/statuscol.nvim",
        opts = function()
          local builtin = require('statuscol.builtin')
          return {
            setopt = true,
            -- controls the order of the columns
            segments = {
              {
                text = { ' ', '%s' },
                click = 'v:lua.ScSa'
              },
              {
                text = { builtin.lnumfunc },
                condition = { true, builtin.not_empty },
                click = 'v:lua.ScLa',
              },
              { text = { ' ', builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
            },
            clickmod = "c",   -- modifier used for certain actions in the builtin clickhandlers:
            -- "a" for Alt, "c" for Ctrl and "m" for Meta.
            clickhandlers = { -- builtin click handlers
              Lnum                    = builtin.lnum_click,
              FoldClose               = builtin.foldclose_click,
              FoldOpen                = builtin.foldopen_click,
              FoldOther               = builtin.foldother_click,
              DapBreakpointRejected   = builtin.toggle_breakpoint,
              DapBreakpoint           = builtin.toggle_breakpoint,
              DapBreakpointCondition  = builtin.toggle_breakpoint,
              DiagnosticSignError     = builtin.diagnostic_click,
              DiagnosticSignHint      = builtin.diagnostic_click,
              DiagnosticSignInfo      = builtin.diagnostic_click,
              DiagnosticSignWarn      = builtin.diagnostic_click,
              GitSignsTopdelete       = builtin.gitsigns_click,
              GitSignsUntracked       = builtin.gitsigns_click,
              GitSignsAdd             = builtin.gitsigns_click,
              GitSignsChange          = builtin.gitsigns_click,
              GitSignsChangedelete    = builtin.gitsigns_click,
              GitSignsDelete          = builtin.gitsigns_click,
              gitsigns_extmark_signs_ = builtin.gitsigns_click,
            },
          }
        end
      }
    },
    priority = 900,
    opts = {
      close_fold_kinds_for_ft = {
        default = { 'imports', },
        json = { 'array' },
      },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Fold",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    },
    init = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.keymap.set('n', 'zK', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local suffix = ("   %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        local rAlignAppndx =
            math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
        suffix = (" "):rep(rAlignAppndx) .. suffix
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      opts["fold_virt_text_handler"] = handler
      require("ufo").setup(opts)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
  }
end
