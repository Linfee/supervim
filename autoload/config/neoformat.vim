fu! config#neoformat#after()
  let g:neoformat_enabled_java = ['googlefmt']
  let g:neoformat_java_googlefmt = {
        \ 'exe': 'java',
        \ 'args': ['-jar', get(g:,'spacevim_layer_lang_java_formatter', '')],
        \ 'replace': 0,
        \ 'stdin': 0,
        \ 'no_append': 0,
        \ }
  try
    let g:neoformat_enabled_java += neoformat#formatters#java#enabled()
  catch
  endtry
endf
