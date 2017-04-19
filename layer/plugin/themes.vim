" Supervim.layer
" themes

LayerPlugin 'morhetz/gruvbox'
LayerPlugin 'sickill/vim-monokai'
LayerPlugin 'tomasr/molokai'

fu! themes#after()
  " gruvbox
  let g:gruvbox_italic = 1
  let g:gruvbox_contrast_dark = 'soft'
  let g:gruvbox_contrast_light = 'soft'
  " let g:gruvbox_hls_cursor = 'orange'
  " let g:gruvbox_italicize_string = 1
  set background=dark
endf
