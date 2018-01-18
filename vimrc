"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ v / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: linfee
" Repo: https://github.com/linfee/supervim

let g:is_win = has('win32') || has('win64')
let g:is_linux = has('unix') && !has('macunix')
let g:is_win_unix = has('win32unix')
let g:is_osx = has('macunix')
let g:is_nvim = has('nvim')
" Fixme: not work in nvim
let g:is_gui = !has('nvim') && has('gui_running')

let g:is_oni = get(g:, 'gui_oni')
let g:is_nyaovim = exists('g:nyaovim_version')

let g:_vim = 'vim'
if g:is_win_unix | let g:_vim = 'winunixvim' | en
if g:is_nvim     | let g:_vim = 'nvim'       | en
if g:is_oni      | let g:_vim = 'oni'        | en
if g:is_nyaovim  | let g:_vim = 'nyaovim'    | en

" set main config dir
let g:config_home = expand('~/.vim')

let &runtimepath = expand(g:config_home . ',') . &runtimepath

for s:s in ['betterdefault', 'encodingforzh', 'key', 'keymap', 'ui', 'compatible', 'config', 'ex']
  exe 'source '.g:config_home.'/scripts/'.s:s.'.vim'
endfor

let &runtimepath .=  expand(',' . g:config_home . '/after')
