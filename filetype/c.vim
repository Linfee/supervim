" filetype config for .c file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

" 运行
call DoMap('nnore', 'r', ':w<cr>:!gcc % -o %< && ./%<<cr>', ['<buffer>'])

" 调试
nnoremap <buffer> <F8> :w<cr>:!g++ % -g -o %< && gdb ./%<<cr>
