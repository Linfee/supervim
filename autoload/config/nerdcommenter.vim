fu! config#nerdcommenter#before()
  " Use compact syntax for prettified multi-line comments
  let g:NERDCompactSexyComs = 1
  " Align line-wise comment delimiters flush left instead of following code indentation
  let g:NERDDefaultAlign = 'left'
  " Set a language to use its alternate delimiters by default
  let g:NERDAltDelims_java = 1
  " override default
  let g:NERDCustomDelimiters={
        \ 'python': { 'left': '#' },
        \ }
  " allow work on empty line
  let g:NERDCommentEmptyLines = 1
  " trail whitespace after uncomment
  let g:NERDTrimTrailingWhitespace=1
  let g:NERDSpaceDelims=1
  let g:NERDRemoveExtraSpaces=1
endf
