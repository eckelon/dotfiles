vim.g.mapleader = " "

vim.pack.add({
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/neovim/nvim-lspconfig",
})

vim.cmd("color catppuccin | hi Comment cterm=italic gui=italic")
vim.g.netrw_banner, vim.g.netrw_keepdir, vim.g.netrw_winsize = 0, 1, 25
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.opt.number, vim.opt.ignorecase, vim.opt.smartcase, vim.opt.termguicolors = true, true, true, true
vim.opt.shortmess:append("atTFc")
vim.opt.swapfile, vim.opt.backup, vim.opt.writebackup, vim.opt.undofile = false, false, false, true

vim.opt.path = ".,**"
local map = vim.keymap.set
map("i", "jj", "<Esc>", { desc = "Return to normal mode" })
map("n", "gh", "0", { desc = "Go to start of line" })
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "<leader>co", ":copen<CR>", { silent = true, desc = "Open quickfix" })
map("n", "<leader>cc", ":cclose<CR>", { silent = true, desc = "Close quickfix" })
map("n", "<C-c>", "gcc", { remap = true, desc = "Toggle comment line" })
map("i", "<C-c>", "<C-o>gcc", { remap = true, desc = "Toggle comment line" })
map("x", "<C-c>", "gc", { remap = true, desc = "Toggle comment selection" })

local function toggle_mappings_panel()
  local bn = vim.fn.bufnr("KeyMappings")
  if bn ~= -1 then return vim.cmd("bwipeout " .. bn) end
  vim.cmd("botright vnew KeyMappings | put =execute('verbose nmap') | setl nomod buftype=nofile bufhidden=wipe")
end

map("n", "<leader>?", toggle_mappings_panel, { silent = true, desc = "Toggle mappings panel" })

local function highlight_current_file(f)
  if f ~= "" then vim.fn.search(vim.fn.escape(f, "\\.*[]^$"), "wc") end
end

local function open_directory_drawer()
  local f = vim.fn.expand("%:t")
  vim.cmd("let g:netrw_liststyle=0 | Ex")
  highlight_current_file(f)
end

local function toggle_sidebar_tree()
  if vim.bo.filetype == "netrw" then
    vim.cmd("Lexplore 0")
  else
    local dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
    local f = vim.fn.expand("%:t")
    vim.cmd("let g:netrw_liststyle=3 | Lexplore " .. vim.fn.escape(dir, " "))
    vim.defer_fn(function() highlight_current_file(f) end, 50)
  end
end

map("n", "-", open_directory_drawer, { silent = true, desc = "Open parent directory" })
map("n", "<leader>e", toggle_sidebar_tree, { silent = true, desc = "Toggle file tree" })

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
autocmd("FileType", { group = augroup, pattern = "netrw", callback = function() vim.opt_local.bufhidden = "delete" end })
autocmd("TextYankPost", { group = augroup, callback = function() vim.highlight.on_yank({ higroup = "Visual" }) end })
autocmd("FileType", { group = augroup, callback = function() pcall(vim.treesitter.start) end }) -- Built-in Treesitter

-- Auto-reload config on save
autocmd("BufWritePost", {
  group = augroup,
  pattern = "*.lua",
  callback = function(args)
    local config_path = vim.fn.resolve(vim.fn.stdpath("config"))
    local file_path = vim.fn.resolve(args.file)
    if file_path:find(config_path, 1, true) == 1 then
      dofile(file_path)
    end
  end,
})

-- Find and Grep improvements --
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg, vim.opt.grepformat = "rg --vimgrep --smart-case --hidden --no-messages --glob '!.git'", "%f:%l:%c:%m"
end

-- LSP
vim.o.autocomplete = true
vim.o.completeopt = "menu,menuone,noselect,nearest"
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "❌",
      [vim.diagnostic.severity.WARN] = "⚠️",
    },
  },
})

autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

autocmd("BufWritePre", {
  group = augroup,
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf })
  end,
})

vim.lsp.enable({ "basedpyright", "ruff", "ts_ls", "gopls", "bashls" })

-- FZF-Lua
require("fzf-lua").setup({ defaults = { git_icons = false } })
map("n", "<leader>ff", require("fzf-lua").files, { desc = "Find files" })
map("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Buffers" })
map("n", "<leader>fg", require("fzf-lua").live_grep, { desc = "Live grep" })
map("n", "<leader>fd", require("fzf-lua").diagnostics_workspace, { desc = "Diagnostics" })
