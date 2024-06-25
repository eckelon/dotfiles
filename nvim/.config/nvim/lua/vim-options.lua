vim.g.mapleader = " "

vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 30
vim.g.netrw_localcopydircmd = 'cp -r'

vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

local Map = vim.keymap.set

-- Navigate vim panes better
Map('n', '<c-k>', ':wincmd k<CR>')
Map('n', '<c-j>', ':wincmd j<CR>')
Map('n', '<c-h>', ':wincmd h<CR>')
Map('n', '<c-l>', ':wincmd l<CR>')

-- Buffers
Map('n', 'bn', ':bn<CR>')
Map('n', 'bp', ':bp<CR>')

-- I love Helix

Map('n', 'gh', '0')
Map('n', 'gl', '$')
Map('n', 'ge', 'G')

-- File Tree
-- Map('n', '-', ':Nvim:<CR>')
-- Map('n', 'e', ':Lex<CR>')

Map('i', 'jj', '<esc><CR>')

Map('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true
