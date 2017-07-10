" filetype config for .md file

setl smarttab
" setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

inoremap <buffer> · `
nmap <buffer> <cr> <Plug>Markdown_EditUrlUnderCursor

nnoremap <buffer> <localleader>t :Toc<cr>

nmap <buffer> <space>r <Plug>MarkdownPreview
