fu! config#ncm#before()
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
endf

fu! config#ncm#after()
  " launch
  call cm#_auto_enable_check()

  let g:cm_complete_delay = 50

  set shortmess+=c
  " inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

  " Use tab to select the popup menu:
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  augroup NcmInit
    au!
    au User CmSetup call cm#register_source({'name' : 'cm-css',
          \ 'priority': 9, 
          \ 'scoping': 1,
          \ 'scopes': ['css','scss'],
          \ 'abbreviation': 'css',
          \ 'cm_refresh_patterns':[':\s+\w*$'],
          \ 'cm_refresh': {'omnifunc': 'csscomplete#CompleteCSS'},
          \ })
  augroup END
endf
