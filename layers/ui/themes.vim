" Supervim.layer
" themes

let layer.plugins += ['morhetz/gruvbox']
let layer.plugins += ['sickill/vim-monokai']
let layer.plugins += ['tomasr/molokai']

fu! themes#after()
  " gruvbox
  let g:gruvbox_italic = 1
  let g:gruvbox_contrast_dark = 'soft'
  let g:gruvbox_contrast_light = 'soft'
  " let g:gruvbox_hls_cursor = 'orange'
  " let g:gruvbox_italicize_string = 1
  set background=dark
endf
