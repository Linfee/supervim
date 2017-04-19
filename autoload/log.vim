fu! log#init(...)
  let s:log_level = 1
  if a:0 > 0
    call log#set_level(a:1)
  en
  let s:prefix = ['[Error] ', '[Warning] ', '[Info] ', '[Debug] ']
  let s:highlight = ['Error', 'WarningMsg', 'Comment', 'Debug']
  let s:logs = []
endf

fu! log#set_level(level)
  if a:level == 'info'
    let s:log_level = 3
  elsei a:level == 'debug'
    let s:log_level = 2
  elsei a:level == 'warning'
    let s:log_level = 1
  elsei a:level == 'error'
    let s:log_level = 0
  el
    let s:log_level = -1
  en
endf

fu! log#debug(...)
  call s:Log(3, a:000)
endf
fu! log#info(...)
  call s:Log(2, a:000)
endf
fu! log#warning(...)
  call s:Log(1, a:000)
endf
fu! log#error(...)
  call s:Log(0, a:000)
endf

com! -nargs=+ Debug call log#debug(<args>)
com! -nargs=+ Info call log#info(<args>)
com! -nargs=+ Warning call log#warning(<args>)
com! -nargs=+ Error call log#error(<args>)
com! -nargs=1 LogLevel call log#set_level(<args>)
com! -nargs=0 ShowLogs call s:ShowLogs()
com! -nargs=0 ShowAllLogs call s:ShowAllLogs()

fu! s:Log(level, log)
  " Param: number, list
  let msg = ''
  for i in a:log
    let msg = msg . " " . string(i)[1:-2]
  endfo
  " echom msg
  " let msg = substitute(msg, "''", "'", "g")
  let log = {'level': a:level, 'log': s:prefix[a:level] . msg}
  " call s:EchoLog(log)
  call add(s:logs, log)
endf

fu! s:EchoLog(log)
  if a:log.level <= s:log_level
    exe 'echohl ' . s:highlight[a:log.level] . ' | echom "' . a:log.log . '" | echohl Normal'
  en
endf

fu! s:ShowLogs()
  for log in s:logs
    if log.level <= s:log_level
      exe 'echohl ' . s:highlight[log.level] . ' | echo "' . log.log . '" | echohl Normal'
    en
  endfo
endf

fu! s:ShowAllLogs()
  for log in s:logs
    exe 'echohl ' . s:highlight[log.level] . ' | echo "' . log.log . '" | echohl Normal'
  endfo
endf
