" Layer: utils
" file explorer, shell, denite

let layer.plugins += ['Konfekt/FastFold']
let layer.plugins += ['tpope/vim-repeat']

" TODO: these git command not work
let layer.plugins += [['tpope/vim-fugitive', {'on_cmd': [
      \ 'Git', 'Gcd', 'Glcd', 'Gstatus', 'Gcommit', 'Gmerge', 'Gpull', 'Gpush',
      \ 'Gfetch', 'Ggrep', 'Glgrep', 'Glog', 'Gllog', 'Gedit', 'Gsplit', 'Gvsplit',
      \ 'Gtabedit', 'Gpedit', 'Gread', 'Gwrite', 'Gwq', 'Gdiff', 'Gsdiff', 'Gvdiff',
      \ 'Gmove', 'Gremove', 'Gblame', 'Gbrowse' 
      \ ]}]]

let layer.plugins += [['mbbill/undotree',   {'on_cmd': 'UndotreeToggle'}]]
let layer.plugins += [['junegunn/goyo.vim', {'on_cmd': 'Goyo'}]]

let layer.plugins += [['tell-k/vim-autopep8',
      \ {'on_ft': 'python', 'on_cmd': 'Autopep8', 'after': 'utils#autopep8'}]]
let layer.plugins += [['majutsushi/tagbar',
      \ {'on_cmd': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}]]

let layer.sub_layers = 'nerdtree'

fu! utils#after()
  " Key: goyo <leader>g
  nnoremap <space>g :Goyo<cr>
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
  if executable('ctags')
    let g:tagbar_left=0
    let g:tagbar_width = 30
    let g:tagbar_zoomwidth = 0          " 缩放以使最长行可见
    let g:tagbar_show_visibility = 1    " 显示可见性
    if IsWin()
      let g:tagbar_iconchars = ['+', '-'] " 折叠字符
    else
      let g:tagbar_iconchars = ['▶', '▼'] " 折叠字符
    endif
  en

  if executable('ctags')
    " Key: <leader>t
    nnoremap <space>t :TagbarToggle<cr>
  endif

  " for fastfold
  let g:tex_fold_enabled=1
  let g:vimsyn_folding='af'
  let g:xml_syntax_folding = 1
  let g:php_folding = 1
  let g:perl_fold = 1

  " for undotree
  " Key: undotree <leader>u
  nnoremap <space>u :UndotreeToggle<cr>
  let g:undotree_SetFocusWhenToggle=1

  " for autopep8
  let g:autopep8_disable_show_diff = 0
endf
fu! utils#autopep8()
  " for autopep8
  nnoremap == :Autopep8<cr>
endf
