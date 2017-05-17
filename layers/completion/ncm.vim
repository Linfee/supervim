" Layer: ncm
" For completion
" Dep: pip3 install --user neovim jedi mistune psutil setproctitle

let layer.plugins += [['roxma/nvim-completion-manager', {'on_event': 'InsertEnter'}]]
let layer.sub_layers = ['javacomplete2','snippet']

" for vim8.0
if !has('nvim')
  let layer.plugins += ['roxma/vim-hug-neovim-rpc']
endif

let layer.conflic = ['deoplete', 'deoplete_jdei', 'necomplete']

" before
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

" after
fu! ncm#after()
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
