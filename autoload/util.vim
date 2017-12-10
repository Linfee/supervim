"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim
"

" Toggle background color
fu! util#toggle_bg()
  exe 'set bg=' . (&bg==#'dark' ? 'light' : 'dark')
endf

" Strip trailing whitespace
fu! util#strip_trailing_whitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endf

" Run shell command
fu! util#shell_run(cmdline)
  botright new

  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal nobuflisted
  setlocal noswapfile
  setlocal nowrap
  setlocal filetype=shell
  setlocal syntax=shell

  call setline(1, a:cmdline)
  call setline(2, substitute(a:cmdline, '.', '=', 'g'))
  execute 'silent $read !' . escape(a:cmdline, '%#')
  setlocal nomodifiable
    1
endf
" command! -complete=file -nargs=+ Shell call util#shell_run(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}

" delete trilling slash
fu! util#delete_trilling_slash()
  let g:cmd = getcmdline()

  if has("win16") || has("win32")
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  el
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  en

  if g:cmd == g:cmd_edited
    if has("win16") || has("win32")
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    el
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    en
  en

  return g:cmd_edited
endf

" Toggle hex viewer mode
" for ex.vim
fu! util#hex_toggle()
  if &binary " from hex
    set nobinary
    exe 'set display='. b:option_display
    exe 'silent%!xxd -r'
  el
    let b:option_display = &display
    set binary
    set display=uhex
    exe 'silent%!xxd'
  en
endf

" Replace in buffer
" for keymap.vim
fu! util#replace(confirm, wholeword, replace)
  " Param:
  "   confirm：whether confirm for each one
  "   wholeword：whether match whole world
  "   replace：replace with this string
  wa
  let l:flag = ''
  if a:confirm
    let l:flag .= 'gec'
  else
    let l:flag .= 'ge'
  endif
  let l:search = ''
  if a:wholeword
    let l:search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
  else
    let l:search .= expand('<cword>')
  endif
  let l:replace = escape(a:replace, '/\&~')
  execute 'argdo %s/' . l:search . '/' . l:replace . '/' . l:flag . '| update'
endf

" for keymap.vim
fu! util#visual_selection(direction, extra_filter) range " {{2
  let l:saved_reg = @"
  execute 'normal! vgvy'

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", '', '')

  if a:direction ==# 'gv'
    call s:cmdLine("Ag \"" . l:pattern . "\" " )
  elseif a:direction ==# 'replace'
    call s:cmdLine('%s' . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endf
fu! s:cmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endf

" get better experience when use soft swap
" for keymap.vim
fu! util#wrap_relative_motion(key, ...)
  let l:vis_sel=''
  if a:0
    let l:vis_sel='gv'
  endif
  if &wrap
    execute 'normal!' l:vis_sel . 'g' . a:key
  else
    execute 'normal!' l:vis_sel . a:key
  endif
endf

" vim:set et ts=2 sts=2 sw=2 tw=0:
