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

set tabstop=4
set shiftwidth=4 smarttab

let mapleader = " "

colorscheme slate
set t_ut=

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

" Fuzzy finding and grepping

function! FZF() abort
    let l:tempname = tempname()
    " fzf | awk '{ print $1":1:0" }' > file
    execute 'silent !fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
    try
        execute 'cfile ' . l:tempname
        redraw!
    finally
        call delete(l:tempname)
    endtry
endfunction

set grepprg=rg\ --vimgrep
command! -nargs=* Rg call RG(<q-args>)
nnoremap <leader>/ :Rg<cr>

function! RG(args) abort
    let l:tempname = tempname()
    let l:pattern = '.'
    if len(a:args) > 0
        let l:pattern = a:args
    endif
    " rg --vimgrep <pattern> | fzf -m > file
    execute 'silent !rg --vimgrep ''' . l:pattern . ''' | fzf -m > ' . fnameescape(l:tempname)
    try
        execute 'cfile ' . l:tempname
        redraw!
    finally
        call delete(l:tempname)
    endtry
endfunction

command! -nargs=* Files call FZF()
nnoremap <leader>f :Files<cr>
