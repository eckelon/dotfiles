set encoding=UTF-8
set completeopt-=noselect

let s:uname = system("uname -s")
if s:uname == "Darwin"
  let g:clipboard = {
        \ 'name': 'pbcopy',
        \ 'copy': {
        \    '+': 'pbcopy',
        \    '*': 'pbcopy',
        \  },
        \ 'paste': {
        \    '+': 'pbpaste',
        \    '*': 'pbpaste',
        \ },
        \ 'cache_enabled': 0,
        \ }
endif
set clipboard=unnamed
set gcr=a:blinkon0              "Disable cursor blink
set hlsearch
set mouse=a
set nobackup
set nowritebackup
set noswapfile
set backspace=indent,eol,start
set hidden
set cpt-=t "don't scan ctags

"indentation
set autoindent
set cindent
set smartindent

set noerrorbells visualbell t_vb=
set splitright
set nowb
set number
" set relativenumber
set numberwidth=4
:set ruler
set statusline+=%#warningmsg#
set statusline+=%*
set wildignore+=*.pyc,node_modules,*.egg-info,*/*session.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*/dist/*
set wildignore+=*.rar,*.war,*/target/*
set wildignore+=**/*/node_modules/**/*,.bloop/*
set path+=**
set wildmenu
set ttyfast
set lazyredraw
set updatetime=300
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

set ignorecase " Ignore case when searching
set smartcase  " When searching try to be smart about cases
set incsearch  " Jumping search

"quickfix window to open after any grep invocation
autocmd QuickFixCmdPost *grep* cwindow

autocmd FileType c,cpp,cs,java,jade,javascript   setlocal commentstring=//\ %s
autocmd FileType desktop              setlocal commentstring=#\ %s
autocmd FileType sql                  setlocal commentstring=--\ %s
autocmd FileType xdefaults            setlocal commentstring=!%s
autocmd FileType git,gitcommit        setlocal foldmethod=syntax foldlevel=1

let g:rg_command = '
      \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
      \ -g "*.{js,php,phtml,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
      \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist,setup,pub,dev,lib,.history,bower_components}/*" '

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

set conceallevel=0
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0

"save on focus lost https://vim.fandom.com/wiki/Auto_save_files_when_focus_is_lost
au FocusLost * silent! wa

" folding
" zc?????????close the fold (where your cursor is positioned)
" zM ???close all folds on current buffer
" zo?????????open the fold (where your cursor is positioned)
" zR?????????open all folds on current buffer
" zj?????????cursor is moved to next fold
" zk?????????cursor is moved to previous fold
set foldmethod=syntax "syntax highlighting items specify folds
set foldcolumn=1 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened<Paste>


if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
endif

set inccommand=split

"svelte
let g:vim_svelte_plugin_use_sass = 1
let g:vim_vue_plugin_use_sass = 1

"dirvish
let g:dirvish_mode = ':sort ,^.*[\/],'
"vue
let g:vue_pre_processors = 'detect_on_enter'

" automatically leave insert mode after 'updatetime' milliseconds of inaction
au CursorHoldI * stopinsert
" set 'updatetime' to 10s when in insert mode
au InsertEnter * let updaterestore=&updatetime | set updatetime=10000
au InsertLeave * let &updatetime=updaterestore

let g:vimwiki_list = [{'path': '~/NextCloud/Notes',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:goyo_width = 120

"Vim Autoformat
let g:formatdef_rustfmt = '"rustfmt"'
let g:formatters_rust = ['rustfmt']
au BufWrite *.rs :Autoformat
