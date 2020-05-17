" filetype config for .html file

if &ft == 'markdown'
  finish
en
setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

if g:is_osx
  nnoremap <buffer> <space>r :w<cr>:silent !open % &<cr>:redraw!<cr>
endif
