" let layer.plugins += ['vimwiki/vimwiki']
" make this work
let layer.plugins += [['vimwiki/vimwiki', {'on_ft': 'wiki',
      \ 'on_cmd': 'VimwikiTabIndex'
      \ }]]

fu! vimwiki#after()
  nnoremap <leader>v :VimwikiTabIndex<cr>
endf
