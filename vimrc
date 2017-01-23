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

" Function: {{
let g:_t = {}
silent fun! TryLoad(file)
let filename = split(fnamemodify(a:file, ':t'), '\.')[-2]
if filereadable(expand(a:file))
    exe 'let g:_t.' . filename . ' = reltime()[1]'
    exe 'source '. expand(a:file)
    exe 'let g:_t.' . filename . ' = reltime()[1] - g:_t.' . filename
else
    exe 'let g:_t.' . filename . ' = 0'
endif
endf

" 处理编码问题，正确解决win(cmd,shell,gvim,解决绝大多数)和linux下的编码问题
silent fun! EncodingForCn()
    set encoding=utf8
    set fileencoding=utf8
    set fileencodings=utf8,chinese,latin1,gbk,big5,ucs-bom
    if IsWin()
        if !IsGui()
            " set fileencoding=chinese
            set termencoding=utf8
            " 解决console输出乱码
            " language messages zh_CN.utf-8
            language messages zh_CN.utf8
        else
            "set fileencodings=utf-8,chinese,latin-1
            "set fileencoding=chinese
            source $VIMRUNTIME/delmenu.vim
            source $VIMRUNTIME/menu.vim
            " 解决console输出乱码
            set langmenu=none
            language messages zh_CN.utf8
        endif
    endif
endf
"}}

call TryLoad('~/.vim/betterdefault.vim')

call TryLoad('~/.vim/before.vim')

call TryLoad('~/.vim/ui.vim')

" 处理中文编码
call EncodingForCn()

call TryLoad('~/.vim/keymap.vim')

call TryLoad('~/.vim/plugin.vim')

call TryLoad('~/.vim/extension.vim')
call TryLoad('~/.vim/custom.vim')
call TryLoad('~/.vim/gvimrc.vim')

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:
