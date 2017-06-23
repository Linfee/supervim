fu! config#vim_markdown#before()
  let g:vim_markdown_folding_style_pythonic = 1
  let g:vim_markdown_toc_autofit = 1
  let g:vim_markdown_emphasis_multiline = 0

  let g:vim_markdown_toc_autofit = 1
  let g:vim_markdown_emphasis_multiline = 0
  " let g:vim_markdown_conceal = 0
  let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']
endf

fu! config#vim_markdown#after()
  " let g:vim_markdown_folding_style_pythonic = 1
  let g:vim_markdown_override_foldtext = 1
  " let g:vim_markdown_toc_autofit = 1
  let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
  " Syntax extensions
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_new_list_item_indent = 4
  " let g:vim_markdown_no_extensions_in_markdown = 1
  let g:vim_markdown_autowrite = 1
endf
