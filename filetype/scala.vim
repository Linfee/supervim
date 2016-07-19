" filetype config for .scala file
let g:ftconfigloaded = 1

set smarttab
set expandtab
set autoindent
let &shiftwidth=2
let &tabstop=2
let &softtabstop=2

iabbrev <buffer> scsh #!/bin/sh<cr>exec scala "$0<right> "$@<right><cr>!#<cr><cr>
iabbrev <buffer> sisr scala.io.StdIn.readLine("")<left>
