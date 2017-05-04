let layer.sub_layers = ['betterdefault', 'key', 'keymap', 'editing']
let layer.sub_layers += ['default_ui']
if has('nvim')
  let layer.sub_layers += ['deoplete']
else
  let layer.sub_layers += ['neocomplete']
endif
let layer.sub_layers += ['utils', 'syntastic', 'markdown', 'front_end']

let layer.sub_layers += ['translate']
let layer.sub_layers += ['backup']
