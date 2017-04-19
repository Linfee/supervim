" 执行 vimscript
"
" nnoremap <space>e :set operatorfunc=vimscript#execute<cr>g@
" vnoremap <space>e :<c-u>call vimscript#execute(visualmode())<cr>

func! vimscript#execute(type)

    let saved_unnamed_register = @@

    if a:type ==? 'v' || a:type ==# '^V'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    @@

    let @@ = saved_unnamed_register
endf
