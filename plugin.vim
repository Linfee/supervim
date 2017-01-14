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

" 插件配置 {{
call TryLoad('~/.vim/plug.vim')

call plug#begin('~/.vim/plugged')
    " language support
    " Plug 'derekwyatt/vim-scala', {'for': 'scala'}
    Plug 'davidhalter/jedi-vim', {'for': 'python'} " python补全
    " Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']} " 高亮显示匹配html标签
    " Plug 'pangloss/vim-javascript', {'for': 'javascript'}
    " Plug 'elzr/vim-json', {'for': 'json'}
    " Plug 'Linfee/vim-markdown', {'for': 'markdown'}
    Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'} " markdown实时预览
    " Plug 'hail2u/vim-css3-syntax', {'for': 'css'} " css3语法高亮支持

    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle', 'NERDTreeFind']}
    Plug 'jistr/vim-nerdtree-tabs', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'Xuyuanp/nerdtree-git-plugin', {'on': ['NERDTreeTabsToggle', 'NERDTreeToggle']}
    Plug 'scrooloose/nerdcommenter' " 快捷注释
    if executable('ctags') " 需要ctags支持
        Plug 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}
        let g:s_has_ctags = 1
    endif
    " Plug 'kshenoy/vim-signature' " 显示书签
    Plug 'mbbill/undotree' " 撤销树
    " Plug 'mhinz/vim-signify' " 快捷diff列
    Plug 'osyo-manga/vim-over' " 可以预览的替换

    Plug 'Shougo/neocomplete.vim' " 补全插件
    if executable('look') " 需要ctags支持
        Plug 'ujihisa/neco-look' " 提供补全英文单词的支持，依赖look命令
        let g:s_has_look = 1
    endif
    " Plug 'scrooloose/syntastic' " 静态语法检查
    Plug 'Linfee/ultisnips-zh-doc'
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'luochen1990/rainbow' " 彩虹括增强版

    " if !IsWin()
        " Plug 'Shougo/vimproc.vim', {'do': 'make'}
    "     Plug 'Shougo/vimshell.vim'
    " endif

    " Plug 'kana/vim-textobj-user' " 方便地自定义文本对象
    " Plug 'mhinz/vim-startify' " 启动画面
    Plug 'itchyny/lightline.vim'
    Plug 'itchyny/vim-cursorword'
    Plug 'sickill/vim-monokai'
    Plug 'tomasr/molokai'
    " Plug 'terryma/vim-multiple-cursors' " 多光标
    Plug 'tpope/vim-surround' " 包围插件
    Plug 'tpope/vim-repeat' " 使用.重复第三方插件的功能
    Plug 'junegunn/vim-easy-align' " 排版插件
    " Plug 'easymotion/vim-easymotion' " 快捷移动光标
    " css等语言中高亮显示颜色
    " Plug 'gorodinskiy/vim-coloresque', {'for': ['vim','html','css','js']}
    " Plug 'terryma/vim-expand-region' " 扩展选择
    Plug 'jiangmiao/auto-pairs' " 自动插入配对括号引号
    Plug 'tell-k/vim-autopep8', {'for': 'python'} " pep8自动格式化

    " Plug 'dyng/ctrlsf.vim' " 强大的工程查找工具，依赖ack，ag
    " 强大的模糊搜索，需要命令行工具fzf支持
    " Ag [PATTERN] 命令的支持需要安装 ggreer/the_silver_searcher
    Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
    Plug 'junegunn/fzf.vim'

    " Plug 'tpope/vim-fugitive' " git集成 比较费时间
    " Plug 'rhysd/conflict-marker.vim' " 处理git冲突文件

    " Plug 'Konfekt/FastFold' " 快速折叠，处理某些折叠延迟
    Plug 'strom3xFeI/vimdoc-cn'

    " Plug '~/tmp/vim/vim-potion' " potion语言支持，dev
    " Plug '~/tmp/vim/vim-md' " plugin for markdown
    Plug '~/tmp/vim/vim-markdown' " plugin for markdown
    " Plug '~/tmp/vim/ctrlp.vim'
    Plug '~/tmp/vim/newctrlp'
    Plug '~/tmp/vim/finder'

    Plug '~/tmp/vim/denite'
call plug#end() " }}

" plugin config ------------------------------------------------------------{{1

" Neocomplete {{2
if isdirectory(expand('~/.vim/plugged/neocomplete.vim'))
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    let g:neocomplete#enable_auto_delimiter = 1
    " let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1
    " Define dictionary.
    " if !IsWin()
    "     let g:neocomplete#sources#dictionary#dictionaries = {
    "                 \ 'default' : '',
    "                 \ 'vimshell' : $HOME.'/.vimshell_hist',
    "                 \ 'scheme' : $HOME.'/.gosh_completions'
    "                 \ }
    " else
        let g:neocomplete#sources#dictionary#dictionaries = {
                    \ 'default' : '',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }
    " endif

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " omni 补全配置 {{3
    augroup omnif
        autocmd!
        autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        " python使用jedi
        autocmd FileType python setlocal omnifunc=jedi#completions
        " autocmd FileType python setlocal omnifunc=jedi#completions
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    augroup END
    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " if !IsWin()
    "     let g:neocomplete#use_vimproc = 1
    " endif " }}3

    " 自动打开关闭弹出式的预览窗口 {{3
    augroup AutoPopMenu
        autocmd!
        autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    augroup END
    set completeopt=menu,preview,longest "}}3

    " 回车键插入当前的补全项
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
        " For no inserting <CR> key.
        return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction

    " <C-k> 补全snippet
    " <C-k> 下一个输入点
    imap <silent><expr><C-k> neosnippet#expandable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

    inoremap <expr><C-g> neocomplete#undo_completion()
    inoremap <expr><C-l> neocomplete#complete_common_string()
    "inoremap <expr><CR> neocomplete#complete_common_string()

    " 使用回车确认补全
    " shift加回车确认补全保存缩进
    inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

    function! CleverCr()
        if pumvisible()
            " if neosnippet#expandable()
            "     let exp = "\<Plug>(neosnippet_expand)"
            "     return exp . neocomplete#smart_close_popup()
            " else
            return neocomplete#smart_close_popup()
            " endif
        else
            return "\<CR>"
        endif
    endfunction

    imap <expr> <Tab> CleverTab()

    " 回车插入补全并保存缩进，或者展开snippet
    " imap <expr> <CR> CleverCr()
    " <C-h>,<BS> 关闭预览窗口并删除补全预览
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y> neocomplete#smart_close_popup()
    " 使用tab补全
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
    " 额外的快捷键
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    " inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

endif
" }}2

" ultisnips {{2
if isdirectory(expand('~/.vim/plugged/ultisnips'))
    " 定义snippet文件存放的位置
    let g:UltiSnipsSnippetsDir=expand("~/.vim/ultisnips")
    let g:UltiSnipsSnippetDirectories=["ultisnips"]

    " Trigger configuration.
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsListSnippets="<c-tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"
    nnoremap <leader>au :UltiSnipsAddFiletypes<space>
    nnoremap <space>au :UltiSnipsAddFiletypes<space>

    " execute是一个命令，没有对应的方法，定义一个，在snippets中用
    function! EXE(e)
        execute(a:e)
    endfunction
endif
" }}2

" jedi-vim {{2
if isdirectory(expand('~/.vim/plugged/jedi-vim'))
    " jedi 补全快捷键, 有补全插件就不需要了
    " let g:jedi#completions_command = "<c-n>"
    " 跳转到定义(源码)
    let g:jedi#goto_command = "<leader>d"
    " 跳转到引入(import, 定义)
    let g:jedi#goto_assignments_command = "<leader>g"
    " 显示文档
    let g:jedi#documentation_command = "K"
    " 文档高度
    let g:jedi#max_doc_height = 15
    " 重命名
    let g:jedi#rename_command = "<leader>r"
    let g:jedi#usages_command = "<leader>n"
    " 在vim中打开模块(源码) :Pyimport
    " 自动初始化
    let g:jedi#auto_initialization = 1
    " 关掉jedi的补全样式，使用自定义的
    let g:jedi#auto_vim_configuration = 0
    " 输入点的时候自动补全
    let g:jedi#popup_on_dot = 1
    " 自动选中第一个
    " let g:jedi#popup_select_first = 0
    " 补全结束后自动关闭文档窗口
    let g:jedi#auto_close_doc = 1
    " 显示参数列表
    let g:jedi#show_call_signatures = 1
    " 延迟多久显示参数列表
    let g:jedi#show_call_signatures_delay = 300
    " 使用go to的时候使用tab而不是buffer
    let g:jedi#use_tabs_not_buffers = 1
    " 开启jedi补全
    let g:jedi#completions_enabled = 1
    " 指定使用go to使用split的方式，并指定split位置
    let g:jedi#use_splits_not_buffers = 'bottom'
    " 强制使用python3运行jedi
    " let g:jedi#force_py_version = 3
    " 自动完成from .. import ..
    let g:jedi#smart_auto_mappings = 1
