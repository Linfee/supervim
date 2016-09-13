" filetype config for .html file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

if IsOSX()
    call DoMap('nnore', 'r', ':w<cr>:silent !open % &<cr>:redraw!<cr>', ['<buffer>'])
endif
