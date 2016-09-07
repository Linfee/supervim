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
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']} " 高亮显示匹配html标签 尝试重新实现
    Plug 'amirh/HTML-AutoCloseTag', {'for': ['html', 'xml']} " 自动关闭html标签
    Plug 'mattn/emmet-vim', {'for': 'html'}
    Plug 'pangloss/vim-javascript', {'for': 'javascript'}
    Plug 'elzr/vim-json', {'for': 'json'}
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'} " markdown实时预览
    Plug 'hail2u/vim-css3-syntax', {'for': 'css'} " css3语法高亮支持
    if executable('javac') " 需要javac支持
        Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    endif

    Plug 'tomtom/tlib_vim' " Some utility functions for VIM
    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'jistr/vim-nerdtree-tabs', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'scrooloose/nerdcommenter' " 快捷注释 尝试重新实现
    if executable('ctags') " 需要ctags支持
        Plug 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar', 'NERDTree']}
        let g:s_has_ctags = 1
    endif
    Plug 'kshenoy/vim-signature' " 显示书签
    Plug 'mbbill/undotree' " 撤销树
    Plug 'mhinz/vim-signify' " 快捷diff列
    Plug 'osyo-manga/vim-over' " 替换时候可以预览

    " 各种文本对象
    Plug 'kana/vim-textobj-user'
    Plug 'reedes/vim-textobj-sentence'
    Plug 'whatyouhide/vim-textobj-xmlattr', {'for': ['xml', 'html']} " xml属性文本对象x
    Plug 'coderifous/textobj-word-column.vim' " 列文本对象 c

    Plug 'Shougo/neocomplete.vim' " 补全插件
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'ujihisa/neco-look'
    Plug 'luochen1990/rainbow' " 彩虹括号增强版

    Plug 'Shougo/vimproc.vim', {'do': 'make'}
    Plug 'Shougo/vimshell.vim'

    Plug 'mhinz/vim-startify' " 启动画面
    Plug 'itchyny/lightline.vim'
    Plug 'altercation/vim-colors-solarized'
    Plug 'flazz/vim-colorschemes' " 主题包
    Plug 'tomasr/molokai'
    Plug 'maxbrunsfeld/vim-yankstack' " 粘帖栈
    Plug 'terryma/vim-multiple-cursors' " 多光标
    Plug 'tpope/vim-surround' " 包围插件
    Plug 'tpope/vim-repeat' " 使用.重复第三方插件的功能
    Plug 'junegunn/vim-easy-align' " 排版插件
    Plug 'easymotion/vim-easymotion' " 尝试重新实现
    " css等语言中高亮显示颜色
    " Plug 'gorodinskiy/vim-coloresque', {'for': ['vim','html','css','js']}
    Plug 'terryma/vim-expand-region' " 扩展选择
    Plug 'jiangmiao/auto-pairs' " 自动插入配对括号引号
    Plug 'vim-scripts/EasyGrep', {'on': ['Grep', 'GrepAdd', 'Replace', 'ReplaceUndo', 'GrepOptions', 'ResultListFilter', 'ResultListOpen']}
    if executable('fzf') " 强大的模糊搜索，必备神器，需要命令行工具fzf支持
        " Ag [PATTERN] 命令的支持需要安装 ggreer/the_silver_searcher
        if executable('brew')
            Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
        else
            Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
            Plug 'junegunn/fzf.vim'
        endif
        let g:s_has_fzf = 1
    endif
    Plug 'tpope/vim-fugitive' " git集成 比较费时间
    Plug 'rhysd/conflict-marker.vim' " 处理git冲突文件
    Plug 'Konfekt/FastFold' " 快速折叠，处理某些折叠延迟
    Plug 'vim-scripts/sessionman.vim' " 管理session
    Plug 'reedes/vim-litecorrect' " 轻量级的拼写纠正

    Plug 'junegunn/goyo.vim'
    Plug 'ryanoasis/vim-devicons' " 各种小图标
    Plug 'strom3xFeI/vimdoc-cn'

    call plug#end()
endif
