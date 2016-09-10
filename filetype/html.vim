" filetype config for .html file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

func! RunHtml()
    if IsOSX()
        exe 'silent !open % &'
        exe 'redraw!'
    endif
endf

call DoMap('nnore', 'r', ':call RunHtml()<cr>', ['<buffer>'])
