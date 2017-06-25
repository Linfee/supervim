fu! config#ctrlsf_vim#before()
  let g:ctrlsf_mapping = {
        \ "open"    : ["<CR>", "o"],
        \ "openb"   : "O",
        \ "split"   : "-",
        \ "vsplit"  : "\\",
        \ "tab"     : "t",
        \ "tabb"    : "T",
        \ "popen"   : "p",
        \ "quit"    : "q",
        \ "next"    : "n",
        \ "prev"    : "N",
        \ "pquit"   : "q",
        \ "loclist" : "=",
        \ "chgmode" : "M",
        \ }
  " don't close ctrlsf window after open a file from here
  let g:ctrlsf_auto_close = 0
  " let g:ctrlsf_selected_line_hl = 'op'
  let g:ctrlsf_toggle_map_key = '<leader>t'
  let g:ctrlsf_indent = 2
endf

if !exists('*config#ctrlsf_vim#ctrlsf_search')
  fu config#ctrlsf_vim#ctrlsf_search(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
      normal! `<v`>y
    elseif a:type ==# 'char'
      normal! `[v`]y
    else
      return
    endif
    exe 'CtrlSF '.string(@@)
    let @@ = saved_unnamed_register
  endf
en
