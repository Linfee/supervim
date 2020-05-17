" filetype config for .go file

setl smarttab
setl tabstop=2
setl softtabstop=2
setl shiftwidth=2
setl textwidth=79
setl expandtab
setl autoindent
setl fileformat=unix
setl nowrap

nnoremap <buffer> <space>r :w<cr>:!lua ./%<cr>
