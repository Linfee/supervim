fu! config#nerdtree#before()

  if !g:is_osx
    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
  else
    let g:NERDTreeDirArrowExpandable = emoji#for('file_folder')
    let g:NERDTreeDirArrowCollapsible = emoji#for('open_file_folder')
  endif

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

  if g:no_nerd_font
    let g:NERDTreeGitStatusIndicatorMapCustom = {
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
    if !g:is_osx
      let g:NERDTreeGitStatusIndicatorMapCustom = {
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
    else
      let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ "Modified"  : emoji#for('small_orange_diamond'),
            \ "Staged"    : emoji#for('white_check_mark'),
            \ "Untracked" : emoji#for('small_blue_diamond'),
            \ "Renamed"   : emoji#for('arrows_counterclockwise'),
            \ "Unmerged"  : emoji#for('collision'),
            \ "Deleted"   : emoji#for('heavy_multiplication_x'),
            \ "Dirty"     : emoji#for('zap'),
            \ "Clean"     : emoji#for('ok'),
            \ "Unknown"   : emoji#for('grey_question')
            \ }
    endif
  endif
endf


fu! config#nerdtree#after()
  " use ctrlsf in nerdtree menu
  call NERDTreeAddMenuItem({
        \ 'text': '(s)earch files by CtrlSF',
        \ 'shortcut': 's',
        \ 'callback': 'NERDTreeSearchByCtrlSF' })
  call NERDTreeAddKeyMap({
        \ 'key': '<c-s>',
        \ 'callback': 'NERDTreeSearchByCtrlSF',
        \ 'quickhelpText': 'Search by CtrlSF',
        \ 'scope': 'Node' })
  function! NERDTreeSearchByCtrlSF(...)
    " get the current dir from NERDTree
    let l:cd = g:NERDTreeDirNode.GetSelected().path.str()
    " get the pattern
    let pattern = input("CtrlSF: ")
    if pattern == ''
      echo 'Maybe another time...'
      return
    endif
    let l:tmp = get(g:, 'ctrlsf_open_left')
    let g:ctrlsf_open_left = 0
    exe "CtrlSF '".pattern."' '".l:cd."'"
    let g:ctrlsf_open_left = l:tmp
    " NERDTreeClose
  endfunction

  " add key a and d
  call NERDTreeAddKeyMap({
        \ 'key': 'a',
        \ 'callback': 'config#nerdtree#add_node',
        \ 'quickhelpText': 'Add a child node',
        \ 'scope': 'Node'})
  call NERDTreeAddKeyMap({
        \ 'key': 'd',
        \ 'callback': 'config#nerdtree#delete_node',
        \ 'quickhelpText': 'Delete current node',
        \ 'scope': 'Node'})
  call NERDTreeAddKeyMap({
        \ 'key': 'b',
        \ 'callback': 'config#nerdtree#add_bookmark',
        \ 'quickhelpText': 'Add current node to bookmark list',
        \ 'scope': 'Node'})
endf

fu! config#nerdtree#add_node(...)
  call NERDTreeAddNode()
endf
fu! config#nerdtree#delete_node(...)
  call NERDTreeDeleteNode()
endf
fu! config#nerdtree#add_bookmark(...)
  Bookmark
endf
