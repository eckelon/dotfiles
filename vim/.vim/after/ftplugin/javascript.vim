if g:lsp_auto_enable == 0
  compiler eslint
  setlocal formatexpr=
  setlocal formatprg=prettier\ --log-level\ silent\ --stdin-filepath\ %
  setlocal omnifunc=javascriptcomplete#CompleteJS
  let format_auto = 1

  command! -buffer -range=% Prettier if g:format_auto == 1 | let b:winview = winsaveview() | silent! execute <line1> . "," . <line2> . "!prettier --log-level silent --stdin-filepath %" | call winrestview(b:winview) | endif

  augroup Formatonsave
    autocmd!
    autocmd BufWritePre <buffer> Prettier
  augroup END
endif
