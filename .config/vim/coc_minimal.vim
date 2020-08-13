" ============================================================================
" CoC
" ============================================================================

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current line.
nnoremap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nnoremap <leader>qf  <Plug>(coc-fix-current)
"	imap <C-j> <Plug>(coc-snippets-expand-jump)

command! SortImports call CocAction('runCommand', 'editor.action.organizeImport')
