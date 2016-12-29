" 提供翻译支持

func translate#Translate(type)

    py3 import translate

    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " silent execute "grep! -R " . shellescape(@@) . " ."
    " echom @@
    py3 print(translate.query(vim.eval('@@')))
    " copen

    let @@ = saved_unnamed_register
endf
