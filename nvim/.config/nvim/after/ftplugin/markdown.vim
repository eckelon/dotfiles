let s:css_file = stdpath('config') .. '/pandoc-preview.html'
let &l:makeprg = 'pandoc %:S -s -H ' .. s:css_file .. ' -o /tmp/preview.html && open /tmp/preview.html'
