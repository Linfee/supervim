" filetype config for .java file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=2
setl tabstop=2
setl softtabstop=2

setl nowrap

call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:!javac % && java %<<cr>')
