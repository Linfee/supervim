fu! config#nerdtree#before()
  let g:NERDTreeDirArrowExpandable = '+'
  let g:NERDTreeDirArrowCollapsible = '-'
  let g:NERDTreeWinPos = "left"
  let g:NERDTreeWinSize = "35"
  let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
  let NERDTreeShowBookmarks=1
  let NERDTreeChDirMode=0
  let NERDTreeMouseMode=2
  let NERDTreeShowHidden=1
  let NERDTreeKeepTreeInNewTab=1
  " 多个tab的nerdtree同步
  let g:nerdtree_tabs_synchronize_view = 1

  " Automatically find and select currently opened file in NERDTree
  let g:nerdtree_tabs_open_on_console_startup=0
  let g:nerdtree_tabs_open_on_gui_startup=0
  let g:nerdtree_tabs_open_on_new_tab=1

  if g:is_win
    let g:NERDTreeIndicatorMapCustom = {
          \ "Modified"  : "M",
          \ "Staged"    : "S",
          \ "Untracked" : "U",
          \ "Renamed"   : "R",
          \ "Unmerged"  : "u",
          \ "Deleted"   : "X",
          \ "Dirty"     : "D",
          \ "Clean"     : "C",
          \ "Unknown"   : "?"
          \ }
  else
    let g:NERDTreeIndicatorMapCustom = {
          \ "Modified"  : "✹",
          \ "Staged"    : "✚",
          \ "Untracked" : "✭",
          \ "Renamed"   : "➜",
          \ "Unmerged"  : "═",
          \ "Deleted"   : "✖",
          \ "Dirty"     : "✗",
          \ "Clean"     : "✔︎",
          \ "Unknown"   : "?"
          \ }
  endif
endf


" use ctrlsf in nerdtree menu
fu! config#nerdtree#after()
  call NERDTreeAddMenuItem({
        \ 'text': '(s)earch files.',
        \ 'shortcut': 's',
        \ 'callback': 'NERDTreeAck' })

  fu! NERDTreeAck()
    " get the current dir from NERDTree
    let l:cd = g:NERDTreeDirNode.GetSelected().path.str()
    " get the pattern
    let pattern = input("Enter the pattern: ")
    if pattern == ''
      echo 'Maybe another time...'
      return
    endif
    let l:ctrlsf_open_left = g:ctrlsf_open_left
    let g:ctrlsf_open_left = 0
    exe "CtrlSF '".pattern."' '".l:cd."'"
    let g:ctrlsf_open_left = l:ctrlsf_open_left
  endf
endf
