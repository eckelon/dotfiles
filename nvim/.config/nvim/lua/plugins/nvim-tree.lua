return {
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   version = "*",
  --   lazy = false,
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },

  --   config = function()
  --     -- disable netrw at the very start of your init.lua
  --     vim.g.loaded_netrw = 1
  --     vim.g.loaded_netrwPlugin = 1
  --     vim.keymap.set("n", ",e", ":NvimTreeFindFile<CR>", { noremap = false })
  --     vim.keymap.set("n", ",b", ":NvimTreeClose<CR>", { noremap = false })


  --     -- OR setup with some options
  --     require("nvim-tree").setup({
  --       sort = { sorter = "case_sensitive" },
  --       view = { width = 60 },
  --       renderer = { group_empty = true },
  --       actions = { open_file = { window_picker = { enable = false } } },
  --     })
  --   end
  -- }
}
