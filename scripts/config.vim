set cpoptions&vim
scriptencoding utf-8

let g:plugex_use_log = 0
let g:plugex_use_cache = 1
let g:use_lightline = get(g:, 'use_lightline', 1)
let g:no_nerd_font = get(g:, 'no_nerd_font')

if !g:is_nvim
  com UpdateRemotePlugins echo ''
en

let g:plugex_cache_dir_name = g:_vim
if plugex#begin()

  " ===========================================================================
  " ui
  " ===========================================================================
  " colors
  PlugEx 'junegunn/seoul256.vim'
  PlugEx 'morhetz/gruvbox'
  PlugEx 'sickill/vim-monokai'
  PlugEx 'altercation/vim-colors-solarized'
  PlugEx 'joshdick/onedark.vim'

  PlugEx 'mhinz/vim-startify', {'on_event': 'VimEnter'}
  PlugEx 'ryanoasis/vim-devicons', {'on_event': 'VimEnter', 'enable': !g:no_nerd_font}
  PlugEx 'itchyny/lightline.vim', {'on_event': 'VimEnter', 'enable': g:use_lightline}
  PlugEx 'junegunn/rainbow_parentheses.vim', {'on_event': 'VimEnter'}
  PlugEx 'junegunn/vim-emoji'
  PlugEx 'mhinz/vim-signify', {'on_event': 'VimEnter'}
  PlugEx 'itchyny/vim-cursorword'
  PlugEx 't9md/vim-choosewin', {'on': '<plug>(choosewin)'}
  PlugEx 'Yggdroot/indentLine', {'on': ['IndentLinesEnable', 'IndentLinesDisable', 'IndentLinesToggle']}

  " ===========================================================================
  " completion
  " ===========================================================================
  if g:is_nvim
    " let g:use_deoplete = get(g:, 'use_deoplete', 1)
    let g:use_ncm2 = get(g:, 'use_ncm2', 1)
  elseif has('lua')
    let g:use_neocomplete = get(g:, 'use_neocomplete', 1)
  endif

  " PlugEx 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp'], 'enable': 0}
  PlugEx 'SirVer/ultisnips', {'on_event': ['InsertEnter', 'CursorHold'], 'for': 'snippets'}
  PlugEx 'honza/vim-snippets', {'on_event': ['InsertEnter', 'CursorHold']}
  PlugEx 'Linfee/ultisnips-zh-doc', {'on_event': ['InsertEnter', 'CursorHold']}
  PlugEx 'Shougo/context_filetype.vim', {'on_event': 'InsertEnter'}

  " deoplete
  PlugEx 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins', 'on_event': 'InsertEnter', 'enable': get(g:, 'use_deoplete')}
  PlugEx 'zchee/deoplete-jedi', {'lazy': 1, 'enable': get(g:, 'use_deoplete')}
  PlugEx 'fszymanski/deoplete-emoji', {'lazy': 1, 'enable': get(g:, 'use_deoplete')}
  PlugEx 'zchee/deoplete-go', {
        \ 'do': 'make && !go get -u github.com/mdempsky/gocode',
        \ 'for': 'go', 'enable': get(g:, 'use_deoplete')}

  " completion for viml and show function params for viml and ruby
  PlugEx 'Shougo/neco-vim', {'on_event': 'InsertEnter'}
  PlugEx 'Shougo/echodoc.vim', {'on_event': 'InsertEnter', 'after': 'echodoc#enable'}
  PlugEx 'Shougo/neco-syntax', {'on_event': 'InsertEnter'} " for syntax

  " neocomplete
  PlugEx 'Shougo/neocomplete.vim',  {'on_event': 'InsertEnter', 'enable': get(g:, 'use_neocomplete')}

  " ncm2
  PlugEx 'ncm2/ncm2', {'enable': get(g:, 'use_ncm2')}
  PlugEx 'roxma/nvim-yarp', {'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-jedi', {'lazy': 1, 'enable': get(g:, 'use_ncm2')} " python
  PlugEx 'ncm2/ncm2-bufword', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-path', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-github', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-tmux', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-tagprefix', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'filipekiss/ncm2-look.vim', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'jsfaint/gen_tags.vim', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-syntax', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-cssomni', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-tern', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-vim', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-go', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-ultisnips', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-html-subscope', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-markdown-subscope', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'ncm2/ncm2-highprio-pop', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'yuki-ycino/ncm2-dictionary', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'fgrsnau/ncm2-aspell', {'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'fgrsnau/ncm2-otherbuf', {'branch': 'ncm2', 'lazy': 1, 'enable': get(g:, 'use_ncm2')}
  PlugEx 'gaalcaras/ncm-R', {'lazy': 1, 'enable': get(g:, 'use_ncm2'), 'for': 'r'}

  " ===========================================================================
  " editing
  " ===========================================================================
  PlugEx 'scrooloose/nerdcommenter', {'on_event': 'VimEnter'}
  PlugEx 'jiangmiao/auto-pairs', {'on_event': 'InsertEnter', 'after': 'AutoPairsTryInit'}
  PlugEx 'tpope/vim-surround', {'on_event': 'VimEnter'}
  " expand region
  PlugEx 'terryma/vim-expand-region', {'on': ['v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)']}
  " format and align
  PlugEx 'sbdchd/neoformat', {'on': 'Neoformat'}
  PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)'], 'on_event': 'CursorHold'}
  " movement
  PlugEx 'easymotion/vim-easymotion', {'on_event': 'VimEnter'}
  " multiple cursors
  PlugEx 'terryma/vim-multiple-cursors', {'on_event': 'VimEnter'}
  " see content of register
  PlugEx 'junegunn/vim-peekaboo', {'on_event': 'VimEnter'}

  PlugEx 'tpope/tpope-vim-abolish', {'on_event': 'VimEnter'}
  PlugEx 'tpope/vim-endwise', {'on_event': 'InsertEnter'}

  " textobj
  PlugEx 'kana/vim-textobj-user', {'lazy': 1}
  PlugEx 'kana/vim-textobj-indent', {'on_event': 'VimEnter'}
  PlugEx 'kana/vim-textobj-line', {'on_event': 'VimEnter'}
  PlugEx 'kana/vim-textobj-entire', {'on_event': 'VimEnter'}
  PlugEx 'kana/vim-textobj-syntax', {'on_event': 'VimEnter'}
  PlugEx 'kana/vim-textobj-lastpat', {'on_event': 'VimEnter'}

  " ===========================================================================
  " lang
  " ===========================================================================
  " front end
  PlugEx 'Valloric/MatchTagAlways', {'for': ['html', 'xml', 'xhtml', 'jsp']}
  PlugEx 'pangloss/vim-javascript', {'for': 'javascript'}
  PlugEx 'elzr/vim-json',           {'for': 'json'}
  PlugEx 'hail2u/vim-css3-syntax',  {'for': 'css'}
  PlugEx 'othree/html5.vim',        {'for': 'html'}
  PlugEx 'dag/vim-fish',            {'for': 'fish'}

  " markdown
  PlugEx 'godlygeek/tabular', {'on': ['Tabularize', 'AddTabularPattern', 'AddTabularPipeline']}
  PlugEx 'plasticboy/vim-markdown' " no plugin dir, no need to lazyload
  PlugEx 'iamcco/markdown-preview.vim', {'on': '<Plug>MarkdownPreview'}
  PlugEx 'mzlogin/vim-markdown-toc', {'on_event': ['VimEnter', 'InsertEnter', 'if &ft==''markdown''']}

  " javascript
  PlugEx 'othree/javascript-libraries-syntax.vim' " no plugin dir, no need to lazyload

  " python
  PlugEx 'davidhalter/jedi-vim', {'on_event': ['VimEnter', 'InsertEnter', 'if &ft==''python''']}

  " ruby
  PlugEx 'vim-ruby/vim-ruby' " no plugin dir, no need to lazyload

  " kotlin
  PlugEx 'udalov/kotlin-vim' " no plugin dir, no need to lazyload

  " scala
  PlugEx 'derekwyatt/vim-scala', {'for': 'scala'}

  " go
  PlugEx 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}

  " vimwiki
  PlugEx 'vimwiki/vimwiki', {'for': 'vimwiki', 'on_event': 'CursorHold'}

  " xml
  PlugEx 'sukima/xmledit' " no plugin dir, no need to lazyload

  " viml dev
  " go to define
  PlugEx 'mhinz/vim-lookup', {'on_func': ['lookup#lookup', 'lookup#pop']}
  " plugin for making plugin
  PlugEx 'tpope/vim-scriptease', {'on_event': 'VimEnter'}
  " get the version of Vim and Neovim that introduced or removed features
  PlugEx 'tweekmonster/helpful.vim', {'on': 'HelpfulVersion', 'for': 'help'}
  " for test
  PlugEx 'junegunn/vader.vim', {'on': 'Vader'}

  " ===========================================================================
  " tools
  " ===========================================================================
  " nerdtree
  PlugEx 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle']}
  PlugEx 'jistr/vim-nerdtree-tabs', {'lazy': 1}
  PlugEx 'Xuyuanp/nerdtree-git-plugin', {'lazy': 1}
  PlugEx 'Linfee/nerdtree-open', {'lazy': 1}

  " tagbar
  PlugEx 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar'], 'enable': executable('ctags')}

  " undotree
  PlugEx 'mbbill/undotree',    {'on': 'UndotreeToggle'}

  " code check
  PlugEx 'w0rp/ale', {'on_event': 'VimEnter', 'do': 'pip3 install --user vim-vint autopep8 flake8 pylint'}

  PlugEx 'Konfekt/FastFold',   {'on_event': 'VimEnter'}
  PlugEx 'tpope/vim-repeat' " no plugin dir, no need to lazyload

  " git
  PlugEx 'tpope/vim-fugitive',   {'on_event': 'VimEnter'}
  PlugEx 'gregsexton/gitv',      {'on': 'Gitv'}
  PlugEx 'junegunn/gv.vim',      {'on': 'GV'}
  PlugEx 'cohama/agit.vim',      {'on': ['Agit', 'AgitFile']}
  PlugEx 'lambdalisue/gina.vim', {'on': 'Gina'}
  PlugEx 'jreybert/vimagit',     {'on': ['Magit', 'MagitOnly']}
  PlugEx 'rhysd/committia.vim',  {'for': 'gitcommit'}

  " search
  PlugEx 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
  PlugEx 'dyng/ctrlsf.vim', {'on': ['CtrlSF', 'CtrlSFOpen', 'CtrlSFUpdate',
        \ 'CtrlSFClose', 'CtrlSFClearHL', 'CtrlSFToggle', 'CtrlSFQuickfix',
        \ '<Plug>CtrlSFPrompt', '<Plug>CtrlSFVwordPath', '<Plug>CtrlSFVwordExec',
        \ '<Plug>CtrlSFCwordPath', '<Plug>CtrlSFPwordPath']}
  PlugEx 'mhinz/vim-grepper', {'on': ['Grepper', 'GrepperAg', 'GrepperGit',
        \ 'GrepperGrep', '<plug>(GrepperOperator)']}
  " incsearch
  PlugEx 'haya14busa/incsearch.vim', {'on': ['<Plug>(incsearch-forward)',
        \ '<Plug>(incsearch-backward)', '<Plug>(incsearch-stay)'], 'on_event': 'CursorHold'}
  PlugEx 'haya14busa/incsearch-fuzzy.vim', {'deps': 'incsearch.vim',
        \ 'on': ['<Plug>(incsearch-fuzzy-/)', '<Plug>(incsearch-fuzzy-?)',
        \ '<Plug>(incsearch-fuzzy-stay)'], 'on_event': 'CursorHold'}
  PlugEx 'haya14busa/vim-asterisk', {'deps': 'incsearch.vim', 'on': [
        \ '<Plug>(asterisk-*)', '<Plug>(asterisk-#)', '<Plug>(asterisk-g*)',
        \ '<Plug>(asterisk-g#)', '<Plug>(asterisk-z*)', '<Plug>(asterisk-gz*)',
        \ '<Plug>(asterisk-z#)', '<Plug>(asterisk-gz#)'], 'on_event': 'CursorHold'} " *-Improved
  PlugEx 'haya14busa/incsearch-easymotion.vim', {'deps':
        \ ['incsearch.vim', 'vim-easymotion'], 'on': ['<Plug>(incsearch-easymotion-/)',
        \ '<Plug>(incsearch-easymotion-?)', '<Plug>(incsearch-easymotion-stay)'], 'on_event': 'CursorHold'}

  " denite
  let g:use_denite = (g:is_nvim || v:version>=800) && has('python3')
  PlugEx 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins',
        \ 'enable': g:use_denite, 'on': 'Denite', 'on_event': 'CursorHold'}
  PlugEx 'Shougo/neomru.vim',  {'on': ['NeoMRUReload', 'NeoMRUSave',
        \ 'NeoMRUImportFile', 'NeoMRUImportDirectory']}

  " fzf
  PlugEx 'junegunn/fzf.vim', {'on': ['Files', 'GitFiles', 'GFiles', 'Buffers',
        \ 'Lines', 'BLines', 'Colors', 'Locate', 'Ag', 'Tags', 'BTags',
        \ 'Snippets', 'Commands', 'Marks', 'Helptags', 'Windows', 'Commits',
        \ 'BCommits', 'Maps', 'Filetypes', 'History', 'FZF'], 'deps': 'fzf', 
        \ 'on_event': 'CursorHold'}
  PlugEx 'junegunn/fzf', {'on_event': 'CursorHold'}

  " help focus on writing in vim
  PlugEx 'junegunn/goyo.vim',  {'on': 'Goyo'}
  PlugEx 'junegunn/limelight.vim', {'on': 'Limelight'}

  " vim calendar
  PlugEx 'itchyny/calendar.vim', {'on': 'Calendar'}
  " close anything
  PlugEx 'mhinz/vim-sayonara', {'on': 'Sayonara'}
  " the interactive scratchpad for hackers
  PlugEx 'metakirby5/codi.vim', {'on': 'Codi'}
  "  tracing exceptions thrown by VimL scripts
  PlugEx 'tweekmonster/exception.vim' " no plugin dir, no need to lazyload

  " ===========================================================================
  " other
  " ===========================================================================
  PlugEx 'strom3xFeI/vimdoc-cn', {'lazy': 1}
  " PlugEx '~/tmp/vim/vim-finder', {'on': 'VimEnter'}
  " PlugEx '~/tmp/vim/vlib'

  if g:is_nyaovim
    PlugEx 'rhysd/nyaovim-popup-tooltip', {'on': 'VimEnter'}
    PlugEx 'rhysd/nyaovim-markdown-preview', {'on': 'VimEnter'}
    PlugEx 'rhysd/nyaovim-mini-browser', {'on': 'VimEnter'}
    PlugEx 'rhysd/nyaovim-tree-view', {'on': 'VimEnter'}
  endif
