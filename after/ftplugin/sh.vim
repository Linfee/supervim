" filetype config for .sh file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2
setl textwidth=80
setl nospell


setl nowrap

nnoremap <buffer> <space>r :w<cr>:!chmod u+x % && ./%<cr>
