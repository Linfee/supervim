autocmd! * <buffer>
autocmd InsertCharPre <buffer> call InterceptInsert()

let b:key = ''
func! InterceptInsert()
    let b:key = b:key . v:char
    echo b:key
    let v:char = ''
endf

startinsert

