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

" Function {{
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
endf "}}

call TryLoad('~/.vim/betterdefault.vim')

call TryLoad('~/.vim/before.vim')

call TryLoad('~/.vim/ui.vim')

call backup#BackupCursor() " 调用以自动恢复光标
call backup#BackupUndo() " 调用以自动备份undo
" call backup#BackupFile() " 调用以自动备份文件
" call backup#BackupView() " 调用以自动备份view

" 处理中文编码
call vlib#EncodingForCn()

call TryLoad('~/.vim/keymap.vim')

call TryLoad('~/.vim/plugin.vim')

call TryLoad('~/.vim/extension.vim')
call TryLoad('~/.vim/custom.vim')
call TryLoad('~/.vim/gvimrc.vim')

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:
