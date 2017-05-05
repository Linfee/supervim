let layer.sub_layers = ['betterdefault', 'key', 'keymap', 'editing']
let layer.sub_layers += ['default_ui']
if has('nvim')
  let layer.sub_layers += ['deoplete']
else
  let layer.sub_layers += ['neocomplete']
endif
" tools
let layer.sub_layers += ['utils',]
" lang
let layer.sub_layers += ['vimwiki', 'markdown', 'front_end']
" syntax check
let layer.sub_layers += ['syntastic']
" extension
let layer.sub_layers += ['translate']
let layer.sub_layers += ['backup']
