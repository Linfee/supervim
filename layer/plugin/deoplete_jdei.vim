LayerPlugin 'zchee/deoplete-jedi'

ConflicLayers 'ncm', 'jedi'

LayerWhen 'expand("%")=~".py"'

fu! deoplete_jdei#after()
  let g:deoplete#sources#jedi#show_docstring = 1
endf

