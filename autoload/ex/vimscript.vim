" 执行 vimscript
" nnoremap <space>e :set operatorfunc=ex#vimscript#execute<cr>g@
" vnoremap <space>e :<c-u>call ex#vimscript#execute(visualmode())<cr>

fu! ex#vimscript#execute(type)

    let saved_unnamed_register = @@

    if a:type ==? 'v' || a:type ==# '^V'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    @*

    let @* = saved_unnamed_register
endf
