vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>r',
    ":lua require('vscode-neovim').action('editor.action.rename')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gr',
    ":lua require('vscode-neovim').action('editor.action.goToReferences')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gR',
    ":lua require('vscode-neovim').action('references-view.findReferences')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gd',
    ":lua require('vscode-neovim').action('editor.action.revealDefinition')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>k',
    ":lua require('vscode-neovim').action('editor.action.showHover')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'ge',
    ":lua require('vscode-neovim').action('cursorBottom')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gh',
    ":lua require('vscode-neovim').action('cursorHome')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gl',
    ":lua require('vscode-neovim').action('cursorEnd')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gn',
    ":lua require('vscode-neovim').action('workbench.action.nextEditor')<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'gp',
    ":lua require('vscode-neovim').action('workbench.action.previousEditor')<CR>", { noremap = true, silent = true })

vim.opt.clipboard:append("unnamedplus")
