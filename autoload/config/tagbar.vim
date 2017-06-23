fu! config#tagbar#after()
  let g:tagbar_left=0
  let g:tagbar_width = 30
  let g:tagbar_zoomwidth = 0          " 缩放以使最长行可见
  let g:tagbar_show_visibility = 1    " 显示可见性
  if g:is_win
    let g:tagbar_iconchars = ['+', '-'] " 折叠字符
  else
    let g:tagbar_iconchars = ['▶', '▼'] " 折叠字符
  endif
endf
