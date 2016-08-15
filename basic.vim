" | |   _        ___                 _
" | |  (_)_ __  / _/___ ___  __   __(_)_ __ ___  _ __ ___
" | |  | | '_ \| |_/ _ \ _ \ \ \ / /| | '_ ` _ \| '__/ __|
" | |__| | | | |  _| __/ __/  \ V / | | | | | | | | | (__
" |____|_|_| |_|_| \___\___|   \_/  |_|_| |_| |_|_|  \___|
"
" Author: Linfee
" REPO:
"
" basic --------------------------------------------------------------------{{{1
" enviroment -----------------------{{{2
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
" ----------------------------------}}}2

" plugin ---------------------------{{{2
if filereadable(expand("$VIMFILES/supervim/plug.vim"))
	source $VIMFILES/supervim/plug.vim
endif
if !exists("g:ideavim")
	call plug#begin('~/.vim/plugged')
	" language support
	Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
	Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
	Plug 'klen/python-mode', { 'for': 'python' }
	Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
	Plug 'Valloric/MatchTagAlways'

	Plug 'scrooloose/nerdtree'
	Plug 'jistr/vim-nerdtree-tabs'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'scrooloose/nerdcommenter'
	Plug 'majutsushi/tagbar'
	Plug 'kshenoy/vim-signature'
	Plug 'mbbill/undotree'

    Plug 'Shougo/neocomplete.vim'
	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
	Plug 'ujihisa/neco-look'

	Plug 'Shougo/vimproc.vim'
	Plug 'Shougo/vimshell.vim'
	Plug 'Shougo/unite.vim'
	Plug 'Shougo/unite-outline'
	Plug 'Shougo/vimfiler.vim'
	Plug 'ujihisa/unite-colorscheme'

	Plug 'mhinz/vim-startify' " 启动画面
	Plug 'itchyny/lightline.vim'
	Plug 'Yggdroot/indentLine' " 缩进可视化
	Plug 'altercation/vim-colors-solarized'
	Plug 'tomasr/molokai'
	Plug 'jnurmine/Zenburn'
    Plug 'maxbrunsfeld/vim-yankstack'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	Plug 'godlygeek/tabular'
	Plug 'jiangmiao/auto-pairs'
	Plug 'terryma/vim-expand-region'
	Plug 'easymotion/vim-easymotion'
	Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tacahiroy/ctrlp-funky' "A simple function navigator for ctrlp
	Plug 'tpope/vim-fugitive'
	Plug 'vim-scripts/EasyGrep'
	Plug 'Konfekt/FastFold'
    Plug 'vim-scripts/sessionman.vim'

	Plug 'ryanoasis/vim-devicons'
	Plug 'strom3xFeI/vimdoc-cn'

	call plug#end()
endif

" 开启文件类型检测
filetype plugin indent on
" ---------------------------------}}}2

" 自定义一个leader键(不同于vim内置，是额外的一个)，使用提供的方法映射 {{{2
let g:leadercustom = "<space>"
" 该函数用来快捷定义使用 g:leadercustom 的映射，参照下面的调用使用
" 第四个参数是使用临时定义的 leadercustom 代替 g:leadercustom
" call DoMap('nnore', '<cr>', ':nohlsearch<cr>', '', ['<silent>'])
function! DoMap(prefix, key, operation, ...)
	let s:c = a:prefix
	let key_prefix = exists('g:leadercustom') ? g:leadercustom : '<space>'
	if a:0 > 0
		let	key_prefix = a:1
	endif
	if s:c !~ "map"
		let s:c = s:c . 'map'
	endif
	if a:0 > 1
		for n in a:2
			let s:c = s:c . ' ' . n
		endfor
	endif
	let s:c = s:c . ' ' . key_prefix . a:key . ' ' . a:operation
	" echo s:c
	exe s:c
endfunction
" }}}2

