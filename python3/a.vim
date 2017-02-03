autocmd! * <buffer>
autocmd InsertCharPre <buffer> call InterceptInsert()

let b:prompt = ''
func! InterceptInsert()
    let b:prompt = b:prompt . v:char
    echo b:prompt
    let v:char = ''
endf

startinsert

