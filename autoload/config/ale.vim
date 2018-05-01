scriptencoding utf-8

fu! config#ale#before()
  " for statusline
  let g:airline#extensions#ale#enabled = 0
  if !plugex#is_loaded('lightline.vim')
    set statusline=%{config#ale#statusline()}
  en

  if !g:is_osx
    let g:ale_echo_msg_error_str = 'error'
    let g:ale_echo_msg_warning_str = 'warning'
  else
    let g:ale_echo_msg_error_str = emoji#for('heavy_exclamation_mark')
    let g:ale_echo_msg_warning_str = emoji#for('arrow_right')
  endif
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

  if !g:is_osx
    let g:ale_sign_error = 'E>'
    let g:ale_sign_warning = 'W>'
    let g:ale_sign_info = 'I>'
    let g:ale_sign_style_error = 'S>'
    let g:ale_sign_style_warning = 's>'
  else
    let g:ale_sign_error = emoji#for('heavy_exclamation_mark')
    let g:ale_sign_warning = emoji#for('arrow_right')
    let g:ale_sign_info = emoji#for('arrow_forward')
    let g:ale_sign_style_error = emoji#for('-1')
    let g:ale_sign_style_warning = emoji#for('face_with_rolling_eyes')
  endif

  let g:ale_linters = {
        \ 'javascript': ['jshint'],
        \ 'python': ['flake8', 'autopep8']
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
        \   'Warning:%d | Error:%d',
        \   l:all_non_errors,
        \   l:all_errors
        \)
endf
