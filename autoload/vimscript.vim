" 执行 vimscript
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
