" filetype config for .py file

setl smarttab
setl tabstop=4
setl softtabstop=4
setl shiftwidth=4
setl textwidth=79
setl expandtab
setl autoindent
setl fileformat=unix

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


" 运行
if IsWin() && !IsWinUnix() " for windows
    if exists("g:s_py2")
        call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:silent!echo "____________________"<cr>:!py %<cr>')
    else
        call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:silent!echo ____________________<cr>:!python %<cr>')
    endif
else " for linux, osx, mingw, msys2, cygwin
    call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:!echo "\033[0;32m____________________\033[0m"<cr>:!chmod u+x % && ./%<cr>')
endif
" vim-autopep8格式化
nnoremap = :Autopep8<cr>
