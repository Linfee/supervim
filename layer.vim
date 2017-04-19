" base
UseLayer 'betterdefault'
UseLayer 'key'
UseLayer 'keymap'
UseLayer 'editing'
" UseLayer 'base_ui'
" UseLayer 'statusline'

" plugin
UseLayer 'simple_ui'
UseLayer 'lightline'
UseLayer 'utils'

if has('nvim')
" UseLayer 'ncm'
UseLayer 'deoplete'
el
  UseLayer 'neocomplete'
en

UseLayer 'syntastic'
UseLayer 'markdown'
UseLayer 'front_end'
