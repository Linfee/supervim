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

" 处理编码问题，正确解决win(cmd,shell,gvim,解决绝大多数)和linux下的编码问题 {{
silent fun! EncodingForCn()
    set fileencoding=utf8
    set fileencodings=utf8,chinese,latin1,gbk,big5,ucs-bom
    if IsWin()
        if !IsGui()
            set termencoding=chinese
            "set fileencoding=chinese
            set langmenu=zh_CN.utf8
            " 解决console输出乱码
            language messages zh_CN.gbk
        else
            set encoding=utf8
            "set fileencodings=utf-8,chinese,latin-1
            "set fileencoding=chinese
            source $VIMRUNTIME/delmenu.vim
            source $VIMRUNTIME/menu.vim
            " 解决console输出乱码
            language messages zh_CN.utf8
        endif
    endif
endf " }}

" 自定义一个leader键(不同于vim内置，是额外的一个)，使用提供的方法映射 {{
" 仅用于supervim
let g:leadercustom = "<space>"
" 该函数用来快捷定义使用 g:leadercustom 的映射，参照下面的调用使用
" 第四个参数是使用临时定义的 leadercustom 代替 g:leadercustom
" call DoMap('nnore', '<cr>', ':nohlsearch<cr>', ['<silent>'], '<enter>')
function! DoMap(prefix, key, operation, ...)
    let s:c = a:prefix
    let key_prefix = exists('g:leadercustom') ? g:leadercustom : '<space>'
    if s:c !~ "map"
        let s:c = s:c . 'map'
    endif
    " 添加第一个可选参数，接受数组，常传入['<slient>', '<buffer>']等
    if a:0 > 0
        for n in a:1
            let s:c = s:c . ' ' . n
        endfor
    endif
    " 添加第二个可选参数，用于映射不是<space>打头的映射
    if a:0 > 1
        let key_prefix = a:2
    endif
    let s:c = s:c . ' ' . key_prefix . a:key . ' ' . a:operation
    " echo s:c
    exe s:c
endfunction " }}

" 该函数用来映射所有的a-*映射以及a-s-*映射 {{
" 支持的映射如下表，key1指定*，operation指定要映射的操作，
" 另外还可以提供第key2，alt组合键之后的按键，以及可选的选项
" key1只能指定下面dict的key，而且value为' '的指定了也无效，最好不用，
" 虽然这是mac导致的(我的黑苹果)，但为了平台一致性，其它系统也取消了
" 简单说就是alt+e|n|i|c|u不要映射，alt+backspace或功能键也不要映射
" 如果指定key2应该指定为原有的样子，而不是表中的简写形式
" call DoAltMap('<prefix>', '<key1>', '<operaiton>', '<key2>', ['<silent>等'])
set cpo&vim
silent fun! DoAltMap(prefix, key1, operation, ...)

    let s:c = a:prefix
    if s:c !~ "map"
        let s:c = s:c . 'map'
    endif
    if a:0 > 1 " 添加<silent>等选项
        for n in a:2
            let s:c = s:c . ' ' . n
        endfor
    endif
    if IsOSX()
        let s:d = { 'a': 'å', 'A': 'Å', 'b': '∫', 'B': 'ı', 'c': ' ', 'C': 'Ç',
                  \ 'd': '∂', 'D': 'Î', 'e': ' ', 'E': '´', 'f': 'ƒ', 'F': 'Ï',
                  \ 'g': '©', 'G': '˝', 'h': '˙', 'H': 'Ó', 'i': ' ', 'I': 'ˆ',
                  \ 'j': '∆', 'J': 'Ô', 'k': '˚', 'K': '', 'l': '¬', 'L': 'Ò',
                  \ 'm': 'µ', 'M': 'Â', 'n': ' ', 'N': '˜', 'o': 'ø', 'O': 'Ø',
                  \ 'p': 'π', 'P': '∏', 'q': 'œ', 'Q': 'Œ', 'r': '®', 'R': '‰',
                  \ 's': 'ß', 'S': 'Í', 't': '†', 'T': 'ˇ', 'u': ' ', 'U': '¨',
                  \ 'v': '√', 'V': '◊', 'w': '∑', 'W': '„', 'x': '≈', 'X': '˛',
                  \ 'y': '¥', 'Y': 'Á', 'z': 'Ω', 'Z': '¸', '-': '–', '_': '—',
                  \ '=': '≠', '+': '±', '[': '“', '{': '”', ']': '‘', '}': '’',
                  \ ';': '…', ':': 'æ', "'": 'æ', '"': 'Æ', ',': '≤', '<': '¯',
                  \ '.': '≥', '>': '˘', '/': '÷', '?': '¿', '1': '¡', '2': '™',
                  \ '3': '£', '4': '¢', '5': '∞', '6': '§', '7': '¶', '8': '•',
                  \ '9': 'ª', '0': 'º'}
        if has_key(s:d, a:key1)
            let s:c = s:c . ' ' . get(s:d, a:key1)
        else
            return
        endif
    elseif IsLinux() && !IsGui()
        let s:c = s:c . ' ' . a:key1
    else
        let s:c = s:c . ' <a-'
        let s:c = s:c . a:key1
        let s:c = s:c . '>'
    endif

    if a:0 > 0 " 如果有别的键也加上
        let s:c = s:c . a:1
    endif
    let s:c = s:c . ' ' . a:operation
    exe s:c
endf " }}

" 尝试加载文件 {{
silent fun! TryLoad(file, ...)
    let filename = split(fnamemodify(a:file, ':t'), '\.')[-2]
    if filereadable(expand(a:file))
        exe 'let g:t.' . filename . ' = reltime()[1]'
        exe('source '. expand(a:file))
        exe 'let g:t.' . filename . ' = reltime()[1] - g:t.' . filename
    else
        exe 'let g:t.' . filename . ' = 0'
    endif
endf "}}

" 快速切换背景色 {{
silent fun! ToggleBG()
    let s:tbg = &background
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endf "}}

" 创建文件夹，如果文件夹不存在的化 {{
silent fun! MkdirIfNotExists(dir)
    if !isdirectory(expand(a:dir))
        call mkdir(expand(a:dir))
    endif
endf " }}

" Initialize NERDTree as needed {{
fun! NERDTreeInitAsNeeded()
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
fun! StripTrailingWhitespace()
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
fun! RunShellCommand(cmdline)
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

function! CmdLine(str) " {{
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction  " }}

function! HasPaste() " 如果paste模式打开的化返回true {{
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction " }}

func! DeleteTillSlash() " {{{
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

func! DeleteTrailingWhiteSpace() " 删除每行末尾的空白，对python使用 {{
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc " }}

function! VisualSelection(direction, extra_filter) range " {{
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction "}}

function! Replace(confirm, wholeword, replace) " 替换函数 {{
    " 替换函数。参数说明：
    " confirm：是否替换前逐一确认
    " wholeword：是否整词匹配
    " replace：被替换字符串
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction " }}

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:
