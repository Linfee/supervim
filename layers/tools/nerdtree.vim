" Layer: nerdtree
let layer.plugins += [['jistr/vim-nerdtree-tabs',
      \ {'on_cmd': ['NERDTreeTabsToggle', 'NERDTreeToggle']}]]
let layer.plugins += [['scrooloose/nerdtree',
      \ {'on_cmd': ['NERDTreeTabsToggle', 'NERDTreeToggle', 'NERDTreeFind']}]]
let layer.plugins += [['Xuyuanp/nerdtree-git-plugin',
      \ {'on_cmd': ['NERDTreeTabsToggle', 'NERDTreeToggle']}]]


" before
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

if IsWin()
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


fu! nerdtree#after()
  " Key: <leader>n nerdtree
  nnoremap <space>n :NERDTreeTabsToggle<cr>
  nnoremap <space>e :NERDTreeFind<CR>
endf
