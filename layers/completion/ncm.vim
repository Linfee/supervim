" Layer: ncm
" For completion
" Dep: pip3 install --user neovim jedi mistune psutil setproctitle

let layer.plugins += [['roxma/nvim-completion-manager', {'on_event': 'InsertEnter'}]]
let layer.plugins += [['SirVer/ultisnips',              {'on_event': 'InsertEnter'}]]
let layer.plugins += [['honza/vim-snippets',            {'on_event': 'InsertEnter'}]]

let layer.plugins += ['Linfee/ultisnips-zh-doc']

" for vim8.0
if !has('nvim')
  let layer.plugins += ['roxma/vim-hug-neovim-rpc']
endif

let layer.sub_layers = ['jedi', 'javacomplete2']
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


  " for ultisnip --------------------------------------------------------------
  let g:UltiSnipsExpandTrigger    = "<Plug>(ultisnips_expand)"
  let g:UltiSnipsJumpForwardTrigger = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger  = "<c-k>"
  let g:UltiSnipsRemoveSelectModeMappings = 0
  " optional
  inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

  " snippets files
  let g:UltiSnipsSnippetsDir=expand(g:layer#vimfile."ultisnips")
  let g:UltiSnipsSnippetDirectories=["ultisnips"]
  " Trigger configuration.
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsListSnippets="<c-tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"
  nnoremap <leader>ua :UltiSnipsAddFiletypes<space>
  nnoremap <space>ua :UltiSnipsAddFiletypes<space>

endf
