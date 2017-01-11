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

set background=dark              " 设置背景色

" 设置补全菜单样式
set completeopt=longest,menu,preview

colorscheme desert

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
    set guioptions-=L   " remove scoll bar
    set guioptions-=r
    set guioptions-=b
    set guioptions-=e
    " 设置字体
    if IsLinux()
        set guifont=Source\ Code\ Pro\ 9
    elseif IsWin()
        set guifont=Source\ Code\ Pro:h9
    else
        set guifont=SauceCodePro\ Nerd\ Font:h11
    endif
endif
