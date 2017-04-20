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
  " for nerdtree
  " NERDTress File highlighting
  function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
    exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
    exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
  endfunction

  call NERDTreeHighlightFile('java'   , 'green'   , 'none' , 'green'   , '#151515')
  call NERDTreeHighlightFile('vim'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('md'     , 'blue'    , 'none' , '#3366FF' , '#151515')
  call NERDTreeHighlightFile('xml'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('config' , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('conf'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('json'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('html'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
  call NERDTreeHighlightFile('styl'   , 'cyan'    , 'none' , 'cyan'    , '#151515')
  call NERDTreeHighlightFile('css'    , 'cyan'    , 'none' , 'cyan'    , '#151515')
  call NERDTreeHighlightFile('coffee' , 'Red'     , 'none' , 'red'     , '#151515')
  call NERDTreeHighlightFile('js'     , 'Red'     , 'none' , '#ffa500' , '#151515')
  call NERDTreeHighlightFile('python' , 'Magenta' , 'none' , '#ff00ff' , '#151515')

  " Key: <leader>n nerdtree
  nnoremap <Leader>n :NERDTreeTabsToggle<CR>
  nnoremap <leader>e :NERDTreeFind<CR>
  " 快速切换nerdtree到当前文件目录
  nnoremap <silent><leader>xn :exec("NERDTree ".expand('%:h'))<CR>
endf
