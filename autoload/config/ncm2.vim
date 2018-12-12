fu! config#ncm2#before()
  aug NcmBefore
    au!
    au BufEnter * call ncm2#enable_for_buffer()
    au TextChangedI * call ncm2#auto_trigger()
  aug END

  " wellle/tmux-complete.vim
  let g:tmuxcomplete#trigger = 'completefunc'

  " for ncm2-ultisnip
  let g:UltiSnipsExpandTrigger='<tab>'

endf

fu! config#ncm2#after()
  inoremap <c-c> <ESC>
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
endf
