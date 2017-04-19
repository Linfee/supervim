" Editing enhancement
LayerPlugin 'scrooloose/nerdcommenter' 
LayerPlugin 'jiangmiao/auto-pairs' 
LayerPlugin 'tpope/vim-surround'
LayerPlugin 'osyo-manga/vim-over', {'on': ['OverCommandLine']}
LayerPlugin 'itchyny/vim-cursorword'
LayerPlugin 'terryma/vim-expand-region'
LayerPlugin 'junegunn/vim-easy-align'
LayerPlugin 'terryma/vim-multiple-cursors' 

" before
" for nerdcommenter
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" override default
let g:NERDCustomDelimiters={
      \ 'python': { 'left': '#' },
      \ }
" allow work on empty line
let g:NERDCommentEmptyLines = 1
" trail whitespace after uncomment
let g:NERDTrimTrailingWhitespace=1
let g:NERDSpaceDelims=1
let g:NERDRemoveExtraSpaces=1

" for auto-pairs 
let g:AutoPairs = {'(': ')', '[': ']', '{': '}', "'": "'",'"': '"', '`': '`'}
let g:AutoPairsShortcutToggle = ''
nnoremap <leader>ta :call AutoPairsToggle()<cr>
if IsOSX()
  let g:AutoPairsShortcutFastWrap = 'å'
elseif IsLinux() && !IsGui()
  let g:AutoPairsShortcutFastWrap = 'a'
else
  let g:AutoPairsShortcutFastWrap = '<a-a>'
endif

fu! editing#after()
  " for vim-surround
  vmap Si S(i_<esc>f)

  " for vim-over
  " <leader>rr快速执行替换预览
  nnoremap <leader>rr :OverCommandLine<cr>%s/

  " for vim-expand-region
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)
  let g:expand_region_text_objects = {
        \ 'iw'  :0,
        \ 'iW'  :0,
        \ 'i"'  :0,
        \ 'i''' :0,
        \ 'i]'  :1,
        \ 'ib'  :1,
        \ 'iB'  :1,
        \ 'il'  :1,
        \ 'ii'  :1,
        \ 'ip'  :0,
        \ 'ie'  :0,
        \ }

  " for vim-easy-align
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap <leader>a <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap <leader>a <Plug>(EasyAlign)
  let g:easy_align_delimiters = {
        \ '>': { 'pattern': '>>\|=>\|>' },
        \ '/': {
        \     'pattern':         '//\+\|/\*\|\*/',
        \     'delimiter_align': 'l',
        \     'ignore_groups':   ['!Comment'] },
        \ ']': {
        \     'pattern':       '[[\]]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ ')': {
        \     'pattern':       '[()]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ 'd': {
        \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
        \     'left_margin':  0,
        \     'right_margin': 0
        \   }
        \ }

  " for vim-multiple-cursors
  let g:multi_cursor_next_key='<C-n>'
  let g:multi_cursor_prev_key='<C-p>'
  let g:multi_cursor_skip_key='<C-x>'
  let g:multi_cursor_quit_key='<c-[>'
  nnoremap <c-c> :call multiple_cursors#quit()<CR>
  nnoremap <silent> <leader>/ :MultipleCursorsFind <c-r>/<cr>
  vnoremap <silent> <leader>/ :MultipleCursorsFind <c-r>/<cr>
  " 多光标时禁用补全插件 {{3
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

