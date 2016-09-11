" filetype config for .java file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

func! RunJava()
    exec "w"
    exec "!javac % && java %<"
endf

call DoMap('nnore', 'r', ':call RunJava()<cr>', ['<buffer>'])
