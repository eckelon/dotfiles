vim.g.mapleader, vim.g.netrw_banner, vim.g.netrw_keepdir, vim.g.netrw_winsize = " ", 0, 0, 25
vim.cmd.packadd("matchit")
vim.cmd("colorscheme unokai | hi Comment cterm=italic gui=italic")

-- Options (grouped for brevity)
local opt = vim.opt
opt.termguicolors, opt.number, opt.swapfile, opt.ignorecase, opt.splitright, opt.showmode, opt.cursorline = true, true, false, true, true, false, true
opt.wildmode, opt.complete, opt.listchars, opt.path = "longest:full,full", ".,w,b,u,i,k", { tab = ">-" }, ".,**"
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.clipboard:append({"unnamed", "unnamedplus"})
opt.shortmess:append("atTFc")

-- Statusline
function _G.git_branch()
  local b = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  return b ~= "" and ("   " .. b) or ""
end
opt.statusline = "%f %m%r%h%w%{v:lua.git_branch()}%=" .. " %y  %l:%c  %p%% "

-- Built-in Treesitter
vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })

-- Keymaps (noremap is true by default in vim.keymap.set)
local map = vim.keymap.set
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jj", "<Esc>", { desc = "Return to normal mode" })
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
map("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })
map("n", "ge", "G", { desc = "Go to end of file" })
map("n", "gh", "0", { desc = "Go to start of line" })
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "<leader>co", ":copen<CR>", { silent = true, desc = "Open quickfix" })
map("n", "<leader>cc", ":cclose<CR>", { silent = true, desc = "Close quickfix" })
map("n", "<leader>ff", ":find ", { desc = "Find file" })
map("n", "<leader>e", function()
  local f = vim.fn.expand("%:t")
  vim.cmd("let g:netrw_liststyle = 3")
  vim.cmd("normal! m'")
  vim.cmd("Lexplore")
  if f ~= "" and vim.bo.filetype == "netrw" then vim.fn.search("\\<" .. vim.fn.escape(f, "\\.*[]^$") .. "\\>", "wc") end
end, { silent = true, desc = "Toggle file tree" })
map("n", "<leader>?", ":MapAll<CR>", { silent = true, desc = "List all mappings" })
map("n", "<C-c>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<C-c>", "gc", { remap = true, desc = "Toggle comment block" })
map("n", "-", function()
  local f = vim.fn.expand("%:t")
  vim.cmd("let g:netrw_liststyle = 0")
  vim.cmd("normal! m'")
  vim.cmd("Ex")
  if f ~= "" then vim.fn.search("\\<" .. vim.fn.escape(f, "\\.*[]^$") .. "\\>", "wc") end
end, { silent = true, desc = "Open parent directory" })
map("n", "<leader>b", function()
  local q = {}
  for i=1, vim.fn.bufnr("$") do if vim.fn.buflisted(i)==1 then table.insert(q, {bufnr=i}) end end
  vim.fn.setqflist(q)
  vim.cmd("copen")
end, { silent = true, desc = "List open buffers" })

-- Grep & Find Config
if vim.fn.executable("fd") == 1 then
  function _G.FdFindFunc(pattern) return vim.fn.systemlist({"fd", "-tf", "-Hi", "-p", "-a", "-c", "never", "-E", ".git", pattern or ""}) end
  vim.o.findfunc = "v:lua.FdFindFunc"
end
if vim.fn.executable("rg") == 1 then
  opt.grepprg, opt.grepformat = "rg --vimgrep --smart-case --hidden --no-messages --glob '!.git'", "%f:%l:%c:%m"
end
map("n", "<leader>/", function()
  local w = vim.fn.input("Grep: "); vim.cmd("redraw")
  if w == "" then return end
  local sm = vim.o.more; vim.o.more = false
  vim.cmd("silent! grep! " .. vim.fn.shellescape(w))
  vim.cmd("copen"); vim.o.more = sm; vim.cmd("redraw!")
end, { desc = "Grep text in project" })

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
autocmd("FileType", { pattern = "qf", callback = function(ev) map("n", "<CR>", function() vim.cmd("cclose | silent cc " .. vim.fn.line(".")) end, { buffer = ev.buf, silent = true }) end })
autocmd("FileType", { pattern = "netrw", callback = function() vim.opt_local.bufhidden = "wipe" end })

-- Commands
local cmd = vim.api.nvim_create_user_command

local function term_cmd(command)
  vim.cmd("vertical new")
  vim.fn.jobstart(command, { term = true, on_exit = function(_, code) if code == 0 then vim.cmd("silent! bdelete!") end end })
  vim.cmd("startinsert")
end

