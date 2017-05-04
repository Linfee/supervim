" Layer: snippet

let layer.plugins += [['SirVer/ultisnips',
      \ {'on_event': 'InsertEnter', 'after': 'snippet#ultisnip_after'}]]
let layer.plugins += [['honza/vim-snippets', {'on_event': 'InsertEnter'}]]
let layer.plugins += ['Linfee/ultisnips-zh-doc']

fu! snippet#ultisnip_after()
  " snippets files
  let g:UltiSnipsSnippetsDir=expand('~/.vim/ultisnips')
  let g:UltiSnipsSnippetDirectories=["ultisnips"]
  " Trigger configuration.
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsListSnippets="<c-tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"

  nnoremap <leader>ua :UltiSnipsAddFiletypes<space>

  if &ft == 'snippets'
    set ft=snippets
  endif
endf
