if g:lsp_auto_enable == 0
  command! -buffer -range=% Gofmt let b:winview = winsaveview() |
    \ silent! execute <line1> . "," . <line2> . "!gofmt " |
    \ call winrestview(b:winview)

  compiler go

  setlocal formatexpr=
  setlocal formatprg=gofmt\ %


  augroup Formatonsave
    autocmd!
    autocmd BufWritePre <buffer> Gofmt
    autocmd BufWritePost <buffer> :Make
  augroup END
endif
