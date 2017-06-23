fu! config#syntastic#after()
  if !filereadable('pom.xml') && !filereadable('build.gradle') && isdirectory('bin')
    let g:syntastic_java_javac_options = '-d bin'
  endif

  " set statusline+=%#warningmsg#
  " set statusline+=%{SyntasticStatuslineFlag()}
  " set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0
  let g:syntastic_enable_signs=1
  " let g:syntastic_aggregate_errors = 1 " 显示多个检查器的错误
  let g:syntastic_python_checkers=['flake8']
  let g:syntastic_javascript_checkers = ['jshint']
  let g:syntastic_python_flake8_args='--max-line-length=84'
  let g:syntastic_java_javac_config_file_enabled = get(g:, 'syntastic_java_javac_config_file_enabled', 1)
  let g:syntastic_java_javac_delete_output = get(g:, 'syntastic_java_javac_delete_output', 0)
  let g:syntastic_error_symbol = get(g:, 'spacevim_error_symbol', '✖')
  let g:syntastic_warning_symbol = get(g:, 'spacevim_warning_symbol', '➤')
  let g:syntastic_vimlint_options = get(g:, 'syntastic_vimlint_options', {
        \'EVL102': 1 ,
        \'EVL103': 1 ,
        \'EVL205': 1 ,
        \'EVL105': 1 ,
        \})
endf
