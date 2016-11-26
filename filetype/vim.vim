" filetype config for .vim file

setl smarttab
setl expandtab
setl autoindent
setl shiftwidth=4
setl tabstop=4
setl softtabstop=4

setl nowrap

function ExeCurrentLIne()
    echo ">>> " . getline(".") ."\n" 
    exe getline(".")
endfunction

" 将当前行当作vim命令执行
nnoremap <cr> :call ExeCurrentLIne()<cr>

