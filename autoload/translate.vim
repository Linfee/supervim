" 提供翻译支持
" nnoremap <space>t :set operatorfunc=translate#translate<cr>g@
" vnoremap <space>t :<c-u>call translate#translate(visualmode())<cr>
" command! -nargs=+ Trans call translate#ts(<f-args>)

py3 import translate

" Operator function
func! translate#translate(type)

    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " Use vim's echo not python's print so it will show multi line
    py3 vim.vars['translate#result'] = translate.translate(vim.eval('@@'))
    echo g:translate#result

    let @@ = saved_unnamed_register
endf

" translate
func! translate#ts(...)
    for i in a:000
        py3 print(translate.query(vim.eval('i')))
    endfor
endf
