"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim
"

"  列参考线 {
" ReferenceLine('+') 右移参考线
" ReferenceLine('-') 左移参考线
" ReferenceLine('r') 移除参考线
function! ReferenceLine(t)
    if exists('w:ccnum')
        let ccnum=w:ccnum
    elsei exists('b:ccnum')
        let ccnum=b:ccnum
    else
        let ccnum=0
    endif
    let oldcc=ccnum
    " let ccc=&cc
    " ec oldcc
    let ccc=','.&cc.','
    " add/sub
    if a:t=='+' || a:t=='-'
        " check old cc
        if match(ccc, ','.oldcc.',')<0
            let oldcc=0
            let ccnum=0
        endif
        " step
        let csw=&sw
        if a:t=='add'
            let ccnum=ccnum + csw
        elsei a:t=='sub'
            let ccnum=ccnum - csw
            if ccnum < 0 | let ccnum=0 | endif
        endif
        if oldcc > 0 | let ccc=substitute(ccc, ','.oldcc.',', ',', '') | endif
        let ccc=ccc.ccnum
        " ec ccc
        " ec ccnum
        let ccc=substitute(ccc, '^0,\|,0,\|,0$', ',', 'g')
        let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
        " ec ccc
        let w:ccnum=ccnum
        let b:ccnum=ccnum
        exec "setl cc=".ccc
        " del
    elsei a:t=='r'
        let ccc=substitute(ccc, ','.oldcc.',', ',', '')
        let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
        " ec ccc
        let w:ccnum=0
        let b:ccnum=0
        exec "setl cc=".ccc
    endif
endf
" 外部接口，调用它来设置列参考线，0表示没有参考线
function! SetRL(n)
    if !exists('b:is_rl_added')
        call ReferenceLine('+')
        let &cc = 0
        let b:is_rl_added = 1
    endif
    let &cc = a:n
endfunction
" Bug: 新建立的缓冲区会继承之前的参考线
" 外部接口，删除列参考线
function! RemoveRL()
    if b:is_rl_added == 0
        return
    endif
    let &cc = 0
endfunction
" 自动添加80列参考线
augroup RL
    autocmd!
    autocmd FileType * call SetRL(81)
augroup END
" }

"  空格与制表转换 {
fu! ToggleTab(t)
    if a:t == 'tab'
        setl noet
        ret!
    elsei a:t == 'space'
        setl et
        ret
    en
endf
com! -nargs=0 ToSpace call ToggleTab('space')
com! -nargs=0 ToTab call ToggleTab('tab')
" }

" mybatis逆向工程 {
let g:mybatis_generate_core="none"
let g:driverPath="none"
func! MybatisGenerate()
    if g:mybatis_generate_core == "none" || g:driverPath == "none"
        echo "你必须设置 g:driverPath 和 g:mybatis_generate_core 才能运行该方法"
        return
    endif
    exe("!java -Xbootclasspath/a:" . g:driverPath . " -jar " . g:mybatis_generate_core . expand(" -configfile %") . " -overwrite")
endfunc
" }

" fcitx-support {
let g:input_toggle = 0
function! Fcitx2en()
   let s:input_status = system("fcitx-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx-remote -c")
   endif
endfunction

function! Fcitx2zh()
   let s:input_status = system("fcitx-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx-remote -o")
      let g:input_toggle = 0
   endif
endfunction

if IsLinux() && !exists('g:s_no_fcitx_vim')
    set timeoutlen=300
    augroup FcitxSupport
        autocmd!
        autocmd InsertLeave * call Fcitx2en()
        autocmd InsertEnter * call Fcitx2zh()
    augroup END
endif
" }

" translate operation {
nnoremap <space>t :set operatorfunc=<SID>Translate<cr>g@
vnoremap <space>t :<c-u>call <SID>Translate(visualmode())<cr>

py3 import translate

function! s:Translate(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " silent execute "grep! -R " . shellescape(@@) . " ."
    " echom @@
    py3 print(translate.query(vim.eval('@@')))
    " copen

    let @@ = saved_unnamed_register
endfunction
" }

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker nospell:
