return {
  settings = {
    args = {
      '--config=' .. os.getenv('HOME') .. '/.config/nvim/lint/pyproject.toml',
    }
  }
}
