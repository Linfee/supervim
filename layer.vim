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
el
  UseLayer 'statusline'
en
UseLayer 'devicon'

if has('nvim')
  " UseLayer 'ncm'
  UseLayer 'deoplete'
el
  UseLayer 'neocomplete'
en

UseLayer 'utils'
UseLayer 'syntastic'
UseLayer 'markdown'
UseLayer 'front_end'
