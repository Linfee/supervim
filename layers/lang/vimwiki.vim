" let layer.plugins += ['vimwiki/vimwiki']
" make this work
let layer.plugins += [['vimwiki/vimwiki', {'for': 'wiki',
      \ 'on': 'VimwikiTabIndex'
      \ }]]

fu! vimwiki#after()
  nnoremap <leader>v :VimwikiTabIndex<cr>
endf
