" | |   _        ___                 _
" | |  (_)_ __  / _/___ ___  __   __(_)_ __ ___  _ __ ___
" | |  | | '_ \| |_/ _ \ _ \ \ \ / /| | '_ ` _ \| '__/ __|
" | |__| | | | |  _| __/ __/  \ V / | | | | | | | | | (__
" |____|_|_| |_|_| \___\___|   \_/  |_|_| |_| |_|_|  \___|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim


" 尝试加载plug插件管理器
let g:s_loaded_plug = TryLoad('~/.vim/supervim/plug.vim', 1)

if !exists("g:ideavim")
	call plug#begin('~/.vim/plugged')
	" language support
	Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
    Plug 'derekwyatt/vim-sbt', { 'for': 'scala' }
	Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
	Plug 'klen/python-mode', { 'for': 'python' }
	Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    Plug 'spf13/vim-preview' " markdown等语言的快速预览
	" Plug 'Valloric/MatchTagAlways' " 高亮显示匹配html标签
    Plug 'amirh/HTML-AutoCloseTag' " 自动关闭html标签
    Plug 'mattn/emmet-vim'
    Plug 'tomtom/tlib_vim' " Some utility functions for VIM
    Plug 'pangloss/vim-javascript', {'for': 'javascript'}
    Plug 'elzr/vim-json', {'for': 'json'}

	Plug 'scrooloose/nerdtree'
	Plug 'jistr/vim-nerdtree-tabs'
	" Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'scrooloose/nerdcommenter' " 快捷注释
    if executable('ctags')
        Plug 'majutsushi/tagbar'
    endif
	Plug 'kshenoy/vim-signature'
	Plug 'mbbill/undotree'
    Plug 'mhinz/vim-signify' " 快捷diff列
    Plug 'osyo-manga/vim-over' " 替换时候可以预览
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-indent'
    Plug 'reedes/vim-textobj-quote'
    Plug 'reedes/vim-textobj-sentence'
    Plug 'bps/vim-textobj-python', { 'for': 'python' } " python文本对象
    Plug 'coderifous/textobj-word-column.vim' " 列文本对象 c
    Plug 'glts/vim-textobj-comment' " 注释文本对象 c
    Plug 'whatyouhide/vim-textobj-xmlattr' " xml属性文本对象x

    Plug 'Shougo/neocomplete.vim'
	" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
	Plug 'ujihisa/neco-look'
    Plug 'luochen1990/rainbow' " 彩虹括号增强版

	Plug 'Shougo/vimproc.vim'
	Plug 'Shougo/vimshell.vim'
	Plug 'Shougo/unite.vim'
	Plug 'Shougo/unite-outline'
	Plug 'Shougo/vimfiler.vim'
	Plug 'ujihisa/unite-colorscheme'
    Plug 'mattn/webapi-vim' " vim interface to Web API

	Plug 'mhinz/vim-startify' " 启动画面
	Plug 'itchyny/lightline.vim'
	Plug 'Yggdroot/indentLine' " 缩进可视化
	Plug 'altercation/vim-colors-solarized'
	Plug 'tomasr/molokai'
    Plug 'flazz/vim-colorschemes' " 主题包
    Plug 'maxbrunsfeld/vim-yankstack' " 粘帖栈
	Plug 'terryma/vim-multiple-cursors' " 多光标
	Plug 'tpope/vim-surround' " 包围插件
	Plug 'tpope/vim-repeat' " 使用.重复第三方插件的功能
    Plug 'junegunn/vim-easy-align' " 排版插件
	Plug 'jiangmiao/auto-pairs' " 自动插入配对括号引号
    Plug 'hail2u/vim-css3-syntax'
    Plug 'gorodinskiy/vim-coloresque' " css等语言中高亮显示颜色
	Plug 'terryma/vim-expand-region' " 扩展选择
	Plug 'easymotion/vim-easymotion'
	Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tacahiroy/ctrlp-funky' "A simple function navigator for ctrlp
	Plug 'tpope/vim-fugitive' " git集成
    Plug 'rhysd/conflict-marker.vim' " 处理git冲突文件
	Plug 'vim-scripts/EasyGrep'
	Plug 'Konfekt/FastFold' " 快速折叠，处理某些折叠延迟
    Plug 'vim-scripts/sessionman.vim' " 管理session
    Plug 'reedes/vim-litecorrect' " 轻量级的拼写纠正

	Plug 'ryanoasis/vim-devicons'
	Plug 'strom3xFeI/vimdoc-cn'

	call plug#end()
endif
