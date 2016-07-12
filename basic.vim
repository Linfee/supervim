""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This is the personal vimrc file of Linfee
" FILE:     basic.vim
" Author:   Linfee
" EMAIL:    Linfee@hotmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" >>> Enviroment {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 判断运行环境
silent function! IsOSX()
	return has("macunix")
endfunction
silent function! IsLinux()
	return has("unix") && !has('macunix') || has('win32unix')
endfunction
silent function! IsWin()
	return has('win32') || has('win64')
endfunction
silent function! IsGui()
	return has('gui_running')
endfunction


if IsWin()
	let $VIMFILES = $HOME.'/vimfiles'
else
	let $VIMFILES = $HOME.'/.vim'
endif

" 关闭vi兼容性
set nocompatible

" 处理编码问题，正确解决win(cmd,shell,gvim,解决绝大多数)和linux下的编码问题
set fileencoding=utf-8
set fileencodings=utf-8,chinese,latin1,gbk,big5,ucs-bom
if IsWin()
	if !IsGui()
		set termencoding=chinese
		"set fileencoding=chinese
		set langmenu=zh_CN.utf-8
		" 解决console输出乱码
		language messages zh_CN.gbk
	else
		set encoding=utf-8
		"set fileencodings=utf-8,chinese,latin-1
		"set fileencoding=chinese
		source $VIMRUNTIME/delmenu.vim
		source $VIMRUNTIME/menu.vim
		" 解决console输出乱码
		language messages zh_CN.utf-8
	endif
endif

if !exists("g:ideavim")
	" 使用vim-plug管理vim插件
	if filereadable(expand("$VIMFILES/supervim/plug.vim"))
		source $VIMFILES/supervim/plug.vim
		source $VIMFILES/supervim/plugins_config.vim
	else
		echo "Please use 'Call Init()' to init this cool vim"
	endif

	function! Init()
		if IsWin()
			silent execute "!md $VIMFILES\autoload"
			silent execute "!$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"
			silent execute "!(New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\vimfiles\supervim\plug.vim"))"
			silent execute "!mk $VIMFILES\temp"
			silent execute "!mk $VIMFILES\temp\undo"
			silent execute "!mk $VIMFILES\temp\backup"
			silent execute "!mk $VIMFILES\temp\view"
		else
			silent execute "!curl -fLo ~/.vim/supervim/plug.vim --create-dirs \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
			silent execute "!mkdir -p $VIMFILES/temp/{undo,backup,view}"
		endif
		source $VIMFILES/supervim/basic.vim
		silent execute "PlugInstall"
		vsplit $VIMFILES/custom.vim
		silent execute "wq"
	endfunction
endif
" }}}


" >>> General {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [general] 开启文件类型检测，并自动加载文件类型插件，自动缩进
filetype plugin on
filetype indent on

" [general] 设置光标能到达的虚拟位置
set virtualedit=

" [general] 定义单词结尾
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-
set iskeyword-=，
set iskeyword-=。

" [general] 让vim和系统能互相拷贝粘贴
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" [keymap] 设置 leader 键
let mapleader = ";"
let g:mapleader = ";"
let maplocalleader = "\\"

" [general] 快速编辑/保存vim配置文件
nnoremap <space>sv :source ~/.vimrc<cr>
 
" }}}


" >>> UI {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [edit] 搜索时候忽略大小写
set ignorecase

" [edit] 只能匹配大小写
set smartcase

" [edit] 高亮显示搜索结果
set hlsearch

" [edit] 使用增量查找
set incsearch 

" [view] 使用j/k的时候，光标到窗口的最小行数
set scrolloff=11

" [view] 允许终端使用鼠标，打字时隐藏鼠标
set mouse=a                 " 允许终端vim使用鼠标，所有模式
set mousehide               " 打字时候隐藏鼠标指针

" [view] 开启wild菜单
set wildmenu