endif
" }}2

" nerdtree {{2
if isdirectory(expand('~/.vim/plugged/nerdtree'))
    " 使用箭头表示文件夹折叠
    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
    let g:NERDTreeWinPos = "left"
    let g:NERDTreeWinSize = "35"
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeShowBookmarks=1
    let NERDTreeChDirMode=0
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
    " 多个tab的nerdtree同步
    let g:nerdtree_tabs_synchronize_view = 1

    " Automatically find and select currently opened file in NERDTree
    let g:nerdtree_tabs_open_on_console_startup=0
    let g:nerdtree_tabs_open_on_gui_startup=0
    let g:nerdtree_tabs_open_on_new_tab=1

    if IsWin()
        let g:NERDTreeIndicatorMapCustom = {
                    \ "Modified"  : "M",
                    \ "Staged"    : "S",
                    \ "Untracked" : "U",
                    \ "Renamed"   : "R",
                    \ "Unmerged"  : "u",
                    \ "Deleted"   : "X",
                    \ "Dirty"     : "D",
                    \ "Clean"     : "C",
                    \ "Unknown"   : "?"
                    \ }
    else
        let g:NERDTreeIndicatorMapCustom = {
                    \ "Modified"  : "✹",
                    \ "Staged"    : "✚",
                    \ "Untracked" : "✭",
                    \ "Renamed"   : "➜",
                    \ "Unmerged"  : "═",
                    \ "Deleted"   : "✖",
                    \ "Dirty"     : "✗",
                    \ "Clean"     : "✔︎",
                    \ "Unknown"   : "?"
                    \ }
    endif



    " NERDTress File highlighting
    function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
        exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
        exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
    endfunction

    call NERDTreeHighlightFile('java'   , 'green'   , 'none' , 'green'   , '#151515')
    call NERDTreeHighlightFile('vim'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('md'     , 'blue'    , 'none' , '#3366FF' , '#151515')
    call NERDTreeHighlightFile('xml'    , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('config' , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('conf'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('json'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('html'   , 'yellow'  , 'none' , 'yellow'  , '#151515')
    call NERDTreeHighlightFile('styl'   , 'cyan'    , 'none' , 'cyan'    , '#151515')
    call NERDTreeHighlightFile('css'    , 'cyan'    , 'none' , 'cyan'    , '#151515')
    call NERDTreeHighlightFile('coffee' , 'Red'     , 'none' , 'red'     , '#151515')
    call NERDTreeHighlightFile('js'     , 'Red'     , 'none' , '#ffa500' , '#151515')
    call NERDTreeHighlightFile('python' , 'Magenta' , 'none' , '#ff00ff' , '#151515')

    nnoremap <leader>e :NERDTreeFind<CR>
    nnoremap <Leader>tn :NERDTreeTabsToggle<CR>
    call DoMap('nnore', 'n', ':NERDTreeTabsToggle<cr>')
    " 快速切换nerdtree到当前文件目录
    nnoremap <silent><leader>n :exec("NERDTree ".expand('%:h'))<CR>
endif
" }}2

" nerdcommenter {{2
if isdirectory(expand('~/.vim/plugged/nerdcommenter'))
    " Use compact syntax for prettified multi-line comments
    let g:NERDCompactSexyComs = 1
    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'
    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_java = 1
    " 添加自定义注释或者覆盖已有注释
    let g:NERDCustomDelimiters={
        \ 'python': { 'left': '#' },
        \ }
        " \ 'python': { 'left': '#', 'right': '#' }
    " 可以注释和反注释空行
    let g:NERDCommentEmptyLines = 1
    " 取消注释的时候去掉两端空格
    let g:NERDTrimTrailingWhitespace=1
    let g:NERDSpaceDelims=1
    let g:NERDRemoveExtraSpaces=1
endif
" }}2

" tagbar {{2
if isdirectory(expand('~/.vim/plugged/tagbar'))
    let g:tagbar_left=0
    let g:tagbar_width = 30
    let g:tagbar_zoomwidth = 0          " 缩放以使最长行可见
    let g:tagbar_show_visibility = 1    " 显示可见性
    let g:tagbar_iconchars = ['▶', '▼'] " 折叠字符

    nnoremap <leader>tt :TagbarToggle<cr>
    " call DoMap('nnore', 't', ':TagbarToggle<cr>')
endif
" }}2

" vim-expand-region {{2
if isdirectory(expand('~/.vim/plugged/vim-expand-region'))
    vmap v <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)
endif
" }}2

" vim-multiple-cursors {{2
if isdirectory(expand('~/.vim/plugged/vim-multiple-cursors'))
    let g:multi_cursor_next_key='<C-n>'
    let g:multi_cursor_prev_key='<C-p>'
    let g:multi_cursor_skip_key='<C-x>'
    let g:multi_cursor_quit_key='<c-[>'
    nnoremap <c-c> :call multiple_cursors#quit()<CR>
    call DoMap('nnore', '/', ':MultipleCursorsFind <c-r>/<cr>', ['<silent>'])
    call DoMap('vnore', '/', ':MultipleCursorsFind <c-r>/<cr>', ['<silent>'])

    " 和 neocomplete 整合{{3
    " Called once right before you start selecting multiple cursors
    function! Multiple_cursors_before()
      if exists(':NeoCompleteLock')==2
        exe 'NeoCompleteLock'
      endif
    endfunction

    " Called once only when the multiple selection is canceled (default <Esc>)
    function! Multiple_cursors_after()
      if exists(':NeoCompleteUnlock')==2
        exe 'NeoCompleteUnlock'
      endif
    endfunction " }}3
    " 多光标高亮样式 (see help :highlight and help :highlight-link)
    " highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
    " highlight link multiple_cursors_visual Visual
endif
" }}2

" lightline {{2
if isdirectory(expand('~/.vim/plugged/lightline.vim'))
    let g:lightline = {
                \ 'colorscheme': 'default',
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ]],
                \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
                \ },
                \ 'component_expand': {
                \   'syntastic': 'SyntasticStatuslineFlag',
                \ },
                \ 'component_type': {
                \   'syntastic': 'error',
                \ },
                \ 'subseparator': { 'left': '>', 'right': '<' }
                \ }
                " \ 'subseparator': { 'left': '›', 'right': '‹' }
    let g:tagbar_status_func = 'TagbarStatusFunc'

    function! TagbarStatusFunc(current, sort, fname, ...) abort
        let g:lightline.fname = a:fname
        return lightline#statusline(0)
    endfunction
endif
" }}2

" vim-markdown {{2
if isdirectory(expand('~/.vim/plugged/vim-markdown'))
    " 关掉它自带的折叠
    let g:vim_markdown_toc_autofit = 1
    let g:vim_markdown_emphasis_multiline = 0
    " 关闭语法隐藏，显示markdown源码而不要隐藏一些东西
    " let g:vim_markdown_conceal = 0
    " 代码块语法
    let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']
endif
" }}2

" vim-easy-align {{2
if isdirectory(expand('~/.vim/plugged/vim-easy-align'))
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = {
    \ '>': { 'pattern': '>>\|=>\|>' },
    \ '/': {
    \     'pattern':         '//\+\|/\*\|\*/',
    \     'delimiter_align': 'l',
    \     'ignore_groups':   ['!Comment'] },
    \ ']': {
    \     'pattern':       '[[\]]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ ')': {
    \     'pattern':       '[()]',
    \     'left_margin':   0,
    \     'right_margin':  0,
    \     'stick_to_left': 0
    \   },
    \ 'd': {
    \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
    \     'left_margin':  0,
    \     'right_margin': 0
    \   }
    \ }
