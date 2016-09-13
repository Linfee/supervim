" filetype config for .java file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

call DoMap('nnore', 'r', ':w<cr>:!javac % && java %<<cr>', ['<buffer>'])
