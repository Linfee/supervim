call plugex#begin(expand(g:config_home.'/.repo'))

" " completion
" PlugEx 'Shougo/neco-vim', {'on_event': 'InsertEnter if ''vim''==&ft'}
" PlugEx 'Shougo/echodoc.vim', {'on_event': 'InsertEnter if or(''vim''==&ft, ''ruby''==&ft)'}
" PlugEx 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins',
"       \ 'on_event': 'InsertEnter'}
" " PlugEx 'Shougo/neocomplete.vim',  {'on_event': 'InsertEnter'}
" PlugEx 'artur-shaik/vim-javacomplete2', {'for': 'java', 'on_event': 'InsertEnter'}
" PlugEx 'Linfee/ultisnips-zh-doc', {'on_event': 'VimEnter'}
" PlugEx 'honza/vim-snippets', {'on_event': ['InsertEnter', 'CursorHold']}
" PlugEx 'SirVer/ultisnips', {'on_event': ['InsertEnter', 'CursorHold']}
"
" " editing
" PlugEx 'scrooloose/nerdcommenter', {'on_event': 'VimEnter'}
" PlugEx 'jiangmiao/auto-pairs', {'on_event': 'InsertEnter'}
" PlugEx 'tpope/vim-surround', {'on': [
"       \ '<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround',
"       \ '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround',
"       \ '<Plug>YSsurround', '<Plug>YSsurround', '<Plug>VSurround',
"       \ '<Plug>VgSurround', '<Plug>Isurround', '<Plug>Isurround',
"       \ '<Plug>ISurround'
"       \ ]}
" PlugEx 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
" PlugEx 'terryma/vim-expand-region', {'on': ['v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)' ]}
" PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}
" PlugEx 'sbdchd/neoformat', {'on': 'Neoformat'}
" PlugEx 'easymotion/vim-easymotion', {'on_event': 'VimEnter'}
" PlugEx 'terryma/vim-multiple-cursors', {'on_event': 'VimEnter'}
" PlugEx 'itchyny/vim-cursorword', {'on_event': 'VimEnter'}
"
" " lang
" PlugEx 'Valloric/MatchTagAlways', {'for': ['html', 'xml', 'xhtml', 'jsp']}
" PlugEx 'pangloss/vim-javascript', {'for': 'javascript'}
" PlugEx 'elzr/vim-json',           {'for': 'json'}
" PlugEx 'hail2u/vim-css3-syntax',  {'for': 'css'}
"
" PlugEx 'godlygeek/tabular',
"       \ {'on': ['Tabularize', 'AddTabularPattern', 'AddTabularPipeline']}
" PlugEx 'plasticboy/vim-markdown', {'on_event': 'VimEnter'}
" PlugEx 'iamcco/markdown-preview.vim',
"       \ {'for': 'markdown', 'on': 'MarkdownPreview'}
"
" PlugEx 'davidhalter/jedi-vim',
"       \ {'on_event': 'InsertEnter'}
"
" PlugEx 'vim-ruby/vim-ruby', {'on_event': 'VimEnter'}
"
" PlugEx 'vimwiki/vimwiki', {'for': 'wiki', 'on': 'VimwikiTabIndex'}
"
" " tools
" PlugEx 'jistr/vim-nerdtree-tabs'
" PlugEx 'Xuyuanp/nerdtree-git-plugin'
" PlugEx 'scrooloose/nerdtree',
"       \ {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle']}
"
" PlugEx 'vim-syntastic/syntastic', {'on_event': 'VimEnter'}
"
" PlugEx 'Konfekt/FastFold', {'on_event': 'VimEnter'}
" PlugEx 'tpope/vim-repeat', {'on_event': 'VimEnter'}
" PlugEx 'tpope/vim-fugitive', {'on_event': 'VimEnter'}
" PlugEx 'gregsexton/gitv',   {'on': 'Gitv'}
" PlugEx 'mbbill/undotree',   {'on': 'UndotreeToggle'}
" PlugEx 'junegunn/goyo.vim', {'on': 'Goyo'}
" PlugEx 'majutsushi/tagbar',
"       \ {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}
" " vim calendar
" PlugEx 'itchyny/calendar.vim', {'on': 'Calendar'}
" " close anything
" PlugEx 'mhinz/vim-sayonara', {'on': 'Sayonara'}
"
" PlugEx 'Shougo/denite.nvim',
"       \ {'do': ':UpdateRemotePlugins'}
" PlugEx 'Shougo/neomru.vim',  {'on':
"       \ ['NeoMRUReload', 'NeoMRUSave', 'NeoMRUImportFile', 'NeoMRUImportDirectory']}
" " deol, shell in vim
" PlugEx 'Shougo/deol.nvim', {'on_event': 'VimEnter'}
"
"
" " zh doc
PlugEx 'strom3xFeI/vimdoc-cn', {'on_event': 'VimEnter'}

" PlugExGroup 'groupName',
"       \ ['strom3xFeI/vimdoc-cn', {'on_event': 'VimEnter'}],
"       \ ['mhinz/vim-sayonara', {'on': 'Sayonara'}],
"       \ 'scrooloose/nerdtree',
"       \ {'on_event': 'VimEnter'}

call plugex#end()
