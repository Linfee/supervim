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

" Functions {{1

" 自定义一个leader键(不同于vim内置，是额外的一个)，使用提供的方法映射 {{2
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
endfunction " }}2

" 该函数用来映射所有的a-*映射以及a-s-*映射 {{
" 支持的映射如下表，key1指定*，operation指定要映射的操作，
" 另外还可以提供第key2，alt组合键之后的按键，以及可选的选项
" key1只能指定下面dict的key，而且value为' '的指定了也无效，最好不用，
" 虽然这是mac导致的(我的黑苹果)，但为了平台一致性，其它系统也取消了
" 简单说就是alt+e|n|i|c|u不要映射，alt+backspace或功能键也不要映射
" 如果指定key2应该指定为原有的样子，而不是表中的简写形式
" call DoAltMap('<prefix>', '<key1>', '<operaiton>', '<key2>', ['<silent>等'])
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
call DoAltMap('nnore', ';', ';')    " 使用<a-;>来完成原来;的工作

" editing --------------------------{{
" 搜索替换
" 搜索并替换所有
call DoMap('vnore', 'r', ":call VisualSelection('replace', '')<CR>", ['<silent>'])
" 非整词
nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

" 横向滚动
map zl zL
map zh zH

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
call DoMap('nnore', '<cr>', ':nohlsearch<cr>', ['<silent>'])
" <alt-=> 使用表达式寄存器
call DoAltMap('inore', '=', '<c-r>=')
" 使用<a-p>代替<C-n>进行补全
call DoAltMap('inore', 'p', '<c-n>')
" <a-x>删除当前行
call DoAltMap('inore', 'x', '<c-o>dd')
" <a-d> 删除词
call DoAltMap('inore', 'd', '<c-w>')
call DoAltMap('cnore', 'd', '<c-w>')

" 快捷移动
call DoAltMap('inore', 'j', '<down>')
call DoAltMap('inore', 'k', '<up>')
call DoAltMap('inore', 'h', '<left>')
call DoAltMap('inore', 'l', '<right>')
call DoAltMap('inore', 'm', '<s-right>')
call DoAltMap('inore', 'N', '<s-left>')
call DoAltMap('inore', 'o', '<end>')
call DoAltMap('inore', 'I', '<home>')
call DoAltMap('nnore', 'j', '10gj')
call DoAltMap('nnore', 'k', '10gk')

call DoAltMap('cnore', 'j', '<down>')
call DoAltMap('cnore', 'k', '<up>')
call DoAltMap('cnore', 'h', '<left>')
call DoAltMap('cnore', 'l', '<right>')
call DoAltMap('cnore', 'm', '<s-right>')
call DoAltMap('cnore', 'N', '<s-left>')
call DoAltMap('cnore', 'o', '<end>')
call DoAltMap('cnore', 'I', '<home>')

call DoAltMap('vnore', 'j', '10gj')
call DoAltMap('vnore', 'k', '10gk')

" alt-s进入命令行模式
call DoAltMap('nnore', 's', ':')
call DoAltMap('inore', 's', '<c-o>:')
call DoAltMap('vnore', 's', ':')

" 在Visual mode下使用*和#搜索选中的内容
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" 切换行可视模式
call DoMap("nnore", '<space>', 'V')
call DoMap("vnore", '<space>', 'V')

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

call DoAltMap('nnore', '1', '1gt')
call DoAltMap('nnore', '2', '2gt')
call DoAltMap('nnore', '3', '3gt')
call DoAltMap('nnore', '4', '4gt')
call DoAltMap('nnore', '5', '5gt')
call DoAltMap('nnore', '6', '6gt')
call DoAltMap('nnore', '7', '7gt')
call DoAltMap('nnore', '8', '8gt')
call DoAltMap('nnore', '9', '9gt')

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
call DoMap('nnore', 'q', ':close<cr>')
call DoMap('nnore', 'w', ':w<cr>')
" 以sudo权限保存
if !IsWin()
    cnoremap W! !sudo tee % > /dev/null<cr>
    call DoMap('nnore', 'W', ':!sudo tee % > /dev/null')
endif

" ----------------------------------}}

" macro ----------------------------{{
" 使用alt+.快速重复上一个宏
call DoAltMap('nnore', '.', '@@')
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
call DoMap('nnore', 'q', ':close<cr>')
call DoMap('nnore', 'w', ':w<cr>')

" ----------------------------------}}

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:
