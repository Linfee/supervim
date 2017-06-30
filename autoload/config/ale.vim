scriptencoding utf-8

fu! config#ale#before()
  " for statusline
  let g:airline#extensions#ale#enabled = 0
  if !plugex#is_loaded('lightline.vim')
    set statusline=%{config#ale#statusline()}
  en

  let g:ale_echo_msg_error_str = 'error'
  let g:ale_echo_msg_warning_str = 'warning'
  let g:ale_echo_msg_format = '[%linter%] [%severity%] %s '

  " Disable linting for all minified js and css files.
  let g:ale_pattern_options = {
        \ '\.min.js$': {'ale_enabled': 0},
        \ '\.min.css$': {'ale_enabled': 0}
        \ }
  let g:ale_linter_aliases = {
        \ 'nvim': 'vim'
        \ }
  let g:ale_maximum_file_size = 10485760
  " let g:ale_open_list = 1

  let g:ale_sign_error = '✖'
  let g:ale_sign_warning = '➤'
  let g:ale_sign_info = '>>'
  let g:ale_sign_style_error = 's>'
  let g:ale_sign_style_warning = 's>'

  let g:ale_linters = {
        \ 'javascript': ['jshint'],
        \ 'python': ['flake8']
        \ }
  let g:ale_python_flake8_options = '--max-line-length=84'

  if !filereadable('pom.xml') && !filereadable('build.gradle') && isdirectory('bin')
    let g:ale_java_javac_options = '-d bin'
  endif
endf

fu! config#ale#after()
  nmap <silent> <localleader>k <Plug>(ale_previous_wrap)
  nmap <silent> <localleader>j <Plug>(ale_next_wrap)
endf

fu! config#ale#statusline() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(
        \   '%dW %dE',
        \   all_non_errors,
        \   all_errors
        \)
endf
