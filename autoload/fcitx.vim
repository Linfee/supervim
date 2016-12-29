" 提供fcitx中英文自动切换功能

" 开启fcitx中英文切换
func fcitx#FcitxSupportOn()
    let s:timeoutlen = &timeoutlen
    set timeoutlen=300
    augroup FcitxSupport
        autocmd!
        autocmd InsertLeave * call fcitx#Fcitx2en()
        autocmd InsertEnter * call fcitx#Fcitx2zh()
    augroup END
endf

" 关闭fcitx中英文切换
func fcitx#FcitxSupportOff()
    let &timeoutlen = s:timeoutlen
    augroup FcitxSupport
        autocmd!
    augroup END
endf

" 切换fcitx到英文状态
func fcitx#Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endf

" 切换fcitx到中文状态
func fcitx#Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endf


