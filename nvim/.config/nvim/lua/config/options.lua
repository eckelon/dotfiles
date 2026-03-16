-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.conceallevel = 0
vim.opt.relativenumber = false -- Never got used to this
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "c", '"_c', opts) -- Don't save the contents to change to the clipboard

vim.keymap.set("i", "<C-n>", "<Down>", opts)
vim.keymap.set("i", "<C-p>", "<Up>", opts)
vim.keymap.set("i", "<C-f>", "<Right>", opts)
vim.keymap.set("i", "<C-b>", "<Left>", opts)
vim.keymap.set("i", "<A-f>", "<C-Right>", opts) -- next word
vim.keymap.set("i", "<A-b>", "<C-Left>", opts) -- prev word
vim.keymap.set("i", "<C-e>", "<End>", opts)
vim.keymap.set("i", "<C-a>", "<Home>", opts)
