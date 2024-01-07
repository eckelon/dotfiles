return {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<C-c>',
        },
      })
    vim.keymap.set('x', '<C-c>', '<Plug>(comment_toggle_linewise_visual)')
    end
}