" 该函数用来映射所有的a-*映射以及a-s-*映射 {{{2
" 支持的映射如下表，key1指定*，operation指定要映射的操作，
" 另外还可以提供第key2，alt组合键之后的按键，以及可选的选项
" key1只能指定下面dict的key，而且value为' '的指定了也无效，最好不用，
" 虽然这是mac导致的(我的黑苹果)，但为了平台一致性，其它系统也取消了
" 简单说就是alt+e|n|i|c|u不要映射，alt+backspace或功能键也不要映射
" 如果指定key2应该指定为原有的样子，而不是表中的简写形式
" call DoAltMap('<prefix>', '<key1>', '<operaiton>', '<key2>', ['<silent>等'])
function! DoAltMap(prefix, key1, operation, ...)
	let d = { 'a': 'å', 'A': 'Å', 'b': '∫', 'B': 'ı', 'c': ' ', 'C': 'Ç',
			 \'d': '∂', 'D': 'Î', 'e': ' ', 'E': '´', 'f': 'ƒ', 'F': 'Ï',
			 \'g': '©', 'G': '˝', 'h': '˙', 'H': 'Ó', 'i': ' ', 'I': 'ˆ',
			 \'j': '∆', 'J': 'Ô', 'k': '˚', 'K': '', 'l': '¬', 'L': 'Ò',
			 \'m': 'µ', 'M': 'Â', 'n': ' ', 'N': '˜', 'o': 'ø', 'O': 'Ø',
			 \'p': 'π', 'P': '∏', 'q': 'œ', 'Q': 'Œ', 'r': '®', 'R': '‰',
			 \'s': 'ß', 'S': 'Í', 't': '†', 'T': 'ˇ', 'u': ' ', 'U': '¨',
			 \'v': '√', 'V': '◊', 'w': '∑', 'W': '„', 'x': '≈', 'X': '˛',
			 \'y': '¥', 'Y': 'Á', 'z': 'Ω', 'Z': '¸', '-': '–', '_': '—',
			 \'=': '≠', '+': '±', '[': '“', '{': '”', ']': '‘', '}': '’',
			 \';': '…', ':': 'æ', "'": 'æ', '"': 'Æ', ',': '≤', "<": '¯',
			 \'.': '≥', ">": '˘', '/': '÷', "?": '¿', }
	
	let s:c = a:prefix
	if s:c !~ "map"
		let s:c = s:c . 'map'
	endif
	if a:0 > 1 " 添加<silent>等选项
		for n in a:2
			let s:c = s:c . ' ' . n
		endfor
	endif
	if !has_key(d, a:key1)
		let s:c = s:c . ' ' . a:key1
	else
		if IsOSX() 
			let s:c = s:c . ' ' . get(d, a:key1)
		elseif IsLinux() && IsGui()
			let s:c = s:c . ' ' . a:key1
		else
			let s:c = s:c . ' <a-'
			let s:c = s:c . a:key1
			let s:c = s:c . '>'
		endif
	endif
	if a:0 > 0 " 如果有别的键也加上
		let s:c = s:c . a:1
	endif
	let s:c = s:c . ' ' . a:operation
	exe s:c
endfunction
" }}}2

" 设置光标能到达的虚拟位置
set virtualedit=
" 让vim和系统共享剪切板
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" 允许终端使用鼠标，打字时隐藏鼠标
set mouse=a
set mousehide
" 命令行不全
set wildmenu
" 不显示模式，让lightline显示
set noshowmode
" 不要使用swp文件做备份
" set noswapfile
" 显示绝对行号和相对行号
" set relativenumber
set number
" 隐藏缓冲区而不是卸载缓冲区
set hidden
" 删除在插入模式可以删除的特殊内容
set backspace=indent,eol,start
set magic
" 最后一个窗口总之有状态行
set laststatus=2
" 显示配对的括号，引号等，以及显示时光标的闪烁频率
set showmatch 
set mat=2
" 关掉错误声音
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" 在左端添加额外折叠列
set foldcolumn=2
" 窗口的最小高度
set winminheight=0
" 光标离开屏幕时(比如j)，最小滚动的行数，这样看起来舒服
set scrolljump=0
" 执行完宏之后不要立刻重绘
set lazyredraw 
" 开启语法高亮
syntax enable
" 设置行间距
set linespace=0
" 最多打开的标签数目
" set tabpagemax=10
" 可以移动到的额外虚拟位置
set whichwrap=b,s,h,l,<,>,[,]
" 开启语法高亮
syntax on
" 当文件被改变时自动载入
set autoread
" 高亮显示当前行/列
set cursorline
" set cursorcolumn
" 设置命令行历史记录
set history=1000
" 命令行高度
set cmdheight=2
" 设置命令行模式补全模式
set wildmode=list:longest,full
" 设置忽略补全的文件名
set wildignore=*.o,*~,*.pyc,*.class
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" 使用连接命令时，在 '.'、'?' 和 '!' 之后插入两个空格。如果 'cpoptions'
set nojoinspaces
" 新的分割窗口总是在右边和下边打开
set splitright
set splitbelow
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
" 设置 leader 键
let mapleader = ";"
let g:mapleader = ";"
let maplocalleader = "\\"
" }}}1

