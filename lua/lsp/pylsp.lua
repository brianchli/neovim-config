local py_settings = {
  pylsp = {
    plugins = {
      pyflakes = { enabled = false },
      pylint = { enabled = false },
      pycodestyle = { enabled = false },
      autopep8 = { enabled = false },
      flake8 = { enabled = false },
      yapf = { enabled = true },
    },
  }
}

return "pylsp", py_settings
