setlocal shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent
setlocal colorcolumn=80
setlocal path=,..
setlocal wildignore+=*/node_modules/*
setlocal wildignore+=*/__pycache__/*
setlocal include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
setlocal define=^\\s*\\\\(def\\\|class\\)\\>
setlocal includeexpr=PyInclude(v:fname)
setlocal omnifunc=ale#completion#OmniFunc
setlocal completeopt+=noinsert

let g:mucomplete#enable_auto_at_startup = 1
let b:ale_linters = ['flake8', 'pylsp']
let b:ale_fixers = ['black', 'isort', 'autoimport', 'ruff']
let b:ale_warn_about_trailing_whitespace = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1

nmap gd :ALEGoToDefinition<CR>
nmap gD :ALEGoToImplementation<CR>
nmap gT :ALEGoToTypeDefinition<CR>
nmap gr :ALEFindReferences<CR>
nmap <leader>r :ALERename<CR>

xmap <c-c>  <Plug>Commentary
nmap <c-c> <Plug>CommentaryLine

command! -bar Runlinter silent make %:p | redraw!
function! ToggleDiagnostics()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        cw 5
    else
        cclose
    endif
endfunction
nmap <leader>d :call ToggleDiagnostics()<CR>
packadd vim-mucomplete
packadd ale
packadd vim-commentary

