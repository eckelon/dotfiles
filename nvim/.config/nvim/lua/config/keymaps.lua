-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<esc>", { desc = "Go to normal mode" })

-- I <3 Helix
vim.keymap.set("n", "gh", "0", { desc = "Start of line" })
vim.keymap.set("n", "gl", "$", { desc = "End of line" })
vim.keymap.set("n", "ge", "G", { desc = "Last line" })
