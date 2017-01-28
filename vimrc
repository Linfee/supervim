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

" Function: {{1
" 尝试加载vim脚本 {{2
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
endf " 2}}

" 处理编码问题，正确解决win(cmd,shell,gvim,解决绝大多数)和linux下的编码问题 2{{
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
endf " 2}}

" Init，download plug.vim, mkdir ~/.vim/temp/{view, undo, backup}，PlugInstall {{2
function! Init()
    if IsWin()
        !md ~\vimfiles\autoload
        !$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        !(New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\.vim\autoload\plug.vim"))
    else
        !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
    call MkdirIfNotExists("~/.vim/temp")
    call MkdirIfNotExists("~/.vim/temp/view")
    call MkdirIfNotExists("~/.vim/temp/undo")
    call MkdirIfNotExists("~/.vim/temp/backup")
    exe "PlugInstall"
    exe "quit"
    exe "quit"
endfunction " 2}}

function! UpdateSupervim() " {{2
    exe "!cd ~/.vim && git pull"
    source ~/.vim/vimrc
    echom "You'd better reopen your vim!"
endfunction " 2}}
" 1}}

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
