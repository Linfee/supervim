" base
UseLayer 'betterdefault'
UseLayer 'key'
UseLayer 'keymap'
UseLayer 'editing'

" UseLayer 'base_ui'
" UseLayer 'statusline'

" plugin
UseLayer 'simple_ui'
if !IsWinUnix()
  UseLayer 'lightline'
en
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
