syntax enable
filetype plugin on

set nocompatible
set number
set mouse=a
set clipboard^=unnamed,unnamedplus
set termguicolors
set incsearch
set hlsearch
set cursorline
set nobackup
set noswapfile
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m


set tabstop=4
set shiftwidth=4 smarttab
set path=.,,
let mapleader = " "

colorscheme slate
set t_ut=

imap jj <Esc>
map <silent> - :Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>

set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*

" Display all matching files when we tab complete
set wildmenu

" Tweaks for browsing
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 15

" Fuzzy finding and grepping
command! -nargs=+ -complete=file SearchCursor
    \ execute 'silent grep! <cword>' | redraw! | copen 5

nnoremap <leader>s :SearchCursor <cword> *<CR>
nnoremap <leader>f :find **/
