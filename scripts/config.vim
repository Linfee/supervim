set cpo&vim

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

PlugEx 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp'], 'on_event': 'InsertEnter'}
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
" PlugEx 'itchyny/vim-cursorword'

" =============================================================================
" lang
" =============================================================================

" =============================================================================
" ui
" =============================================================================
PlugEx 'morhetz/gruvbox'
PlugEx 'sickill/vim-monokai'
PlugEx 'tomasr/molokai'

" PlugEx 'mhinz/vim-startify'
PlugEx 'luochen1990/rainbow', {'on_event': 'VimEnter'}
PlugEx 'mhinz/vim-signify', {'on_event': 'VimEnter'}
PlugEx 'ryanoasis/vim-devicons', {'on_event': 'VimEnter'}
PlugEx 'itchyny/lightline.vim', {'on_event': 'VimEnter', 'enable': !exists('g:gui_oni')}

" other
PlugEx 'strom3xFeI/vimdoc-cn', {'lazy': 1}

call plugex#end()

" theme setting
call config#theme#after()
