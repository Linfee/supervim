set cpo&vim
scriptencoding utf-8

let g:plugex_use_log = 0
let g:plugex_use_cache = 0

if plugex#begin()

  " ===========================================================================
  " ui
  " ===========================================================================
  " colors
  PlugEx 'morhetz/gruvbox'
  PlugEx 'sickill/vim-monokai'
  PlugEx 'tomasr/molokai'

  PlugEx 'mhinz/vim-startify', {'on_event': 'VimEnter'}
  PlugEx 'itchyny/lightline.vim', {'on_event': 'VimEnter', 'enable': !exists('g:gui_oni')}
  PlugEx 'ryanoasis/vim-devicons', {'on_event': 'VimEnter'}
  PlugEx 'junegunn/rainbow_parentheses.vim', {'on_event': 'VimEnter'}
  PlugEx 'mhinz/vim-signify', {'on_event': 'VimEnter'}
  PlugEx 'itchyny/vim-cursorword'

  " ===========================================================================
  " completion
  " ===========================================================================
  if g:is_nvim
    let g:use_deoplete = 1
  elseif has('lua')
    let g:use_neocomplete = 1
  else
    let g:use_ncm_for_vim8 = 1
  endif

  PlugEx 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']}
  PlugEx 'SirVer/ultisnips', {'on_event': ['InsertEnter', 'CursorHold']}
  PlugEx 'honza/vim-snippets', {'on_event': ['InsertEnter', 'CursorHold']}
  PlugEx 'Linfee/ultisnips-zh-doc', {'on_event': ['InsertEnter', 'CursorHold']}

  " completion for viml and show function params for viml and ruby
  PlugEx 'Shougo/neco-vim', {'on_event': 'VimEnter'}
  PlugEx 'Shougo/echodoc.vim', {'on_event': 'InsertEnter', 'after': 'echodoc#enable'}

  " deoplete
  PlugEx 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins', 'on_event': 'VimEnter',
        \ 'enable': get(g:, 'use_deoplete')}
  PlugEx 'zchee/deoplete-jedi', {'lazy': 1, 'enable': get(g:, 'use_deoplete')}
  " neocomplete
  PlugEx 'Shougo/neocomplete.vim',  {'on_event': 'VimEnter',
        \ 'enable': get(g:, 'use_neocomplete')}
  " ncm
  PlugEx 'roxma/vim-hug-neovim-rpc', {'lazy': 1,
        \ 'enable': get(g:, 'use_ncm_for_vim8')}
  PlugEx 'roxma/nvim-completion-manager', {'on_event': 'VimEnter',
        \ 'enable': get(g:, 'use_ncm_for_vim8')}

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
  PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}
  " movement
  PlugEx 'easymotion/vim-easymotion', {'on_event': 'VimEnter'}
  " multiple cursors
  PlugEx 'terryma/vim-multiple-cursors', {'on_event': 'VimEnter'}
  " see content of register
  PlugEx 'junegunn/vim-peekaboo', {'on_event': 'VimEnter'}

  PlugEx 'tpope/tpope-vim-abolish', {'on_event': 'VimEnter'}

  " ===========================================================================
  " lang
  " ===========================================================================
  " front end
  PlugEx 'Valloric/MatchTagAlways', {'for': ['html', 'xml', 'xhtml', 'jsp']}
  PlugEx 'pangloss/vim-javascript', {'for': 'javascript'}
  PlugEx 'elzr/vim-json',           {'for': 'json'}
  PlugEx 'hail2u/vim-css3-syntax',  {'for': 'css'}

  " markdown
  PlugEx 'godlygeek/tabular', {'on': ['Tabularize', 'AddTabularPattern', 'AddTabularPipeline']}
  PlugEx 'plasticboy/vim-markdown' " no plugin dir, no need to lazyload
  PlugEx 'iamcco/markdown-preview.vim', {'for': 'markdown', 'on': 'MarkdownPreview'}

  " python
  PlugEx 'davidhalter/jedi-vim', {'on_event': 'InsertEnter if &ft==''python'''}

  " ruby
  PlugEx 'vim-ruby/vim-ruby' " no plugin dir, no need to lazyload

  " vimwiki
  PlugEx 'vimwiki/vimwiki', {'for': 'wiki', 'on': 'VimwikiTabIndex'}

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
  PlugEx 'jistr/vim-nerdtree-tabs'
  PlugEx 'Xuyuanp/nerdtree-git-plugin'
  PlugEx 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle']}

  " undotree
  PlugEx 'mbbill/undotree',    {'on': 'UndotreeToggle'}

  " syntastic
  PlugEx 'vim-syntastic/syntastic', {'on_event': 'InsertEnter'}

  PlugEx 'Konfekt/FastFold',   {'on_event': 'VimEnter'}
  PlugEx 'tpope/vim-repeat' " no plugin dir, no need to lazyload

  " git
  PlugEx 'tpope/vim-fugitive', {'on_event': 'VimEnter'}
  PlugEx 'gregsexton/gitv',    {'on': 'Gitv'}
  PlugEx 'cohama/agit.vim', {'on': ['Agit', 'AgitFile']}

  " search
  PlugEx 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
  PlugEx 'dyng/ctrlsf.vim', {'on': ['CtrlSF', 'CtrlSFOpen', 'CtrlSFUpdate',
        \ 'CtrlSFClose', 'CtrlSFClearHL', 'CtrlSFToggle', 'CtrlSFQuickfix',
        \ '<Plug>CtrlSFPrompt', '<Plug>CtrlSFVwordPath', '<Plug>CtrlSFVwordExec',
        \ '<Plug>CtrlSFCwordPath', '<Plug>CtrlSFPwordPath']}

  " help focus on writing in vim
  PlugEx 'junegunn/goyo.vim',  {'on': 'Goyo'}
  PlugEx 'junegunn/limelight.vim', {'on': 'Limelight'}

  PlugEx 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar'],
        \ 'enable': executable('ctags')}
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
endif
call plugex#end()

