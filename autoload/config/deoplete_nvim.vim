fu! config#deoplete_nvim#before()
  let g:deoplete#delimiters = ['/', '\']
  let g:deoplete#buffer#require_same_filetype = 0
  let g:deoplete#auto_complete_delay = 50

  let g:deoplete#enable_smart_case = 1
  let g:deoplete#enable_refresh_always = 1
  let g:deoplete#max_abbr_width = 0
  let g:deoplete#max_menu_width = 0

  let g:deoplete#ignore_sources = {}
  let g:deoplete#omni#input_patterns = {}
  let g:deoplete#omni_patterns = {}

  " for jedi
  let g:jedi#completions_enabled = 0

  " for deoplete
  let g:deoplete#enable_at_startup = 1

  " java && jsp
  let g:deoplete#omni#input_patterns.java = ['[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*']
  let g:deoplete#omni#input_patterns.jsp = ['[^. \t0-9]\.\w*']
  let g:deoplete#ignore_sources.java = ['omni']
  call deoplete#custom#set('javacomplete2', 'mark', '')

  " go
  let g:deoplete#ignore_sources.go = ['omni']
  call deoplete#custom#set('go', 'mark', '')
  call deoplete#custom#set('go', 'rank', 9999)

  " perl
  let g:deoplete#omni#input_patterns.perl = ['[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*']

  " javascript
  "let g:deoplete#omni#input_patterns.javascript = ['[^. \t0-9]\.\w*']
  let g:deoplete#ignore_sources.javascript = ['omni']
  call deoplete#custom#set('ternjs', 'mark', 'tern')
  call deoplete#custom#set('ternjs', 'rank', 9999)

  " php
  let g:deoplete#omni#input_patterns.php = ['[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*' ]
  let g:deoplete#ignore_sources.php = ['phpcd', 'around', 'member']
  "call deoplete#custom#set('phpcd', 'mark', '')
  "call deoplete#custom#set('phpcd', 'input_pattern', '\w*|[^. \t]->\w*|\w*::\w*')

  " gitcommit
  let g:deoplete#omni#input_patterns.gitcommit = ['[ ]#[ 0-9a-zA-Z]*']

  let g:deoplete#ignore_sources.gitcommit = ['neosnippet']

  " lua
  let g:deoplete#omni_patterns.lua = '.'

  " c c++
  call deoplete#custom#set('clang2', 'mark', '')
  let g:deoplete#ignore_sources.c = ['omni']

  " rust
  let g:deoplete#ignore_sources.rust = ['omni']
  call deoplete#custom#set('racer', 'mark', '')

  " public settings
  call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
  let g:deoplete#ignore_sources._ = ['around']
  " inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
  " inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
  set isfname-==
endf


fu! config#deoplete_nvim#after()
  " for deoplete-jedi
  let g:deoplete#sources#jedi#show_docstring = 1

  " for neco-vim
  if !exists('g:necovim#complete_functions')
    let g:necovim#complete_functions = {}
  endif
  let g:necovim#complete_functions.Ref = 'ref#complete'

  " for echodoc
  set noshowmode

  " <C-h>, <BS>: close popup and delete backword char.
  " inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  " inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  inoremap <expr><C-g> deoplete#undo_completion()
  inoremap <expr><C-l> deoplete#refresh()

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
  endfunction

  " manual  trigger
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
endf
