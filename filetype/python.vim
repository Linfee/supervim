" filetype config for .py file
let g:ftconfigloaded = 1

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setlocal ff=unix

function! PythonFt()
	call SetTab(4)
	setl ff=unix
	setl foldmethod=indent
	setl foldlevel=99
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

