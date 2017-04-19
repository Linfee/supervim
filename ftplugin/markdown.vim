" filetype config for .md file

setl smarttab
" setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

inoremap <buffer> · `

if layer#is_layer_loaded('markdown')
  nnoremap <buffer> <leader>r :MarkdownPreview<cr>
en
