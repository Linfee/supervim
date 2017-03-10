" filetype config for .py file

setl smarttab
setl tabstop=4
setl softtabstop=4
setl shiftwidth=4
setl textwidth=79
setl expandtab
setl autoindent
setl fileformat=unix

setl ff=unix
match Error /\s\+$/
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir=os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF


" run {{1
if IsWin() && !IsWinUnix() " for windows
    if exists("g:s_py2")
        call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:!py %<cr>')
    else
        call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:!python %<cr>')
    endif
else " for linux, osx, mingw, msys2, cygwin
    call DoCustomLeaderMap('nnoremap <buffer>', 'r', ':w<cr>:!echo "\033[0;32m____________________\033[0m"<cr>:!chmod u+x % && ./%<cr>')
endif
" vim-autopep8格式化
nnoremap = :Autopep8<cr>
" }}1

" fold {{1
setl foldmethod=expr
setl foldexpr=s:GetPythonFold(v:lnum)
setl foldtext=GetPythonFoldText()

let b:f = {'GetPythonFold':0, 'UpdateFoldTable':0}
let b:foldTable = {}

py3 import pyfold
func! s:GetPythonFold(lnum)
    let b:f.GetPythonFold += 1
    if len(b:foldTable) == 0
        call s:UpdateFoldTable()
    endif
    return get(b:foldTable, a:lnum, '=')
endf

func! s:UpdateFoldTable()
    let b:f.UpdateFoldTable += 1
    py3 pyfold.updateFoldTable()
    if &foldenable
        normal zx
    endif
endf

func! GetPythonFoldText()
    let line = getline(v:foldstart)
    let foldedlinecount = v:foldend - v:foldstart
    return line . '  + ' . foldedlinecount .' lines ... '
endf

augroup resCurPy
    autocmd!
    au InsertLeave *.py :set foldmethod=expr
    au InsertEnter *.py :set foldmethod=manual
    au BufEnter,InsertLeave,BufWrite,BufWritePre *.py call s:UpdateFoldTable()
augroup END


" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:

