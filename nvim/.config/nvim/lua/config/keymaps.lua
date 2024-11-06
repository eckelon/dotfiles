-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.api.nvim_set_keymap("i", "jj", "<esc>", { desc = "Go to normal mode" })

-- I <3 Helix
vim.api.nvim_set_keymap("n", "gh", "0", { desc = "Start of line" })
vim.api.nvim_set_keymap("n", "gl", "$", { desc = "End of line" })
vim.api.nvim_set_keymap("n", "ge", "G", { desc = "Last line" })

-- Map Ctrl-C to toggle comments
vim.api.nvim_set_keymap("n", "<C-c>", "gcc", { noremap = false, silent = true })
vim.api.nvim_set_keymap("v", "<C-c>", "gc", { noremap = false, silent = true })
