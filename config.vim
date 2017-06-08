call plugex#begin(expand(g:config_home.'/.repo'))

" completion
PlugEx 'Shougo/neco-vim', {'on_event': 'InsertEnter'}
PlugEx 'Shougo/echodoc.vim', {'on_event': 'InsertEnter'}
PlugEx 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins',
      \ 'on_event': 'InsertEnter'}
" PlugEx 'Shougo/neocomplete.vim',  {'on_event': 'InsertEnter'}
PlugEx 'artur-shaik/vim-javacomplete2', {'for': 'java', 'on_event': 'InsertEnter'}
PlugEx 'Linfee/ultisnips-zh-doc'
PlugEx 'honza/vim-snippets', {'on_event': ['InsertEnter', 'CursorHold']}
PlugEx 'SirVer/ultisnips', {'on_event': ['InsertEnter', 'CursorHold']}

" editing
PlugEx 'scrooloose/nerdcommenter', {'on': [
      \ 'n<Plug>NERDCommenterAltDelims', 'x<Plug>NERDCommenterUncomment',
      \ 'n<Plug>NERDCommenterUncomment', 'x<Plug>NERDCommenterAlignBoth',
      \ 'n<Plug>NERDCommenterAlignBoth', 'x<Plug>NERDCommenterAlignLeft',
      \ 'n<Plug>NERDCommenterAlignLeft', 'n<Plug>NERDCommenterAppend',
      \ 'x<Plug>NERDCommenterYank', 'n<Plug>NERDCommenterYank',
      \ 'x<Plug>NERDCommenterSexy', 'n<Plug>NERDCommenterSexy',
      \ 'x<Plug>NERDCommenterInvert', 'n<Plug>NERDCommenterInvert',
      \ 'n<Plug>NERDCommenterToEOL', 'x<Plug>NERDCommenterNested',
      \ 'n<Plug>NERDCommenterNested', 'x<Plug>NERDCommenterMinimal',
      \ 'n<Plug>NERDCommenterMinimal', 'x<Plug>NERDCommenterToggle',
      \ 'n<Plug>NERDCommenterToggle', 'x<Plug>NERDCommenterComment',
      \ 'n<Plug>NERDCommenterComment'
      \ ], 'on_event': 'InsertEnter'}
PlugEx 'jiangmiao/auto-pairs', {'on_event': 'InsertEnter'}
PlugEx 'tpope/vim-surround', {'on': [
      \ '<Plug>Dsurround', '<Plug>Csurround', '<Plug>CSurround',
      \ '<Plug>Ysurround', '<Plug>YSurround', '<Plug>Yssurround',
      \ '<Plug>YSsurround', '<Plug>YSsurround', '<Plug>VSurround',
      \ '<Plug>VgSurround', '<Plug>Isurround', '<Plug>Isurround',
      \ '<Plug>ISurround'
      \ ]}
PlugEx 'osyo-manga/vim-over', {'on': 'OverCommandLine'}
PlugEx 'terryma/vim-expand-region', {'on': ['v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)' ]}
PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}
PlugEx 'sbdchd/neoformat', {'on': 'Neoformat'}
PlugEx 'easymotion/vim-easymotion'
PlugEx 'terryma/vim-multiple-cursors'
PlugEx 'itchyny/vim-cursorword'

" lang
PlugEx 'Valloric/MatchTagAlways', {'for': ['html', 'xml', 'xhtml', 'jsp']}
PlugEx 'pangloss/vim-javascript', {'for': 'javascript'}
PlugEx 'elzr/vim-json',           {'for': 'json'}
PlugEx 'hail2u/vim-css3-syntax',  {'for': 'css'}

PlugEx 'godlygeek/tabular',
      \ {'on': ['Tabularize', 'AddTabularPattern', 'AddTabularPipeline']}
PlugEx 'plasticboy/vim-markdown'
PlugEx 'iamcco/markdown-preview.vim',
      \ {'for': 'markdown', 'on': 'MarkdownPreview'}

PlugEx 'davidhalter/jedi-vim',
      \ {'on_event': 'InsertEnter'}

PlugEx 'vim-ruby/vim-ruby'

PlugEx 'vimwiki/vimwiki', {'for': 'wiki', 'on': 'VimwikiTabIndex'}

" tools
PlugEx 'jistr/vim-nerdtree-tabs'
PlugEx 'Xuyuanp/nerdtree-git-plugin'
PlugEx 'scrooloose/nerdtree',
      \ {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle']}

PlugEx 'vim-syntastic/syntastic', {'on_event': 'InsertEnter'}

PlugEx 'Konfekt/FastFold'
PlugEx 'tpope/vim-repeat'
PlugEx 'tpope/vim-fugitive'
PlugEx 'gregsexton/gitv',   {'on': 'Gitv'}
PlugEx 'mbbill/undotree',   {'on': 'UndotreeToggle'}
PlugEx 'junegunn/goyo.vim', {'on': 'Goyo'}
PlugEx 'majutsushi/tagbar',
      \ {'on': ['TagbarToggle', 'TagbarOpen', 'Tagbar']}
" vim calendar
PlugEx 'itchyny/calendar.vim', {'on': 'Calendar'}
" close anything
PlugEx 'mhinz/vim-sayonara', {'on': 'Sayonara'}

PlugEx 'Shougo/denite.nvim',
      \ {'do': ':UpdateRemotePlugins'}
PlugEx 'Shougo/neomru.vim',  {'on':
      \ ['NeoMRUReload', 'NeoMRUSave', 'NeoMRUImportFile', 'NeoMRUImportDirectory']}
" deol, shell in vim
PlugEx 'Shougo/deol.nvim'


" zh doc
PlugEx 'strom3xFeI/vimdoc-cn'

" PlugExGroup 'groupName',
          " \ ['abc/def', {}],
          " \ ['foo/bar', {}],
          " \ 'baz'
          " \ {''}

call plugex#end()
