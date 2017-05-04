let layer.conflic = 'ncm'
let layer.condition = 'expand("%")=~".py"'
let layer.plugins += [['zchee/deoplete-jedi', {'on_event': 'InsertEnter'}]]

fu! deoplete_jdei#after()
  let g:deoplete#sources#jedi#show_docstring = 1
endf

