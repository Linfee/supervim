fu! config#nvim_completion_manager#before()
  augroup omnif
    autocmd!
    autocmd Filetype *
          \if &omnifunc == "" |
          \setlocal omnifunc=syntaxcomplete#Complete |
          \endif
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=jedi#completions
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  augroup END

  let g:cm_complete_delay = 50

  set shortmess+=c
endf

fu! config#nvim_completion_manager#after()
  " launch
  call cm#_auto_enable_check()

  " When use ctrl-c to exit insert mode, it will not trigger InsertLeave
  inoremap <c-c> <esc>
  " inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " Use tab to select the popup menu:
  " Not use this, use tab to trigger snippet
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

endf
