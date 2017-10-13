let s:os = {}
let vlib#os# = s:os

let s:os.is_win = has('win32') || has('win64')
let s:os.is_linux = has('unix') && !has('macunix')
let s:os.is_win_unix = has('win32unix')
let s:os.is_osx = has('macunix')
let s:os.is_nvim = has('nvim')
let s:os.is_gui = !has('nvim') && has('gui_running')

fu! s:os.mkdir(dir)
  return mkdir(a:dir)
endf

fu! s:os.mkdirs(dir)
  return mkdir(a:dir, 'p')
endf

fu! s:os.rmdir(dir)
  py3 import os
endf
