
set splitright
command! -nargs=* Test vsplit | terminal npm t
command! -nargs=* TestCurrent vsplit | terminal npx lab % --reporter console --assert @hapi/code --coverage --verbose
