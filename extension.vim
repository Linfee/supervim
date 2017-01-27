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
com! -nargs=0 ToSpace call extension#ToggleTab('space')
com! -nargs=0 ToTab call extension#ToggleTab('tab')
" }

" mybatis逆向工程 {
" let g:extension#mybatis_generate_core="none"
" let g:extension#driverPath="none"
com! -nargs=0 MybatisGenerate call extension#MybatisGenerate()
" }

" fcitx-support {
let g:fcitx#no_fcitx_support = 1
if IsLinux()
    if !exists('g:fcitx#no_fcitx_support')
        call fcitx#FcitxSupportOn()
    endif
endif
" }

" translate operation {
nnoremap <space>t :set operatorfunc=translate#Translate<cr>g@
vnoremap <space>t :<c-u>call translate#Translate(visualmode())<cr>
" }

" backup {
call backup#BackupCursor() " 调用以自动恢复光标
call backup#BackupUndo() " 调用以自动备份undo
" call backup#BackupFile() " 调用以自动备份文件
" call backup#BackupView() " 调用以自动备份view
" }

" color preview for vim {
" ~/.vim/syntax/colorful.vim
" use syntax file from https://github.com/gko/vim-coloresque
command! -nargs=0 -bar ColorPreview exe 'w | syn include syntax/colorful.vim | e'
" }

" for workman layout normal mode {
command! -nargs=0 UseWorkman call workman#toWorkman()
command! -nargs=0 WorkmanToggle call workman#workmanToggle()
" }

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker nospell:
