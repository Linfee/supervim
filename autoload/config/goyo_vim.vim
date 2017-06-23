fu! config#goyo_vim#after()
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
endf
