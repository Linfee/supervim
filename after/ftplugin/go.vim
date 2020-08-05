" filetype config for .go file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

nnoremap <buffer> <space>r :w<cr>:GoRun<cr><esc>
nnoremap <buffer> <space>= :GoFmt<cr>
nnoremap <buffer> <space>u :GoTestFun -v<cr>
