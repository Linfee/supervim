"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim

scriptencoding utf-8

" 设置补全菜单样式
" set completeopt=longest,menu,preview
set completeopt=menuone
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
try | set switchbuf=useopen,usetab,newtab | set showtabline=2 | catch | endtry
" 设置 gui 与 cli
if g:is_gui
  " 设置窗口位置和大小
  winpos 410 5
  set lines=45 columns=135
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
  if g:is_win
    set guifont=SauceCodePro\ NF:h9
  elsei g:is_osx
    set guifont=SauceCodePro\ NF:h11
  else
    set guifont=SauceCodePro\ NF\ 9
  en
endif

if g:is_nvim
  aug nvim_font
    au!
    au! VimEnter * call timer_start(10, 'Test')
  aug END
  fu! Test(...)
    try
      exe 'Guifont! SauceCodePro NF:h9'
      " exe 'Guifont! Monaco:h9'
    catch
    endtry
  endf
en

set laststatus=2
" Broken down into easily includeable segments
set statusline=%<%f\                     " Filename
set statusline+=%w%h%m%r                 " Options
set statusline+=\ [%{&ff}/%Y]            " Filetype
set statusline+=\ [%{getcwd()}]          " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
