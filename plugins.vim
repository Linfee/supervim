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

" 尝试加载plug插件管理器
let g:s_loaded_plug = TryLoad('~/.vim/supervim/plug.vim', 1)

if !exists("g:ideavim")
    call plug#begin('~/.vim/plugged')
    " language support
    " Plug 'derekwyatt/vim-scala', {'for': 'scala'}
    Plug 'davidhalter/jedi-vim', {'for': 'python'} " python补全
    Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']} " 高亮显示匹配html标签
    Plug 'pangloss/vim-javascript', {'for': 'javascript'}
    Plug 'elzr/vim-json', {'for': 'json'}
    Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
    Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'} " markdown实时预览
    Plug 'hail2u/vim-css3-syntax', {'for': 'css'} " css3语法高亮支持

    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle', 'NERDTreeFind']}
    Plug 'jistr/vim-nerdtree-tabs', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'scrooloose/nerdcommenter' " 快捷注释
    if executable('ctags') " 需要ctags支持
        Plug 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}
        let g:s_has_ctags = 1
    endif
    Plug 'kshenoy/vim-signature' " 显示书签
    Plug 'mbbill/undotree' " 撤销树
    Plug 'mhinz/vim-signify' " 快捷diff列
    Plug 'osyo-manga/vim-over' " 可以预览的替换

    Plug 'Shougo/neocomplete.vim' " 补全插件
    if executable('look') " 需要ctags支持
        Plug 'ujihisa/neco-look' " 提供补全英文单词的支持，依赖look命令
        let g:s_has_look = 1
    endif
    Plug 'scrooloose/syntastic' " 静态语法检查
    Plug 'Linfee/ultisnips-zh-doc'
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'luochen1990/rainbow' " 彩虹括增强版

    if !IsWin()
        Plug 'Shougo/vimproc.vim', {'do': 'make'}
        Plug 'Shougo/vimshell.vim'
    endif

    Plug 'kana/vim-textobj-user' " 方便地自定义文本对象
    Plug 'mhinz/vim-startify' " 启动画面
    Plug 'itchyny/lightline.vim'
    Plug 'sickill/vim-monokai'
    Plug 'tomasr/molokai'
    Plug 'terryma/vim-multiple-cursors' " 多光标
    Plug 'tpope/vim-surround' " 包围插件
    Plug 'tpope/vim-repeat' " 使用.重复第三方插件的功能
    Plug 'junegunn/vim-easy-align' " 排版插件
    Plug 'easymotion/vim-easymotion' " 快捷移动光标
    " css等语言中高亮显示颜色
    " Plug 'gorodinskiy/vim-coloresque', {'for': ['vim','html','css','js']}
    Plug 'terryma/vim-expand-region' " 扩展选择
    Plug 'jiangmiao/auto-pairs' " 自动插入配对括号引号
    Plug 'tell-k/vim-autopep8', {'for': 'python'} " pep8自动格式化

    Plug 'dyng/ctrlsf.vim' " 强大的工程查找工具，依赖ack，ag
    " 强大的模糊搜索，需要命令行工具fzf支持
    " Ag [PATTERN] 命令的支持需要安装 ggreer/the_silver_searcher
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
    Plug 'junegunn/fzf.vim'

    Plug 'tpope/vim-fugitive' " git集成 比较费时间
    Plug 'rhysd/conflict-marker.vim' " 处理git冲突文件

    Plug 'Konfekt/FastFold' " 快速折叠，处理某些折叠延迟
    Plug 'strom3xFeI/vimdoc-cn'

    call plug#end()
endif
