" Layer: deplete
" For completion
" Dep: nvim python3
LayerPlugin 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
LayerPlugin 'Shougo/neco-vim', {'for': 'vim'}
LayerPlugin 'Shougo/echodoc.vim', {'for': ['vim', 'ruby']}

LayerPlugin 'Linfee/ultisnips-zh-doc'
LayerPlugin 'SirVer/ultisnips'
LayerPlugin 'honza/vim-snippets'

ConflicLayers 'ncm', 'necomplete'

LayerWhen 'has("nvim")'

" LayerSubLayers 'deoplete_jdei', 'javacomplete2'
LayerSubLayers 'jedi', 'javacomplete2'

if has("nvim")
  let g:deoplete#delimiters = ['/', '\']

  let g:deoplete#buffer#require_same_filetype = 0

  let g:deoplete#auto_complete_delay = 50

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
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType python setlocal omnifunc=jedi#completions
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  augroup END
en

" after
fu! deoplete#after()

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  inoremap <expr><C-g> deoplete#undo_completion()
  inoremap <expr><C-l> deoplete#refresh()

  " <CR>: close popup and save indent.
  " inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  " function! s:my_cr_function() abort
  "   return deoplete#close_popup() . "\<CR>"
  " endfunction

  " manual  trigger
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction "}}}

  augroup DeopleteInit
    autocmd!
    autocmd VimEnter * call deoplete#initialize()
  augroup END

  " deoplete options
  let g:deoplete#enable_at_startup = 1
  " let g:deoplete#enable_ignore_case = 1
  " let g:deoplete#enable_smart_case = 1
  let g:deoplete#enable_camel_case = 1
  let g:deoplete#enable_refresh_always = 1
  let g:deoplete#max_abbr_width = 0
  let g:deoplete#max_menu_width = 0
  " init deoplet option dict
  let g:deoplete#ignore_sources = get(g:,'deoplete#ignore_sources',{})
  let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
  let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})


  " java && jsp
  let g:deoplete#omni#input_patterns.java = get(g:deoplete#omni#input_patterns, 'java', [
        \'[^. \t0-9]\.\w*',
        \'[^. \t0-9]\->\w*',
        \'[^. \t0-9]\::\w*',
        \])
  let g:deoplete#omni#input_patterns.jsp = get(g:deoplete#omni#input_patterns, 'jsp', ['[^. \t0-9]\.\w*'])
  if layer#is_layer_loaded('javacomplete2') " javacomplete2
    let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['omni'])
    call deoplete#custom#set('javacomplete2', 'mark', '')
  else
    let g:deoplete#ignore_sources.java = get(g:deoplete#ignore_sources, 'java', ['javacomplete2'])
    call deoplete#custom#set('omni', 'mark', '')
  endif

  " go
  let g:deoplete#ignore_sources.go = get(g:deoplete#ignore_sources, 'go', ['omni'])
  call deoplete#custom#set('go', 'mark', '')
  call deoplete#custom#set('go', 'rank', 9999)

  " perl
  let g:deoplete#omni#input_patterns.perl = get(g:deoplete#omni#input_patterns, 'perl', [
        \'[^. \t0-9]\.\w*',
        \'[^. \t0-9]\->\w*',
        \'[^. \t0-9]\::\w*',
        \])

  " javascript
  let g:deoplete#omni#input_patterns.javascript = get(g:deoplete#omni#input_patterns, 'javascript', ['[^. \t0-9]\.\w*'])

  " php
  let g:deoplete#omni#input_patterns.php = get(g:deoplete#omni#input_patterns, 'php', [
        \'[^. \t0-9]\.\w*',
        \'[^. \t0-9]\->\w*',
        \'[^. \t0-9]\::\w*',
        \])
  let g:deoplete#ignore_sources.php = get(g:deoplete#ignore_sources, 'php', ['phpcd', 'around', 'member'])
  "call deoplete#custom#set('phpcd', 'mark', '')
  "call deoplete#custom#set('phpcd', 'input_pattern', '\w*|[^. \t]->\w*|\w*::\w*')

  " lua
  let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')

  " c c++
  call deoplete#custom#set('clang2', 'mark', '')
  let g:deoplete#ignore_sources.c = get(g:deoplete#ignore_sources, 'c', ['omni'])

  " rust
  let g:deoplete#ignore_sources.rust = get(g:deoplete#ignore_sources, 'rust', ['omni'])
  call deoplete#custom#set('racer', 'mark', '')

  " public settings
  call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
  let g:deoplete#ignore_sources._ = get(g:deoplete#ignore_sources, '_', ['around'])
  inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

  " for neco-vim --------------------------------------------------------------
  if !exists('g:necovim#complete_functions')
    let g:necovim#complete_functions = {}
  endif
  let g:necovim#complete_functions.Ref =
        \ 'ref#complete'

  " for echodoc ---------------------------------------------------------------
  set noshowmode
  let g:echodoc_enable_at_startup = 1

  " for ultisnip --------------------------------------------------------------
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