endif
call plugex#end()

" theme setting
call config#theme#after()

" =============================================================================
" triggers
" =============================================================================
"---------------------------------------
" ui
"---------------------------------------
" FOR: rainbow_parentheses.vim
nnoremap <leader>tr :RainbowParentheses!!<cr>

" FOR: vim-choosewin
nmap <tab><tab> <plug>(choosewin)

" FOR: indentLine
nnoremap <leader>ti :IndentLinesToggle<cr>

"---------------------------------------
" completion
"---------------------------------------
" completion
" omni 补全配置
augroup omnif
  autocmd!
  autocmd Filetype *
        \if &omnifunc == "" |
        \setlocal omnifunc=syntaxcomplete#Complete |
        \endif
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  " autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " python使用jedi
  autocmd FileType python setlocal omnifunc=jedi#completions
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END
set completefunc=emoji#complete

"---------------------------------------
" editing
"---------------------------------------
" FOR: nerdcommenter
Map n <a-/> :call NERDComment("n", "Toggle")<CR>j
Map v <a-/> :call NERDComment("n", "Toggle")<CR>j


" FOR: vim-surround
vmap Si S(i_<esc>f)

" FOR: vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap V <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw': 0, 'iW': 0, 'i"': 0, 'i''': 0, 'i]': 1, 'ib': 1,
      \ 'iB': 1, 'il':1 , 'ii':1 , 'ip' : 0, 'ie': 0 }

" FOR: vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)
nnoremap <localleader>ga ga

" FOR: vim-multiple-cursors
nnoremap <silent> <c-c> :call multiple_cursors#quit()<CR>
nnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>
vnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>

"---------------------------------------
" lang
"---------------------------------------
" FOR: vimwiki
nnoremap <leader>v :VimwikiTabIndex<cr>

" FOR: exception.vim
com! -bar WTF call exception#trace()

" FOR: vim-scriptease
nnoremap <silent> <localleader>K :<C-U>exe 'help '.scriptease#helptopic()<CR>

"---------------------------------------
" tools
"---------------------------------------
" FOR: nerdtree
nnoremap <space>[ :NERDTreeTabsToggle<cr>

" FOR: tagbar
if executable('ctags')
  nnoremap <space>] :TagbarToggle<cr>
endif

" FOR: undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle=1

" FOR: ale
nnoremap <leader>ta :ALEToggle<cr>

" FOR: Gina
nnoremap <silent> <space>gd :Gina diff<CR>
nnoremap <silent> <space>gs :Gina status<CR>
nnoremap <silent> <space>gc :Gina commit<CR>
nnoremap <silent> <space>gb :Gina blame :<CR>
nnoremap <silent> <space>gp :Gina push<CR>
nnoremap <silent> <space>ga :Gina add %<CR>
nnoremap <silent> <space>gA :Gina add .<CR>

" FOR: vim-over
" <leader>rr快速执行替换预览
nnoremap <leader>rr :OverCommandLine<cr>%s/

" FOR: vim-grepper
nnoremap <leader>ff :Grepper

" FOR: ctrlsf.vim
nnoremap <space>s :set operatorfunc=config#ctrlsf_vim#ctrlsf_search<cr>g@
vnoremap <space>s :<c-u>call config#ctrlsf_vim#ctrlsf_search(visualmode())<cr>
nmap     <c-s>f <Plug>CtrlSFPrompt
vmap     <c-s>f <Plug>CtrlSFVwordPath
vmap     <c-s>F <Plug>CtrlSFVwordExec
nmap     <c-s>n <Plug>CtrlSFCwordPath
nmap     <c-s>p <Plug>CtrlSFPwordPath
nnoremap <c-s>o :CtrlSFOpen<CR>
nnoremap <c-s>t :CtrlSFToggle<CR>
inoremap <c-s>t <Esc>:CtrlSFToggle<CR>

" FOR: incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" FOR: incsearch-fuzzy.vim
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" FOR: vim-asterisk
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

" FOR: incsearch-easymotion.vim
map <leader>/ <Plug>(incsearch-easymotion-/)
map <leader>? <Plug>(incsearch-easymotion-?)
map <leader>g/ <Plug>(incsearch-easymotion-stay)
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
        \   'converters': [incsearch#config#fuzzy#converter()],
        \   'modules': [incsearch#config#easymotion#module()],
        \   'keymap': {"\<CR>": '<Over>(easymotion)'},
        \   'is_expr': 0,
        \   'is_stay': 1
        \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> <leader>/ incsearch#go(<SID>config_easyfuzzymotion())

" FOR: denite
nnoremap <space>O :Denite file_rec<cr>

" FOR: fzf
" files
nnoremap <space>o :Files<cr>
" git files
nnoremap <space>fgl :GFiles<cr>
" git status
nnoremap <space>fgs :GFiles?<cr>
" git commits (fugitive.vim)
nnoremap <space>fgc :Commits<cr>
" git commits for current buffer
nnoremap <space>fgb :BCommits<cr>
" open buffers
nnoremap <space>b :Buffers<cr>
" colorschemes
nnoremap <space>fs :Colors<cr>
" ag search result <a-a> to select all, <a-d> to deselect all
nnoremap <space>fa :Ag<cr>
" lines in loades buffers
nnoremap <space>fl :Lines<cr>
" linesin the current buffer
nnoremap <space>fbl :BLines<cr>
" tags in the project
nnoremap <space>ft :Tags<cr>
" tags in the current buffer
nnoremap <space>fbl :BTags<cr>
" marks
nnoremap <space>fma :Marks<cr>
" windows
nnoremap <space>fw :Windows<cr>
" windows
nnoremap <space>fsl :Locate
" v:oldfiles and open buffers
nnoremap <space>fhh :History<cr>
" command history
nnoremap <space>fh: :History:<cr>
" search history
nnoremap <space>fh/ :History/<cr>
" snippets (untisnip)
nnoremap <space>fs :Snippets<cr>
" commands
nnoremap <space>fc :Commands<cr>
" normal mode maps
nnoremap <space>fmp :Maps<cr>
" help tags
nnoremap <space>fht :Helptags<cr>
" file types
nnoremap <space>fft :Filetypes<cr>

" FOR: Goyo
nnoremap <space>\ :Goyo<cr>

" FOR: calendar
nnoremap <space>c :Calendar -view=year -split=horizontal -position=below -height=12<cr>

" FOR: vim-sayonara
nnoremap <tab>q :Sayonara<cr>
