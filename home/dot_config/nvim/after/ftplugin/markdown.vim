function! s:MdPreview() abort
  let l:path = expand('%:p')
  if !empty($ZELLIJ)
    call system(['zellij', 'run', '--in-place', '--close-on-exit', '--', 'glow', '-p', l:path])
  else
    enew
    let l:buf = bufnr('%')
    call jobstart(['glow', '-p', l:path], {'term': v:true, 'on_exit': {j,d,e -> execute('silent! bwipeout! ' . l:buf)}})
    startinsert
  endif
endfunction

command! -buffer -bar MdPreview call s:MdPreview()
cnoreabbrev <buffer><expr> make getcmdtype() ==# ':' && getcmdline() ==# 'make' ? 'MdPreview' : 'make'
