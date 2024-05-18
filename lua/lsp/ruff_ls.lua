local ruff_settings = {
  settings = {
    args = {
      '--config=' .. os.getenv('HOME') .. '/.config/nvim/lint/pyproject.toml',
    }
  }
}

return "ruff_lsp", ruff_settings
