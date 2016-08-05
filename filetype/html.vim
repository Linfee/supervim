" filetype config for .html file
let g:ftconfigloaded = 1

set smarttab
set expandtab
set autoindent
let &shiftwidth=2
let &tabstop=2
let &softtabstop=2

func! RunHtml()
    if IsOSX()
        exe 'silent !open % &'
        exe 'redraw!'
    endif
endf

nnoremap <leader>r :call RunHtml()<cr>
call DoMap('nnore', 'r', ':call RunHtml()<cr>')
