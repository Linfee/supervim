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

" basic --------------------------------------------------------------------{{{1

" enviroment -----------------------{{{2
source ~/.vim/supervim/vlib.vim

set nocompatible
if !IsWin()
    set shell=/bin/sh
endif

" 在windows上使用~/.vim而不是~/vimfiles，为了更好的跨平台
if IsWin()
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
endif

" 处理中文编码
call EncodingForCn()

" ----------------------------------}}}2

" plugin ---------------------------{{{2
" 尝试加载预加载文件
let g:s_loaded_before = TryLoad('~/.vim/before.vim')

" 尝试加载插件配置文件
if !exists("g:noplugin")
    let g:s_loaded_plugins = TryLoad('~/.vim/supervim/plugins.vim', 1)
else
    let g:s_loaded_plugins = 0
endif

" 无插件检测
function! NoPlugin()
    return !exists('g:s_loaded_plugins') || exists('g:noplugin')
endfunction

" 开启文件类型检测
filetype plugin indent on
" ---------------------------------}}}2

" general ---------------------------{{{2
set virtualedit=onemore          " 设置光标能到达的虚拟位置
set history=1000                 " 设置命令行历史记录
call ShareClipboard()            " 让vim和系统共享剪切板
syntax on                        " 开启语法高亮
set shortmess+=filmnrxoOtT       " 不要出现 hit enter 的提示
set noshowmode                   " 不显示模式，让lightline显示
" set noswapfile                   " 不要使用swp文件做备份
set number                       " 现实绝对行号
" set relativenumber               " 显示相对行号
set hidden                       " 隐藏缓冲区而不是卸载缓冲区
set backspace=indent,eol,start   " 删除在插入模式可以删除的特殊内容
set laststatus=2                 " 最后一个窗口总之有状态行
set wildmenu                     " 命令行补全
set foldcolumn=2                 " 在左端添加额外折叠列
set winminheight=0               " 窗口的最小高度
set tabpagemax=15                " 最多打开的标签数目
set scrolljump=1                 " 光标离开屏幕时(比如j)，最小滚动的行数，这样看起来舒服
set scrolloff=15                 " 使用j/k的时候，光标到窗口的最小行数
set lazyredraw                   " 执行完宏之后不要立刻重绘
set linespace=0                  " 设置行间距
set whichwrap=b,s,h,l,<,>,[,]    " 可以移动到的额外虚拟位置
set autoread                     " 当文件被改变时自动载入
set cursorline                   " 高亮显示当前行
" set cursorcolumn                 " 高亮显示当前列
set cmdheight=2                  " 命令行高度
set fileformats=unix             " 文件类型(使用的结尾符号)
scriptencoding utf8              " 设置脚本的编码
" set confirm                      " 退出需要确认
set list
set magic

" 新的分割窗口总是在右边和下边打开
set splitright
set splitbelow

" 显示配对的括号，引号等，以及显示时光标的闪烁频率
set showmatch
set mat=2

" 关掉错误声音
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" 允许终端使用鼠标，打字时隐藏鼠标
set mouse=a
set mousehide

" 设置命令行模式补全模式
set wildmode=list:longest,full
" 设置忽略补全的文件名
set wildignore=*.o,*~,*.pyc,*.class

" 防止连接命令时，在 '.'、'?' 和 '!' 之后插入两个空格。如果 'cpoptions'
set nojoinspaces
if IsWin()
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" 定义单词结尾
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-
set iskeyword-=，
set iskeyword-=。

" 重新加载vimrc
call DoMap('nnore', 'sv', ':source ~/.vimrc<cr>')

" 备份光标
function! BackupCursor()
    if exists("g:s_backup_cursor")
        return
    endif
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
        " 编辑git commit时是一个例外
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END
    let g:s_backup_cursor = 1
endfunction

" 备份文件
function! BackupFile()
    if exists("g:s_backup_cursor")
        return
    endif
    set backup
    set backupdir=~/.vim/temp/backup
    set backupext=.__bak__
    let g:s_backup_fiie = 1
endfunction

" 备份undo
function! BackupUndo()
    if exists("g:s_backup_undo")
        return
    endif
    if has('persistent_undo')
        set undofile
        " 设置undofile的存储目录
        set undodir=~/.vim/temp/undo
        " 最大可撤销次数
        set undolevels=1000
        " Maximum number lines to save for undo on a buffer reload
        set undoreload=10000
    endif
    let g:s_backup_undo = 1
endfunction

" 备份view
function! BackupView()
    if exists("g:s_backup_view")
        return
    endif
    set viewoptions=folds,options,cursor,unix,slash
    set viewdir=~/.vim/temp/view
    augroup backupView
        autocmd!
        autocmd BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
        autocmd BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
    augroup END
    nnoremap <c-s-f12> :!find ~/.vim/temp/view -mtime +30 -exec rm -a{} \;<cr>
    " TODO: let vim delete too old file auto
    let g:s_backup_view = 1
endfunction

