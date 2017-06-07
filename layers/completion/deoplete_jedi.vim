let layer.conflic = 'ncm'
let layer.plugins += [['zchee/deoplete-jedi', {'on_event': 'InsertEnter if &ft=="python"'}]]

fu! deoplete_jedi#after()
  let g:deoplete#sources#jedi#show_docstring = 1
endf

