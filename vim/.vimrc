syntax enable
filetype plugin on
colorscheme catppuccin_mocha

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
set path=,..
set t_ut= "avoid weird to the highlight in the terminal
set laststatus=2
set statusline=%f "show the filename in the statusbar
set splitright

let mapleader = " "
let g:netrw_banner = 0
let g:netrw_altv = 1

set omnifunc=ale#completion#OmniFunc
set completeopt+=noinsert

let g:mucomplete#enable_auto_at_startup = 1
let b:ale_warn_about_trailing_whitespace = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '🔴'
let g:ale_sign_warning = '❕'
let g:ale_cursor_detail = 1
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_window_border = []

highlight clear ALEErrorSign
highlight clear ALEWarningSign

inoremap jj <Esc>
nnoremap <silent> - :Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>/ :Rg<CR>
nnoremap <leader>s :Rg <C-R>=expand('<cword>')<CR><CR>

nnoremap gd :ALEGoToDefinition<CR>
nnoremap gD :ALEGoToImplementation<CR>
nnoremap gT :ALEGoToTypeDefinition<CR>
nnoremap gr :ALEFindReferences<CR>
nnoremap ga :ALECodeAction
nnoremap <leader>r :ALERename<CR>

xnoremap <c-c> <Plug>Commentary
nnoremap <c-c> <Plug>CommentaryLine