endif
" }}2

" vim-surround {{2
if isdirectory(expand('~/.vim/plugged/vim-surround'))
    vmap Si S(i_<esc>f)
endif
" }}2

" undotree {{2
if isdirectory(expand('~/.vim/plugged/undotree'))
    nnoremap <leader>tu :UndotreeToggle<cr>
    nnoremap <space>u :UndotreeToggle<cr>
    let g:undotree_SetFocusWhenToggle=1
endif
" }}2

" autopair {{2
if isdirectory(expand('~/.vim/plugged/auto-pairs'))
    "  什么时候想自己写插件应该看看这个插件的源码
    let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'",'"':'"', '`':'`'}
    let g:AutoPairsShortcutToggle = '<leader>ta'
    if IsOSX()
        let g:AutoPairsShortcutFastWrap = 'å'
    elseif IsLinux() && !IsGui()
        let g:AutoPairsShortcutFastWrap = 'a'
    else
        let g:AutoPairsShortcutFastWrap = '<a-a>'
    endif
endif
" }}2

" MatchTagAlways {{2
if isdirectory(expand('~/.vim/plugged/MatchTagAlways'))
    let g:mta_use_matchparen_group = 1
    let g:mta_filetypes = {
                \ 'html' : 1,
                \ 'xhtml' : 1,
                \ 'xml' : 1,
                \}
