LayerSubLayers 'betterdefault', 'key', 'keymap', 'editing'

" LayerSubLayers 'base_ui'

LayerSubLayers 'simple_ui'

if !IsWinUnix()
  LayerSubLayers 'lightline'
el
  LayerSubLayers 'statusline'
en

LayerSubLayers 'devicon'

if has('nvim')
  " LayerSubLayers 'ncm'
  LayerSubLayers 'deoplete'
el
  LayerSubLayers 'neocomplete'
en

LayerSubLayers 'utils', 'syntastic', 'markdown', 'front_end'

" extension
LayerSubLayers 'translate'

