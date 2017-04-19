LayerPlugin 'morhetz/gruvbox'

fu! gruvbox#after()
  " gruvbox
  let g:gruvbox_italic = 1
  let g:gruvbox_contrast_dark = 'soft'
  let g:gruvbox_contrast_light = 'soft'
  " let g:gruvbox_hls_cursor = 'orange'
  " let g:gruvbox_italicize_string = 1
  colorscheme gruvbox
  set background=dark

endf
