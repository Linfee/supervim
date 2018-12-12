"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO:   https://github.com/Linfee/supervim
" Layer: BetterDefault

" --------------------------------------
" better default
" --------------------------------------

if !has('nvim')
  set nocompatible                 " 关闭vi兼容性
en
filetype plugin indent on        " 自动指定文件类型、缩进
syntax on                        " 开启语法高亮

set encoding=utf8
scriptencoding utf-8
set number                       " 显示绝对行号
set relativenumber               " 显示相对行号
set mouse=                       " 允许使用鼠标
set mousehide                    " 输入时隐藏鼠标
set virtualedit=onemore          " 虚拟编辑意味着光标可以定位在没有实际字符的地方
set history=1000                 " 设置命令行历史记录
if !has('nvim') && v:version < 800 " for old_version_vim
  set shortmess+=filmnrxoOtT     " 避免一部分 hit enter 的提示
el
  set shortmess+=cfilmnrxoOtT    " 避免一部分 hit enter 的提示
en
set noshowmode                   " 不显示模式，由插件显示模式
" set noswapfile                 " 不要使用swp文件做备份
set hidden                       " 隐藏缓冲区而不是卸载缓冲区
set backspace=indent,eol,start   " 删除在插入模式可以删除的特殊内容
set laststatus=2                 " 最后一个窗口总有状态行
set wildmode=list:longest,full   " 设置命令行模式补全模式
set foldcolumn=2                 " 在左端添加额外折叠列
set winminheight=0               " 窗口的最小高度
set tabpagemax=15                " 最多打开的标签数目
set scrolljump=1                 " 光标离开屏幕时(比如j)，最小滚动的行数，这样看起来舒服
set scrolloff=5                 " 使用j/k的时候，光标到窗口的最小行数
set lazyredraw                   " 执行完宏之后不要立刻重绘
set linespace=0                  " 设置行间距
set whichwrap=b,s,h,l,<,>,[,]    " 左右移动光标键可以移动到的额外虚拟位置
set autoread                     " 当文件被改变时自动载入
set cursorline                   " 高亮显示当前行
" set cursorcolumn                 " 高亮显示当前列
" set cmdheight=2                  " 命令行高度
set fileformats=unix             " 文件类型(使用的结尾符号)
" set confirm                      " 退出需要确认
set synmaxcol=200

set list
set magic

" 新的分割窗口总是在右边和下边打开
set splitright
set splitbelow

" 显示配对的括号，引号等，以及显示时光标的闪烁频率
set showmatch
set matchtime=2

" 关掉错误声音，这个设置仅仅对gui有效
set noerrorbells
set novisualbell
set t_vb=
set timeoutlen=500

" 命令行补全和忽略补全的文件类型
set wildmenu
set wildignore=*.o,*~,*.pyc,*.class
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,.git\*,.hg\*,.svn\*
set wildignore+=*.sw*
" 防止连接命令时，在 '.'、'?' 和 '!' 之后插入两个空格。如果 'cpoptions'
" set nojoinspaces
set cpoptions&vim


" 让vim和系统共享默认剪切板
if has('clipboard')
  if has('unnamedplus') " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
  endif
endif

" --------------------------------------
" format
" --------------------------------------
set nowrap                       " 不要软换行
set formatoptions-=t             " 输入的时候不要自动软换行
set autoindent                   " 自动缩进
set expandtab                    " 将制表符扩展为空格
set smarttab                     " 只能缩进
set shiftwidth=4                 " 格式化时制表符占几个空格位置
set tabstop=4                    " 编辑时制表符占几个空格位置
set softtabstop=4                " 把连续的空格看做制表符
set matchpairs+=<:>              " 设置形成配对的字符
set nospell                      " 默认不要开启拼写检查
set foldenable                   " 基于缩进或语法进行代码折叠
set linebreak
set textwidth=500

" --------------------------------------
" look and feel
" --------------------------------------
set ignorecase                   " 搜索时候忽略大小写
set smartcase                    " 智能匹配大小写
set hlsearch                     " 高亮显示搜索结果
set incsearch                    " 使用增量查找
set colorcolumn=80,120           " 80列和120列参考线
highlight COlorColumn ctermbg=233
set guicursor=a:block-blinkon0   " 让gui光标不要闪
highlight clear SignColumn       " 高亮列要匹配背景色
highlight clear LineNr           " 移除当前行号处的高亮色
highlight clear CursorLineNr     " 删掉当前行号上的高亮

" 高亮某些特殊位置的特殊字符
set listchars=tab:\|\ ,trail:.,nbsp:.,extends:#,precedes:#
" set listchars=tab:\|\ ,trail:.,nbsp:.,extends:#,precedes:#,eol:$

if !has('gui_running') && !has('win32unix') && !has('nvim')
  if &term ==# 'xterm' || &term ==# 'screen'
    " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    set t_Co=256
  endif
endif

" 设置补全菜单样式
set completeopt=longest,menu,preview

" --------------------------------------
" keymap
" --------------------------------------
" 使用jk退出插入模式
inoremap jk <esc>
" 使用Y复制到行尾
nnoremap Y y$
" j/k可以移动到软换行上
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" H, L移动到行首行尾
map H ^
map L $

" vmode下能连续使用 < >
vnoremap < <gv
vnoremap > >gv

" 允许使用 . 对选中的行执行上一个命令
vnoremap . :normal! .<cr>

nnoremap Q gqap
vnoremap Q gq

" quick set tab size
com! -nargs=1 TabSize call s:tab_size(<args>)
fu! s:tab_size(n) abort
  exe 'setl shiftwidth=' . a:n
  exe 'setl tabstop=' . a:n
  exe 'setl softtabstop=' . a:n
endf

" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldlevel=0 foldmethod=marker nospell:
