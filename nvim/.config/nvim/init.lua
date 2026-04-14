vim.g.mapleader = " "

vim.cmd("color sorbet | hi Comment cterm=italic gui=italic")
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

if vim.fn.executable("fd") == 1 then
  function _G.FdFindFunc(pattern) return vim.fn.systemlist({"fd", "-tf", "-Hi", "-p", "-a", "-c", "never", "-E", ".git", pattern or ""}) end
  vim.o.findfunc = "v:lua.FdFindFunc"
end

vim.api.nvim_create_user_command("Fd", function(opts)
  local files = _G.FdFindFunc and _G.FdFindFunc(opts.args) or vim.fn.systemlist("find . -name " .. vim.fn.shellescape("*" .. opts.args .. "*") .. " -not -path '*/.git/*'")
  vim.fn.setqflist(vim.tbl_map(function(f) return { filename = f, text = f } end, files))
  vim.cmd("copen")
end, { nargs = 1 })

map("n", "<leader>ff", ":find ", { desc = "Fuzzy find files" })
map("n", "<leader>fF", ":Fd ", { desc = "Find files" })

local function grep_word_under_cursor()
  vim.cmd("silent grep! -F -- " .. vim.fn.shellescape(vim.fn.expand("<cword>")))
  vim.cmd("copen")
end

local function grep_visual_selection()
  local text = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.visualmode() }), "\n")
  vim.cmd("silent grep! -F -- " .. vim.fn.shellescape(text))
  vim.cmd("copen")
end

map("n", "<leader>gr", grep_word_under_cursor, { desc = "Grep word" })
map("x", "<leader>gr", grep_visual_selection, { desc = "Grep selection" })
