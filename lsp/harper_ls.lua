return {
  cmd = { "harper-ls", "--stdio" },
  filetypes = { "c", "cpp", "gitcommit", "go", "html", "java", "javascript", "lua", "markdown", "nix", "python", "rust", "swift", "toml", "typescript", "typescriptreact", "cmake" },
  root_markers = { ".git" },
  settings = {
    ["harper-ls"] = {
      userDictPath = "",
      fileDictPath = "",
      linters = {
        SpellCheck = false,
        SpelledNumbers = false,
        AnA = true,
        SentenceCapitalization = false,
        UnclosedQuotes = true,
        WrongQuotes = false,
        LongSentences = true,
        RepeatedWords = true,
        Spaces = true,
        Matcher = true,
        CorrectNumberSuffix = true
      },
      codeActions = {
        ForceStable = false
      },
      markdown = {
        IgnoreLinkTitle = false
      },
      diagnosticSeverity = "hint",
      isolateEnglish = false,
      dialect = "Australian",
      maxFileLength = 120000
    }
  }

}
