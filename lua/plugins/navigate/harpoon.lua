return {
  {
    "ThePrimeagen/harpoon",
    lazy = false,
    branch = "harpoon2",
    init = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup(
        {
          settings = {
            save_on_toggle = true,
          }
        }
      )
      -- REQUIRED

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "append to harpoon list" })
      vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "open harpoon list" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "open harpoon list item 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "open harpoon list item 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "open harpoon list item 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "open harpoon list item 4" })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>j", function() harpoon:list():prev() end,
        { desc = "toggle to prev saved harpoon buffer " })
      vim.keymap.set("n", "<leader>k", function() harpoon:list():next() end,
        { desc = "toggle to next saved harpoon buffer" })

      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end
      vim.keymap.set("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end,
        { desc = "fzf search harpoon buffers" })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  }
}
