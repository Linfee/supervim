" Layer: noecomplete
" For completion
" Dep: vim, lua
let layer.plugins += [['Shougo/neocomplete.vim',  {'on_event': 'InsertEnter'}]]
let layer.plugins += [['davidhalter/jedi-vim',    {'on_event': 'InsertEnter',
      \ 'on_ft': 'python'}]]

let layer.sub_layers = ['javacomplete2', 'jedi', 'snippet']
let layer.condition = '!has("nvim")'
let layer.conflic = ['ncm', 'deoplete', 'deoplete_jdei']

" before
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#force_overwrite_completefunc = 1
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $CACHE.'/vimshell/command-history',
      \ 'java' : '~/.vim/dict/java.dict',
      \ 'ruby' : '~/.vim/dict/ruby.dict',
      \ 'scala' : '~/.vim/dict/scala.dict',
      \ }

" after
fu! neocomplete#after()
  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'
  let g:neocomplete#keyword_patterns._ = '\h\k*(\?'

  let g:neocomplete#data_directory= '~/.cache/neocomplete'
  let g:acp_enableAtStartup = 0
  " Use smartcase.
  let g:neocomplete#enable_camel_case = 1
  "let g:neocomplete#enable_ignore_case = 1
  let g:neocomplete#enable_fuzzy_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3


  " AutoComplPop like behavior.
  let g:neocomplete#enable_auto_select = 0

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  " omni 补全配置 {{3
  augroup omnif
    autocmd!
    autocmd Filetype *
          \if &omnifunc == "" |
          \setlocal omnifunc=syntaxcomplete#Complete |
          \endif
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " python使用jedi
    autocmd FileType python setlocal omnifunc=jedi#completions
    " autocmd FileType python setlocal omnifunc=jedi#completions
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.java = '[^. \t0-9]\.\w*'
  let g:neocomplete#sources#omni#input_patterns.lua = '[^. \t0-9]\.\w*'
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
  " }}3

  " 自动打开关闭弹出式的预览窗口 {{3
  augroup AutoPopMenu
    autocmd!
    autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  augroup END
  set completeopt=menu,preview,longest "}}3

  " 回车键插入当前的补全项
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction

  " <C-k> 补全snippet
  " <C-k> 下一个输入点
  imap <silent><expr><C-k> neosnippet#expandable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
        \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
  smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()
  "inoremap <expr><CR> neocomplete#complete_common_string()

  " 使用回车确认补全
  " shift加回车确认补全保存缩进
  inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

  function! CleverCr()
    if pumvisible()
      " if neosnippet#expandable()
      "     let exp = "\<Plug>(neosnippet_expand)"
      "     return exp . neocomplete#smart_close_popup()
      " else
      return neocomplete#smart_close_popup()
      " endif
    else
      return "\<CR>"
    endif
  endfunction

  imap <expr> <Tab> CleverTab()

  " 回车插入补全并保存缩进，或者展开snippet
  " imap <expr> <CR> CleverCr()
  " <C-h>,<BS> 关闭预览窗口并删除补全预览
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y> neocomplete#smart_close_popup()
  " 使用tab补全
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
  " 额外的快捷键
  inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
  " inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

endf
