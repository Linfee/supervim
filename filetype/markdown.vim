" filetype config for .md file
let g:ftconfigloaded = 1

set smarttab
set expandtab
set autoindent
let &shiftwidth=4
let &tabstop=4
let &softtabstop=4

inoremap · `

func! RunMd()
    exe 'silent !open % &'
    exe 'redraw!'
endf

call DoMap('nnore', 'r', ':call RunMd()<cr>')
