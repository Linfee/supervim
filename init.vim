"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ v / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: linfee
" Repo: https://github.com/linfee/supervim
"

" Functions {{
fu! IsWin()
  retu has('win32') || has('win64')
endf
fu! IsLinux()
  " for linux, return 0 on osx
  retu has('unix') && !has('macunix')
endf
fu! IsWinUnix()
  " for cygwin and mingw on windows
  retu has('win32unix')
endf
fu! IsOSX()
  retu has('macunix')
endf
fu! IsGui()
  retu has('gui_running')
endf
" }}

let &rtp = '~/.nvim,' . &rtp
let g:layer#vimfile = '~/.nvim/'

let layer_config_abs = expand('~/.nvimrc')
if filereadable(layer_config_abs)
  let g:layer#config_abs = layer_config_abs
en

call log#init('info')

call layer#init_layer()

" vim: fmr={{,}} fdm=marker
