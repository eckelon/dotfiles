colorscheme material

set noshowmode
set termguicolors

" fix italics inside tmux
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

let g:material_terminal_italics = 1
let g:material_theme_style = 'palenight'
let g:lightline = {
            \ 'colorscheme': 'material_vim',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head'
            \ },
            \ 'tabline': {
            \   'left': [ ['buffers'] ],
            \   'right': [ [''] ]
            \ },
            \ 'component_expand': {
            \   'buffers': 'lightline#bufferline#buffers'
            \ },
            \ 'component_type': {
            \   'buffers': 'tabsel'
            \ }
            \ }

let g:lightline#bufferline#clickable = 1
let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#show_number  = 1
set showtabline=2

" let g:Illuminate_highlightUnderCursor = 0
let g:Illuminate_ftwhitelist = ['vim', 'sh', 'javascript', 'vue', 'css', 'scss', 'pcss']
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedWord guibg=#676E95 guifg=#ffffff
augroup END

if has("autocmd")
    " Highlight TODO, FIXME, NOTE, etc.
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
endif
