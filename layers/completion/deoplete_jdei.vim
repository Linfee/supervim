let layer.conflic = 'ncm'
let layer.plugins += [['zchee/deoplete-jedi', {'on_event': 'InsertEnter', 'on_if': '&ft=="python"'}]]

fu! deoplete_jdei#after()
  let g:deoplete#sources#jedi#show_docstring = 1
endf

