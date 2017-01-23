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

" Group: environment supervim {{

function! vlib#Init() " 初始化，创建 ~/.vim/temp/{view, undo, backup}，PlugInstall {{2
    call MkdirIfNotExists("~/.vim/temp")
    call MkdirIfNotExists("~/.vim/temp/view")
    call MkdirIfNotExists("~/.vim/temp/undo")
    call MkdirIfNotExists("~/.vim/temp/backup")
    exe "PlugInstall"
    exe "quit"
    exe "quit"
endfunction " 2}}

function! vlib#UpdateSupervim() " {{2
    exe "!cd ~/.vim && git pull"
    source ~/.vim/vimrc
    echom "You'd better reopen your vim"
endfunction " 2}}

" }}

" 快速切换背景色 {{
silent fun! vlib#ToggleBG()
    let s:tbg = &background
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endf "}}

" 创建文件夹，如果文件夹不存在的化 {{
silent fun! vlib#MkdirIfNotExists(dir)
    if !isdirectory(expand(a:dir))
        call mkdir(expand(a:dir))
    endif
endf " }}

" Initialize NERDTree as needed {{
fun! vlib#NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endf " }}

" Strip whitespace {{
fun! vlib#StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endf " }}

" Run shell command {{
fun! vlib#RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
endf
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}

function! vlib#CmdLine(str) " {{
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction  " }}

function! vlib#HasPaste() " 如果paste模式打开的化返回true {{
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction " }}

func! vlib#DeleteTillSlash() " {{{
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc " }}}

func! vlib#DeleteTrailingWhiteSpace() " 删除每行末尾的空白，对python使用 {{
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc " }}

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:
