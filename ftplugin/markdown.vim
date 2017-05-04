" filetype config for .md file

setl smarttab
" setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

inoremap <buffer> · `

if layers#is_layer_loaded('markdown')
  nnoremap <buffer> <space>r :MarkdownPreview<cr>
en
