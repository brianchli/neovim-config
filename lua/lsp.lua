local map = vim.keymap.set

local M = {}

local SNACK_METHODS = {
  gd = "textDocument/definition",
  gD = "textDocument/declaration",
  gI = "textDocument/implementation",
  gy = "textDocument/typeDefinition",

  gr = "textDocument/references",

  gai = "callHierarchy/incomingCalls",
  gao = "callHierarchy/outgoingCalls",

  -- symbols
  ["<leader>ss"] = "textDocument/documentSymbol",
  ["<leader>sS"] = "workspace/symbol",

  -- signature
  ["<C-k>"] = "textDocument/signatureHelp",
}

local LSP_METHODS = {
  ["textDocument/signatureHelp"] = {
    mode = "n",
    key  = "<C-k>",
    fn   = vim.lsp.buf.signature_help,
    desc = "signature help",
  },

  ["textDocument/typeDefinition"] = {
    mode = "n",
    key  = "<space>D",
    fn   = vim.lsp.buf.type_definition,
    desc = "buf type definition",
  },

  ["textDocument/documentSymbol"] = {
    attach = function(client, bufnr)
      require("nvim-navic").attach(client, bufnr)
    end,
  },

  ["textDocument/codeAction"] = {
    mode = "n",
    key  = "<space>ca",
    fn   = vim.lsp.buf.code_action,
    desc = "code actions",
  },

  ["textDocument/rename"] = {
    mode = "n",
    key  = "<leader>rn",
    fn   = vim.lsp.buf.rename,
    desc = "LSP Rename",
  },

  ["textDocument/formatting"] = {
    mode = "n",
    key  = "<space>F",
    fn   = function()
      require("conform").format({ async = true })
    end,
    desc = "format file",
  },

  ["workspace/workspaceFolders"] = {
    keys = {
      {
        mode = "n",
        key  = "<space>wa",
        fn   = vim.lsp.buf.add_workspace_folder,
        desc = "add workspace folder",
      },
      {
        mode = "n",
        key  = "<space>wr",
        fn   = vim.lsp.buf.remove_workspace_folder,
        desc = "remove workspace folder",
      },
      {
        mode = "n",
        key  = "<space>wl",
        fn   = function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = "list workspace folders",
      },
    },
  },
  ['textDocument/documentHighlight'] = {
    init = function(buf)
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })

      -- When cursor stops moving: Highlightsall instances of the symbol under the cursor
      -- When cursor moves: Clears the highlighting
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      -- When LSP detaches: Clears the highlighting
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  },

  ['textDocument/inlayHint'] = {
    init = function(buf, client)
      local original_handler = client.rpc.request;
      local inlay_hint_group = vim.api.nvim_create_augroup('lsp-inlay-hint', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = buf,
        group = inlay_hint_group,
        callback = function()
          if not vim.lsp.inlay_hint.is_enabled({ 0 }) then
            vim.lsp.inlay_hint.enable(true, { 0 })
          end
        end,
      })

      local last_line = nil;
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = buf,
        group = inlay_hint_group,
        callback = function()
          local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
          if last_line ~= nil and last_line == cursor_line then
            return
          end
          if vim.lsp.inlay_hint.is_enabled({ 0 }) then
            vim.lsp.inlay_hint.enable(false, { 0 })
          end
        end,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-inlay-hint-detach', { clear = true }),
        callback = function(event2)
          vim.api.nvim_clear_autocmds { group = 'lsp-inlay-hint', buffer = event2.buf }
        end,
      })

      client.rpc.request = function(methods, params, handler, ...)
        if methods ~= 'textDocument/inlayHint' then
          return original_handler(methods, params, handler, ...)
        end

        local decorator = function(err, ok)
          local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
          last_line = cursor_line
          local filtered = vim.tbl_filter(function(hint)
            return hint.position.line == cursor_line
          end, ok or {})
          return handler(err, filtered)
        end

        return original_handler(methods, params, decorator, ...)
      end
    end

  }
}

-- Taken from:
-- https://github.com/adibhanna/minimal-vim/blob/5cd34cc07c242b880d0cf74b14e08cd66ee6804e/lua/config/autocmds.lua#L36
local function client_supports_method(client, method, bufnr)
  if vim.fn.has 'nvim-0.11' == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end

local opt_def = function(o, ...)
  return _G.utils.tjoin({ silent = true, buffer = ... }, o)
end

local apply = function(client, buf)
  local function del(mode, lhs)
    pcall(vim.keymap.del, mode, lhs, { buffer = buf })
  end

  for key, method in pairs(SNACK_METHODS) do
    if not client_supports_method(client, method) then
      del('n', key)
    end
  end

  for method, spec in pairs(LSP_METHODS) do
    if client_supports_method(client, method, buf) then
      if spec.attach then
        spec.attach(client, buf)
      elseif spec.keys then
        for _, entry in pairs(spec.keys) do
          map(entry.mode, entry.key, entry.fn, opt_def({ desc = entry.desc }))
        end
      elseif spec.init then
        spec.init(buf, client)
      else
        map(spec.mode, spec.key, spec.fn, opt_def({ desc = spec.desc }))
      end
    end
  end
end

M.apply = apply

return M
