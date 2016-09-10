" filetype config for .md file
let g:ftconfigloaded = 1

setl smarttab
" setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

inoremap · `

func! RunMd()
    exe 'MarkdownPreview'
endf

call DoMap('nnore', 'r', ':call RunMd()<cr>', ['<buffer>'])
