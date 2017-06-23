set cpo&vim
scriptencoding utf-8

let g:plugex_log = 1
call plugex#begin(expand(g:config_home.'/.repo'))

" =============================================================================
" completion
" =============================================================================
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
PlugEx 'zchee/deoplete-jedi', {'lazy': 1,
      \ 'enable': get(g:, 'use_deoplete')}
" neocomplete
PlugEx 'Shougo/neocomplete.vim',  {'on_event': 'VimEnter',
      \ 'enable': get(g:, 'use_neocomplete')}
" ncm
PlugEx 'roxma/vim-hug-neovim-rpc', {'lazy': 1,
      \ 'enable': get(g:, 'use_ncm_for_vim8')}
PlugEx 'roxma/nvim-completion-manager', {'on_event': 'VimEnter',
      \ 'enable': get(g:, 'use_ncm_for_vim8')}

" =============================================================================
" editing
" =============================================================================
PlugEx 'scrooloose/nerdcommenter', {'on_event': 'VimEnter'}
PlugEx 'jiangmiao/auto-pairs', {'on_event': 'InsertEnter', 'after': 'AutoPairsTryInit'}
PlugEx 'tpope/vim-surround', {'on': [
      \ '<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround',
      \ '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround',
      \ '<Plug>YSsurround', '<Plug>YSsurround', '<Plug>VSurround',
      \ '<Plug>VgSurround', '<Plug>Isurround', '<Plug>Isurround',
      \ '<Plug>ISurround'
      \ ]}
" find and replace
PlugEx 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
" expand region
PlugEx 'terryma/vim-expand-region', {'on': ['v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)']}
" format and align
PlugEx 'sbdchd/neoformat', {'on': 'Neoformat'}
PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}
" movement
PlugEx 'easymotion/vim-easymotion', {'on': 'VimEnter'}
" multiple cursors
PlugEx 'terryma/vim-multiple-cursors', {'on': 'VimEnter'}
" underline cursorword
PlugEx 'itchyny/vim-cursorword'

" =============================================================================
" lang
" =============================================================================
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
PlugEx 'davidhalter/jedi-vim', {'on_event': 'InsertEnter if &ft=''python'''}

" ruby
PlugEx 'vim-ruby/vim-ruby' " no plugin dir, no need to lazyload

" vimwiki
PlugEx 'imwiki/vimwiki', {'for': 'wiki', 'on': 'VimwikiTabIndex'}

" =============================================================================
" tools
" =============================================================================
" nerdtree
PlugEx 'jistr/vim-nerdtree-tabs'
PlugEx 'Xuyuanp/nerdtree-git-plugin'
PlugEx 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle']}

" syntastic
PlugEx 'vim-syntastic/syntastic', {'on_event': 'InsertEnter'}

PlugEx 'Konfekt/FastFold'
PlugEx 'tpope/vim-repeat'

PlugEx 'tpope/vim-fugitive'
PlugEx 'gregsexton/gitv',   {'on': 'Gitv'}
PlugEx 'mbbill/undotree',   {'on': 'UndotreeToggle'}
PlugEx 'junegunn/goyo.vim', {'on': 'Goyo'}

PlugEx 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar'], 'enable': executable('ctags')}
" vim calendar
PlugEx 'itchyny/calendar.vim', {'on': 'Calendar'}
" close anything
PlugEx 'mhinz/vim-sayonara', {'on': 'Sayonara'}

" =============================================================================
" ui
" =============================================================================
PlugEx 'morhetz/gruvbox'
PlugEx 'sickill/vim-monokai'
PlugEx 'tomasr/molokai'

PlugEx 'mhinz/vim-startify'
PlugEx 'luochen1990/rainbow', {'on_event': 'VimEnter'}
PlugEx 'mhinz/vim-signify', {'on_event': 'VimEnter'}
PlugEx 'ryanoasis/vim-devicons', {'on_event': 'VimEnter'}
PlugEx 'itchyny/lightline.vim', {'on_event': 'VimEnter', 'enable': !exists('g:gui_oni')}

" other
PlugEx 'strom3xFeI/vimdoc-cn', {'lazy': 1}

call plugex#end()

" theme setting
call config#theme#after()

" =============================================================================
" triggers
" =============================================================================
" for vim-surround
let g:surround_no_mappings = 1
vmap Si S(i_<esc>f)
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap cS  <Plug>CSurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
  imap    <C-S> <Plug>Isurround
endif
imap      <C-G>s <Plug>Isurround
imap      <C-G>S <Plug>ISurround


" for vim-over
" <leader>rr快速执行替换预览
nnoremap <leader>rr :OverCommandLine<cr>%s/


" for vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap V <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'i]'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'il'  :1,
      \ 'ii'  :1,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }


" for vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap <leader>a <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap <leader>a <Plug>(EasyAlign)


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
