fu! config#vim_json#before()
  nnoremap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
  let g:vim_json_syntax_conceal = 0
endf
