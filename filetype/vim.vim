" filetype config for .vim file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

" 执行默认缓冲区内容
call DoMap('nnore', 'e', ':@*<cr>')

