" Editing enhancement
let layer.plugins += [['scrooloose/nerdcommenter', {'on_map': [
      \ 'n<Plug>NERDCommenterAltDelims', 'x<Plug>NERDCommenterUncomment',
      \ 'n<Plug>NERDCommenterUncomment', 'x<Plug>NERDCommenterAlignBoth',
      \ 'n<Plug>NERDCommenterAlignBoth', 'x<Plug>NERDCommenterAlignLeft',
      \ 'n<Plug>NERDCommenterAlignLeft', 'n<Plug>NERDCommenterAppend',
      \ 'x<Plug>NERDCommenterYank', 'n<Plug>NERDCommenterYank',
      \ 'x<Plug>NERDCommenterSexy', 'n<Plug>NERDCommenterSexy',
      \ 'x<Plug>NERDCommenterInvert', 'n<Plug>NERDCommenterInvert',
      \ 'n<Plug>NERDCommenterToEOL', 'x<Plug>NERDCommenterNested',
      \ 'n<Plug>NERDCommenterNested', 'x<Plug>NERDCommenterMinimal',
      \ 'n<Plug>NERDCommenterMinimal', 'x<Plug>NERDCommenterToggle',
      \ 'n<Plug>NERDCommenterToggle', 'x<Plug>NERDCommenterComment',
      \ 'n<Plug>NERDCommenterComment'
      \ ], 'on_event': 'InsertEnter'}]]
let layer.plugins += [['jiangmiao/auto-pairs', {'on_event': 'InsertEnter', 'after': 'AutoPairsTryInit'}]]

let layer.plugins += [['tpope/vim-surround', {'on_map': [
      \ '<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround',
      \ '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround',
      \ '<Plug>YSsurround', '<Plug>YSsurround', '<Plug>VSurround',
      \ '<Plug>VgSurround', '<Plug>Isurround', '<Plug>Isurround',
      \ '<Plug>ISurround'
      \ ]}]]
let layer.plugins += [['osyo-manga/vim-over', {'on_cmd': 'OverCommandLine'}]]
let layer.plugins += [['terryma/vim-expand-region', {'on_map': [
      \ 'v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)' ]}]]
let layer.plugins += [['junegunn/vim-easy-align',
      \ {'on_map': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}]]
let layer.plugins += ['terryma/vim-multiple-cursors']
let layer.plugins += ['itchyny/vim-cursorword']

" before
" for nerdcommenter ------------------------------------------------------------
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
nmap <leader>ca <Plug>NERDCommenterAltDelims
xmap <leader>cu <Plug>NERDCommenterUncomment
nmap <leader>cu <Plug>NERDCommenterUncomment
xmap <leader>cb <Plug>NERDCommenterAlignBoth
nmap <leader>cb <Plug>NERDCommenterAlignBoth
xmap <leader>cl <Plug>NERDCommenterAlignLeft
nmap <leader>cl <Plug>NERDCommenterAlignLeft
nmap <leader>cA <Plug>NERDCommenterAppend
xmap <leader>cy <Plug>NERDCommenterYank
nmap <leader>cy <Plug>NERDCommenterYank
xmap <leader>cs <Plug>NERDCommenterSexy
nmap <leader>cs <Plug>NERDCommenterSexy
xmap <leader>ci <Plug>NERDCommenterInvert
nmap <leader>ci <Plug>NERDCommenterInvert
nmap <leader>c$ <Plug>NERDCommenterToEOL
xmap <leader>cn <Plug>NERDCommenterNested
nmap <leader>cn <Plug>NERDCommenterNested
xmap <leader>cm <Plug>NERDCommenterMinimal
nmap <leader>cm <Plug>NERDCommenterMinimal
xmap <leader>c<Space> <Plug>NERDCommenterToggle
nmap <leader>c<Space> <Plug>NERDCommenterToggle
xmap <leader>cc <Plug>NERDCommenterComment
nmap <leader>cc <Plug>NERDCommenterComment

" for auto-pairs ---------------------------------------------------------------
let g:AutoPairs = {'(': ')', '[': ']', '{': '}', "'": "'",'"': '"', '`': '`'}
let g:AutoPairsShortcutToggle = ''
nnoremap <leader>ta :call AutoPairsToggle()<cr>
if has('nvim')
  let g:AutoPairsShortcutFastWrap = '<a-a>'
elseif IsOSX()
  let g:AutoPairsShortcutFastWrap = 'å'
elseif IsLinux() && !IsGui()
  let g:AutoPairsShortcutFastWrap = 'a'
else
  let g:AutoPairsShortcutFastWrap = '<a-a>'
endif

fu! editing#after()
  " for vim-surround -----------------------------------------------------------
  vmap Si S(i_<esc>f)

  let g:surround_no_mappings = 1
  nmap ds  <Plug>Dsurround
  nmap cs  <Plug>Csurround
  nmap cS  <Plug>CSurround
  nmap ys  <Plug>Ysurround
  nmap yS  <Plug>YSurround
  nmap yss <Plug>Yssurround
  nmap ySs <Plug>YSsurround
  nmap ySS <Plug>YSsurround
  xmap S   <Plug>VSurround
  xmap gS  <Plug>VgSurround
  if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
    if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
      imap    <C-S> <Plug>Isurround
    endif
    imap      <C-G>s <Plug>Isurround
    imap      <C-G>S <Plug>ISurround
  endif

  " for vim-over ---------------------------------------------------------------
  " <leader>rr快速执行替换预览
  nnoremap <leader>rr :OverCommandLine<cr>%s/

  " for vim-expand-region ------------------------------------------------------
  vmap v <Plug>(expand_region_expand)
  vmap V <Plug>(expand_region_shrink)
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

  " for vim-easy-align ---------------------------------------------------------
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

  " for vim-multiple-cursors ---------------------------------------------------
  let g:multi_cursor_next_key='<C-n>'
  let g:multi_cursor_prev_key='<C-p>'
  let g:multi_cursor_skip_key='<C-x>'
  let g:multi_cursor_quit_key='<c-[>'
  nnoremap <c-c> :call multiple_cursors#quit()<CR>
  nnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>
  vnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>
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