endif
" }}2

" Fugitive {{2
if isdirectory(expand('~/.vim/plugged/vim-fugitive'))
    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
endif
" }}2

" rainbow {{2
if isdirectory(expand('~/.vim/plugged/rainbow'))
    let g:rainbow_conf = {
        \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
        \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
        \   'operators': '_,_',
        \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
        \   'separately': {
        \       '*': {},
        \       'tex': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
        \       },
        \       'lisp': {
        \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
        \       },
        \       'vim': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
        \       },
        \       'html': {
        \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
        \       },
        \       'css': 0,
        \   }
        \}
    let g:rainbow_active = 1
    nnoremap <leader>tr :RainbowToggle<cr>
endif
" }}2

" vim-json {{2
if isdirectory(expand('~/.vim/plugged/vim-json'))
    nnoremap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
endif
" }}2

" vim-javascript {{2
if isdirectory(expand('~/.vim/plugged/vim-javascript'))
    " 语法高亮插件
    let g:javascript_plugin_jsdoc = 1
    " 为jsDoc开启语法高亮
    let g:javascript_plugin_ngdoc = 1
    " Enables some additional syntax highlighting for NGDocs
    let g:javascript_plugin_flow = 1
    " 按照语法折叠
    " set foldmethod=syntax

    let g:javascript_conceal_function       = "ƒ"
    let g:javascript_conceal_null           = "ø"
    let g:javascript_conceal_this           = "@"
    " let g:javascript_conceal_return         = "⇚"
    let g:javascript_conceal_undefined      = "¿"
    " let g:javascript_conceal_NaN            = "ℕ"
    let g:javascript_conceal_prototype      = "¶"
    " let g:javascript_conceal_static         = "•"
    let g:javascript_conceal_super          = "Ω"
    " let g:javascript_conceal_arrow_function = "⇒"
endif
" }}2

" MarkdownPreview {{2
if isdirectory(expand('~/.vim/plugged/markdown-preview.vim'))
    if IsOSX()
        let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
        " path to the chrome or the command to open chrome(or other modern browsers)
    elseif IsLinux()
        if executable('chrome')
            let g:mkdp_path_to_chrome = "chrome"
        elseif executable('chromium')
            let g:mkdp_path_to_chrome = "chromium"
        elseif executable('chromium-browser')
            let g:mkdp_path_to_chrome = "chromium-browser"
        endif
    endif
    " path to the chrome or the command to open chrome(or other modern browsers)

    let g:mkdp_auto_start = 0
    " set to 1, the vim will open the preview window once enter the markdown
    " buffer

    let g:mkdp_auto_open = 0
    " set to 1, the vim will auto open preview window when you edit the
    " markdown file

    let g:mkdp_auto_close = 1
    " set to 1, the vim will auto close current preview window when change
    " from markdown buffer to another buffer

    let g:mkdp_refresh_slow = 0
    " set to 1, the vim will just refresh markdown when save the buffer or
    " leave from insert mode, default 0 is auto refresh markdown as you edit or
    " move the cursor

    let g:mkdp_command_for_global = 0
    " set to 1, the MarkdownPreview command can be use for all files,
    " by default it just can be use in markdown file vim-instant-markdown
    if IsOSX()
        let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
    endif
endif
" }}2

