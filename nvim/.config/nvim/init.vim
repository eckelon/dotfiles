set nocompatible
set number
set background=dark
colorscheme habamax
syntax enable
filetype plugin on

imap jj <Esc>
map <silent> - :Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Tweaks for browsing

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 15