" [view] 设置状态行的样式
if has('cmdline_info')
    " 显示光标当前位置
    set ruler
    " A ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
endif
if has('statusline')
    set laststatus=2
    set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
endif

" [view] 显示模式
set showmode

" [view] 最多打开的标签数目
set tabpagemax=10

" [view] 行号
set number

" [view] 循序隐藏缓冲区而不是卸载缓冲区
set hidden

" [view] 删除在插入模式可以删除的特殊内容
set backspace=eol,start,indent

" [view] 可以移动到的额外虚拟位置
set whichwrap+=<,>,h,l

" [view] 设置行间距
set linespace=0

" [view] 执行完宏之后不要立刻重绘
set lazyredraw 

" [view] 打开magic选项
set magic

" [view] 显示配对的括号，引号等
set showmatch 

" [view] 显示匹配括号，引号时光标的闪烁频率
set mat=2

" [view] 关掉错误声音
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" [view] 在左端添加额外一列
set foldcolumn=2

" [view] 设置窗口的最小高度
set winminheight=1

" [view] 光标离开屏幕时(比如j)，最小滚动的行数
set scrolljump=0

" [codestyle] 自动折叠
set foldenable

" [color] 开启语法高亮
syntax enable

" [color] 允许使用指定语法高亮配色方案代替默认方案
syntax on

" [view] 高亮主题
colorscheme molokai
" colorscheme zenburn

" [color] 设置背景色
set background=dark

" [view] 设置 gui 与 cli
if IsGui()
    " 设置窗口位置和大小
    winpos 85 100
    set lines=45 columns=120

    " 设置gui下标签内容
    set guitablabel=%M\ %t

    " 隐藏不需要的gui组件
	set guioptions-=m   " remove menu
	set guioptions-=T   " remove toolbar
	set guioptions-=L
	set guioptions-=r
	set guioptions-=b
	set guioptions-=e

    " [font] 设置字体
    if IsLinux()
        set guifont=Ubuntu\ Mono\ Regular\ 10,Source\ Code\ Pro\ Light\ 9
    elseif IsOSX()
        set guifont=Monaco:h10,YaHei\ Consolas\ Hybrid:h10
    elseif IsWin()
        set guifont=Source\ Code\ Pro:h11
    endif
else
    " 让箭头键和其它键能使用
    if !IsWin()
        set term=$TERM
        if &term == 'xterm' || &term == 'screen'
            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
            set t_Co=256
        endif
    endif
endif

" [view] 高亮列要匹配背景色
highlight clear SignColumn
" [view] 移除当前行号处的高亮色
highlight clear LineNr

" [view] 高亮显示当前行/列
set cursorline
" set cursorcolumn

" }}}


" >>> File backup undo view {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [file] 当文件被改变时自动载入
set autoread

" [file] 以sudo权限保存
if !IsWin()
    cnoremap W! !sudo tee % > /dev/null<cr>
    nnoremap <space>W :!sudo tee % > /dev/null
endif

" [file] 保存与退出
nnoremap <space>q :Bclose<cr>:tabclose<cr>gT
nnoremap <space>w :w<cr>

" [file] 文件类型(使用的结尾符号)
set fileformats=mac,unix,dos

" [file] 设置脚本的编码
scriptencoding utf-8

" [file] 快速编辑当前文件所在目录
cnoremap $c e <C-\>eCurrentFileDir("e")<cr>

" [file] 关闭备份
set nobackup
set nowritebackup

" [file] 退出需要确认
set confirm

" [file] 备份光标
function! BackupCursor()
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
endfunction

function! BackupFile()
    " [file] 备份文件
    set backup
    set backupdir=$VIMFILES/temp/backup
    set backupext=.__bak__
endfunction

" [file] 备份undo
function! BackupUndo()
    if has('persistent_undo')
        set undofile
        " 设置undofile的存储目录
        set undodir=$VIMFILES/temp/undo
        " 最大可撤销次数
        set undolevels=1000
        " Maximum number lines to save for undo on a buffer reload
        set undoreload=10000
    endif
