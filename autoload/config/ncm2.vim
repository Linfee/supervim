fu! config#ncm2#before()
    au BufEnter * call ncm2#enable_for_buffer()
    au TextChangedI * call ncm2#auto_trigger()
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endf

fu! config#ncm2#after()
endf
