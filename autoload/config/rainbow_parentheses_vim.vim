fu! config#rainbow_parentheses_vim#before()
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['[', ']']]

  " List of colors that you do not want. ANSI code or #RRGGBB
  let g:rainbow#blacklist = [233, 234]
endf

fu! config#rainbow_parentheses_vim#after()
  RainbowParentheses
endf
