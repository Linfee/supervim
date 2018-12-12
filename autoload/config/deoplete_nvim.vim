fu! config#deoplete_nvim#before()
  call deoplete#custom#option({
        \ 'async_timeout': 50,
        \ 'auto_complete': v:true,
        \ 'auto_complete_delay': 50,
        \ 'auto_refresh_delay': 50,
        \ 'camel_case': v:true,
        \ 'complete_method': 'complete',
        \ 'delimiters': ['/', '\'],
        \ 'max_list': 200,
        \ 'num_processes': 4,
        \ 'on_insert_enter': v:true,
        \ 'on_text_changed_i': v:true,
        \ 'refresh_always': v:true,
        \ 'skip_chars': ['(', ')'],
        \ 'smart_case': v:true,
        \ })

  " " set the ignore sources
  call deoplete#custom#option('ignore_sources', {
        \ 'gitcommit': ['neosnippet']
        \ })


  " " set the keyword
  call deoplete#custom#option('keyword_patterns', {
        \ '_': '[a-zA-Z_]\k*',
        \ 'tex': '\\?[a-zA-Z_]\w*',
        \ 'ruby': '[a-zA-Z_]\w*[!?]?',
        \})

  " " use 'omnifunc' directly as soon as the pattern is matched
  call deoplete#custom#option('omni_patterns', {
        \ 'java': '[^. *\t]\.\w*',
        \ 'lua': '.',
        \})

  " " set the source
  " call deoplete#custom#option('sources', {
  "       \ '_': ['buffer'],
  "       \ 'cpp': ['buffer', 'tag'],
  "       \})

  " " set the omni source function for languages
  call deoplete#custom#source('omni', 'functions', {
        \ 'ruby':  'rubycomplete#Complete',
        \ 'javascript': ['tern#Complete', 'jspc#omni']
        \})

  " set the omni input patterns
  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'ruby':       ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
        \ 'php':        ['\w+|[^. \t]->\w*|\w+::\w*'],
        \ 'perl':       ['[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*'],
        \ 'jsp':        ['[^. \t0-9]\.\w*'],
        \ 'java':       ['[^. \t0-9]\.\w*', '[^. \t0-9]\->\w*', '[^. \t0-9]\::\w*'],
        \ 'gitcommit':  ['[ ]#[ 0-9a-zA-Z]*'],
        \ 'javascript': '[^. *\t]\.\w*',
        \})

  " call deoplete#custom#set('emoji', 'filetypes', ['gitcommit', 'markdown'])

  call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
  call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
  call deoplete#custom#source('_', 'max_abbr_width', 0)
  call deoplete#custom#source('_', 'max_menu_width', 0)
  call deoplete#custom#source('_', 'require_same_filetype', 0)
  call deoplete#custom#source('javacomplete2', 'mark', '')
  call deoplete#custom#source('go', 'mark', '')
  call deoplete#custom#source('ternjs', 'mark', 'tern')
  call deoplete#custom#source('phpcd', 'mark', '')
  call deoplete#custom#source('phpcd', 'input_pattern', '\w*|[^. \t]->\w*|\w*::\w*')
  call deoplete#custom#source('clang2', 'mark', '')
  call deoplete#custom#source('racer', 'mark', '')

  " PlugEx lazy load deoplete
  let g:deoplete#enable_at_startup = 1

  " let deoplete can complete filename after "=".
  set isfname-==

endf
"
fu! config#deoplete_nvim#after()
  " jedi
  let g:jedi#completions_enabled = 1
  let g:deoplete#sources#jedi#show_docstring = 1

  " for neco-vim
  if !exists('g:necovim#complete_functions')
    let g:necovim#complete_functions = {}
  endif
  let g:necovim#complete_functions.Ref = 'ref#complete'

  " for echodoc
  set noshowmode

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  inoremap <expr><C-g> deoplete#undo_completion()
  inoremap <expr><C-l> deoplete#refresh()

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
  endfunction

  " manual  trigger
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? "\<C-n>" :
  "       \ <SID>check_back_space() ? "\<TAB>" :
  "       \ deoplete#mappings#manual_complete()
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " disable deoplete when use multiple cursors
  function! g:Multiple_cursors_before()
    call deoplete#custom#buffer_option('auto_complete', v:false)
  endfunction
  function! g:Multiple_cursors_after()
    call deoplete#custom#buffer_option('auto_complete', v:true)
  endfunction
endf