" format -------------------------------------------------------------------{{{1
" 自动缩进
set autoindent
" 不要软换行
set nowrap
" 将制表符扩展为tab
set expandtab
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

" 默认不要开启拼写检查
set nospell

" 一定长度的行以换行显示
set linebreak
set textwidth=500
" set wrapmargin=120

" 基于缩进或语法进行代码折叠
set foldenable
set foldmethod=marker
nnoremap <leader>af :set foldenable!<cr>

" 设置vim切换粘贴模式的快捷键，不能点击的终端启用
set pastetoggle=<leader>pp
" }}}1

" look and feel ------------------------------------------------------------{{{1
" 搜索时候忽略大小写
set ignorecase
" 只能匹配大小写
set smartcase
" 最多15个标签
set tabpagemax=15
" 高亮显示搜索结果
set hlsearch
" 使用增量查找
set incsearch 
" 使用j/k的时候，光标到窗口的最小行数
set scrolloff=11
"  设置状态行的样式
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
" 让gui光标不要闪
set gcr=a:block-blinkon0
" 高亮主题
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai
" colorscheme zenburn
" 设置背景色
set background=dark
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
		set guifont=SauceCodePro\ Nerd\ Font\ 12
	else
		set guifont=SauceCodePro\ Nerd\ Font:h12
		set guifont=SauceCodePro\ Nerd\ Font:h12
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

" 高亮列要匹配背景色
highlight clear SignColumn
" 移除当前行号处的高亮色
highlight clear LineNr
" 提亮一下光标行
hi CursorLine ctermbg=235   cterm=none
" 定制补全菜单颜色
" 补全菜单的前景和背景
hi pmenu  guifg=#b6b6a6 guibg=#1B1D1E ctermfg=144 ctermbg=233
" 滚动条guibg
hi pmenusbar  guifg=#ff0000 guibg=#ffff00 gui=none ctermfg=darkcyan ctermbg=233 cterm=none
" 滑块guibg
hi pmenuthumb  guifg=#ffff00 guibg=#ff0000 gui=none ctermfg=lightgray ctermbg=144 cterm=none
" hi pmenu  guifg=#000000 guibg=#f8f8f8 ctermfg=black ctermbg=lightgray
" hi pmenusbar  guifg=#8a95a7 guibg=#f8f8f8 gui=none ctermfg=darkcyan ctermbg=lightgray cterm=none
" hi pmenuthumb  guifg=#f8f8f8 guibg=#8a95a7 gui=none ctermfg=lightgray ctermbg=darkcyan cterm=none
" }}}3

" }}}

" editing ------------------------------------------------------------------{{{1
" 快速关闭搜索高亮
call DoMap('nnore', '<cr>', ':nohlsearch<cr>', '', ['<silent>'])
" 搜索并替换所有
call DoMap('vnore', 'r', ":call VisualSelection('replace', '')<CR>", '', ['<silent>'])
" 搜索并替换所有
vnoremap <silent> <leader>fr :call VisualSelection('replace', '')<CR>
" 查找并合并冲突
nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
" 横向滚动
map zl zL
map zh zH
" 快速查找当前单词
nnoremap <leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" 快速切换拼写检查
noremap <c-f11> :setlocal spell!<cr>
" 拼写检查功能
set nospell
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=
" 使用jk退出插入模式
inoremap jk <esc>
" 将光标所在单词切换成大写/小写
nnoremap <c-u> g~iw
inoremap <c-u> <esc>g~iwea
" i_alt-x删除当前行
call DoAltMap('inore', 'x', '<c-o>dd')
" 使用<M-p>代替<C-n>进行补全
call DoAltMap('inore', 'p', '<c-n>')
" 设置补全菜单样式
set completeopt=longest,menu,preview
" alt+d 删除词
call DoAltMap('inore', 'd', '<c-w>')
call DoAltMap('cnore', 'd', '<c-w>')
" alt+= 使用表达式寄存器
call DoAltMap('inore', '=', '<c-r>=')
" leader q格式化
nnoremap <silent> <leader>q gwip
" 开关折叠
nnoremap - za
nnoremap _ zf
" 让Y表示复制到行尾巴
call yankstack#setup()
nmap Y y$
" [move] j/k可以移动到软换行上
nnoremap j gj
nnoremap k gk
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
nnoremap <leader>f0 :set foldlevel=0<cr>
nnoremap <leader>f1 :set foldlevel=1<cr>
nnoremap <leader>f2 :set foldlevel=2<cr>
nnoremap <leader>f3 :set foldlevel=3<cr>
nnoremap <leader>f4 :set foldlevel=4<cr>
nnoremap <leader>f5 :set foldlevel=5<cr>
nnoremap <leader>f6 :set foldlevel=6<cr>
nnoremap <leader>f7 :set foldlevel=7<cr>
nnoremap <leader>f8 :set foldlevel=8<cr>
nnoremap <leader>f9 :set foldlevel=9<cr>
" }}}1

" file buffer tab and window -----------------------------------------------{{{1
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
nnoremap <tab>[ :tabfirst<cr>
nnoremap <tab>] :tablast<cr>
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>q :close<cr>

nnoremap <tab>{ :bprevious<cr>
nnoremap <tab>} :bnext<cr>
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
map <leader>Q :bufdo bd<cr>
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
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
" 切换工作目录到当前文件目录
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" 保存与退出
call DoMap('nnore', 'q', ':close<cr>')
call DoMap('nnore', 'w', ':w<cr>')
" 以sudo权限保存
if !IsWin()
    cnoremap W! !sudo tee % > /dev/null<cr>
	call DoMap('nnore', 'W', ':!sudo tee % > /dev/null')
endif
" 文件类型(使用的结尾符号)
set fileformats=unix
" 设置脚本的编码
scriptencoding utf8
" 退出需要确认
set confirm

" 备份光标
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

" 备份文件
function! BackupFile()
    set backup
    set backupdir=$VIMFILES/temp/backup
    set backupext=.__bak__
endfunction

" 备份undo
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

" 备份view
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
" }}}1

" misc ---------------------------------------------------------------------{{{1
" ctags setting
set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif

" [iabbrev]
iabbrev xdate <c-r>=strftime("%Y/%d/%m %H:%M:%S")<cr>
" 去除Windows的 ^M 在编码混乱的时候
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" 一些有用的方法，该配置文件中使用过的 {{{2
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction  " }}}2

function! VisualSelection(direction, extra_filter) range " {{{2
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
endfunction "}}}2

function! HasPaste() " 如果paste模式打开的化返回true {{{2
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction " }}}2

func! DeleteTillSlash() " {{{2
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
endfunc " }}}2

func! DeleteTrailingWhiteSpace() " 删除每行末尾的空白，对python使用 {{{2
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc " }}}2

function! StripTrailingWhitespace() " Strip whitespace {{{2
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction " }}}2

" 编译和运行 {{{
if !exists("g:ideavim")
	" 按F5编译运行
	" nnoremap <F5> :call Run()<CR>
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
		elseif &filetype == 'markdown' || &filetype == 'html' || &filetype == 'ftl'
			exec "silent !exec google-chrome % &"
			exec "redraw!"
		elseif &filetype == 'scala'
			exec "!scala -deprecation %" 
		elseif &filetype == 'python3'
			exec "!python %"
		endif
	endfunc
	"C,C++的调试
	map <F8> :call Rungdb()<CR>
	func! Rungdb()
		exec "w"
		exec "!g++ % -g -o %<"
		exec "!gdb ./%<"
	endfunc
endif " }}}2

function! s:RunShellCommand(cmdline) " Run Shell command {{{2
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
endfunction

command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
" e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
" }}}2

function! ToggleBG() " 切换背景色 {{{2
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
        set background=light
    else
        set background=dark
    endif
endfunction
noremap <leader>bg :call ToggleBG()<CR>
" }}}2

" }}}1

" plugin config ------------------------------------------------------------{{{1
" 如果是ideavim就不要加载下面的东西了
if exists("g:ideavim")
    finish
endif

" Neocomplete {{{2
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#max_list = 15
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
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
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

let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
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


" 使用unite菜单的补全
imap <C-;> <Plug>(neocomplete_start_unite_complete)
imap <C-l> <Plug>(neocomplete_start_unite_quick_match)
" }}}2

" ultisnips {{{2
" 定义snippet文件存放的位置
let g:UltiSnipsSnippetsDir=expand("$VIMFILES/supervim/ultisnips")
let g:UltiSnipsSnippetDirectories=["UltiSnips", "supervim/ultisnips"]

" Trigger configuration.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="∆"
let g:UltiSnipsJumpBackwardTrigger="˚"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
nnoremap <leader>au :UltiSnipsAddFiletypes<space>
nnoremap <space>au :UltiSnipsAddFiletypes<space>

" execute是一个命令，没有对应的方法，定义一个，在snippets中用
function! EXE(e)
    execute(a:e)
endfunctio
" }}}2

" unite {{{2
let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.git = {
            \ 'description' : '            gestionar repositorios git
            \                            ⌘ [espacio]g',
            \}
let g:unite_source_menu_menus.git.command_candidates = [
            \['▷ tig                                                        ⌘ ,gt',
            \'normal ,gt'],
            \['▷ git status       (Fugitive)                                ⌘ ,gs',
            \'Gstatus'],
            \['▷ git diff         (Fugitive)                                ⌘ ,gd',
            \'Gdiff'],
            \['▷ git commit       (Fugitive)                                ⌘ ,gc',
            \'Gcommit'],
            \['▷ git log          (Fugitive)                                ⌘ ,gl',
            \'exe "silent Glog | Unite quickfix"'],
            \['▷ git blame        (Fugitive)                                ⌘ ,gb',
            \'Gblame'],
            \['▷ git stage        (Fugitive)                                ⌘ ,gw',
            \'Gwrite'],
            \['▷ git checkout     (Fugitive)                                ⌘ ,go',
            \'Gread'],
            \['▷ git rm           (Fugitive)                                ⌘ ,gr',
            \'Gremove'],
            \['▷ git mv           (Fugitive)                                ⌘ ,gm',
            \'exe "Gmove " input("destino: ")'],
            \['▷ git push         (Fugitive, salida por buffer)             ⌘ ,gp',
            \'Git! push'],
            \['▷ git pull         (Fugitive, salida por buffer)             ⌘ ,gP',
            \'Git! pull'],
            \['▷ git prompt       (Fugitive, salida por buffer)             ⌘ ,gi',
            \'exe "Git! " input("comando git: ")'],
            \['▷ git cd           (Fugitive)',
            \'Gcd'],
            \]
nnoremap <silent>[menu]g :Unite -silent -start-insert menu:git<CR>

" ultisnips source
function! UltiSnipsCallUnite()
    Unite -start-insert -winheight=10 -immediately -no-empty ultisnips
    return ''
endfunction
inoremap <silent> <leader>wu <C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
nnoremap <silent> <leader>wu a<C-R>=(pumvisible()? "\<LT>C-E>":"")<CR><C-R>=UltiSnipsCallUnite()<CR>
" }}}2

" nerdtree {{{2
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
" nnoremap <Leader>n <plug>NERDTreeTabsToggle<CR>
nnoremap <Leader>n :NERDTreeTabsToggle<CR>
call DoMap('nnore', 'n', ':NERDTreeTabsToggle<cr>')
" }}}2

" nerdcommenter {{{2
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" 添加自定义注释或者覆盖已有注释
" let g:NERDCustomDelimiters={
"     \ 'markdown': { 'left': '<!--', 'right': '-->' },
"     \ }
" 可以注释和反注释空行
let g:NERDCommentEmptyLines = 1
" 取消注释的时候去掉两端空格
let g:NERDTrimTrailingWhitespace=1
let g:NERDSpaceDelims=1
let g:NERDRemoveExtraSpaces=1
" }}}2

" tagbar {{{2
nnoremap <leader>t :TagbarToggle<cr>
call DoMap('nnore', 't', ':TagbarToggle<cr>')
" }}}2

" ctrlp {{{2
" Default mapping and default command
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" 设置ctrlp窗口的样式，从上边打开
let g:ctrlp_match_window = 'top'
" 打开已经打开的文件就尝试调到那个窗口而不是打开新的
let g:ctrlp_switch_buffer = 'Et'
" 设置默认的查找起始目录
let g:ctrlp_working_path_mode = 'ra'
" 自定义的默认查找起始目录
let g:ctrlp_root_markers = ['.p, .vim, home']
" 忽略这些文件
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
" 额外的搜索工具
if executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
elseif executable('ack-grep')
    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
    " On Windows use "dir" as fallback command.
elseif IsWin()
    let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
else
    let s:ctrlp_fallback = 'find %s -type f'
endif
" 设置一下ctrlp的窗口高度
let g:ctrlp_max_height = 10
" 跟随链接但是忽略内部循环的链接，避免重复。
let g:ctrlp_follow_symlinks = 0
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }
let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ }
" \ 'fallback': s:ctrlp_fallback
call DoMap('nnore', 'o', ':CtrlP<CR>')
call DoMap('nnore', 'O', ':CtrlPBuffer<cr>')
call DoMap('nnore', 'p', ':CtrlPMRU<cr>')
" }}}2

" ctrlp-funky {{{2
" CtrlP extensions
let g:ctrlp_extensions = ['funky']
"funky
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fe :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
let g:ctrlp_funky_matchtype = 'path'
let g:ctrlp_funky_syntax_highlight = 1
" }}}2

" vim-expand-region {{{2
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" }}}2

" vim-surround {{{2
vmap Si S(i_<esc>f)
" }}}2

" vim-multiple-cursors {{{2
let g:multi_cursor_next_key="\<c-s>"
" }}}2

" lightline {{{2
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
            \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightLineFugitive',
            \   'filename': 'LightLineFilename',
            \   'fileformat': 'LightLineFileformat',
            \   'filetype': 'LightLineFiletype',
            \   'fileencoding': 'LightLineFileencoding',
            \   'mode': 'LightLineMode',
            \   'ctrlpmark': 'CtrlPMark',
            \ },
            \ 'component_expand': {
            \   'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
            \   'syntastic': 'error',
            \ },
            \ 'subseparator': { 'left': '|', 'right': '|' }
            \ }

function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                \ fname == '__Tagbar__' ? g:lightline.fname :
                \ fname =~ '__Gundo\|NERD_tree' ? '' :
                \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
                \ &ft == 'unite' ? unite#get_status_string() :
                \ &ft == 'vimshell' ? vimshell#get_status_string() :
                \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
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
                \ fname == 'ControlP' ? 'CtrlP' :
                \ fname == '__Gundo__' ? 'Gundo' :
                \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                \ fname =~ 'NERD_tree' ? 'NERDTree' :
                \ &ft == 'unite' ? 'Unite' :
                \ &ft == 'vimfiler' ? 'VimFiler' :
                \ &ft == 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
    if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
        call lightline#link('iR'[g:lightline.ctrlp_regex])
        return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
    else
        return ''
    endif
endfunction

let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction

augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction
" }}}2

" vim-markdown {{{2
" 关掉它自带的折叠
let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_style_pythonic = 1
"let g:vim_markdown_folding_level = 2
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0
" 关闭语法隐藏，显示markdown源码而不要隐藏一些东西
let g:vim_markdown_conceal = 0
" 代码块语法
let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']
" }}}2

" javacomplete2 {{{2
augroup javacomplete2
    autocmd!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInf
    "autocmd FileType java inoremap <expr><space> pumvisible() ? "\<F2>" : "<space>"
    autocmd FileType java inoremap  . .
    autocmd FileType java call JavaComplete2Config()
