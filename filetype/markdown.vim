" filetype config for .md file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

inoremap · `

func! RunMd()
    if IsOSX()
        exe 'silent !open % &'
        exe 'redraw!'
    endif
endf

nnoremap <leader>r :call RunMd()<cr>
call DoMap('nnore', 'r', ':call RunMd()<cr>')

