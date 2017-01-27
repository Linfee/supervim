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

" Functions: {{1

" 这两个a2b的方法是用于在使用了b键盘布局的情况下想保持a键盘布局的快捷键位置 " {{2
" 注意：表示特殊键的字符串如 <space> <bs> <cr> 不要传递给这两个方法
let s:qwerty_layout =  'qwertyuiopasdfghjkl;zxcvbnmQWERTYUIOPASDFGHJKL:ZXCVBNM'
let s:workman_layout = 'qdrwbjfup;ashtgyneoizxmcvklQDRWBJFUP:ASHTGYNEOIZXMCVKL'
silent fun! Qwerty2Workman(qwerty_key) " <a-j> -> <a-n>
    let r = tr(a:qwerty_key, s:qwerty_layout, s:workman_layout)
    let r = substitute(r, 'm-', 'c-', '')
    let r = substitute(r, 'l-', 'm-', '')
    return r
endf
silent fun! Workman2Qwerty(qwerty_key) " <a-j> -> <a-y>
    let r = tr(a:qwerty_key, s:workman_layout, s:qwerty_layout)
    let r = substitute(r, 'c-', 'm-', '')
    let r = substitute(r, 'v-', 'c-', '')
    return r
endf " 2}}

" vim中有几个键很少用，例如普通模式的<space>，该函数可以把它们作为自定义leader定义映射 {{2
" 默认使用<space>作为leader，通过修改 g:customleader 的值来更改(需要在调用该函数前设置)
" 如果传入第四个参数，函数会忽略 g:customleader 的设置，使用第四个参数指定的leader，
" 如果希望执行unmap，指定第一个参数为相应的命令并让第三个参数为''即可
" 例: call DoCustomLeaderMap('nnoremap <silent>', '<cr>', ':nohlsearch<cr>')
"     call DoCustomLeaderMap('nnoremap <silent>', '<cr>', ':nohlsearch<cr>', '<tab>')
silent func! DoCustomLeaderMap(cmd, lhs, rhs, ...)
    let lhs = a:lhs
    let customleader = '<space>'
    if a:0 > 0
        let customleader = a:1
    elseif exists('g:customleader')
        let customleader = g:customleader
    endif
    if strlen(a:rhs) == 0 " 用于 umap
        exe a:cmd . ' ' . customleader . lhs
    else " 正常 map
        exe a:cmd . ' ' . customleader . lhs . ' ' . a:rhs
    endif
    " echom a:cmd . ' ' . customleader . lhs . ' ' . a:rhs
endf " 2}}

" 提供跨平台的<a-*>以及<a-s-*>映射，后者是可以转换为前者 {{2
" Arg: cmd 映射命令，如果有特殊参数，也一并算进来，例: 'nnoremap <buffer>'
" Arg: lhs 包含<a-*>的映射，作为map系列命令的lhs参数，对于<a-*>映射，map命令的该
"       参数在不同平台是不同的，该函数会将其转换为正确的参数使映射正常工作，用户
"       只需要使用传入<a-*>即可，*<a-*>*或包含多个<a-*>都是可以的，对于<a-s-j>其
"       实等效于<a-J>这里要求用户使用<a-J>，不要使用shift
" Arg: rhs 该参数会直接作为map系列命令的rhs参数，如果希望执行unmap，让该参数为''
" 例: call DoAltMap('nnoremap <buffer>', '<a-j>', '<down>')
"     call DoAltMap('nunmap <buffer>', '<a-j>', '')
let s:keys =      "abcdefghijklmnopqrtuvwxyzABCDEFGHIJKLMNOPQRsSTUVWXYZ-=[];'" . ',./_+{}:"<>?1234567890'
let s:alt_keys =  "å∫ ∂ ƒ©˙ ∆˚¬µ øπœ®† √∑≈¥ΩÅıÇÎ´Ï˝ÓˆÔÒÂ˜Ø∏Œ‰ßÍˇ¨◊„˛Á¸–≠“‘…æ" . '≤≥÷—±”’æÆ¯˘¿¡™£¢∞§¶•ªº'
silent func! DoAltMap(cmd, lhs, rhs)
    let lhs = a:lhs
    let m = match(lhs, '<a-.>')
    while m != -1
        let char = lhs[m+3]
        if IsOSX()
            let lhs = substitute(lhs, '<a-' . char . '>', tr(char, s:keys, s:alt_keys), '')
        elseif IsLinux() && !IsGui() " 大多数现代Linux终端，使用 
            let lhs = substitute(lhs, '<a-' . char . '>', "" . char, '')
        else " 其他情况，如win，linux gui，都可以原样映射
            break
        endif
        let m = match(lhs, '<a-.>')
    endw
    if strlen(a:rhs) == 0 " 用于 umap
        exe a:cmd . ' ' . lhs
    else " 正常 map
        exe a:cmd . ' ' . lhs . ' ' . a:rhs
    endif
    " echom a:cmd . ' ' . lhs . ' ' . a:rhs
endf
" 2}}

function! VisualSelection(direction, extra_filter) range " {{2
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
endfunction " }}2

function! Replace(confirm, wholeword, replace) " 替换函数 {{2
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
endfunction " }}2

" }}

" 设置 leader 键
let mapleader = ";"
let maplocalleader = "\\"
call DoAltMap('nnoremap', '<a-;>', ';') " 使用<a-;>来完成原来;的工作

" editing --------------------------{{
" 搜索替换
" 搜索并替换所有
call DoCustomLeaderMap('vnoremap <silent>', 'r', ":call VisualSelection('replace', '')<CR>")
" 非整词
nnoremap gR :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 整词
nnoremap grw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap grc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap grwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

" 横向滚动
nnoremap zl zL
nnoremap zh zH

" 快速切换拼写检查
noremap <c-f11> :setlocal spell!<cr>
" 拼写检查功能
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=
" 开关折叠
nnoremap - za
nnoremap _ zf
" 查找并合并冲突
nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" 快速查找当前单词
nnoremap <leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" 将光标所在单词切换成大写/小写
nnoremap <c-u> g~iw
inoremap <c-u> <esc>g~iwea
" 设置vim切换粘贴模式的快捷键，不能点击的终端启用
nnoremap <leader>tp :set paste!<cr>
" 去除Windows的 ^M 在编码混乱的时候
nnoremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" 快速关闭搜索高亮
call DoCustomLeaderMap('nnoremap <silent>', '<cr>', ':nohlsearch<cr>')
" <alt-=> 使用表达式寄存器
call DoAltMap('inoremap', '<a-=>', '<c-r>=')
" 使用<a-p>代替<C-n>进行补全
call DoAltMap('inoremap', '<a-p>', '<c-n>')
" <a-x>删除当前行
call DoAltMap('inoremap', '<a-x>', '<c-o>dd')
" <a-d> 删除词
call DoAltMap('inoremap', '<a-d>', '<c-w>')
call DoAltMap('cnoremap', '<a-d>', '<c-w>')

" 快捷移动
call DoAltMap('inoremap', '<a-j>', '<down>')
call DoAltMap('inoremap', '<a-k>', '<up>')
call DoAltMap('inoremap', '<a-h>', '<left>')
call DoAltMap('inoremap', '<a-l>', '<right>')
call DoAltMap('inoremap', '<a-m>', '<s-right>')
call DoAltMap('inoremap', '<a-N>', '<s-left>')
call DoAltMap('inoremap', '<a-o>', '<end>')
call DoAltMap('inoremap', '<a-i>', '<home>')
call DoAltMap('noremap', '<a-j>', '10gj')
call DoAltMap('noremap', '<a-k>', '10gk')

call DoAltMap('cnoremap', '<a-j>', '<down>')
call DoAltMap('cnoremap', '<a-k>', '<up>')
call DoAltMap('cnoremap', '<a-h>', '<left>')
call DoAltMap('cnoremap', '<a-l>', '<right>')
call DoAltMap('cnoremap', '<a-m>', '<s-right>')
call DoAltMap('cnoremap', '<a-N>', '<s-left>')
call DoAltMap('cnoremap', '<a-o>', '<end>')
call DoAltMap('cnoremap', '<a-I>', '<home>')

" alt-s进入命令行模式
call DoAltMap('nnoremap', '<a-s>', ':')
call DoAltMap('inoremap', '<a-s>', '<c-o>:')
call DoAltMap('vnoremap', '<a-s>', ':')

" 在Visual mode下使用*和#搜索选中的内容
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" 切换行可视模式
call DoCustomLeaderMap("nnoremap", '<space>', 'V')
call DoCustomLeaderMap("vnoremap", '<space>', 'V')

" 快速设置foldlevel
nnoremap <leader><f0> :set foldlevel=0<cr>
nnoremap <leader><f1> :set foldlevel=1<cr>
nnoremap <leader><f2> :set foldlevel=2<cr>
nnoremap <leader><f3> :set foldlevel=3<cr>
nnoremap <leader><f4> :set foldlevel=4<cr>
nnoremap <leader><f5> :set foldlevel=5<cr>
nnoremap <leader><f6> :set foldlevel=6<cr>
nnoremap <leader><f7> :set foldlevel=7<cr>
nnoremap <leader><f8> :set foldlevel=8<cr>
nnoremap <leader><f9> :set foldlevel=9<cr>

" 一些跟行有关的移动命令对软换行的表现
if !exists('g:s_wrapRelMotion')
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap <silent> $ :call WrapRelativeMotion("$")<CR>
    noremap <silent> <End> :call WrapRelativeMotion("$")<CR>
    noremap <silent> 0 :call WrapRelativeMotion("0")<CR>
    noremap <silent> <Home> :call WrapRelativeMotion("0")<CR>
    noremap <silent> ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap <silent> $ v:call WrapRelativeMotion("$")<CR>
    onoremap <silent> <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap <silent> $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <silent> <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <silent> 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <silent> <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <silent> ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
endif
" ----------------------------------}}

" file buffer tab and window -------{{
nnoremap <tab><cr> <c-w>_
nnoremap <tab>= <c-w>=
nnoremap <tab>j <C-w>j
nnoremap <tab>k <C-w>k
nnoremap <tab>l <C-w>l
nnoremap <tab>h <C-w>h
nnoremap <tab><up> <C-w>-
nnoremap <tab><down> <C-w>+
nnoremap <tab><left> <C-w><
nnoremap <tab><right> <C-w>>
nnoremap <tab>i :tabprevious<cr>
nnoremap <tab>o :tabnext<cr>
nnoremap <tab>{ :tabfirst<cr>
nnoremap <tab>} :tablast<cr>
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>q :close<cr>

nnoremap <tab>[ :bprevious<cr>
nnoremap <tab>] :bnext<cr>
nnoremap <tab>b :execute "ls"<cr>
nnoremap <tab>- :split<cr>
nnoremap <tab>\ :vsplit<cr>

nnoremap <tab>x :tabclose<cr>
nnoremap <tab>c :close<cr>
nnoremap <tab>s :tabs<cr>
nnoremap <tab>f :tabfind<space>
nnoremap <tab>m :tabmove<space>
nnoremap <tab>m :tabmove
nnoremap <tab>t :tabonly<cr> 

call DoAltMap('nnoremap', '<a-1>', '1gt')
call DoAltMap('nnoremap', '<a-2>', '2gt')
call DoAltMap('nnoremap', '<a-3>', '3gt')
call DoAltMap('nnoremap', '<a-4>', '4gt')
call DoAltMap('nnoremap', '<a-5>', '5gt')
call DoAltMap('nnoremap', '<a-6>', '6gt')
call DoAltMap('nnoremap', '<a-7>', '7gt')
call DoAltMap('nnoremap', '<a-8>', '8gt')
call DoAltMap('nnoremap', '<a-9>', '9gt')

" 关闭所有缓冲区
nnoremap <leader>Q :bufdo bd<cr>
" 切换当前和上一个标签
let g:lasttab = 1
nnoremap <tab><tab> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" 切换到当前打开buffer的目录
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
" 在一个新的标签中打开当前buffer的文件
map <tab>g :tabedit <c-r>=expand("%:p:h")<cr>/
" 指定在缓冲区间切换时的行为
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" 快速编辑
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <leader>ew :e %%
nnoremap <leader>es :sp %%
nnoremap <leader>ev :vsp %%
nnoremap <leader>et :tabe %%
" 切换工作目录到当前文件目录
cnoremap cwd lcd %:p:h
cnoremap cd. lcd %:p:h

" 保存与退出
call DoCustomLeaderMap('nnoremap', 'q', ':close<cr>')
call DoCustomLeaderMap('nnoremap', 'w', ':w<cr>')
" 以sudo权限保存
if !IsWin()
    cnoremap W! !sudo tee % > /dev/null<cr>
    call DoCustomLeaderMap('nnoremap', 'W', ':!sudo tee % > /dev/null')
endif

" ----------------------------------}}

" macro ----------------------------{{
" 使用alt+.快速重复上一个宏
call DoAltMap('nnoremap', '<a-.>', '@@')
" 关闭所有缓冲区
nnoremap <leader>Q :bufdo bd<cr>
" 切换当前和上一个标签
let g:lasttab = 1
nnoremap <tab><tab> :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" 切换到当前打开buffer的目录
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
" 在一个新的标签中打开当前buffer的文件
map <tab>g :tabedit <c-r>=expand("%:p:h")<cr>/
" 指定在缓冲区间切换时的行为
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" 快速编辑
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
nnoremap <leader>ew :e %%
nnoremap <leader>es :sp %%
nnoremap <leader>ev :vsp %%
nnoremap <leader>et :tabe %%
" 切换工作目录到当前文件目录
cnoremap cwd lcd %:p:h
cnoremap cd. lcd %:p:h

" 保存与退出
call DoCustomLeaderMap('nnoremap', 'q', ':close<cr>')
call DoCustomLeaderMap('nnoremap', 'w', ':w<cr>')

" ----------------------------------}}

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:
