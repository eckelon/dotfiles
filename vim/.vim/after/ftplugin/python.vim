set shiftwidth=4 tabstop=4 softtabstop=4 autoindent smartindent
set colorcolumn=80
compiler python
setlocal path=.,**
setlocal wildignore+=*/node_modules/*
setlocal wildignore+=*/__pycache__/*
setlocal include=^\\s*\\(from\\\|import\\)\\s*\\zs\\(\\S\\+\\s\\{-}\\)*\\ze\\($\\\|\ as\\)
setlocal define=^\\s*\\\\(def\\\|class\\)\\>
setlocal includeexpr=PyInclude(v:fname)
setlocal formatprg=black\ -q\ -
setlocal equalprg=black\ -q\ %

command! -bar Foo silent nor *n:ij^r/<CR>

command! -bar Runlinter silent make %:p | redraw!
autocmd BufWritePost * Runlinter
function! ToggleDiagnostics()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        cw 5
    else
        cclose
    endif
endfunction
nmap <leader>d :call ToggleDiagnostics()<CR>

function! PyInclude(fname)
  let parts = split(a:fname, ' import ')
  let l = parts[0]
  if len(parts) > 1
	let r = parts[1]
	let joined = join([l, r], '.')
	let fp = substitute(joined, '\.', '/', 'g') . '.py'
	let found = glob(fp, 1)
	if len(found)
	  return found
	endif
	endif
  return substitute(l, '\.', '/', 'g') . '.py'
endfunction
