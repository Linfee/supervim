" --------------------------------------
" functions to judgment environment
" --------------------------------------
silent function! IsOSX()
    return has('macunix')
endfunction
silent function! IsLinux()
    return has('unix') && !has('macunix')
endfunction
silent function! WINDOWS()
    return  (has('win32') || has('win64'))
endfunction
silent function! IsWinUnix()
    return has('win32unix')
endf
silent function! IsGui()
    return has('gui_running')
endf

" --------------------------------------
" better default
" --------------------------------------
" use ~/.vim but ~/vimfiles on windows
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif


set nocompatible                 " 关闭vi兼容性
filetype plugin indent on        " 自动指定文件类型、缩进
syntax on                        " 开启语法高亮

set number                       " 现实绝对行号
" set relativenumber               " 显示相对行号
set mouse=a                      " 允许使用鼠标
set mousehide                    " 输入时隐藏鼠标
set virtualedit=onemore          " 虚拟编辑意味着光标可以定位在没有实际字符的地方
set history=1000                 " 设置命令行历史记录
set shortmess+=filmnrxoOtT       " 避免一部分 hit enter 的提示
set noshowmode                   " 不显示模式，由插件显示模式
" set noswapfile                 " 不要使用swp文件做备份
set hidden                       " 隐藏缓冲区而不是卸载缓冲区
set backspace=indent,eol,start   " 删除在插入模式可以删除的特殊内容
set laststatus=2                 " 最后一个窗口总有状态行
set wildmenu                     " 命令行补全
set wildmode=list:longest,full   " 设置命令行模式补全模式
set foldcolumn=2                 " 在左端添加额外折叠列
set winminheight=0               " 窗口的最小高度
set tabpagemax=15                " 最多打开的标签数目
set scrolljump=1                 " 光标离开屏幕时(比如j)，最小滚动的行数，这样看起来舒服
set scrolloff=15                 " 使用j/k的时候，光标到窗口的最小行数
set lazyredraw                   " 执行完宏之后不要立刻重绘
set linespace=0                  " 设置行间距
set whichwrap=b,s,h,l,<,>,[,]    " 左右移动光标键可以移动到的额外虚拟位置
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

" --------------------------------------
" format
" --------------------------------------
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


" --------------------------------------
" look and feel
" --------------------------------------
set ignorecase                   " 搜索时候忽略大小写
set smartcase                    " 智能匹配大小写
set hlsearch                     " 高亮显示搜索结果
set incsearch                    " 使用增量查找
set gcr=a:block-blinkon0         " 让gui光标不要闪
highlight clear SignColumn       " 高亮列要匹配背景色
highlight clear LineNr           " 移除当前行号处的高亮色
highlight clear CursorLineNr     " 删掉当前行号上的高亮

" 高亮某些特殊位置的特殊字符
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

if !IsGui() && !IsWin() && !has('nvim')
    set term=$TERM
    if &term == 'xterm' || &term == 'screen'
        " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        set t_Co=256
    endif
endif

" 设置补全菜单样式
set completeopt=longest,menu,preview

" --------------------------------------
" look and feel
" --------------------------------------
" 使用jk退出插入模式
inoremap jk <esc>
" 使用Y复制到行尾
nnoremap Y y$
" [move] j/k可以移动到软换行上
nnoremap j gj
nnoremap k gk

" H, L移动到行首行尾
nmap H ^
nmap L $
vmap H ^
vmap L $
omap L $
omap H ^

" vmode下能连续使用 < >
vnoremap < <gv
vnoremap > >gv

" 允许使用 . 对选中的行执行上一个命令
vnoremap . :normal .<cr>
