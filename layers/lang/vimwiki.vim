" let layer.plugins += ['vimwiki/vimwiki']
" make this work
let layer.plugins += [['vimwiki/vimwiki', {'on_ft': 'vimwiki',
      \ 'on_map': [
      \ '<Plug>VimwikiIndex',
      \ '<Plug>VimwikiTabIndex',
      \ '<Plug>VimwikiUISelect',
      \ '<Plug>VimwikiDiaryIndex',
      \ '<Plug>VimwikiMakeDiaryNote',
      \ '<Plug>VimwikiTabMakeDiaryNote',
      \ '<plug>VimwikiMakeYesterdayDiaryNote',
      \ ]}]]

fu! vimwiki#after()
  nmap <Leader>ww <Plug>VimwikiIndex
  nmap <Leader>wt <Plug>VimwikiTabIndex
  nmap <Leader>ws <Plug>VimwikiUISelect
  nmap <Leader>wi <Plug>VimwikiDiaryIndex
  nmap <Leader>w<leader>w <Plug>VimwikiMakeDiaryNote
  nmap <Leader>w<leader>t <Plug>VimwikiTabMakeDiaryNote
  nmap <Leader>d<leader>y <Plug>VimwikiMakeYesterdayDiaryNote
endf