" theme setting
call config#theme#after()

" =============================================================================
" triggers
" =============================================================================
" for vim-surround
vmap Si S(i_<esc>f)

" for vim-over
" <leader>rr快速执行替换预览
nnoremap <leader>rr :OverCommandLine<cr>%s/

" for vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap V <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw': 0, 'iW': 0, 'i"': 0, 'i''': 0, 'i]': 1, 'ib': 1,
      \ 'iB': 1, 'il':1 , 'ii':1 , 'ip' : 0, 'ie': 0 }

" for vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)
nnoremap <leader>ga ga

" for vim-multiple-cursors
nnoremap <silent> <c-c> :call multiple_cursors#quit()<CR>
nnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>
vnoremap <silent> <space>/ :MultipleCursorsFind <c-r>/<cr>

" for vimwiki
nnoremap <leader>v :VimwikiTabIndex<cr>

" for nerdtree
nnoremap <leader>n :NERDTreeTabsToggle<cr>
nnoremap <leader>e :NERDTreeFind<CR>

" for Goyo
nnoremap <space>g :Goyo<cr>

" for tagbar
if executable('ctags')
  nnoremap <leader>t :TagbarToggle<cr>
endif

" for undotree
nnoremap <leader>u :UndotreeToggle<cr>
let g:undotree_SetFocusWhenToggle=1

" for vim-sayonara(
nnoremap <tab>q :Sayonara<cr>

" for calendar
nnoremap <space>c :Calendar -view=year -split=horizontal -position=below -height=12<cr>

" for rainbow_parentheses.vim
nnoremap <leader>tr :RainbowParentheses!!<cr>

" for exception.vim
com! -bar WTF call exception#trace()

" for vim-scriptease
nnoremap <silent> <space>K :<C-U>exe 'help '.scriptease#helptopic()<CR>

" for nerdcommenter
Map n <a-/> <Plug>NERDCommenterToggle
Map v <a-/> <Plug>NERDCommenterToggle

" for ctrlsf.vim
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
