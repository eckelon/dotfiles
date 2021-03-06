let mapleader=","

xmap <leader>c<space> <Plug>Commentary
nmap <leader>c<space> <Plug>Commentary
omap <leader>c<space> <Plug>Commentary
nmap <leader>c<space> <Plug>CommentaryLine

nmap <leader>x <Plug>VimwikiToggleListItem

" I don't want to yank deleted lines when I'm replacing text in visual mode
vnoremap p "_dP

cmap w!! w !sudo tee % >/dev/null
imap jj <Esc>
nnoremap <silent><leader>, :Files<cr>

function! s:ToggleBlame()
    if &l:filetype ==# 'fugitiveblame'
        close
    else
        Gblame
    endif
endfunction

nnoremap gb :call <SID>ToggleBlame()<CR>
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

nnoremap ; :
nmap bn :bn<CR>
nmap bp :bp<CR>
nmap bd :bd<CR>
