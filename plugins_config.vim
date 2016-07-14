""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This is the personal vimrc file of Linfee
" FILE:     plugins_config.vim
" Author:   Linfee
" EMAIL:    Linfee@hotmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" >>> Plugins {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
""""""""""""""""""""""""""""""""""""""""[edit]	
" 自动补全
Plug 'Shougo/neocomplete.vim'
" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" 多光标
Plug 'terryma/vim-multiple-cursors'
" 用来做包围的插件
Plug 'tpope/vim-surround'
" 让surround可以用.重复
Plug 'tpope/vim-repeat'
" 排版工具
Plug 'godlygeek/tabular'
" auto-pairs
Plug 'jiangmiao/auto-pairs'
""""""""""""""""""""""""""""""""""""""""[find]
Plug 'vim-scripts/EasyGrep'
" ctrlP插件
Plug 'ctrlpvim/ctrlp.vim'
""""""""""""""""""""""""""""""""""""""""[move and select]
Plug 'terryma/vim-expand-region'
" easymotion
Plug 'easymotion/vim-easymotion'
""""""""""""""""""""""""""""""""""""""""[git]
Plug 'tpope/vim-fugitive'
""""""""""""""""""""""""""""""""""""""""[language]
Plug 'derekwyatt/vim-scala'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'klen/python-mode'
Plug 'plasticboy/vim-markdown'
""""""""""""""""""""""""""""""""""""""""[ui]
Plug 'itchyny/lightline.vim'
" 几个配色
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
""""""""""""""""""""""""""""""""""""""""[extension]
" 缩进可视化
Plug 'Yggdroot/indentLine'
" Nerdtree 和 它的增强
Plug 'jistr/vim-nerdtree-tabs' | Plug 'scrooloose/nerdtree'
" Nerdtree 的 git插件
Plug 'Xuyuanp/nerdtree-git-plugin'
" Nerd 注释插件
Plug 'scrooloose/nerdcommenter'
" tagbar
Plug 'majutsushi/tagbar'
" 书签强化
Plug 'kshenoy/vim-signature'
" 更好的折叠体验
Plug 'Konfekt/FastFold'
" vim异步执行库，安装后需要到安装目录执行`make`
Plug 'Shougo/vimproc.vim'
" 基于vim异步执行库vimshell
Plug 'Shougo/vimshell.vim'
" 图形化的多分支的undo
Plug 'mbbill/undotree'
""""""""""""""""""""""""""""""""""""""""[help]
Plug 'strom3xFeI/vimdoc-cn'
" Add plugins to &runtimepath
call plug#end()
" }}}1


" >>> Plugin config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" >>>>> Neocomplete {{{
"""""""""""""""""""""""""""""""""""""""
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
			\ 'default' : '',
			\ 'vimshell' : $HOME.'/.vimshell_hist',
			\ 'scheme' : $HOME.'/.gosh_completions'
			\ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
	return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
	" For no inserting <CR> key.
	"return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
augroup omnif
	autocmd!
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}


" >>>>> Nerdtree {{{
""""""""""""""""""""""""""""""""""""""""
" 使用箭头表示文件夹折叠
let g:NERDTreeDirArrowExpandable = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'
let g:NERDTreeWinPos = "left"
let g:NERDTreeWinSize = "35"
let g:NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '\~$', '__pycache__', '\.swp']

" Automatically find and select currently opened file in NERDTree
let g:nerdtree_tabs_open_on_console_startup=0
let g:nerdtree_tabs_open_on_gui_startup=0
let g:nerdtree_tabs_open_on_new_tab=1

nnoremap <Leader>n :NERDTreeTabsToggle<CR>
nnoremap <space>n :NERDTreeTabsToggle<CR>

let g:NERDTreeIndicatorMapCustom = {
			\ "Modified"  : "*",
			\ "Staged"    : "+",
			\ "Untracked" : "-",
			\ "Renamed"   : "R",
			\ "Unmerged"  : "═",
			\ "Deleted"   : "X",
			\ "Dirty"     : "✗",
			\ "Clean"     : "✔︎",
			\ "Unknown"   : "?"
			\ }
"  ✹ ✚ ✭ ➜ ═ ✖ ✗ ✔︎ ?

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
" }}}


" >>>>> nerdcommenter {{{
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" 添加自定义注释或者覆盖已有注释
" let g:NERDCustomDelimiters={
"     \ 'markdown': { 'left': '<!--', 'right': '-->' },
"     \ }
" 可以注释和反注释空行
let g:NERDCommentEmptyLines = 1
" 取消注释的时候去掉两端空格
let g:NERDTrimTrailingWhitespace=1
let g:NERDSpaceDelims=1
let g:NERDRemoveExtraSpaces=1

" }}}


" >>>>> TagBar {{{
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <space>t :TagbarToggle<cr>
" }}}


" >>>>> CtrlP {{{
""""""""""""""""""""""""""""""""""""""""
" Default mapping and default command
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" 设置默认的查找起始目录
let g:ctrlp_working_path_mode = 'ra'
" 自定义的默认查找起始目录
let g:ctrlp_root_markers = ['.p, .vim, home']
" 忽略这些文件
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
" 设置一下ctrlp的窗口高度
let g:ctrlp_max_height = 10

" Exclude files and directories using Vim's wildignore and CtrlP's own g:ctrlp_custom_ignore
" Use a custom file listing command
if IsWin()
	set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
else
	set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
	let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
endif

nnoremap <leader>o :CtrlP<CR>
nnoremap <space>o :CtrlP<CR>
nnoremap <leader>O :CtrlPBuffer<cr>
nnoremap <space>O :CtrlPBuffer<cr>
" }}}


" >>>>> vim-expand-region {{{
""""""""""""""""""""""""""""""""""""""""
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" }}}


" >>>>> vim-surround {{{
""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
" }}}


" >>>>> vim-multiple-cursors {{{
""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<c-s>"
" }}}


" >>>>> lightline {{{
"""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
	  \ 'colorscheme': 'wombat',
	  \ 'active': {
	  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
	  \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
	  \ },
	  \ 'component_function': {
	  \   'fugitive': 'LightLineFugitive',
	  \   'filename': 'LightLineFilename',
	  \   'fileformat': 'LightLineFileformat',
	  \   'filetype': 'LightLineFiletype',
	  \   'fileencoding': 'LightLineFileencoding',
	  \   'mode': 'LightLineMode',
	  \   'ctrlpmark': 'CtrlPMark',
	  \ },
	  \ 'component_expand': {
	  \   'syntastic': 'SyntasticStatuslineFlag',
	  \ },
	  \ 'component_type': {
	  \   'syntastic': 'error',
	  \ },
	  \ 'subseparator': { 'left': '|', 'right': '|' }
	  \ }

function! LightLineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
		\ fname == '__Tagbar__' ? g:lightline.fname :
		\ fname =~ '__Gundo\|NERD_tree' ? '' :
		\ &ft == 'vimfiler' ? vimfiler#get_status_string() :
		\ &ft == 'unite' ? unite#get_status_string() :
		\ &ft == 'vimshell' ? vimshell#get_status_string() :
		\ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
		\ ('' != fname ? fname : '[No Name]') .
		\ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
	if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
	  let mark = ''  " edit here for cool mark
	  let branch = fugitive#head()
	  return branch !=# '' ? mark.branch : ''
	endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
		\ fname == 'ControlP' ? 'CtrlP' :
		\ fname == '__Gundo__' ? 'Gundo' :
		\ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
		\ fname =~ 'NERD_tree' ? 'NERDTree' :
		\ &ft == 'unite' ? 'Unite' :
		\ &ft == 'vimfiler' ? 'VimFiler' :
		\ &ft == 'vimshell' ? 'VimShell' :
		\ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
	call lightline#link('iR'[g:lightline.ctrlp_regex])
	return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
		  \ , g:lightline.ctrlp_next], 0)
  else
	return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
	let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction
" }}}


"  >>>>> ultisnips {{{
""""""""""""""""""""""""""""""""""""""""
" 定义snippet文件存放的位置
let g:UltiSnipsSnippetsDir=expand("$VIMFILES/supervim/ultisnips")
let g:UltiSnipsSnippetDirectories=["UltiSnips", "supervim/ultisnips"]

" Trigger configuration.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
nnoremap <leader>a :UltiSnipsAddFiletypes<space> 
nnoremap <space>a :UltiSnipsAddFiletypes<space> 

" execute是一个命令，没有对应的方法，定义一个，在snippets中用
function! EXE(e)
	execute(a:e)
endfunctio

" }}}


"  >>>>> vim-markdown {{{
""""""""""""""""""""""""""""""""""""""""
" 类似python-mode的折叠
" 关掉它自带的折叠
let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_style_pythonic = 1
"let g:vim_markdown_folding_level = 2
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0
" 关闭语法隐藏，显示markdown源码而不要隐藏一些东西
let g:vim_markdown_conceal = 0
" 代码块语法
let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']
" }}}


"  >>>>> vim-javacomplete2 {{{
""""""""""""""""""""""""""""""""""""""""
augroup javacomplete2
	autocmd!
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
	autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInf
	"autocmd FileType java inoremap <expr><space> pumvisible() ? "\<F2>" : "<space>"
	autocmd FileType java inoremap  . .
	autocmd FileType java call JavaComplete2Config()
augroup END
function! JavaComplete2Config()
	" 自动闭合方法的反括号
	let g:JavaComplete_ClosingBrace = 1 
	" 不要自动导入第一个
	let g:JavaComplete_ImportDefault = -1
	"Enable smart (trying to guess import option) inserting class imports
	nmap <buffer> <F2> <Plug>(JavaComplete-Imports-AddSmart)
	imap <buffer> <F2> <Plug>(JavaComplete-Imports-AddSmart)
	"Enable usual (will ask for import option) inserting class imports
	nmap <buffer> <F3> <Plug>(JavaComplete-Imports-Add)
	imap <buffer> <F3> <Plug>(JavaComplete-Imports-Add)
	"Add all missing imports
	nmap <buffer> <F4> <Plug>(JavaComplete-Imports-AddMissing)
	imap <buffer> <F4> <Plug>(JavaComplete-Imports-AddMissing)
	"Remove all missing imports
	nmap <buffer> <F6> <Plug>(JavaComplete-Imports-RemoveUnused)
	imap <buffer> <F6> <Plug>(JavaComplete-Imports-RemoveUnused)
endfunction
" }}}


"  >>>>> vimshell {{{
""""""""""""""""""""""""""""""""""""""""
nnoremap <space>s :VimShellTab<cr> 
nnoremap <space>d :VimShellPop<cr>
" 覆盖statusline
let g:vimshell_force_overwrite_statusline=0
inoremap <c-j> <c-r>=UltiSnips#ExpandSnippet()<cr>
inoremap <c-k> <c-r>=UltiSnips#JumpForwards()<cr>
augroup vim_shell
	autocmd!
	autocmd FileType vimshell :UltiSnipsAddFiletypes vimshell<cr>
augroup END
"TODO: vimshell
" }}}


"  >>>>> python-mode {{{
""""""""""""""""""""""""""""""""""""""""
" Turn the plugin
let g:pymode = 1
" Turn off plugin's warnings
" let g:pymode_warnings = 1
" Trim unused white spaces on save
let g:pymode_trim_whitespaces = 1
" Setup default python options
let g:pymode_options = 1
" Setup pymode quickfix window
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 6
" 设置python版本
let g:pymode_python = 'python3'
" Enable pymode indentation
let g:pymode_indent = 1
" 开启python折叠
let g:pymode_folding = 1
" Turns on the documentation script
let g:pymode_doc = 1
" Bind keys to show documentation for current word (selection)
let g:pymode_doc_bind = 'K'
" Turn on code checking
let g:pymode_lint = 1
" Check code when editing
let g:pymode_lint_on_fly = 1
" 开启补全
let g:pymode_rope_completion = 1
" }}}


"  >>>>> indentLine {{{
" Vim
let g:indentLine_color_term = 239
"GVim
let g:indentLine_color_gui = '#A4E57E'
" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" 设置表示缩进的字符
" let g:indentLine_char = 'c'
" 默认关闭
let g:indentLine_enabled = 1
nnoremap <space>i :IndentLinesToggle<cr>
nnoremap <leader>ai :IndentLinesToggle<cr>
" }}}


"  >>>>> tabularize {{{
nnoremap <Leader>a& :Tabularize /&<CR>
vnoremap <Leader>a& :Tabularize /&<CR>
nnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a= :Tabularize /=<CR>
nnoremap <Leader>a: :Tabularize /:<CR>
vnoremap <Leader>a: :Tabularize /:<CR>
nnoremap <Leader>a:: :Tabularize /:\zs<CR>
vnoremap <Leader>a:: :Tabularize /:\zs<CR>
nnoremap <Leader>a, :Tabularize /,<CR>
vnoremap <Leader>a, :Tabularize /,<CR>
nnoremap <Leader>a,, :Tabularize /,\zs<CR>
vnoremap <Leader>a,, :Tabularize /,\zs<CR>
nnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
vnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
"  }}}


"  >>>>> vim-surround {{{
" vim-surround常用快捷键
"Normal mode
"    ds  - delete a surrounding
"    cs  - change a surrounding
"    ys  - add a surrounding
"    yS  - add a surrounding and place the surrounded text on a new line + indent it
"    yss - add a surrounding to the whole line
"    ySs - add a surrounding to the whole line, place it on a new line + indent it
"    ySS - same as ySs
   
" Visual mode
"    s   - in visual mode, add a surrounding
"    S   - in visual mode, add a surrounding but place text on new line + indent it
    
" Insert mode
"    <CTRL-s> - in insert mode, add a surrounding
"    <CTRL-s><CTRL-s> - in insert mode, add a new line + surrounding + indent
"    <CTRL-g>s - same as <CTRL-s>
"    <CTRL-g>S - same as <CTRL-s><CTRL-s>
"  }}}


"  >>>>> undotree {{{
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <space>u :UndotreeToggle<cr>
"  }}}


"  >>>>> auto-pairs {{{
"  什么时候想自己写插件应该看看这个插件的源码
let g:AutoPairs = {'(':')', '[':']', '{':'}', '<':'>',"'":"'",'"':'"', '`':'`'}
let g:AutoPairsShortcutToggle = '<leader>ac'
if IsOSX()
	let g:AutoPairsShortcutFastWrap = 'å'
elseif IsLinux() && !IsGui()
	let g:AutoPairsShortcutFastWrap = 'a'
else
	let g:AutoPairsShortcutFastWrap = '<a-a>'
endif
"  }}}


"TODO: vim-multiple-cursors
"TODO: EasyGrep
"TODO: easymotion
"TODO: vim-surround
"TODO: Fugitive
"TODO: pymode

