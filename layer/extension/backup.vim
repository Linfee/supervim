" Layer: backup

if has('nvim')
  let s:dirs = ['~/.cache', '~/.cache/nvim', '~/.cache/nvim/undo']
el
  let s:dirs = ['~/.cache', '~/.cache/vim', '~/.cache/vim/undo']
en

for dir in s:dirs
  try
    if !isdirectory(expand(dir))
      cal mkdir(expand(dir))
    en
  cat
    echoe "can't mkdir " . dir . ", load layer [backup] fail"
    finish
  endt
endfo

" backup cursor
fu! ResCur()
  if line("'\"") <= line("$")
    silent! normal! g`"
    retu 1
  en
endf
aug resCur
  au!
  au BufWinEnter * cal ResCur()
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG cal setpos('.', [0, 1, 1, 0])
aug END

" backup undo
if has('persistent_undo')
  set undofile
  exe 'set undodir=' . s:dirs[2]
  " max undo
  set undolevels=1000
  " Maximum number lines to save for undo on a buffer reload
  set undoreload=10000
en

" backup view
" set viewoptions=folds,options,cursor,unix,slash
" exe 'set viewdir=' . s:dir[3]
" aug backupView
"   au!
"   au BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | en
"   au BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | en
" aug END
" nnoremap <c-s-f12> :!find ~/.vim/temp/view -mtime +30 -exec rm -a{} \;<cr>
" " TODO: let vim delete too old file auto

" " backup file
" set backup
" exe 'set backupdir=' . s:dir[4]
" set backupext=.__bak__
