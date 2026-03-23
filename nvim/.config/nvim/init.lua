require('lualine').setup({})

vim.cmd("colorscheme tokyonight | hi Comment cterm=italic gui=italic")

-- Options (grouped for brevity)
-- local opt = vim.opt
-- opt.termguicolors, opt.number, opt.swapfile, opt.ignorecase, opt.smartcase, opt.splitright, opt.splitbelow, opt.showmode, opt.cursorline =
-- true, true, false, true, true, true, true, true, true
-- opt.signcolumn, opt.inccommand, opt.winborder = "yes", "split", "rounded"
-- opt.wildmode, opt.complete, opt.listchars, opt.path = "longest:full,full", ".,w,b,u,i,k",
-- { tab = ">-", trail = "·", nbsp = "␣" }, ".,**"

vim.g.netrw_banner, vim.g.netrw_keepdir, vim.g.netrw_winsize = 0, 1, 25
vim.g.mapleader = " "
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
vim.opt.number, vim.opt.ignorecase, vim.opt.smartcase, vim.opt.termguicolors = true, true, true, true
vim.opt.shortmess:append("atTFc")
-- Built-in Treesitter
vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })

local map = vim.keymap.set
map("n", ";", ":", { desc = "Enter command mode" })
map("i", "jj", "<Esc>", { desc = "Return to normal mode" })
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
map("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })
map({ "n", "i" }, "<C-x><C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "gh", "0", { desc = "Go to start of line" })
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "<leader>co", ":copen<CR>", { silent = true, desc = "Open quickfix" })
map("n", "<leader>cc", ":cclose<CR>", { silent = true, desc = "Close quickfix" })

local function search_file(f)
  if f ~= "" then vim.fn.search(vim.fn.escape(f, "\\.*[]^$"), "wc") end
end

map("n", "-", function()
  local f = vim.fn.expand("%:t")
  vim.cmd("let g:netrw_liststyle=0 | Ex")
  search_file(f)
end, { silent = true, desc = "Open parent directory" })

map("n", "<leader>e", function()
  local f = vim.fn.expand("%:t")
  vim.cmd("let g:netrw_liststyle=3 | Lexplore")
  vim.schedule(function() search_file(f) end)
end, { silent = true, desc = "Toggle file tree" })

-- Autocmds
local autocmd = vim.api.nvim_create_autocmd
autocmd("FileType", { pattern = "netrw", callback = function() vim.opt_local.bufhidden = "delete" end })

autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = "Visual" }) end })

autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(tostring(vim.fn.argv(0))) == 1 then
      local dir = tostring(vim.fn.argv(0))
      vim.defer_fn(function() require("fzf-lua").files({ cwd = dir }) end, 1)
    end
  end,
  nested = true
})

-- Commands
vim.api.nvim_create_user_command("ConfigReload", function()
  for name, _ in pairs(package.loaded) do
    package.loaded[name] = nil
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload init.lua" })

vim.api.nvim_create_user_command("Git", "term lazygit", {})
map('n', '<leader>lg', '<cmd>Git<cr>')
map('n', '<leader>ff', '<cmd>FzfLua files<cr>')
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>')
map('n', '<leader>?', '<cmd>FzfLua keymaps<cr>')
map('n', '<leader>f/', '<cmd>FzfLua live_grep_native<cr>')
map('n', '<leader>fw', '<cmd>FzfLua grep_cword<cr>')

-- LSP Setup
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end)
    end

    local function o(d) return { buffer = ev.buf, desc = "[LSP] " .. d } end
    map("n", "grd", vim.lsp.buf.definition, o("Go to definition"))
    map("n", "<leader>dl", vim.diagnostic.setqflist, o("List diagnostics"))
    map("n", "<leader>grf", function() vim.lsp.buf.format({ async = true }) end, o("Format buffer"))
    if client and not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_lines = { current_line = true },
  virtual_text = { severity = vim.diagnostic.severity.ERROR },
  signs = { text = { [1] = "✘", [2] = "▲", [3] = "⚑", [4] = "»" } },
  underline = true,
  update_in_insert = false,
})

vim.lsp.config.lua_ls = { cmd = { "lua-language-server" }, filetypes = { "lua" }, root_markers = { ".luarc.json", ".git" }, settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } }, workspace = { library = vim.api.nvim_get_runtime_file("", true) } } } }
vim.lsp.config.gopls = { cmd = { "gopls" }, filetypes = { "go", "gomod", "gowork", "gotmpl" }, root_markers = { "go.work", "go.mod", ".git" }, settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true, completeUnimported = true, usePlaceholders = true } } }
vim.lsp.config.ts_ls = { cmd = { "typescript-language-server", "--stdio" }, filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }, root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" } }
vim.lsp.config.basedpyright = { cmd = { "basedpyright-langserver", "--stdio" }, filetypes = { "python" }, root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }, settings = { basedpyright = { analysis = { autoSearchPaths = true, diagnosticMode = "workspace" } } } }
vim.lsp.config.ruff = { cmd = { "ruff", "server" }, filetypes = { "python" }, root_markers = { "pyproject.toml", "ruff.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" } }
vim.lsp.config.marksman = { cmd = { "/opt/homebrew/bin/marksman", "server" }, filetypes = { "markdown", "markdown.mdx" }, root_markers = { ".marksman.toml", ".git" } }

vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "basedpyright", "ruff", "marksman" })
