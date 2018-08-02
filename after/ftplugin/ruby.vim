" filetype config for .rb file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl ff=unix

nnoremap <buffer> <space>r :w<cr>:!ruby %<cr>