augroup END
function! JavaComplete2Config()
    " 自动闭合方法的反括号
    let g:JavaComplete_ClosingBrace = 1 
    " 不要自动导入第一个
    let g:JavaComplete_ImportDefault = -1
    "Enable smart (trying to guess import option) inserting class imports
    nmap <buffer> <F2> <Plug>(JavaComplete-Imports-AddSmart)
    imap <buffer> <F2> <Plug>(JavaComplete-Imports-AddSmart)
    "Enable usual (will ask for import option) inserting class imports
    nmap <buffer> <F3> <Plug>(JavaComplete-Imports-Add)
    imap <buffer> <F3> <Plug>(JavaComplete-Imports-Add)
    "Add all missing imports
    nmap <buffer> <F4> <Plug>(JavaComplete-Imports-AddMissing)
    imap <buffer> <F4> <Plug>(JavaComplete-Imports-AddMissing)
    "Remove all missing imports
    nmap <buffer> <F6> <Plug>(JavaComplete-Imports-RemoveUnused)
    imap <buffer> <F6> <Plug>(JavaComplete-Imports-RemoveUnused)
endfunction
" }}}2

" vim-shell {{{2
nnoremap <space>s :VimShellTab<cr> 
nnoremap <space>d :VimShellPop<cr>
" 覆盖statusline
let g:vimshell_force_overwrite_statusline=0
inoremap <c-j> <c-r>=UltiSnips#ExpandSnippet()<cr>
inoremap <c-k> <c-r>=UltiSnips#JumpForwards()<cr>
augroup vim_shell
    autocmd!
    autocmd FileType vimshell :UltiSnipsAddFiletypes vimshell<cr>
augroup END
"TODO: vimshell
" }}}2

" python-mode {{{2
" Turn off plugin's warnings
let g:pymode_warnings = 1
" Setup pymode quickfix window
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 6
" 设置python版本
" let g:pymode_python = 'python3'
" Enable pymode indentation
let g:pymode_indent = 1
" 开启python折叠
let g:pymode_folding = 1
" Enable pymode-motion
let g:pymode_motion = 1
" Turns on the documentation script
let g:pymode_doc = 1
" Bind keys to show documentation for current word (selection)
let g:pymode_doc_bind = 'K'
" 转到定义处
let g:pymode_rope_goto_definition_bind = '<leader>d'
" e new vnew，转到定义用哪个命令打开
let g:pymode_rope_goto_definition_cmd = 'vnew'
" Turn on code checking
let g:pymode_lint = 1
" Check code on every save (every)
let g:pymode_lint_unmodified = 0
" 如果光标在有错误的行上显示错误信息
let g:pymode_lint_message = 1
" pymode的错误标识
let g:pymode_lint_todo_symbol = 'DO'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'
" 开启补全
let g:pymode_rope_completion = 1
let g:pymode_lint_checkers = ['pyflakes']

" let g:pymode_rope_completion_bind = '∏'
" }}}2

" indentLine {{{2
" Vim
let g:indentLine_color_term = 239
"GVim
let g:indentLine_color_gui = '#A4E57E'
" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" 设置表示缩进的字符
" let g:indentLine_char = 'c'
" 默认关闭
let g:indentLine_enabled = 1
nnoremap <space>i :IndentLinesToggle<cr>
nnoremap <leader>ai :IndentLinesToggle<cr>
" }}}2

" tabular {{{2
nnoremap <Leader>a& :Tabularize /&<CR>
vnoremap <Leader>a& :Tabularize /&<CR>
nnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a= :Tabularize /=<CR>
nnoremap <Leader>a: :Tabularize /:<CR>
vnoremap <Leader>a: :Tabularize /:<CR>
nnoremap <Leader>a:: :Tabularize /:\zs<CR>
vnoremap <Leader>a:: :Tabularize /:\zs<CR>
nnoremap <Leader>a, :Tabularize /,<CR>
vnoremap <Leader>a, :Tabularize /,<CR>
nnoremap <Leader>a,, :Tabularize /,\zs<CR>
vnoremap <Leader>a,, :Tabularize /,\zs<CR>
nnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
vnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
nnoremap <Leader>a<space> :Tabularize /<space><CR>
vnoremap <Leader>a<space> :Tabularize /<space><CR>

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction
" }}}2

