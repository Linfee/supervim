" 执行 script
nnoremap <space>e<cr> :@*<cr>
nnoremap <space>e :set operatorfunc=ex#script#execute<cr>g@
vnoremap <space>e :<c-u>call ex#script#execute(visualmode())<cr>

fu! ex#script#execute(type)
    let l:tmp = @m

    if a:type ==? 'v' || a:type ==# '^V'
        call execute('normal! `<v`>"my')
    elseif a:type ==# 'char'
        call execute('normal! `[v`]"my')
    else
        return
    endif

    let l:code = @m
    let @m = l:tmp
    unlet l:tmp

    if &ft == 'vim'
      echo execute(l:code)
    elseif &ft == 'python'
      echo execute('py3 ' . l:code)
    else
      echo 'language [' . &ft . '] is not a supported executable language, use vim'
      echo execute(l:code)
    endif
endf

