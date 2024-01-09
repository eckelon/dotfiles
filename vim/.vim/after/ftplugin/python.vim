set colorcolumn=80

setlocal wildignore+=**/venv/**,**/env/**

if g:lsp_auto_enable == 0

  compiler pylint
  command! -buffer -range=% Black let b:winview = winsaveview() |
    \ silent! execute <line1> . "," . <line2> . "!black -q - " |
    \ call winrestview(b:winview)

  augroup Formatonsave
    autocmd!
    autocmd BufWritePost <buffer> :Make
    autocmd BufWritePre <buffer> Black
  augroup END

  setlocal formatexpr=
  setlocal formatprg=black\ -q\ -

endif
nnoremap <leader>fun :-1read $HOME/.vim/snippets/python/function<CR>wviw
nnoremap <leader>lam :-1read $HOME/.vim/snippets/python/lambda<CR>d$j$p0flwviw
