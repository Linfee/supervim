" filetype config for .md file

setl smarttab
" setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

inoremap <buffer> · `
nmap <buffer> <cr> <Plug>Markdown_EditUrlUnderCursor

nnoremap <buffer> <localleader>t :Toc<cr>

nmap <buffer> <space>r <Plug>MarkdownPreview
