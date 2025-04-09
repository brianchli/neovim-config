local lua_settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim', } -- disable unused global message
    },
    workspace = {
      library = {
        vim.env.VIMRUNTIME,
        "${3rd}/luv/library"
      },
    },
  }
}

return "lua_ls", lua_settings
