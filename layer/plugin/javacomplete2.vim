" Layer: javacomplete2

LayerPlugin 'artur-shaik/vim-javacomplete2', {'for': 'java'}
LayerWhen 'executable("javac")'


fu! javacomplete2#after()

  let g:JavaComplete_UseFQN = 1
  let g:JavaComplete_ServerAutoShutdownTime = 300
  let g:JavaComplete_MavenRepositoryDisable = 0

  nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
  nnoremap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
  nnoremap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
  nnoremap <leader>jii <Plug>(JavaComplete-Imports-Add)

  inoremap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
  inoremap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
  inoremap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
  inoremap <C-j>ii <Plug>(JavaComplete-Imports-Add)

  nnoremap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  inoremap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  nnoremap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
  nnoremap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  nnoremap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  nnoremap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
  nnoremap <leader>jts <Plug>(JavaComplete-Generate-ToString)
  nnoremap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
  nnoremap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
  nnoremap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

  inoremap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
  inoremap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
  inoremap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  vnoremap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  vnoremap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  vnoremap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  nnoremap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
  nnoremap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)
endf
