" filetype config for .scala file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

iabbrev <buffer> scsh #!/bin/sh<cr>exec scala "$0<right> "$@<right><cr>!#<cr><cr>
iabbrev <buffer> sisr scala.io.StdIn.readLine("")<left>
