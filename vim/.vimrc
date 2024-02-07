unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

packadd! matchit

if version>= 901
  packadd! editorconfig
else
  packadd! editorconfig-vim
endif

set termguicolors
set background=dark
colorscheme catppuccin_mocha

"always load the lsp options after the colorscheme
source ~/.vim/lsp.vim

set number
set clipboard^=unnamed,unnamedplus

set wildmode=longest:full,full
if has( 'patch-8.2.4325' )
  set wildoptions+=pum
endif
set complete=.,w,b,u,i,k
set listchars=tab:>-
nnoremap ; :

set noswapfile
set nobackup
set hlsearch
set laststatus=2
set nobackup
set nocompatible
set noswapfile
set shortmess+=c   " Shut off completion messages
set smarttab
set ignorecase
set splitright
set noshowmode
set cursorline
set t_ut= "avoid weird to the highlight in the terminal

set undodir=$HOME/.vim/undodir

let mapleader = " "

"-----------------------------
"------- File Explorer -------
"-----------------------------

let g:netrw_banner=0
let g:netrw_keepdir=0
" let g:netrw_liststyle=3
let g:netrw_winsize=15

"----------------------------
"------- Git Commands -------
"----------------------------


command! Gstatus vertical term git status -sb
command! Glog 	 vertical term git lg
command! Gdiff 	 vertical term git diff %
command! Gadd    !git add %
command! -range GBlame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

"hightlight conflict marks
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
"-----------------------------
"------- Finding Files -------
"-----------------------------

" Faster vimgrep/grep via ripgrep

if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

function! Grep(...)
    return system(join([&grepprg] + [join(a:000, ' ')], ' '))
endfunction
command! -nargs=+ -complete=file_in_path Grep cexpr Grep(<f-args>) | copen
nnoremap <leader>? :Grep

" List buffers in quickfix
function Buffers()
    call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr": v:val}'))
endfunction
nnoremap <leader>b :call Buffers()<CR>:copen<CR>

" Fuzzy finding in the quickfix
autocmd! FileType qf nnoremap <buffer> <leader>v <C-w><Enter><C-w>L

if executable("fd")
	function! Fd(pattern)
		let output = systemlist("fd -c never --type f --hidden --exclude .git " . shellescape(a:pattern))
		call setqflist(map(output, '{ "filename": v:val }'))
		copen
	endfunction
	command! -nargs=1 FindFiles call Fd(<q-args>)
	nnoremap <leader>f :FindFiles<space>
endif

if g:lsp_auto_enable == 0
  nnoremap gr :execute 'Grep ' . expand('<cword>')<CR>
endif

nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>

"--------------
"--- Linter ---
"--------------

function! s:make(...) abort
  if empty(a:000)
    let l:args = [expand("%:S")]
  else
    let l:args = a:000
  endif
  return system(join(extend([&makeprg], l:args), ' '))
endfunction

" Run [cl]getexpr using local errorformat, if it's available.
function! s:getexpr_efm(func, msg) abort
  let l:efm_save = &g:errorformat
  if !empty(&l:errorformat)
    let &g:errorformat = &l:errorformat
  endif
  execute a:func . " a:msg"
  let &g:errorformat = l:efm_save
endfunction

command! -nargs=* -complete=file_in_path -bar Make call s:getexpr_efm("cgetexpr", s:make(<args>))
command! -nargs=* -complete=file_in_path -bar LMake call s:getexpr_efm("lgetexpr", s:make(<args>))

"------------------
"--- Navigation ---
"------------------

" Moving lines in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '>-2<CR>gv=gv

" helix-like mappings
nnoremap ge G
nnoremap gh 0
nnoremap gl $

" Closing compaction in insert mode
inoremap [ []<left>
inoremap < <><left>
inoremap ( ()<left>
inoremap { {}<left>
inoremap /* /**/<left><left>

" Visually select pasted or yanked text
nnoremap gV `[v`]

inoremap jj <Esc>
nnoremap <silent> - :Ex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>
nnoremap <silent> <leader>e :Lex <bar> :sil! /<C-R>=expand("%:t")<CR><CR>

xnoremap <C-c> <Plug>Commentary
nnoremap <C-c> <Plug>CommentaryLine

set timeoutlen=500
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<Space>'<CR>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual  ','<CR>

"-------------------------
"--- Fancy status line ---
"-------------------------

augroup customstatusline
    au!
    autocmd BufEnter * let b:git_branch = system("git branch --show-current 2>/dev/null")
augroup end

function! CurrentMode()
    return mode()[0] ==# 'i' ? 'INS' : mode()[0] ==# 'v' ? 'VIS' : 'NOR'
endfunction

function! GetPath(depth)
    let l:path = expand('%:p')
    let l:parts = split(l:path, '/')
    return len(l:parts) > a:depth ? join(l:parts[-a:depth:], '/') : l:path
endfunction

let &statusline = ' %{CurrentMode()} 〉 %{substitute(get(b:, "git_branch", ""), "\n$", "", "")} 〉%{GetPath(4)} %m %= %{&fileencoding} 〈 %{&filetype}〈 %p%%〈 %l:%v '
