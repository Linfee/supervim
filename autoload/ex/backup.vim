" Which backup dir to use
if has('nvim')
  let s:dirs = ['~/.cache', '~/.cache/nvim', '~/.cache/nvim/undo']
else
  let s:dirs = ['~/.cache', '~/.cache/vim', '~/.cache/vim/undo']
en

" Make those dir for backup
for dir in s:dirs
  try
    if !isdirectory(expand(dir))
      call mkdir(expand(dir))
    en
  cat
    echoe "can't mkdir " . dir . ", load layer [backup] fail"
    finish
  endtry
endfor

" Backup cursor
fu! ex#backup#cursor()
  fu! s:res_cur()
    if line("'\"") <= line("$")
      silent! normal! g`"
      retu 1
    en
  endf
  aug resCur
    au!
    au BufWinEnter * call s:res_cur()
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  aug END
endf

" Backup undo
fu! ex#backup#undo()
  if has('persistent_undo')
    set undofile
    exe 'set undodir=' . s:dirs[2]
    " max undo
    set undolevels=1000
    " Maximum number lines to save for undo on a buffer reload
    set undoreload=10000
  en
endf

" Backup view
fu! ex#backup#view()
  set viewoptions=folds,options,cursor,unix,slash
  exe 'set viewdir=' . s:dir[3]
  aug backupView
    au!
    au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | en
    au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | en
  aug END
  nnoremap <c-s-f12> :!find ~/.vim/temp/view -mtime +30 -exec rm -a{} \;<cr>
  " TODO: let vim delete too old file auto
endf

" Backup file
fu! ex#backup#file()
  set backup
  exe 'set backupdir=' . s:dir[4]
  set backupext=.__bak__
endf
