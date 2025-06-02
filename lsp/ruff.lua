return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  settings = {
    args = {
      '--config=' .. os.getenv('HOME') .. '/.config/nvim/lint/pyproject.toml',
    }
  }
}
