return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup()
      vim.keymap.set('n', 'gb', gitsigns.blame)
      vim.opt.statusline:append('%{get(b:,"gitsigns_status","")}')
    end
  }
}
