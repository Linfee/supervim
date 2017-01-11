" backup
" 要开启相应的功能，直接在配置中调用相应的函数

" 备份光标
func! backup#BackupCursor()
    if exists("g:s_backup_cursor")
        return
    endif
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
        " 编辑git commit时是一个例外
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END
    let g:s_backup_cursor = 1
endf

" 备份文件
func! backup#BackupFile()
    if exists("g:s_backup_cursor")
        return
    endif
    set backup
    set backupdir=~/.vim/temp/backup
    set backupext=.__bak__
    let g:s_backup_fiie = 1
endf

" 备份undo
func! backup#BackupUndo()
    if exists("g:s_backup_undo")
        return
    endif
    if has('persistent_undo')
        set undofile
        " 设置undofile的存储目录
        set undodir=~/.vim/temp/undo
        " 最大可撤销次数
        set undolevels=1000
        " Maximum number lines to save for undo on a buffer reload
        set undoreload=10000
    endif
    let g:s_backup_undo = 1
endf

" 备份view
func! backup#BackupView()
    if exists("g:s_backup_view")
        return
    endif
    set viewoptions=folds,options,cursor,unix,slash
    set viewdir=~/.vim/temp/view
    augroup backupView
        autocmd!
        autocmd BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
        autocmd BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
    augroup END
    nnoremap <c-s-f12> :!find ~/.vim/temp/view -mtime +30 -exec rm -a{} \;<cr>
    " TODO: let vim delete too old file auto
    let g:s_backup_view = 1
endf