call BackupCursor() " 调用以自动恢复光标
call BackupUndo() " 调用以自动备份undo
" call BackupFile() " 调用以自动备份文件
" call BackupView() " 调用以自动备份view
" ---------------------------------}}}2

" }}}1

" format -------------------------------------------------------------------{{{1
set nowrap                       " 不要软换行
set autoindent                   " 自动缩进
set expandtab                    " 将制表符扩展为空格
set smarttab                     " 只能缩进
set shiftwidth=4                 " 格式化时制表符占几个空格位置
set tabstop=4                    " 编辑时制表符占几个空格位置
set softtabstop=4                " 把连续的空格看做制表符
set matchpairs+=<:>              " 设置形成配对的字符
set nospell                      " 默认不要开启拼写检查
set foldenable                   " 基于缩进或语法进行代码折叠

" 一定长度的行以换行显示
set linebreak
set textwidth=500
" set wrapmargin=120

set foldmethod=marker
nnoremap <f10> :set foldenable!<cr>

" }}}1

" look and feel ------------------------------------------------------------{{{1
set background=dark              " 设置背景色
set ignorecase                   " 搜索时候忽略大小写
set smartcase                    " 只能匹配大小写
set hlsearch                     " 高亮显示搜索结果
set incsearch                    " 使用增量查找
set gcr=a:block-blinkon0         " 让gui光标不要闪
highlight clear SignColumn       " 高亮列要匹配背景色
highlight clear LineNr           " 移除当前行号处的高亮色
highlight clear CursorLineNr     " 删掉当前行号上的高亮

if NoPlugin()
    colorscheme desert
endif

" 高亮某些特殊位置的特殊字符
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" 提亮一下光标行
hi CursorLine ctermbg=235   cterm=none

"  设置状态行的样式
if has('cmdline_info')
    set ruler                    " 显示光标当前位置
    " A ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
endif

