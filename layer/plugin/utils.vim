" Layer: utils
" file explorer, shell, denite

LayerPlugin 'junegunn/goyo.vim', {'on': 'Goyo'}
LayerPlugin 'mbbill/undotree', {'on': 'UndotreeToggle'}
LayerPlugin 'Konfekt/FastFold'
LayerPlugin 'tpope/vim-repeat'

LayerPlugin 'tpope/vim-fugitive'

LayerPlugin 'tell-k/vim-autopep8', {'for': 'python'}

if executable('ctags')
  LayerPlugin 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}
en

LayerSubLayers 'nerdtree', 'deol',  'denite'


fu! utils#after()
  " for goyo.vim
  let g:goyo_height = '90%'
  let g:hoyo_width = '120'
  let g:goyo_linenr = 0

  let s:save_option = {}
  function! s:goyo_enter()
    let s:save_option['showmode'] = &showmode
    let s:save_option['showcmd'] = &showcmd
    let s:save_option['scrolloff'] = &scrolloff
    set noshowmode
    set noshowcmd
    set scrolloff=999
    if exists(':Limelight') == 2
      Limelight
      let s:save_option['limelight'] = 1
    endif
  endfunction

  function! s:goyo_leave()
    let &showmode = s:save_option['showmode']
    let &showcmd = s:save_option['showcmd']
    let &scrolloff = s:save_option['scrolloff']
    if get(s:save_option,'limelight', 0)
      execute 'Limelight!'
    endif
  endfunction
  augroup goyo_map
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
  augroup END

  " for tagbar
  let g:tagbar_left=0
  let g:tagbar_width = 30
  let g:tagbar_zoomwidth = 0          " 缩放以使最长行可见
  let g:tagbar_show_visibility = 1    " 显示可见性
  if IsWin()
    let g:tagbar_iconchars = ['+', '-'] " 折叠字符
  else
    let g:tagbar_iconchars = ['▶', '▼'] " 折叠字符
  endif

  nnoremap <leader>tt :TagbarToggle<cr>
  " call DoCustomLeaderMap('nnoremap', 't', ':TagbarToggle<cr>')

  " for fastfold
  let g:tex_fold_enabled=1
  let g:vimsyn_folding='af'
  let g:xml_syntax_folding = 1
  let g:php_folding = 1
  let g:perl_fold = 1

  " for undotree
  nnoremap <leader>u :UndotreeToggle<cr>
  let g:undotree_SetFocusWhenToggle=1


  " for autopep8
  let g:autopep8_disable_show_diff = 0
endf
