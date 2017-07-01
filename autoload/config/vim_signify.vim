fu! config#vim_signify#before()
  let g:signify_vcs_list = ['git'] " only use git
  let g:signify_vcs_cmds = {'git': 'git diff --no-color --no-ext-diff -U0 -- %f'}
  let g:signify_cursorhold_normal     = 1
  let g:signify_update_on_focusgained = 1
  " let g:signify_disable_by_default = 1
endf

fu! config#vim_signify#after()
  " for vim-signify
  nnoremap <leader>ts :SignifyToggle<cr>
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
