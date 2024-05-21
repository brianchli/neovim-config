if not vim.g.vscode then
  return {
    'rmagatti/goto-preview',
    keys = {
      { "gt", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "open definition in preview window" },
      { "gx", "<cmd>lua require('goto-preview').close_all_win()<CR>",           desc = "close all preview windows" },
    },
    config = function()
      require('goto-preview').setup {
        height = 20,
        post_open_hook = function(buf, win)
          local orig_state = vim.api.nvim_get_option_value('modifiable', { buf = buf })
          vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

          -- use q to close floating window
          if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<cr>", { noremap = true })
          end

          -- actually close the window and reapply modification permissions
          vim.api.nvim_create_autocmd({ 'WinLeave' }, {
            buffer = buf,
            callback = function()
              vim.api.nvim_win_close(win, false)
              vim.api.nvim_set_option_value('modifiable', orig_state, { buf = buf })
              return true
            end,
          })
          -- close the preview when moving back to the original buffer
          vim.api.nvim_create_autocmd({ 'BufLeavePre' }, {
            buffer = buf,
            callback = function()
              vim.api.nvim_win_close(win, false)
              vim.api.nvim_set_option_value('modifiable', orig_state, { buf = buf })
              return true
            end,

          })
        end
      }
    end
  }
end
