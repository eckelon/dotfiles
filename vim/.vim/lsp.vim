let g:lsp_auto_enable = 1

"--------------------------
"------- LSP Config -------
"--------------------------

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=number
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> <leader>d <plug>(lsp-document-diagnostics)
    nmap <buffer> <leader>r <plug>(lsp-rename)
    nmap <buffer> <leader>k <plug>(lsp-hover)
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> <leader>] <plug>(lsp-next-diagnostic)
    nmap <buffer> <leader>[ <plug>(lsp-previous-diagnostic)
    nmap <buffer> <leader>cd <plug>(lsp-preview-close)
    autocmd! BufWritePre *.py,*.go,*.ts,*.js call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

"lsp settings
let g:lsp_diagnostics_virtual_text_align = "after"
let g:lsp_diagnostics_virtual_text_padding_left = 5
let g:lsp_diagnostics_virtual_text_wrap = "truncate"
let g:lsp_document_code_action_signs_hint = {'text': ''}
let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_format_sync_timeout = 1000

" " nicer colors for the messages
hi LspErrorHighlight cterm=none
hi LspErrorVirtualText ctermfg=red cterm=italic gui=italic guifg=red
hi LspWarningHighlight cterm=underline gui=undercurl
hi LspWarningVirtualText ctermfg=yellow cterm=italic gui=italic guifg=yellow
hi link LspErrorText SignColumn
hi link LspWarningText SignColumn
" hi Comment cterm=italic gui=italic

let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"----------------------------------------
" if LSP is disabled, I'll rely on
" custom completion and makeprg/formatprg
"----------------------------------------


if g:lsp_auto_enable == 1
  packadd! vim-lsp-settings
  packadd! asyncomplete.vim
  packadd! asyncomplete-lsp.vim
else

  " Set the function as the completefunc use with <c-x><c-u>
  set completefunc=CustomCompleteFunc
  setlocal omnifunc=syntaxcomplete#Complete
  inoremap <NUL> <c-x><c-o>
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

  "------- Completion -------

  function! CustomCompleteFunc(findstart, base)
      if a:findstart
          let line = getline('.')
          let start = col('.') - 1
          while start > 0 && line[start - 1] =~ '\w'
              let start -= 1
          endwhile
          return start
      else
          let l:matches = []
          let l:command = &grepprg . ' ' . shellescape(a:base)
          let l:grep_results = split(system(l:command), "\n")
          for result in l:grep_results
              let l:word = matchstr(result, a:base . '\w*')
              if l:word != ''
                  call add(l:matches, l:word)
              endif
          endfor
          let l:unique_matches = {}
          for item in l:matches
              let l:unique_matches[item] = 1
          endfor
          return sort(keys(l:unique_matches))
      endif
  endfunction

  "https://gist.github.com/romainl/ce55ce6fdc1659c5fbc0f4224fd6ad29
  function! QF_signs() abort
  	" define the signs used by quickfix
  	call sign_define('QFError',{'text':'🚩','texthl':'NONE','linehl':'NONE'})
  	call sign_define('QFWarning',{'text':'󰈻','texthl':'NONE','linehl':'NONE'})
  	call sign_define('QFInfo',{'text':'🔎','texthl':'NONE','linehl':'NONE'})
  	" remove any existing signs
  	call sign_unplace('*')
  	" get the quickfix list
  	let s:qfl = getqflist()
  	" loop over quickfix list to place signs
  	for item in s:qfl
  		if match(item.text, '\cerror') >= 0
  			call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
  		elseif match(item.text, '\cwarning') >= 0
  			call sign_place(0, '', 'QFWarning', item.bufnr, {'lnum': item.lnum})
  		else
  			call sign_place(0, '', 'QFInfo', item.bufnr, {'lnum': item.lnum})
  		endif
  	endfor
  endfunction

  augroup quickfix
  	autocmd!
  	"autocmd QuickFixCmdPost [^l]* cwindow | call QF_signs()
  	autocmd QuickFixCmdPost [^l]* call QF_signs()
  	autocmd QuickFixCmdPost l* lwindow | call QF_signs()
  augroup END

  " Clear quickfix list and remove signs
  command! Cclear cexpr [] | sign unplace * group=*
endif
