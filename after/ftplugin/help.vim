nnoremap <buffer> <cr> <c-]>
nnoremap <buffer> <bs> <c-o>

let b:helpful = 1

if !g:is_old_version
  call timer_start(80, {-> helpful#setup()})
en