if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    if !NoPlugin()
        set statusline+=%{fugitive#statusline()} " Git Hotness
    endif
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

" 设置 gui 与 cli
if IsGui()
    " 设置窗口位置和大小
    winpos 685 28
    set lines=47 columns=90
    " 设置gui下标签内容
    set guitablabel=%M\ %t
    " 隐藏不需要的gui组件
    set guioptions-=m   " remove menu
    set guioptions-=T   " remove toolbar
    set guioptions-=L
    set guioptions-=r
    set guioptions-=b
    set guioptions-=e
    " 设置字体
    if IsLinux()
        set guifont=SauceCodePro\ Nerd\ Font\ 11
    elseif IsWin()
        set guifont=Source_Code_Pro:h9
    else
        set guifont=SauceCodePro\ Nerd\ Font:h12
    endif
else
    " 让箭头键和其它键能使用
    if !IsWin() && !has('nvim')
        set term=$TERM
        if &term == 'xterm' || &term == 'screen'
            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            set t_Co=256
        endif
    endif
endif

" }}}1

" keymap -------------------------------------------------------------------{{{1
" 设置 leader 键
let mapleader = ";"
let maplocalleader = "\\"
call DoAltMap('nnore', ';', ';')    " 使用<a-;>来完成原来;的工作

" editing --------------------------{{{2
" 搜索替换
    " 搜索并替换所有
    call DoMap('vnore', 'r', ":call VisualSelection('replace', '')<CR>", ['<silent>'])
    " 不确认、非整词
    nnoremap <Leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
    " 不确认、整词
    nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
    " 确认、非整词
    nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
    " 确认、整词
    nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 快速关闭搜索高亮
call DoMap('nnore', '<cr>', ':nohlsearch<cr>', ['<silent>'])
" 查找并合并冲突
nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" 横向滚动
map zl zL
map zh zH
" 快速查找当前单词
nnoremap <leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" 快速切换拼写检查
noremap <c-f11> :setlocal spell!<cr>
" 拼写检查功能
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=
" 使用jk退出插入模式
inoremap jk <esc>
" 将光标所在单词切换成大写/小写
nnoremap <c-u> g~iw
inoremap <c-u> <esc>g~iwea
" 使用Y复制到行尾
nnoremap Y y$
" <a-x>删除当前行
call DoAltMap('inore', 'x', '<c-o>dd')
" 使用<a-p>代替<C-n>进行补全
call DoAltMap('inore', 'p', '<c-n>')
" 设置补全菜单样式
set completeopt=longest,menu,preview
" <a-d> 删除词
call DoAltMap('inore', 'd', '<c-w>')
call DoAltMap('cnore', 'd', '<c-w>')
" <alt-=> 使用表达式寄存器
call DoAltMap('inore', '=', '<c-r>=')
" 开关折叠
nnoremap - za
nnoremap _ zf
" [move] j/k可以移动到软换行上
nnoremap j gj
nnoremap k gk

" 一些跟行有关的一定命令对软换行的表现
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
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
endif

" 更快捷的移动命令
nmap H ^
nmap L $
vmap H ^
vmap L $
omap L $
omap H ^

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
" vmode下能连续使用 < >
vnoremap < <gv
vnoremap > >gv
" 允许使用 . 对选中的行执行上一个命令
vnoremap . :normal .<cr>
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

" 设置vim切换粘贴模式的快捷键，不能点击的终端启用
nnoremap <leader>tp :set paste!<cr>
" ----------------------------------}}}2

" file buffer tab and window -------{{{2
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

" ----------------------------------}}}2

" macro ----------------------------{{{2
" 使用alt+.快速重复上一个宏
call DoAltMap('nnore', '.', '@@')
" }}}2

" }}}1

" misc ---------------------------------------------------------------------{{{1

" ctags
if exists('g:has_ctags')
    set tags=./tags;/,~/.vimtags
    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
endif

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif

" [iabbrev]
iabbrev xdate <c-r>=strftime("%Y/%d/%m %H:%M:%S")<cr>
"  去除Windows的 ^M 在编码混乱的时候
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

function! Init()
    call MkdirIfNotExists("~/.vim/temp")
    call MkdirIfNotExists("~/.vim/temp/view")
    call MkdirIfNotExists("~/.vim/temp/undo")
    call MkdirIfNotExists("~/.vim/temp/backup")
    exe "PlugInstall"
    exe "quit"
    exe "quit"
endfunction

function! UpdateSupervim()
    exe "!cd ~/.vim/supervim && git pull"
endfunction

" }}}1

" plugin config ------------------------------------------------------------{{{1

" ------------------------exception {{{2
" for supervim with out plugin
if NoPlugin()
    " 尝试加载extesion
    let g:s_loaded_extesion = TryLoad('~/.vim/supervim/extesion.vim')
    " 尝试加载自定义vimrc
    let g:s_loaded_custom = TryLoad('~/.vim/custom.vim')
    " 尝试加载自定义的gvimrc
    let g:s_loaded_gvimrc = TryLoad('~/.vim/gvimrc.vim')
    finish
endif
" ----------------------------------}}}2

" Neocomplete {{{2
if isdirectory(expand('~/.vim/plugged/neocomplete.vim'))
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#enable_auto_delimiter = 1
    " let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1
    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " omni 补全配置 {{{3
    augroup omnif
        autocmd!
        autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        " python使用jedi
        autocmd FileType python setlocal omnifunc=jedi#completions
        " autocmd FileType python setlocal omnifunc=jedi#completions
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    augroup END
    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplete#use_vimproc = 1 " }}}3

    " 自动打开关闭弹出式的预览窗口 {{{3
    augroup AutoPopMenu
        autocmd!
        autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    augroup END
    set completeopt=menu,preview,longest "}}}3

    " 回车键插入当前的补全项
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
        " For no inserting <CR> key.
        return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction

    " <C-k> 补全snippet
    " <C-k> 下一个输入点
    imap <silent><expr><C-k> neosnippet#expandable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

    inoremap <expr><C-g> neocomplete#undo_completion()
    inoremap <expr><C-l> neocomplete#complete_common_string()
    "inoremap <expr><CR> neocomplete#complete_common_string()

    " 使用回车确认补全
    " shift加回车确认补全保存缩进
    inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

    function! CleverCr()
        if pumvisible()
            " if neosnippet#expandable()
            "     let exp = "\<Plug>(neosnippet_expand)"
            "     return exp . neocomplete#smart_close_popup()
            " else
            return neocomplete#smart_close_popup()
            " endif
        else
            return "\<CR>"
        endif
    endfunction

    imap <expr> <Tab> CleverTab()

    " 回车插入补全并保存缩进，或者展开snippet
    " imap <expr> <CR> CleverCr()
    " <C-h>,<BS> 关闭预览窗口并删除补全预览
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y> neocomplete#smart_close_popup()
    " 使用tab补全
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
    " 额外的快捷键
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    " inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

endif
" }}}2

" ultisnips {{{2
if isdirectory(expand('~/.vim/plugged/ultisnips'))
    " 定义snippet文件存放的位置
    let g:UltiSnipsSnippetsDir=expand("~/.vim/supervim/ultisnips")
    let g:UltiSnipsSnippetDirectories=["UltiSnips", "supervim/ultisnips"]

    " Trigger configuration.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsListSnippets="<c-tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"
    nnoremap <leader>au :UltiSnipsAddFiletypes<space>
    nnoremap <space>au :UltiSnipsAddFiletypes<space>

    " execute是一个命令，没有对应的方法，定义一个，在snippets中用
    function! EXE(e)
        execute(a:e)
    endfunction
endif
" }}}2

" jedi-vim {{{2
if isdirectory(expand('~/.vim/plugged/jedi-vim'))
    " jedi 补全快捷键, 有补全插件就不需要了
    " let g:jedi#completions_command = "<c-n>"
    " 跳转到定义(源码)
    let g:jedi#goto_command = "<leader>d"
    " 跳转到引入(import, 定义)
    let g:jedi#goto_assignments_command = "<leader>g"
    " 显示文档
    let g:jedi#documentation_command = "K"
    " 文档高度
    let g:jedi#max_doc_height = 15
    " 重命名
    let g:jedi#rename_command = "<leader>r"
    let g:jedi#usages_command = "<leader>n"
    " 在vim中打开模块(源码) :Pyimport
    " 自动初始化
    let g:jedi#auto_initialization = 1
    " 关掉jedi的补全样式，使用自定义的
    let g:jedi#auto_vim_configuration = 0
    " 输入点的时候自动补全
    let g:jedi#popup_on_dot = 1
    " 自动选中第一个
    " let g:jedi#popup_select_first = 0
    " 补全结束后自动关闭文档窗口
    let g:jedi#auto_close_doc = 1
    " 显示参数列表
    let g:jedi#show_call_signatures = 1
    " 延迟多久显示参数列表
    let g:jedi#show_call_signatures_delay = 300
    " 使用go to的时候使用tab而不是buffer
    let g:jedi#use_tabs_not_buffers = 1
    " 开启jedi补全
    let g:jedi#completions_enabled = 1
    " 指定使用go to使用split的方式，并指定split位置
    let g:jedi#use_splits_not_buffers = 'bottom'
    " 强制使用python3运行jedi
    " let g:jedi#force_py_version = 3
    " 自动完成from .. import ..
    let g:jedi#smart_auto_mappings = 1
endif
" }}}2

" nerdtree {{{2
if isdirectory(expand('~/.vim/plugged/nerdtree'))
    " 使用箭头表示文件夹折叠
    let g:NERDTreeDirArrowExpandable = '▶'
    let g:NERDTreeDirArrowCollapsible = '▼'
    let g:NERDTreeWinPos = "left"
    let g:NERDTreeWinSize = "35"
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeShowBookmarks=1
    let NERDTreeChDirMode=0
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    " 多个tab的nerdtree同步
    let g:nerdtree_tabs_synchronize_view = 1

    " Automatically find and select currently opened file in NERDTree
    let g:nerdtree_tabs_open_on_console_startup=0
    let g:nerdtree_tabs_open_on_gui_startup=0
    let g:nerdtree_tabs_open_on_new_tab=1

    let g:NERDTreeIndicatorMapCustom = {
                \ "Modified"  : "✹",
                \ "Staged"    : "✚",
                \ "Untracked" : "✭",
                \ "Renamed"   : "➜",
                \ "Unmerged"  : "═",
                \ "Deleted"   : "✖",
                \ "Dirty"     : "✗",
                \ "Clean"     : "✔︎",
                \ "Unknown"   : "?"
                \ }

    " NERDTress File highlighting
    function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
        exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
        exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    endfunction

    call NERDTreeHighlightFile('java'   , 'green'   , 'none' , 'green'   , '#151515')
    call NERDTreeHighlightFile('vim'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('md'     , 'blue'    , 'none' , '#3366FF' , '#151515')
    call NERDTreeHighlightFile('xml'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('config' , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('conf'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('json'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('html'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('styl'   , 'cyan'    , 'none' , 'cyan'    , '#151515')
    call NERDTreeHighlightFile('css'    , 'cyan'    , 'none' , 'cyan'    , '#151515')
    call NERDTreeHighlightFile('coffee' , 'Red'     , 'none' , 'red'     , '#151515')
    call NERDTreeHighlightFile('js'     , 'Red'     , 'none' , '#ffa500' , '#151515')
    call NERDTreeHighlightFile('python' , 'Magenta' , 'none' , '#ff00ff' , '#151515')

    nnoremap <leader>e :NERDTreeFind<CR>
    nnoremap <Leader>tn :NERDTreeTabsToggle<CR>
    call DoMap('nnore', 'n', ':NERDTreeTabsToggle<cr>')
    " 快速切换nerdtree到当前文件目录
    nnoremap <silent><leader>n :exec("NERDTree ".expand('%:h'))<CR>
endif
" }}}2

" nerdcommenter {{{2
if isdirectory(expand('~/.vim/plugged/nerdcommenter'))
    " Use compact syntax for prettified multi-line comments
    let g:NERDCompactSexyComs = 1
    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'
    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_java = 1
    " 添加自定义注释或者覆盖已有注释
    let g:NERDCustomDelimiters={
        \ 'python': { 'left': '#' },
        \ }
        " \ 'python': { 'left': '#', 'right': '#' }
    " 可以注释和反注释空行
    let g:NERDCommentEmptyLines = 1
    " 取消注释的时候去掉两端空格
    let g:NERDTrimTrailingWhitespace=1
    let g:NERDSpaceDelims=1
    let g:NERDRemoveExtraSpaces=1
endif
" }}}2

" tagbar {{{2
if isdirectory(expand('~/.vim/plugged/tagbar'))
    let g:tagbar_left=0
    let g:tagbar_width = 30
    let g:tagbar_zoomwidth = 0          " 缩放以使最长行可见
    let g:tagbar_show_visibility = 1    " 显示可见性
    let g:tagbar_iconchars = ['▶', '▼'] " 折叠字符

    nnoremap <leader>tt :TagbarToggle<cr>
    call DoMap('nnore', 't', ':TagbarToggle<cr>')
endif
" }}}2

" vim-expand-region {{{2
if isdirectory(expand('~/.vim/plugged/vim-expand-region'))
    vmap v <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)
endif
" }}}2

" vim-multiple-cursors {{{2
if isdirectory(expand('~/.vim/plugged/vim-multiple-cursors'))
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<c-[>'
    nnoremap <c-c> :call multiple_cursors#quit()<CR>
    call DoMap('nnore', '/', ':MultipleCursorsFind <c-r>/<cr>', ['<silent>'])
    call DoMap('vnore', '/', ':MultipleCursorsFind <c-r>/<cr>', ['<silent>'])

    " 和 neocomplete 整合{{{3
    " Called once right before you start selecting multiple cursors
    function! Multiple_cursors_before()
      if exists(':NeoCompleteLock')==2
        exe 'NeoCompleteLock'
      endif
    endfunction

    " Called once only when the multiple selection is canceled (default <Esc>)
    function! Multiple_cursors_after()
      if exists(':NeoCompleteUnlock')==2
        exe 'NeoCompleteUnlock'
      endif
    endfunction " }}}3
    " 多光标高亮样式 (see help :highlight and help :highlight-link)
    " highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
    " highlight link multiple_cursors_visual Visual
endif
" }}}2

" lightline {{{2
if isdirectory(expand('~/.vim/plugged/lightline.vim'))
    let g:lightline = {
                \ 'colorscheme': 'wombat',
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ]],
                \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
                \ },
                \ 'component_expand': {
                \   'syntastic': 'SyntasticStatuslineFlag',
                \ },
                \ 'component_type': {
                \   'syntastic': 'error',
                \ },
                \ 'subseparator': { 'left': '›', 'right': '‹' }
                \ }
    function! LightLineModified()
        return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunction

    function! LightLineReadonly()
        return &ft !~? 'help' && &readonly ? 'RO' : ''
    endfunction

    function! LightLineFugitive()
        try
            if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
                let mark = ''  " edit here for cool mark
                let branch = fugitive#head()
                return branch !=# '' ? mark.branch : ''
            endif
        catch
        endtry
        return ''
    endfunction

    function! LightLineFileformat()
        return winwidth(0) > 70 ? &fileformat : ''
    endfunction

    function! LightLineFiletype()
        return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
    endfunction

    function! LightLineFileencoding()
        return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
    endfunction

    function! LightLineMode()
        let fname = expand('%:t')
        return fname == '__Tagbar__' ? 'Tagbar' :
                    \ fname == '__Gundo__' ? 'Gundo' :
                    \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                    \ fname =~ 'NERD_tree' ? 'NERDTree' :
                    \ &ft == 'vimfiler' ? 'VimFiler' :
                    \ &ft == 'vimshell' ? 'VimShell' :
                    \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunction

    let g:tagbar_status_func = 'TagbarStatusFunc'

    function! TagbarStatusFunc(current, sort, fname, ...) abort
        let g:lightline.fname = a:fname
        return lightline#statusline(0)
    endfunction

endif
" }}}2

" vim-markdown {{{2
if isdirectory(expand('~/.vim/plugged/vim-markdown'))
    " 关掉它自带的折叠
    let g:vim_markdown_folding_disabled = 1
    "let g:vim_markdown_folding_style_pythonic = 1
    "let g:vim_markdown_folding_level = 2
    let g:vim_markdown_toc_autofit = 1
    let g:vim_markdown_emphasis_multiline = 0
    " 关闭语法隐藏，显示markdown源码而不要隐藏一些东西
    " let g:vim_markdown_conceal = 0
    " 代码块语法
    let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']
endif
" }}}2

" vim-shell {{{2
if isdirectory(expand('~/.vim/plugged/vimshell.vim'))
    nnoremap <space>s :VimShellTab<cr>
    nnoremap <space>d :VimShellPop<cr><esc>

    if has('win32') || has('win64')
      " Display user name on Windows.
      let g:vimshell_prompt = $USERNAME."% "
    else
      " Display user name on Linux.
      let g:vimshell_prompt = $USER."% "
    endif

    " Initialize execute file list.
    let g:vimshell_execute_file_list = {}
    call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python3'
    call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

    autocmd FileType vimshell
    \ call vimshell#altercmd#define('g', 'git')
    \| call vimshell#altercmd#define('i', 'iexe')
    \| call vimshell#altercmd#define('l', 'll')
    \| call vimshell#altercmd#define('ll', 'ls -l')
    \| call vimshell#altercmd#define('la', 'ls -lahk')
    \| call vimshell#altercmd#define('p', 'python3')
    \| call vimshell#hook#add('chpwd', 'my_chpwd', 'MyChpwd')

    function! MyChpwd(args, context)
      call vimshell#execute('ls')
    endfunction

    " 覆盖statusline
    let g:vimshell_force_overwrite_statusline=0
    augroup vim_shell
        autocmd!
        autocmd FileType vimshell :UltiSnipsAddFiletypes vimshell<cr>
    augroup END
endif
" }}}2

" vim-easy-align {{{2
if isdirectory(expand('~/.vim/plugged/vim-easy-align'))
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = {
    \ '>': { 'pattern': '>>\|=>\|>' },
    \ '/': {
    \     'pattern':         '//\+\|/\*\|\*/',
    \     'delimiter_align': 'l',
    \     'ignore_groups':   ['!Comment'] },
    \ ']': {
    \     'pattern':       '[[\]]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ ')': {
    \     'pattern':       '[()]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ 'd': {
    \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
    \     'left_margin':  0,
    \     'right_margin': 0
    \   }
    \ }
endif
" }}}2

" vim-surround {{{2
if isdirectory(expand('~/.vim/plugged/vim-surround'))
    vmap Si S(i_<esc>f)
" vim-surround常用快捷键
"Normal mode
"    ds  - delete a surrounding
"    cs  - change a surrounding
"    ys  - add a surrounding
"    yS  - add a surrounding and place the surrounded text on a new line + indent it
"    yss - add a surrounding to the whole line
"    ySs - add a surrounding to the whole line, place it on a new line + indent it
"    ySS - same as ySs

" Visual mode
"    s   - in visual mode, add a surrounding
"    S   - in visual mode, add a surrounding but place text on new line + indent it

" Insert mode
"    <CTRL-s> - in insert mode, add a surrounding
"    <CTRL-s><CTRL-s> - in insert mode, add a new line + surrounding + indent
"    <CTRL-g>s - same as <CTRL-s>
"    <CTRL-g>S - same as <CTRL-s><CTRL-s>
endif
" }}}2

" undotree {{{2
if isdirectory(expand('~/.vim/plugged/undotree'))
    nnoremap <leader>tu :UndotreeToggle<cr>
    nnoremap <space>u :UndotreeToggle<cr>
    let g:undotree_SetFocusWhenToggle=1
endif
" }}}2

" autopair {{{2
if isdirectory(expand('~/.vim/plugged/auto-pairs'))
    "  什么时候想自己写插件应该看看这个插件的源码
    let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'",'"':'"', '`':'`'}
    let g:AutoPairsShortcutToggle = '<leader>ta'
    if IsOSX()
        let g:AutoPairsShortcutFastWrap = 'å'
    elseif IsLinux() && !IsGui()
        let g:AutoPairsShortcutFastWrap = 'a'
    else
        let g:AutoPairsShortcutFastWrap = '<a-a>'
    endif
endif
" }}}2

" MatchTagAlways {{{2
if isdirectory(expand('~/.vim/plugged/MatchTagAlways'))
    let g:mta_use_matchparen_group = 1
    let g:mta_filetypes = {
                \ 'html' : 1,
                \ 'xhtml' : 1,
                \ 'xml' : 1,
                \}
endif
" }}}2

" Fugitive {{{2
if isdirectory(expand('~/.vim/plugged/vim-fugitive'))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
" }}}2

" rainbow {{{2
if isdirectory(expand('~/.vim/plugged/rainbow'))
    let g:rainbow_conf = {
        \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
        \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
        \   'operators': '_,_',
        \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
        \   'separately': {
        \       '*': {},
        \       'tex': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
        \       },
        \       'lisp': {
        \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
        \       },
        \       'vim': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
        \       },
        \       'html': {
        \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
        \       },
        \       'css': 0,
        \   }
        \}
    let g:rainbow_active = 1
    nnoremap <leader>tr :RainbowToggle<cr>
endif
" }}}2

" AutoCloseTag {{{2
if isdirectory(expand('~/.vim/plugged/HTML-AutoCloseTag'))
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nnoremap <Leader>tt <Plug>ToggleAutoCloseMappings
endif
" }}}2

" vim-json {{{2
if isdirectory(expand('~/.vim/plugged/vim-json'))
    nnoremap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
endif
" }}}2

" vim-javascript {{{2
if isdirectory(expand('~/.vim/plugged/vim-javascript'))
    " 语法高亮插件
    let g:javascript_plugin_jsdoc = 1
    " 为jsDoc开启语法高亮
    let g:javascript_plugin_ngdoc = 1
    " Enables some additional syntax highlighting for NGDocs
    let g:javascript_plugin_flow = 1
    " 按照语法折叠
    " set foldmethod=syntax

    let g:javascript_conceal_function       = "ƒ"
    let g:javascript_conceal_null           = "ø"
    let g:javascript_conceal_this           = "@"
    let g:javascript_conceal_return         = "⇚"
    let g:javascript_conceal_undefined      = "¿"
    let g:javascript_conceal_NaN            = "ℕ"
    let g:javascript_conceal_prototype      = "¶"
    let g:javascript_conceal_static         = "•"
    let g:javascript_conceal_super          = "Ω"
    let g:javascript_conceal_arrow_function = "⇒"
endif
" }}}2

" MarkdownPreview {{{2
if isdirectory(expand('~/.vim/plugged/markdown-preview.vim'))
    if IsOSX()
        let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
        " path to the chrome or the command to open chrome(or other modern browsers)
    elseif IsLinux()
        if executable('chrome')
            let g:mkdp_path_to_chrome = "chrome"
        elseif executable('chromium')
            let g:mkdp_path_to_chrome = "chromium"
        elseif executable('chromium-browser')
            let g:mkdp_path_to_chrome = "chromium-browser"
        endif
    endif
    " path to the chrome or the command to open chrome(or other modern browsers)

    let g:mkdp_auto_start = 0
    " set to 1, the vim will open the preview window once enter the markdown
    " buffer

    let g:mkdp_auto_open = 0
    " set to 1, the vim will auto open preview window when you edit the
    " markdown file

    let g:mkdp_auto_close = 1
    " set to 1, the vim will auto close current preview window when change
    " from markdown buffer to another buffer

    let g:mkdp_refresh_slow = 0
    " set to 1, the vim will just refresh markdown when save the buffer or
    " leave from insert mode, default 0 is auto refresh markdown as you edit or
    " move the cursor

    let g:mkdp_command_for_global = 0
    " set to 1, the MarkdownPreview command can be use for all files,
    " by default it just can be use in markdown file vim-instant-markdown
    if IsOSX()
        let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
    endif
endif
" }}}2

" vim-over {{{2
if isdirectory(expand('~/.vim/plugged/vim-over'))
    " <leader>rr快速执行替换预览
    nnoremap <leader>rr :OverCommandLine<cr>%s/
endif
" }}}2

" CtrlSF {{{2
if isdirectory(expand('~/.vim/plugged/ctrlsf.vim'))
    call DoAltMap('nnore', 'f', ':CtrlSF ')
    call DoMap('nnore', 'f', ':CtrlSFToggle<cr>')
endif
" }}}2

" FZF {{{2
if isdirectory(expand('~/.vim/plugged/fzf.vim'))
    if exists('g:s_has_fzf')
        " 这三个快捷键指定用什么方式打开选中的内容
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-x': 'split',
          \ 'ctrl-v': 'vsplit' }

        " Default fzf layout
        " - down / up / left / right
        let g:fzf_layout = { 'down': '~40%' }

        " In Neovim, you can set up fzf window using a Vim command
        let g:fzf_layout = { 'window': 'enew' }
        let g:fzf_layout = { 'window': '-tabnew' }

        " 自定义fzf的配色
        let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
          \ 'bg':      ['bg', 'Normal'],
          \ 'hl':      ['fg', 'Comment'],
          \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
          \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
          \ 'hl+':     ['fg', 'Statement'],
          \ 'info':    ['fg', 'PreProc'],
          \ 'prompt':  ['fg', 'Conditional'],
          \ 'pointer': ['fg', 'Exception'],
          \ 'marker':  ['fg', 'Keyword'],
          \ 'spinner': ['fg', 'Label'],
          \ 'header':  ['fg', 'Comment'] }

        " Enable per-command history.
        " CTRL-N and CTRL-P will be automatically bound to next-history and
        " previous-history instead of down and up. If you don't like the change,
        " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
        let g:fzf_history_dir = '~/.fzf-history'

        " 自定义命令选项
        " [Files] 使用Files命令时使用coderay来预览文件内容(http://coderay.rubychan.de/)
        let g:fzf_files_options =
          \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
        " [Buffers] 使用Buffers命令时如果可能的话自动跳到目标窗口，而不是新打开一个
        let g:fzf_buffers_jump = 1
        " [[B]Commits] 使用[B]Commit时自定义git log输出形式
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
        " [Tags] 生成tags文件的命令
        let g:fzf_tags_command = 'ctags -R'
        " [Commands] 使用Commands时候直接执行选中命令的快捷键
        let g:fzf_commands_expect = 'alt-enter, ctrl-x'

        " maps
        nmap <leader><tab> <plug>(fzf-maps-n)
        xmap <leader><tab> <plug>(fzf-maps-x)
        omap <leader><tab> <plug>(fzf-maps-o)
        " Insert mode completion
        imap <c-x><c-k> <plug>(fzf-complete-word)
        imap <c-x><c-f> <plug>(fzf-complete-path)
        imap <c-x><c-j> <plug>(fzf-complete-file-ag)
        imap <c-x><c-l> <plug>(fzf-complete-line)
        " Advanced customization using autoload functions
        " inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
        " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

        " status line
        if has('nvim')
            function! s:fzf_statusline()
              " Override statusline as you like
              highlight fzf1 ctermfg=161 ctermbg=251
              highlight fzf2 ctermfg=23 ctermbg=251
              highlight fzf3 ctermfg=237 ctermbg=251
              setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
            endfunction

            autocmd! User FzfStatusLine call <SID>fzf_statusline()
        endif
    endif

    nnoremap <leader>h  :Helptags<cr>
    nnoremap <leader>gf :GFiles?<cr>
    nnoremap <leader>gl :GFiles<cr>
    nnoremap <leader>gc :Commits<cr>
    nnoremap <leader>gb :VCommits<cr>
    nnoremap <leader>gg :Lines<cr>
    nnoremap <leader>G  :BLines<cr>
    nnoremap <leader>fs :Snippets<cr>
    nnoremap <leader>fm :Maps<cr>
    nnoremap <leader>fh :History<cr>
    nnoremap <leader>f: :History:<cr>
    nnoremap <leader>f/ :History/<cr>
    nnoremap <leader>ff :Ag<cr>
    nnoremap <leader>fb :Buffers<cr>
    call DoMap('nnore', 'o', ':Files<cr>')
    call DoMap('nnore', 'O', ':Files ')
    call DoMap('nnore', 'b', ':Buffers<cr>')
    call DoMap('nnore', 'a', ':Ag<cr>')
    call DoMap('nnore', 'l', ':Lines<cr>')
    " Files [PATH]    |  Files (similar to :FZF)
    " GFiles [OPTS]   |  Git files (git ls-files)
    " GFiles?         |  Git files (git status)
    " Buffers         |  Open buffers
    " Colors          |  Color schemes
    " Ag [PATTERN]    |  ag search result (ALT-A to select all, ALT-D to deselect all)
    " Lines [QUERY]   |  Lines in loaded buffers
    " BLines [QUERY]  |  Lines in the current buffer
    " Tags [QUERY]    |  Tags in the project (ctags -R)
    " BTags [QUERY]   |  Tags in the current buffer
    " Marks           |  Marks
    " Windows         |  Windows
    " Locate PATTERN  |  locate command output
    " History         |  v:oldfiles and open buffers
    " History:        |  Command history
    " History/        |  Search history
    " Snippets        |  Snippets (UltiSnips)
    " Commits         |  Git commits (requires fugitive.vim)
    " BCommits        |  Git commits for the current buffer
    " Commands        |  Commands
    " Maps            |  Normal mode mappings
    " Helptags        |  Help tags 1
    " Filetypes       |  File types
