" theme config
fu! config#theme#after()
  try
    set background=dark
    " for themes
    if g:is_win_unix
      colorscheme monokai
    else
      " for gruvbox
      let g:gruvbox_italic = 1
      let g:gruvbox_contrast_dark = 'medium'
      let g:gruvbox_contrast_light = 'medium'
      " let g:gruvbox_hls_cursor = 'purple'
      " let g:gruvbox_italicize_string = 1
      colorscheme gruvbox
    en
  catch
  endtry
endf
