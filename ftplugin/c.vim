" filetype config for .c file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

" 运行
nnoremap <buffer> <leader>r :w<cr>:!gcc % -o %< && ./%<<cr>

" 调试
nnoremap <buffer> <F8> :w<cr>:!g++ % -g -o %< && gdb ./%<<cr>
