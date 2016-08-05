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
    if IsOSX()
        exe 'silent !open % &'
        exe 'redraw!'
    endif
endf

nnoremap <leader>r :call RunMd()<cr>
call DoMap('nnore', 'r', ':call RunMd()<cr>')

set nowrap
