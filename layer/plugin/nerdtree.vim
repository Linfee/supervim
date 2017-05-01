" Layer: nerdtree
LayerPlugin 'scrooloose/nerdtree', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle', 'NERDTreeFind']}
LayerPlugin 'jistr/vim-nerdtree-tabs', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
LayerPlugin 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}


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
  nnoremap <Leader>n :NERDTreeTabsToggle<CR>
  nnoremap <leader>e :NERDTreeFind<CR>
  " 快速切换nerdtree到当前文件目录
  nnoremap <silent><leader>xn :exec("NERDTree ".expand('%:h'))<CR>
endf
