fu! config#vim_multiple_cursors#after()
  let g:multi_cursor_next_key='<C-n>'
  let g:multi_cursor_prev_key='<C-p>'
  let g:multi_cursor_skip_key='<C-k>'
  let g:multi_cursor_quit_key='<c-[>'
  " 多光标时禁用补全插件
  " Called once right before you start selecting multiple cursors
  fu! Multiple_cursors_before()
    if exists(':NeoCompleteLock')==2
      exe 'NeoCompleteLock'
    endif
    let g:deoplete#disable_auto_complete = 1
  endf
  " Called once only when the multiple selection is canceled (default <Esc>)
  fu! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock')==2
      exe 'NeoCompleteUnlock'
    endif
    let g:deoplete#disable_auto_complete = 0
  endf
  " 多光标高亮样式 (see help :highlight and help :highlight-link)
  " highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
  " highlight link multiple_cursors_visual Visual
endf
