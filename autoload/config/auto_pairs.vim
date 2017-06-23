fu! config#auto_pairs#before()
  let g:AutoPairs = {'(': ')', '[': ']', '{': '}', "'": "'",'"': '"', '`': '`'}
  let g:AutoPairsShortcutToggle = ''
  nnoremap <leader>ta :call AutoPairsToggle()<cr>
  if has('nvim')
    let g:AutoPairsShortcutFastWrap = '<a-a>'
  elseif g:is_osx
    let g:AutoPairsShortcutFastWrap = 'å'
  elseif g:is_linux && !g:is_gui
    let g:AutoPairsShortcutFastWrap = 'a'
  else
    let g:AutoPairsShortcutFastWrap = '<a-a>'
  endif
endf
