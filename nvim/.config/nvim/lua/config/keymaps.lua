-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jj", "<esc>")

-- I <3 Helix
vim.keymap.set("n", "gh", "0")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "ge", "G")