" vim-over {{2
if isdirectory(expand('~/.vim/plugged/vim-over'))
    " <leader>rr快速执行替换预览
    nnoremap <leader>rr :OverCommandLine<cr>%s/
endif
" }}2

" CtrlSF {{2
if isdirectory(expand('~/.vim/plugged/ctrlsf.vim'))
    call DoAltMap('nnore', 'f', ':CtrlSF ')
    call DoMap('nnore', 'f', ':CtrlSFToggle<cr>')
endif
" }}2

" vim-autopep8 {{2
if isdirectory(expand('~/.vim/plugged/vim-autopep8'))
    " 格式化完成后不要显示diff窗口
    let g:autopep8_disable_show_diff = 0
endif
" }}2

" syntastic {{2
if isdirectory(expand('~/.vim/plugged/syntastic'))
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 1
    let g:syntastic_enable_signs=1
    let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_aggregate_errors = 1 " 显示多个检查器的错误
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_javascript_checkers = ['jshint']
    let g:syntastic_python_flake8_args='--max-line-length=84'
endif
"}}2

" textobj-user {{2
" if isdirectory(expand('~/.vim/plugged/vim-textobj-user'))
"     call textobj#user#plugin('datetime', {
"     \   'date': {
"     \     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
"     \     'select': ['ad', 'id'],
"     \   },
"     \ })
" endif
"}}2

" vim-shell {{2 for linux and osx
" if isdirectory(expand('~/.vim/plugged/vimshell.vim')) && !IsWin()
"     nnoremap <space>s :VimShellTab<cr>
"     nnoremap <space>d :VimShellPop<cr><esc>
"
"     if has('win32') || has('win64')
"       " Display user name on Windows.
"       let g:vimshell_prompt = $USERNAME."% "
"     else
"       " Display user name on Linux.
"       let g:vimshell_prompt = $USER."% "
"     endif
"
"     " Initialize execute file list.
"     let g:vimshell_execute_file_list = {}
"     call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
"     let g:vimshell_execute_file_list['rb'] = 'ruby'
"     let g:vimshell_execute_file_list['pl'] = 'perl'
"     let g:vimshell_execute_file_list['py'] = 'python3'
"     call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
"
"     autocmd FileType vimshell
"     \ call vimshell#altercmd#define('g', 'git')
"     \| call vimshell#altercmd#define('i', 'iexe')
"     \| call vimshell#altercmd#define('l', 'll')
"     \| call vimshell#altercmd#define('ll', 'ls -l')
"     \| call vimshell#altercmd#define('la', 'ls -lahk')
"     \| call vimshell#altercmd#define('p', 'python3')
"     \| call vimshell#hook#add('chpwd', 'my_chpwd', 'MyChpwd')
"
"     function! MyChpwd(args, context)
"       call vimshell#execute('ls')
"     endfunction
"
"     " 覆盖statusline
"     let g:vimshell_force_overwrite_statusline=0
"     augroup vim_shell
"         autocmd!
"         autocmd FileType vimshell :UltiSnipsAddFiletypes vimshell<cr>
"     augroup END
" endif
" }}2

