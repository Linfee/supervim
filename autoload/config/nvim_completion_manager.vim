fu! config#nvim_completion_manager#before()
  let g:cm_complete_delay = 50
endf

fu! config#nvim_completion_manager#after()
  " launch
  call cm#_auto_enable_check()

  " When use ctrl-c to exit insert mode, it will not trigger InsertLeave
  inoremap <c-c> <esc>
  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " Use tab to select the popup menu:
  " Not use this, use tab to trigger snippet
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endf
