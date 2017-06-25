" filetype config for .py file

setl smarttab
setl tabstop=4
setl softtabstop=4
setl shiftwidth=4
setl textwidth=79
setl expandtab
setl autoindent
setl fileformat=unix

" match Error /\s\+$/
" py3 << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
" project_base_dir=os.environ['VIRTUAL_ENV']
" activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
" execfile(activate_this, dict(__file__=activate_this))
" EOF

setl omnifunc=jedi#completions

if g:is_win
  if exists("g:s_py2")
    nnoremap <buffer> <space>r :w<cr>:!py %<cr>
  else
    nnoremap <buffer> <space>r :w<cr>:!python %<cr>
  endif
else
  nnoremap <buffer> <space>r :w<cr>:!chmod u+x % && ./%<cr>
endif

