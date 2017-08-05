if !$LANG =~# 'zh_CN'
  finish
en

set encoding=utf8
set fileencoding=utf8
set fileencodings=utf8,chinese,latin1,gbk,big5,ucs-bom
if g:is_win
  if g:is_gui
    " set fileencoding=chinese
    set termencoding=utf8
    " set encoding for console
    " language messages zh_CN.utf-8
    language messages zh_CN.utf8
  el
    "set fileencodings=utf-8,chinese,latin-1
    "set fileencoding=chinese
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    " set encoding for console
    set langmenu=none
    language messages zh_CN.utf8
  en
en
