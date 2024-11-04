return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
  },
  {
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = {
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "ms-jpq/coq_nvim" },
    config = function()
      local lsp = require("lspconfig")

      vim.g.coq_settings = { auto_start = true }
      local coq = require("coq")
      vim.cmd("COQnow")

      local servers = {
        'ts_ls',
        'eslint',
        'html',
        'lua_ls',
        'zls',
        'jedi_language_server',
        'bashls',
        'jdtls',
        'gopls',
      }

      for _, config in ipairs(servers) do
        lsp[config].setup(coq.lsp_ensure_capabilities())
      end

      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set('n', 'gr', function()
        require('telescope.builtin').lsp_references()
      end)
      vim.keymap.set('n', 'gd', function()
        require('telescope.builtin').lsp_definitions()
      end)
      vim.keymap.set('n', 'gi', function()
        require('telescope.builtin').lsp_implementations()
      end)
      vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          },
        },
      })
    end,
  },
}
