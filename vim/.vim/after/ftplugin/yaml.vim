if g:lsp_auto_enable == 0

compiler yamllint

augroup YAMLquickfix
    autocmd!
    autocmd BufWritePost <buffer> :Make
augroup END
endif

