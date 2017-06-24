" filetype config for .rb file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl ff=unix

if g:is_win || g:is_win_unix
  nnoremap <buffer> <space>r :w<cr>:!ruby %<cr>
else
  nnoremap <buffer> <space>r :w<cr>:!echo "\033[0;32m____________________\033[0m"<cr>:!ruby %<cr>
endif
