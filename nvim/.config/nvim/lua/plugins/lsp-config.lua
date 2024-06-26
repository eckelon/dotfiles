return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({ capabilites = capabilities })
      lspconfig.eslint.setup({ capabilites = capabilities })
      lspconfig.html.setup({ capabilites = capabilities })
      lspconfig.lua_ls.setup({ capabilites = capabilities })
      lspconfig.zls.setup({ capabilites = capabilities })
      lspconfig.jedi_language_server.setup({ capabilites = capabilities })
      lspconfig.bashls.setup({ capabilites = capabilities })
      lspconfig.jdtls.setup({ capabilites = capabilities })
      lspconfig.gopls.setup({ capabilites = capabilities })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
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
