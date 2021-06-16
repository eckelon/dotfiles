com! FormatHTML %!tidy --indent auto --indent-spaces 4 --wrap 200 --quiet yes --show-body-only auto --show-errors 0 --tidy-mark no --fix-uri no --drop-empty-elements no
com! FormatJS   %!js-beautify --indent-size=4
" com! FormatJSON %!python -m json.tool
com! ToggleCssColor :call css_color#toggle()

com! FormatWordpress :silent! %s/^$\n//g | silent! %s/^\(<h[2345]\)/\r\r\1/ | silent! %s/\(href="[^"]*\) "/\1"/g | silent! %s/<p>\n<\/p>//g | silent! %s/<p>\n<\/p>//g | silent! %s/<li>\n<\/li>//g | silent! %s/<a \(href="[^"]*sysdig.com\)/<a target="_blank" \1/g | silent! %s/<a \(href="\)/<a rel="noopener nofollow noreferrer" target="_blank" \1/g

com! FormatMarketo :silent! %s/^$\n//g | silent! %s/^\(<h[23]\)/\r\r\1/ | silent! %s/\(href="[^"]*\) "/\1"/g | silent! %s/<p>\n<\/p>//g | silent! %s/<p>\n<\/p>//g | silent! %s/<li>\n<\/li>//g | silent! %s/h2>/h1>/g | silent! %s/h3>/h2>/g | silent! %s/^<h1>/<h1 style="font-size: 30px !important; line-height: 100% !important; font-family: Lato, Helvetica, Arial; color: #253746; font-weight: normal!important;">/ | silent! %s/^<h2>/<h2 style="font-size: 21px !important; line-height: 100% !important; color: #253746;">/ | silent! %s/<a /<a style="text-decoration: none!important; color: #00b4c8!important;" /g

command! -bang -nargs=* FindUnderCursor
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

