"setlocal shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent
setlocal colorcolumn=80
setlocal path=,..
set wildmenu
setlocal wildignore+=*/node_modules/*
setlocal wildignore+=*/__pycache__/*

let b:ale_linters = ['flake8', 'pylsp']
let b:ale_fixers = ['black', 'isort', 'autoimport', 'ruff']
let g:ale_python_auto_virtualenv = 1
packadd vim-mucomplete
packadd ale
packadd vim-poliglot
packadd vim-commentary

nnoremap <leader>fun :-1read $HOME/.vim/snippets/python/function<CR>wviw
nnoremap <leader>lam :-1read $HOME/.vim/snippets/python/lambda<CR>d$j$p0flwviw

" handy if not using ALE or similar
"command! -bar Runlinter silent make %:p | redraw!
"function! ToggleDiagnostics()
"    if empty(filter(getwininfo(), 'v:val.quickfix'))
"        cw 5
"    else
"        cclose
"    endif
"endfunction
"nmap <leader>d :call ToggleDiagno:stics()<CR>

