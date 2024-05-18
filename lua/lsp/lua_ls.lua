local lua_settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim', } -- disable unused global message
    },
    workspace = {
      library = { vim.env.VIMRUNTIME },
    },
  }
}

return "lua_ls", lua_settings
