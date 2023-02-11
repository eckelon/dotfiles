setlocal omnifunc=ale#completion#OmniFunc
setlocal completeopt+=noinsert

let b:ale_linters = ['analyzer']
let b:ale_fixers = ['rustfmt']

packadd vim-mucomplete
packadd ale
packadd vim-poliglot
packadd vim-commentary
