" Layer: simple_ui
let layer.plugins += ['mhinz/vim-startify']
let layer.plugins += ['luochen1990/rainbow']
" show diff
let layer.plugins += [['mhinz/vim-signify',
      \ {'on': ['SignifyToggle', 'SignifyToggleHighlight', 'SignifyRefresh', 'SignifyEnable'],
      \ 'on_event': 'InsertEnter'}]]

let layer.sub_layers = ['base_ui', 'themes', 'devicon']
if exists('g:gui_oni')
  let layer.sub_layers += ['statusline']
else
  let layer.sub_layers += ['lightline']
endif


" before
" for rainbow
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

" for vm-signify
let g:signify_vcs_list = ['git'] " only use git
let g:signify_vcs_cmds = {'git': 'git diff --no-color --no-ext-diff -U0 -- %f'}
let g:signify_cursorhold_normal     = 1
let g:signify_update_on_focusgained = 1
" let g:signify_disable_by_default = 1


" after
fu! default_ui#after()
  " for rainbow
  nnoremap <leader>tr :RainbowToggle<cr>

  " for themes
  if g:is_win_unix
    colorscheme monokai
    set background=dark
  en
  colorscheme gruvbox

  " for vim-signify
  nnoremap <leader>tg :SignifyToggle<cr>
  nnoremap <leader>gh :SignifyToggleHighlight<cr>
  nnoremap <leader>gr :SignifyRefresh<cr>
  " hunk jumping
  nmap <leader>gj <plug>(signify-next-hunk)
  nmap <leader>gk <plug>(signify-prev-hunk)
  " hunk text object
  omap ic <plug>(signify-motion-inner-pending)
  xmap ic <plug>(signify-motion-inner-visual)
  omap ac <plug>(signify-motion-outer-pending)
  xmap ac <plug>(signify-motion-outer-visual)
endf
