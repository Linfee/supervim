fu! s:hi(suffix, fg, guifg)
  exec 'hi '.a:suffix.' ctermfg='. a:fg .' guifg='. a:guifg
  exec 'syn match '.a:suffix.' #^\s\+.*'.a:suffix.'$#'
endf

call s:hi('vim', 'grey', 'grey')
call s:hi('java', 'green', 'green')
call s:hi('groovy', 'green', 'green')
call s:hi('kt', 'green', 'green')
call s:hi('scala', 'green', 'green')
call s:hi('rb', 'cyan', 'cyan')
call s:hi('py', 'Magenta', '#ff00ff')
call s:hi('js', 'red', '#ffa506')
call s:hi('json', 'yellow', 'yellow')
call s:hi('json', 'cyan', 'cyan')
call s:hi('md', 'blue', '#3366ff')
call s:hi('xml', 'yellow', 'yellow')
call s:hi('html', 'yellow', 'yellow')
