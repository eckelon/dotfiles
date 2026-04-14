setlocal makeprg=jq\ .\ %\ 2>\&1\ \\\|\ sed\ 's/^/%:/'
setlocal errorformat=%f:jq:\ parse\ error:\ %m\ at\ line\ %l\\,\ column\ %c

setlocal formatprg=jq