" vim-surround {{{2
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
" }}}2

" undotree {{{2
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <space>u :UndotreeToggle<cr>
" }}}2

" autopair {{{2
"  什么时候想自己写插件应该看看这个插件的源码
let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'",'"':'"', '`':'`'}
let g:AutoPairsShortcutToggle = '<leader>ac'
if IsOSX()
    let g:AutoPairsShortcutFastWrap = 'å'
elseif IsLinux() && !IsGui()
    let g:AutoPairsShortcutFastWrap = 'a'
else
    let g:AutoPairsShortcutFastWrap = '<a-a>'
endif
" }}}2

" MatchTagAlways {{{2
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {
            \ 'html' : 1,
            \ 'xhtml' : 1,
            \ 'xml' : 1,
            \}
" }}}2

" vim-devicons {{{2
let g:airline_powerline_fonts = 1
let g:vimfiler_as_default_explorer = 1
" font use double width glyphs
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
" enable open and close folder/directory glyph flags
let g:DevIconsEnableFoldersOpenClose = 1
" specify OS to decide an icon for unix fileformat
let g:WebDevIconsOS = 'Darwin'

" patch font for lightline
let g:lightline = {
            \ 'component_function': {
            \   'filetype': 'MyFiletype',
            \   'fileformat': 'MyFileformat',
            \ }
            \ }

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
" path font for nerd git
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

" nerd icon
augroup nerdColor
    autocmd!
    " NERDTress File highlighting only the glyph/icon
    " test highlight just the glyph (icons) in nerdtree:
    autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
    autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
    autocmd filetype nerdtree highlight go_icon ctermbg=none ctermfg=Red guifg=#ffa500

    autocmd filetype nerdtree syn match haskell_icon ## containedin=NERDTreeFile
    " if you are using another syn highlight for a given line (e.g.
    " NERDTreeHighlightFile) need to give that name in the 'containedin' for this
    " other highlight to work with it
    autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
    autocmd filetype nerdtree syn match go_icon ## containedin=NERDTreeFile
augroup END

" }}}2

" Fugitive {{{2
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
" }}}2

" sessionman {{{2
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
nnoremap <leader>sl :SessionList<CR>
nnoremap <leader>ss :SessionSave<CR>
nnoremap <leader>sc :SessionClose<CR>
" }}}2

" vim-yankstack {{{2
call DoAltMap('n', 'P', '<Plug>yankstack_substitute_older_paste')
call DoAltMap('n', 'p', '<Plug>yankstack_substitute_newer_paste')
" }}}2

" }}}1

" extesion -----------------------------------------------------------------{{{1
"  列参考线 {{{2
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
	autocmd FileType * call SetRL(80)
augroup END
" }}}2

" mybatis逆向工程 {{{2
let g:mybatis_gnenerate_core="none"
let g:driverPath="none"
func! MybatisGenerate()
	if g:mybatis_gnenerate_core == "none" || g:driverPath == "none"
		echo "你必须设置 g:driverPath 和 g:mybatis_gnenerate_core 才能运行该方法"
		return
	endif
	exe("!java -Xbootclasspath/a:" . g:driverPath . " -jar " . g:mybatis_gnenerate_core . expand(" -configfile %") . " -overwrite")
endfunc
" }}}2
" }}}

" filetype -----------------------------------------------------------------{{{1
let $FT_DIR = $VIMFILES . '/supervim/filetype'
if !isdirectory(expand($FT_DIR))
    call mkdir(expand($FT_DIR))
endif
function! LoadFTConfig()
    let b:ftconfig = expand($FT_DIR) . '/' . &filetype . '.vim'
    if filereadable(b:ftconfig)
        execute ('source ' . b:ftconfig)
    endif
endfunction
augroup FTConfig
    autocmd!
    autocmd FileType * call LoadFTConfig()
augroup END

augroup miscs
    autocmd!
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    " Always switch to the current file directory
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
augroup ENDJ
" }}}

