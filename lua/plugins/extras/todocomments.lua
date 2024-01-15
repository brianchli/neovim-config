return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile" },
  config = true,
  keys = {
    { "]t",         function() require("todo-comments").jump_next() end, desc = "next todo comment" },
    { "[t",         function() require("todo-comments").jump_prev() end, desc = "previous todo comment" },
    { "<leader>xt", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "find todo/fix/fixme (Trouble)" },
    { "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "find todo/fix/fixme" },
  },
}
