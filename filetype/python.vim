" filetype config for .py file
let g:ftconfigloaded = 1

set smarttab
set expandtab
set autoindent
let &shiftwidth=4
let &tabstop=4
let &softtabstop=4

setlocal ff=unix

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