endfunction

" [file] 备份view
function! BackupView()
    set viewoptions=folds,options,cursor,unix,slash
    set viewdir=$VIMFILES/temp/view
	augroup backupView
		autocmd!
		autocmd BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
		autocmd BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
	augroup END
    nnoremap <c-s-f12> :!find $VIMFILES/temp/view -mtime +30 -exec rm -a{} \;<cr>
    " TODO: let vim delete too old file auto
endfunction

call BackupCursor()
call BackupUndo()
" call BackupFile()
" call BackupView()

" }}}


" >>> Format {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动缩进
set autoindent
" 不要软换行
set nowrap

" 将制表符扩展为tab
" set expandtab
" 只能缩进
set smarttab
" 格式化时制表符占几个空格位置
set shiftwidth=4
" 编辑时制表符占几个空格位置
set tabstop=4
" 把连续的空格看做制表符
set softtabstop=4


" 防止连接行命令插入两个空格，see 'h joinspaces'
set nojoinspaces

" 下面2行，让分割窗口总是在右边或下打开
set splitright
set splitbelow 

set matchpairs+=<:>         " 设置形成配对的字符 
" TODO: 有空看看$VIMRUNTIME/macros 目录的 matchit.vim 插件

" 设置vim切换粘贴模式的快捷键，不能点击的终端下启用这行
set pastetoggle=<leader>pp

" 默认不要开启拼写检查
set nospell

" 一定长度的行以换行显示
set linebreak
set textwidth=500
" set wrapmargin=120

" [edit] 基于缩进或语法进行代码折叠
set foldmethod=marker
nnoremap <leader>af :set foldenable!<cr>
" }}}


" >>> Editing {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置换行符
augroup ff
	autocmd!
	autocmd FileType * setlocal ff=unix
augroup END
" [find] 快速关闭搜索高亮
noremap <silent> <leader><cr> :nohlsearch<cr>
noremap <silent> <space><cr> :nohlsearch<cr>

" [find] 搜索并替换所有
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
vnoremap <silent> <space>r :call VisualSelection('replace', '')<CR>


