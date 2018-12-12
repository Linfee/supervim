fu! config#ultisnips#after()
  " snippets files
  let g:UltiSnipsSnippetsDir=expand('~/.vim/ultisnips')
  let g:UltiSnipsSnippetDirectories=['ultisnips']
  " Trigger configuration.
  let g:UltiSnipsExpandTrigger='<tab>'
  " let g:UltiSnipsListSnippets='<c-tab>'
  let g:UltiSnipsJumpForwardTrigger='<c-j>'
  let g:UltiSnipsJumpBackwardTrigger='<c-k>'
  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit='vertical'

  let g:UltiSnipsRemoveSelectModeMappings = 0

  nnoremap <leader>ua :UltiSnipsAddFiletypes<space>

  inoremap <silent> <tab> <c-r>=UltiSnips#ExpandSnippetOrJump()<cr>
  inoremap <silent> <s-tab> <c-r>=UltiSnips#JumpBackwards()<cr>

  inoremap <c-x><c-k> <c-x><c-k>
endf
