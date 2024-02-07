return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function ()
    vim.keymap.set("n", "<leader>wd", function() require("trouble").toggle("workspace_diagnostics") end)
    vim.keymap.set("n", "<leader>d", function() require("trouble").toggle("document_diagnostics") end)
    vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
    vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
    vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
  end
}