" FZF {{2 for linux and osx
if isdirectory(expand('~/.vim/plugged/fzf.vim')) && !IsWin()
    if exists('g:s_has_fzf')
        " 这三个快捷键指定用什么方式打开选中的内容
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-x': 'split',
          \ 'ctrl-v': 'vsplit' }

        " Default fzf layout
        " - down / up / left / right
        let g:fzf_layout = { 'down': '~40%' }

        " In Neovim, you can set up fzf window using a Vim command
        let g:fzf_layout = { 'window': 'enew' }
        let g:fzf_layout = { 'window': '-tabnew' }

        " 自定义fzf的配色
        let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
          \ 'bg':      ['bg', 'Normal'],
          \ 'hl':      ['fg', 'Comment'],
          \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
          \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
          \ 'hl+':     ['fg', 'Statement'],
          \ 'info':    ['fg', 'PreProc'],
          \ 'prompt':  ['fg', 'Conditional'],
          \ 'pointer': ['fg', 'Exception'],
          \ 'marker':  ['fg', 'Keyword'],
          \ 'spinner': ['fg', 'Label'],
          \ 'header':  ['fg', 'Comment'] }

        " Enable per-command history.
        " CTRL-N and CTRL-P will be automatically bound to next-history and
        " previous-history instead of down and up. If you don't like the change,
        " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
        let g:fzf_history_dir = '~/.fzf-history'

        " 自定义命令选项
        " [Files] 使用Files命令时使用coderay来预览文件内容(http://coderay.rubychan.de/)
        let g:fzf_files_options =
          \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
        " [Buffers] 使用Buffers命令时如果可能的话自动跳到目标窗口，而不是新打开一个
        let g:fzf_buffers_jump = 1
        " [[B]Commits] 使用[B]Commit时自定义git log输出形式
        let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
        " [Tags] 生成tags文件的命令
        let g:fzf_tags_command = 'ctags -R'
        " [Commands] 使用Commands时候直接执行选中命令的快捷键
        let g:fzf_commands_expect = 'alt-enter, ctrl-x'

        " maps
        nmap <leader><tab> <plug>(fzf-maps-n)
        xmap <leader><tab> <plug>(fzf-maps-x)
        omap <leader><tab> <plug>(fzf-maps-o)
        " Insert mode completion
        imap <c-x><c-k> <plug>(fzf-complete-word)
        imap <c-x><c-f> <plug>(fzf-complete-path)
        imap <c-x><c-j> <plug>(fzf-complete-file-ag)
        imap <c-x><c-l> <plug>(fzf-complete-line)
        " Advanced customization using autoload functions
        " inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
        " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

        " status line
        if has('nvim')
            function! s:fzf_statusline()
              " Override statusline as you like
              highlight fzf1 ctermfg=161 ctermbg=251
              highlight fzf2 ctermfg=23 ctermbg=251
              highlight fzf3 ctermfg=237 ctermbg=251
              setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
            endfunction

            autocmd! User FzfStatusLine call <SID>fzf_statusline()
        endif
    endif

    nnoremap <leader>h  :Helptags<cr>
    nnoremap <leader>gf :GFiles?<cr>
    nnoremap <leader>gl :GFiles<cr>
    nnoremap <leader>gc :Commits<cr>
    nnoremap <leader>gb :VCommits<cr>
    nnoremap <leader>gg :Lines<cr>
    nnoremap <leader>G  :BLines<cr>
    nnoremap <leader>fs :Snippets<cr>
    nnoremap <leader>fm :Maps<cr>
    nnoremap <leader>fh :History<cr>
    nnoremap <leader>f: :History:<cr>
    nnoremap <leader>f/ :History/<cr>
    nnoremap <leader>ff :Ag<cr>
    nnoremap <leader>fb :Buffers<cr>
    call DoMap('nnore', 'o', ':Files<cr>')
    call DoMap('nnore', 'O', ':Files ')
    call DoMap('nnore', 'b', ':Buffers<cr>')
    call DoMap('nnore', 'a', ':Ag<cr>')
    call DoMap('nnore', 'l', ':Lines<cr>')
    " Files [PATH]    |  Files (similar to :FZF)
    " GFiles [OPTS]   |  Git files (git ls-files)
    " GFiles?         |  Git files (git status)
    " Buffers         |  Open buffers
    " Colors          |  Color schemes
    " Ag [PATTERN]    |  ag search result (ALT-A to select all, ALT-D to deselect all)
    " Lines [QUERY]   |  Lines in loaded buffers
    " BLines [QUERY]  |  Lines in the current buffer
    " Tags [QUERY]    |  Tags in the project (ctags -R)
    " BTags [QUERY]   |  Tags in the current buffer
    " Marks           |  Marks
    " Windows         |  Windows
    " Locate PATTERN  |  locate command output
    " History         |  v:oldfiles and open buffers
    " History:        |  Command history
    " History/        |  Search history
    " Snippets        |  Snippets (UltiSnips)
    " Commits         |  Git commits (requires fugitive.vim)
    " BCommits        |  Git commits for the current buffer
    " Commands        |  Commands
    " Maps            |  Normal mode mappings
    " Helptags        |  Help tags 1
    " Filetypes       |  File types
endif
" }}2

" monokai {{2
if isdirectory(expand('~/.vim/plugged/vim-monokai'))
    colorscheme monokai
endif
" }}2

" molokai {{2
" if isdirectory(expand('~/.vim/plugged/molokai'))
"     colorscheme molokai
" endif
" }}2

" }}1

" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:
