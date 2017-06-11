set cpo&vim

let g:plugex_log = 1
call plugex#begin(expand(g:config_home.'/.repo'))

" completion

" editing

" lang

" ui
PlugExGroup 'base_ui',
      \ ['mhinz/vim-startify', {'lazy': 0}],
      \ ['luochen1990/rainbow'],
      \ ['mhinz/vim-signify'],
      \ ['ryanoasis/vim-devicons', {'after': 'config#devicon#after', 'lazy': 1}],
      \ ['itchyny/lightline.vim', {'enable': !exists('g:gui_oni'), 'after': 'config#lightline#after', 'lazy': 1}],
      \ {'before': 'config#base_ui#before', 'after': 'config#base_ui#after', 'on_event': 'VimEnter'}

PlugExGroup 'theme',
      \ ['morhetz/gruvbox', {'lazy': 1}],
      \ ['sickill/vim-monokai', {'lazy': 1}],
      \ ['tomasr/molokai', {'lazy': 1}],
      \ {'after': 'config#theme#after'}

" other
PlugEx 'strom3xFeI/vimdoc-cn', {'on_event': 'VimEnter'}

call plugex#end()
