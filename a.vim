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
let g:is_gui = !has('nvim') && has('gui_running')

" set main config dir
let g:config_home = expand('~/.nvim')

let &rtp = expand(g:config_home . ',') . &rtp . expand(',' . g:config_home . '/after')

fu! Before()
  let g:before = 'before'
endf
fu! After()
  echom g:before
endf


call plugex#begin(expand(g:config_home.'/foos'))

" PlugEx 'strom3xFeI/vimdoc-cn', {'lazy': 1}
" PlugEx 'strom3xFeI/vimdoc-cn', {'for': ['vim']}
" PlugEx 'scrooloose/nerdtree', {'on_event': ['VimEnter']}
" PlugEx 'junegunn/goyo.vim', {'before': function('Before'), 'after': 'After', 'on': 'Goyo', 'deps': ['nerdtree'], 'name': 'Gogo'}
" PlugEx '~/.nvim/bar', {'before': function('Before'), 'after': 'After', 'on': 'Goyo', 'deps': ['nerdtree'], 'name': 'Gogo', 'enable': 0}
" PlugEx '~/.nvim/bar',
"       \ {'before': 'a#before',
"       \ 'after': 'After',
"       \ 'on': ['Goyo', 'n<Plug>Goyo', '<Plug>Gogo'],
"       \ 'deps': ['nerdtree', 'vimdoc-cn'],
"       \ 'name': 'Gogo',
"       \ 'rtp': ['abc', 'def'],
"       \ 'on_event': 'InsertEnter',
"       \ 'on_func': ['Test', 'Demo']
"       \ }
" PlugEx 'junegunn/vim-easy-align'
" PlugEx 'https://github.com/junegunn/vim-github-dashboard.git'
" PlugEx 'SirVer/ultisnips'
" PlugEx 'honza/vim-snippets'
" PlugEx 'tpope/vim-fireplace', {'for': 'clojure'}
" PlugEx 'rdnetto/YCM-Generator', {'branch': 'stable'}
" PlugEx 'fatih/vim-go', {'tag': '*'}
" PlugEx 'nsf/gocode', {'tag': 'v.20150303', 'rtp': 'vim'}
" PlugEx 'junegunn/fzf', {'path': '~/.fzf', 'do': './install --all'}

" PlugEx '~/my-plugin', {'on_event': ['InsertEnter', 'CursorHold', '''java''==&ft']}
" PlugEx '~/my-plugin2', {'on_event': ['InsertEnter if ''java''==&ft',
"       \ 'CursorHold if ''jsp''==&ft',
"       \ 'if or(''java''==&ft, ''jsp''==&ft)']}
" PlugEx '~/my-plugin3', {'on_func': ['Test', 'Test2']}

PlugExGroup 'groupName',
      \ ['strom3xFeI/vimdoc-cn', {'lazy': 1, 'after': 'After2', 'before': 'Before2'}],
      \ ['mhinz/vim-sayonara', {'on': 'Sayonara'}],
      \ ['scrooloose/nerdtree', {'on': 'NERDTreeToggle'}],
      \ {'on_event': 'InsertEnter', 'after': 'After1', 'before': 'Before1'}

call plugex#end()

fu! After1()
  echom 'finish group'
endf
fu! Before1()
  echom 'before group'
endf
fu! After2()
  echom 'finish vimdoc-cn'
endf
fu! Before2()
  echom 'before vimdoc-cn'
endf


