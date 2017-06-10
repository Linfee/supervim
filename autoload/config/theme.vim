fu! config#theme#after()
  set background=dark

  " for themes
  if g:is_win_unix
    colorscheme monokai
  else
    " gruvbox
    let g:gruvbox_italic = 1
    let g:gruvbox_contrast_dark = 'soft'
    let g:gruvbox_contrast_light = 'soft'
    " let g:gruvbox_hls_cursor = 'orange'
    " let g:gruvbox_italicize_string = 1
    colorscheme gruvbox
  en
endf