cmd("Gstatus", "vertical term git status -sb", {})
cmd("Glog", "vertical term git lg", {})
cmd("Gdiff", "vertical term git diff %", {})
cmd("Gcommit", function() term_cmd("git commit") end, {})
cmd("Gadd", function()
  vim.fn.system({"git", "add", vim.fn.expand("%")})
  print("Staged: " .. vim.fn.expand("%"))
end, {})

map("n", "<leader>ga", ":Gadd<CR>", { silent = true, desc = "Git add current file" })
map("n", "<leader>gc", ":Gcommit<CR>", { silent = true, desc = "Git commit" })
map("n", "<leader>gd", ":Gdiff<CR>", { silent = true, desc = "Git diff current file" })
map("n", "<leader>gl", ":Glog<CR>", { silent = true, desc = "Git log" })
map("n", "<leader>gs", ":Gstatus<CR>", { silent = true, desc = "Git status" })
map("n", "<leader>gb", function()
  local file, line = vim.fn.expand("%"), vim.fn.line(".")
  local b = vim.fn.system({"git", "blame", "-L", line .. "," .. line, "--", file}):gsub("\n", "")
  if vim.v.shell_error == 0 then vim.api.nvim_echo({{b, "Comment"}}, false, {}) else print("Not committed") end
end, { desc = "Git blame current line" })

cmd("MapAll", function()
  local l = {" MODE | KEY             | DESC / RHS "}
  for _, md in ipairs({"n","i","v","x","c","t","o"}) do
    for _, maps in ipairs({vim.api.nvim_get_keymap(md), vim.api.nvim_buf_get_keymap(0, md)}) do
      for _, m in ipairs(maps) do table.insert(l, string.format(" %-4s | %-15s | %s", md, (m.lhs or ""):gsub(" ", "<Space>"), m.desc or m.rhs or "<Lua>")) end
    end
  end
  vim.cmd("vnew | setlocal buftype=nofile bufhidden=wipe | nnoremap <buffer> q :q<CR>")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, l)
end, { desc = "List all mappings cleanly" })

-- LSP Setup
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

autocmd("LspAttach", {
  callback = function(ev)
    pcall(vim.lsp.completion.enable, true, ev.data.client_id, ev.buf, { autotrigger = true })
    if not vim.b[ev.buf].lsp_comp then
      autocmd("TextChangedI", { buffer = ev.buf, callback = function()
        local w = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2]):match("[%w_]+$")
        if w and #w >= 3 and vim.fn.pumvisible() == 0 then vim.lsp.completion.get() end
      end })
      vim.b[ev.buf].lsp_comp = true
    end

    local function o(d) return { buffer = ev.buf, desc = "[LSP] " .. d } end
    map("n", "gd", vim.lsp.buf.definition, o("Go to definition"))
    map("n", "gD", vim.lsp.buf.declaration, o("Go to declaration"))
    map("n", "gr", vim.lsp.buf.references, o("Show references"))
    map("n", "gi", vim.lsp.buf.implementation, o("Go to implementation"))
    map("n", "K", vim.lsp.buf.hover, o("Show hover doc"))
    map("n", "<leader>rn", vim.lsp.buf.rename, o("Rename symbol"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, o("Code actions"))
    map("n", "<leader>f", function() vim.lsp.buf.format({async=true}) end, o("Format buffer"))
    map("n", "[d", function() vim.diagnostic.jump({count=-1}) end, o("Previous diagnostic"))
    map("n", "]d", function() vim.diagnostic.jump({count=1}) end, o("Next diagnostic"))
    map("n", "<leader>dl", vim.diagnostic.setqflist, o("List diagnostics"))
  end,
})

vim.diagnostic.config({
  virtual_text = true, signs = { text = { [1] = "✘", [2] = "▲", [3] = "⚑", [4] = "»" } },
  underline = true, update_in_insert = false,
})

vim.lsp.config.lua_ls = { cmd = {"lua-language-server"}, filetypes = {"lua"}, root_markers = {".luarc.json", ".git"}, settings = { Lua = { runtime = {version="LuaJIT"}, diagnostics = {globals={"vim"}}, workspace = {library = vim.api.nvim_get_runtime_file("", true)} } } }
vim.lsp.config.gopls = { cmd = {"gopls"}, filetypes = {"go", "gomod", "gowork", "gotmpl"}, root_markers = {"go.work", "go.mod", ".git"}, settings = { gopls = { analyses = {unusedparams=true}, staticcheck=true, completeUnimported=true, usePlaceholders=true } } }
vim.lsp.config.ts_ls = { cmd = {"typescript-language-server", "--stdio"}, filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"}, root_markers = {"package.json", "tsconfig.json", "jsconfig.json", ".git"} }
vim.lsp.config.pyright = { cmd = {"pyright-langserver", "--stdio"}, filetypes = {"python"}, root_markers = {"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git"}, settings = { python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true, diagnosticMode = "workspace" } } } }
vim.lsp.enable({"lua_ls", "gopls", "ts_ls", "pyright"})