" [find] 查找合并冲突
nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
nnoremap <space>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" [find] 快速查找当前单词
nnoremap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
nnoremap <space>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" [spell] 切换拼写检查
noremap <leader>ss :setlocal spell!<cr>
noremap <space>ss :setlocal spell!<cr>
noremap <c-f11> :setlocal spell!<cr>
" [spell] 拼写检查功能
noremap <leader>sn ]s
noremap <space>sn ]s
noremap <leader>sp [s
noremap <space>sp [s
noremap <leader>sa zg
noremap <space>sa zg
noremap <leader>s? z=
noremap <space>s? z=

" [edit] 设置退出插入模式的快捷键
inoremap jk <esc>

" [edit] 将光标所在单词切换成大写/小写
nnoremap <c-u> g~iw
inoremap <c-u> <esc>g~iwea

" [edit] 删除当前行
inoremap x <c-o>dd
inoremap <M-x> <c-o>dd
inoremap ≈ <c-o>dd

" [edit] 使用<M-p>和<M-P>代替<C-n>和<C-p>进行补全
inoremap p <c-n>
inoremap <M-p> <c-n>
inoremap π <c-n>
"inoremap P <c-p>
"inoremap <M-P> <c-p>
"inoremap ∏ <c-p>

" [edit] 设置补全菜单给样式
set completeopt=longest,menu,preview

" [edit] 删除
inoremap <bs> <c-w>
inoremap <M-bs> <c-w>
inoremap <a-d> <c-w>
inoremap d <c-w>
inoremap ∂ <c-w>

" [edit] 更方便的表达式寄存器
inoremap <c-=> <c-r>=
inoremap = <c-r>=
inoremap <M-=> <c-r>=
inoremap ≠ <c-r>=

" [edit] 格式化
nnoremap <silent> <leader>q gwip

" [edit] 开关折叠
nnoremap - za
nnoremap _ zf

" 让Y表示复制到行尾巴
call yankstack#setup()
nmap Y y$

" [move] 更便捷的移动指令
nnoremap j gj
nnoremap k gk
nmap H ^
nmap L $
vmap H ^
vmap L $
" [move] j/k可以移动到软换行上
nnoremap j gj
nnoremap k gk

" [move] 快捷移动 nmap imap
inoremap j <Down>
inoremap <M-j> <Down>
inoremap ∆ <Down>

inoremap k <Up>
inoremap <M-k> <Up>
inoremap ˚ <Up>

inoremap l <Right>
inoremap <M-l> <Right>
inoremap ¬ <Right>

inoremap h <Left>
inoremap <M-h> <Left>
inoremap ˙ <Left>

inoremap m <S-Right>
inoremap <M-m> <S-Right>
inoremap µ <S-Right>
inoremap Â <S-Right>

inoremap n <S-Left>
inoremap <M-n> <S-Left>
inoremap ˜ <S-Left>

inoremap 0 <home>
inoremap <M-i> <home>
inoremap ˆ <home>

inoremap $ <end>
inoremap <M-o> <end>
inoremap Ø <end>
inoremap ø <end>

nnoremap <m-j> 10gj
nnoremap <m-k> 10gk
nnoremap j 10gj
nnoremap k 10gk
nnoremap ∆ 10gj
nnoremap ˚ 10gk
" }}}1


" >>> CMD {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [cmd] 设置命令行历史记录
set history=1000

" [cmd] 设置命令行模式补全模式
set wildmode=list:longest,full

" [cmd] 设置忽略补全的文件名
set wildignore=*.o,*~,*.pyc,*.class
if IsWin()
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
	set wildignore+=.git\*,.hg\*,.svn\*
endif

" [cmd] 命令行高度
set cmdheight=2

" [cmd] 快速进入命令行模式
nnoremap <M-s> :
nnoremap s :
nnoremap ß :
inoremap <M-s> <c-o>:
inoremap s <c-o>:
inoremap ß <c-o>:
vnoremap <M-s> :
vnoremap s :
vnoremap ß :

" }}}


" >>> vmap {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [v] 在Visual mode下使用*和#搜索选中的内容
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" [v] 用单双引号包围
vnoremap <leader>" <esc>a"<esc>`<i"<esc>`>w
vnoremap <leader>' <esc>a'<esc>`<i'<esc>`>w
vnoremap <leader>` <esc>a`<esc>`<i`<esc>`>w
vnoremap <leader>( <esc>a)<esc>`<i(<esc>`>w
vnoremap <leader>{ <esc>a}<esc>`<i{<esc>`>w
vnoremap <leader>[ <esc>a]<esc>`<i[<esc>`>w
vnoremap <leader>< <esc>a><esc>`<i<<esc>`>w

" [v] vmode下能连续使用 < >
vnoremap < <gv
vnoremap > >gv

" 【v] 允许使用 . 对选中的行执行上一个命令
vnoremap . :normal .<cr>

vnoremap ∆ 10j
vnoremap ˚ 10k

" [v] 切换行可视模式
nnoremap <leader><space> V
vnoremap <leader><space> V
nnoremap <space><space> V
vnoremap <space><space> V

" }}}


" >>> cmap {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap j <Down>
cnoremap <M-j> <Down>
cnoremap ∆ <Down>

cnoremap k <Up>
cnoremap <M-k> <Up>
cnoremap ˚ <Up>

cnoremap l <Right>
cnoremap <M-l> <Right>
cnoremap ¬ <Right>

cnoremap h <Left>
cnoremap <M-h> <Left>
cnoremap ˙ <Left>

cnoremap m <S-Right>
cnoremap <M-m> <S-Right>
cnoremap µ <S-Right>
cnoremap Â <S-Right>

cnoremap n <S-Left>
cnoremap <M-n> <S-Left>
cnoremap ˜ <S-Left>

cnoremap 0 <home>
cnoremap <M-i> <home>
cnoremap ˆ <home>

cnoremap $ <end>
cnoremap <M-o> <end>
cnoremap Ø <end>
cnoremap ø <end>

inoremap <bs> <c-w>
inoremap <M-bs> <c-w>
cnoremap <delete> <c-w>
cnoremap <c-d> <delete>

" }}}


" >>> Buffer Window Tab {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" buffer 和 window 的操作
nnoremap <tab><cr> <c-w>_
nnoremap <tab>= <c-w>=
nnoremap <tab>j <C-w>j
nnoremap <tab>k <C-w>k
nnoremap <tab>l <C-w>l
nnoremap <tab>h <C-w>h
nnoremap <tab>i :bprevious<cr>
nnoremap <tab>o :bnext<cr>
nnoremap <tab>q :Bclose<cr>:tabclose<cr>gT
nnoremap <tab>c :close<cr>
nnoremap <tab>b :execute "ls"<cr>
nnoremap <tab>- :split<cr>
nnoremap <tab>\| :vsplit<cr>
nnoremap <tab><up> <C-w>-
nnoremap <tab><down> <C-w>+
nnoremap <tab><left> <C-w><
nnoremap <tab><right> <C-w>>
" 关闭所有缓冲区
map <leader>Q :bufdo bd<cr>

" 标签操作
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>x :tabclose<cr>
nnoremap <tab>s :tabs<cr>
nnoremap <tab>f :tabfind<space>
nnoremap <tab>m :tabmove<space>
nnoremap <tab>} :tabfirst<cr>
nnoremap <tab>{ :tablast<cr>
nnoremap <tab>[ :tabprevious<cr>
nnoremap <tab>] :tabnext<cr>
nnoremap <tab>m :tabmove
nnoremap <tab>t :tabonly<cr> 
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

" }}}


" >>> Misc {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" [iabbrev]
iabbrev @@ Linfeee@gmail.com
iabbrev ccopy Copyright 2016 Linfeee Zhang, all rights reserved.
iabbrev ssig -- <cr>Linfee Zhang<cr>Linfeee@gmail.com
iabbrev xdate <c-r>=strftime("%Y/%d/%m %H:%M:%S")<cr>

" 去除Windows的 ^M 在编码混乱的时候
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
noremap <space>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" 一些有用的方法，该配置文件中使用过的
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
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
endfunction

" 如果paste模式打开的化返回true
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" 删除缓冲区不关闭窗口
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" 删除每行末尾的空白，对python使用
func! DeleteTrailingWhiteSpace()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc


if !exists("g:ideavim")

	" 按F5编译运行
	map <F5> :call Run()<CR>
	func! Run()
		exec "w"
		if &filetype == 'c'
			exec "!g++ % -o %<"
			exec "! ./%<"
		elseif &filetype == 'cpp'
			exec "!g++ % -o %<"
			exec "! ./%<"
		elseif &filetype == 'java' 
			exec "!javac %" 
			exec "!java %<"
		elseif &filetype == 'sh'
			:!./%
		elseif &filetype == 'groovy'
			exec "!groovy %"
		elseif &filetype == 'markdown' || &filetype == 'html'
			exec "silent !exec google-chrome % &"
			exec "redraw!"
		elseif &filetype == 'scala'
			exec "!scala -deprecation %" 
		endif
	endfunc
	"C,C++的调试
	map <F8> :call Rungdb()<CR>
	func! Rungdb()
		exec "w"
		exec "!g++ % -g -o %<"
		exec "!gdb ./%<"
	endfunc
endif

" }}}