endif
" }}}2

" vim-autopep8 {{{2
if isdirectory(expand('~/.vim/plugged/vim-autopep8'))
    " 格式化完成后不要显示diff窗口
    let g:autopep8_disable_show_diff = 0
endif
" }}}2

" syntastic {{{2
if isdirectory(expand('~/.vim/plugged/syntastic'))
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 1
    let g:syntastic_enable_signs=1
    let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_aggregate_errors = 1 " 显示多个检查器的错误
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_javascript_checkers = ['jshint']
    " Don't warn on
    "   E121 continuation line indentation is not a multiple of four
    "   E128 continuation line under-indented for visual indent
    "   E711 comparison to None should be 'if cond is not None:'
    "   E301 expected 1 blank line, found 0
    "   E261 at least two spaces before inline comment
    "   E241 multiple spaces after ':'
    "   E124 closing bracket does not match visual indentation
    "   E126 continuation line over-indented for hanging indent
    "   E721 do not compare types, use 'isinstance()'
    let g:syntastic_python_flake8_args='--max-line-length=84'
endif
"}}}2

" textobj-user {{{2
if isdirectory(expand('~/.vim/plugged/vim-textobj-user'))
    call textobj#user#plugin('datetime', {
    \   'date': {
    \     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
    \     'select': ['ad', 'id'],
    \   },
    \ })
endif
"}}}2


" molokai {{{2
if isdirectory(expand('~/.vim/plugged/molokai'))
    let g:rehash256 = 1
    let g:molokai_original = 1

    colorscheme molokai
    " 定制补全菜单颜色
    " 补全菜单的前景和背景
    hi pmenu  guifg=#b6b6a6 guibg=#272823 ctermfg=250 ctermbg=233
    " 滚动条guibg
    hi pmenusbar  guifg=#a7a78f guibg=#151515 gui=none ctermfg=248 ctermbg=233 cterm=none
    " 滑块guibg
    hi pmenuthumb  guifg=#151515 guibg=#e16b11 gui=none ctermfg=233 ctermbg=166 cterm=none

endif
" }}}2

" }}}1

" others -------------------------------------------------------------------{{{1
" 尝试加载extension
let g:s_loaded_extension = TryLoad('~/.vim/supervim/extension.vim')
" 尝试加载自定义vimrc
let g:s_loaded_custom = TryLoad('~/.vim/custom.vim')
" 尝试加载自定义的gvimrc
let g:s_loaded_gvimrc = TryLoad('~/.vim/gvimrc.vim')
" }}}1

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{{,}}} fdm=marker nospell:
