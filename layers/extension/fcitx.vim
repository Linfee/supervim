" Layer: fcitx
" auto switch zh/en when use fcitx

LayerWhen 'executable("fcitx")'

fu! fcitx#after()
  " 开启fcitx中英文切换
  fu! s:fcitx_support_on()
    let g:input_toggle = 1
    let s:timeoutlen = &timeoutlen
    set timeoutlen=300
    augroup Fcitx2En
      autocmd!
      autocmd InsertLeave * cal s:fcitx2en()
    augroup END
    if exists('g:fcitx#auto_switch_zh')
      augroup Fcitx2Zh
        autocmd!
        autocmd InsertEnter * cal s:fcitx2zh()
      augroup END
    en
  endf

  " 关闭fcitx中英文切换
  fu! s:fxitx_support_off()
    let &timeoutlen = s:timeoutlen
    augroup FcitxSupport
      autocmd!
    augroup END
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

  cal <sid>fcitx_support_on()
endf
