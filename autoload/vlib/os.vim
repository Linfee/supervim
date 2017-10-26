let s:os = {}
let vlib#os# = s:os

let s:os.is_win = has('win32') || has('win64')
let s:os.is_linux = has('unix') && !has('macunix')
let s:os.is_win_unix = has('win32unix')
let s:os.is_osx = has('macunix')
let s:os.is_nvim = has('nvim')
let s:os.is_gui = !has('nvim') && has('gui_running')
let s:os.name = hostname()

let s:os.getcwd = function('getcwd')

fu! s:os.mkdir(dir)
  return mkdir(a:dir)
endf

fu! s:os.mkdirs(dir)
  return mkdir(a:dir, 'p')
endf

if s:os.is_win
  fu! s:os.rmdir(dir)
    call system('rd /q ' . a:dir)
  endf
  fu! s:os.rmdirs(dir)
    call system('rd /q /s ' . a:dir)
  endf
  fu! s:os.listdir(dir)
    return split(system('dir /b ' . a:dir))
  endf
else
  fu! s:os.rmdir(dir)
    call system('rmdir ' . a:dir)
  endf
  fu! s:os.rmdirs(dir)
    call system('rm -r ' . a:dir)
  endf
  fu! s:os.listdir(dir)
    return split(system('ls -a' . a:dir))[2:]
  endf
en

fu! s:os.rename(from, to)
  return rename(a:from, a:to)
endf

" os.path
let s:os.path = {}
let s:os.path.simplify = function('simplify')
let s:os.path.resolve = function('resolve')

fu! s:os.path.abspath(path)
  return fnamemodify(expand(a:path), ':p')
endf

fu! s:os.path.split(path)
  let l:path = expand(a:path)
  return [fnamemodify(l:path, ':p:h'), fnamemodify(l:path, ':t')]
endf

fu! s:os.path.dirname(path)
  return fnamemodify(expand(a:path), ':p:h')
endf

fu! s:os.path.basename(path)
  return fnamemodify(expand(a:path), ':t')
endf

fu! s:os.path.exists(path)
  return isdirectory(a:path) || getfsize(a:path) != -1
endf

fu! s:os.path.isabs(path)
  return a:path #== s:os.path.abspath(a:path)
endf

fu! s:os.path.isdir(path)
  return isdirectory(a:path)
endf

fu! s:os.path.isfile(path)
  return s:os.path.exists(a:path) && !s:os.path.isdir(a:path)
endf

fu! s:os.path.join(path)
endf

fu! s:os.path.getatime(path)
endf

fu! s:os.path.getmtime(path)
endf

