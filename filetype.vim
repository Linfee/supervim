""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This is the personal vimrc file of Linfee
" FILE:     filetype.vim
" Author:   Linfee
" EMAIL:    Linfee@hotmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! SetTab(n)
	" set expandtab
	set smarttab
	set expandtab
	set autoindent
	let &shiftwidth=a:n
	let &tabstop=a:n
	let &softtabstop=a:n
endfunction

" >>>>> scala >>>>>
function! ScalaFt()
	iabbrev <buffer> scsh #!/bin/sh<cr>exec scala "$0<right> "$@<right><cr>!#<cr><cr>
	iabbrev <buffer> sisr scala.io.StdIn.readLine("")<left>
endfunction

" >>>>> python >>>>>
function! PythonFt()
	call SetTab(4)
	set ff=unix
	set foldmethod=indent
	set foldlevel=99
	match BadWhitespace /\s\+$/
	py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
	project_base_dir=os.environ['VIRTUAL_ENV']
	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
	execfile(activate_this, dict(__file__=activate_this))
EOF
endfunction

function! MarkdownFt()
	call SetTab(4)
	inoremap · `
endfunction

" >>>>> autocmd >>>>>
augroup fileTypes
	autocmd!
	autocmd BufNew,BufRead xml,html,c,scala call SetTab(2)
	autocmd BufNew,BufRead scala call ScalaFt()
	autocmd BufNew,BufRead java call SetTab(4)
	autocmd BufNew,BufRead markdown call MarkdownFt()
	autocmd BufNew,BufRead python call PythonFt()
augroup END


