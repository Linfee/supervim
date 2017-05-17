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

" 设置补全菜单样式
set completeopt=longest,menu,preview
" 设置隐藏级别
set conceallevel=2
"  设置状态行的样式
if has('cmdline_info')
  set ruler                    " 显示光标当前位置
  " A ruler on steroids
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
  set showcmd
endif
" behavior when swithc between buffers
try | set switchbuf=useopen,usetab,newtab | set stal=2 | catch | endtry
" 设置 gui 与 cli
if IsGui()
  " 设置窗口位置和大小
  winpos 685 20
  set lines=44 columns=90
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
  endif
endif
