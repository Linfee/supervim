" 开启fcitx中英文切换
fu! ex#fcitx#fcitx_support_on()
  let g:input_toggle = 1
  let s:timeoutlen = &timeoutlen
  set timeoutlen=300
  augroup FcitxSupport
    autocmd!
    autocmd InsertLeave * cal <sid>fcitx2en()
    autocmd InsertEnter * cal <sid>fcitx2zh()
  augroup END
endf

" 关闭fcitx中英文切换
fu! ex#fcitx#fxitx_support_off()
  let &timeoutlen = s:timeoutlen
  augroup FcitxSupport
    autocmd!
  augroup END
  augroup! FcitxSupport
endf

" 切换fcitx到英文状态
fu! s:fcitx2en()
  let s:input_status = system("fcitx-remote")
  if s:input_status == 2
    let g:input_toggle = 1
    let l:a = system("fcitx-remote -c")
  en
endf

" 切换fcitx到中文状态
fu! s:fcitx2zh()
  let s:input_status = system("fcitx-remote")
  if s:input_status != 2 && g:input_toggle == 1
    let l:a = system("fcitx-remote -o")
    let g:input_toggle = 0
  en
endf

