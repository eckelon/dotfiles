vim.g.skip_defaults_vim = nil
vim.cmd("source " .. vim.env.VIMRUNTIME .. "/defaults.vim")

vim.cmd.packadd("matchit")

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd("hi Comment cterm=italic")

vim.opt.number = true
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions:append("pum")
vim.opt.complete = ".,w,b,u,i,k"
vim.opt.listchars = { tab = ">-" }

vim.keymap.set("n", ";", ":", { noremap = true })

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.compatible = false
vim.opt.shortmess:append("c")
vim.opt.smarttab = true
vim.opt.ignorecase = true
vim.opt.splitright = true
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.path = ",**"

vim.opt.t_ut = ""
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")

vim.g.mapleader = " "

if vim.fn.executable("fd") == 1 then
  vim.opt.findprg = "fd --type f --hidden --exclude .git $* ."
else

if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

vim.keymap.set("n", "<leader>g", function()
  local word = vim.fn.input("Grep: ")
  if word ~= "" then
    vim.cmd("silent grep! " .. word)
    vim.cmd("copen")
  end
end)

vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 15

vim.api.nvim_create_user_command("Gstatus", "vertical term git status -sb", {})
vim.api.nvim_create_user_command("Glog", "vertical term git lg", {})
vim.api.nvim_create_user_command("Gdiff", "vertical term git diff %", {})
vim.api.nvim_create_user_command("Gadd", "!git add %", {})

local function Buffers()
  local bufs = {}
  for i = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(i) == 1 then
      table.insert(bufs, { bufnr = i })
    end
  end
  vim.fn.setqflist(bufs)
end

vim.keymap.set("n", "<leader>b", function()
  Buffers()
  vim.cmd("copen")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>co", ":copen<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cc", ":cclose<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "ge", "G", { noremap = true })
vim.keymap.set("n", "gh", "0", { noremap = true })
vim.keymap.set("n", "gl", "$", { noremap = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})

vim.diagnostic.config({
  virtual_text    = true,
  signs           = true,
  underline       = true,
  update_in_insert = false,
})

vim.lsp.enable({
  "lua_ls",
})
