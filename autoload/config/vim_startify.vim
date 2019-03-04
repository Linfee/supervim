fu! config#vim_startify#after()
  call s:genesis()
endf

" copy from vim-startify/plugin/startify.vim
function! s:genesis()
  if !argc() && line2byte('$') == -1
    if get(g:, 'startify_session_autoload') && filereadable('Session.vim')
      source Session.vim
    elseif !get(g:, 'startify_disable_at_vimenter')
      call startify#insane_in_the_membrane(1)
    endif
  endif
  if get(g:, 'startify_update_oldfiles')
    call map(v:oldfiles, 'fnamemodify(v:val, ":p")')
    autocmd startify BufNewFile,BufRead,BufFilePre *
          \ call s:update_oldfiles(expand('<afile>:p'))
  endif
  autocmd! startify VimEnter
endfunction

function! s:update_oldfiles(file)
  if g:startify_locked || !exists('v:oldfiles')
    return
  endif
  let idx = index(v:oldfiles, a:file)
  if idx != -1
    call remove(v:oldfiles, idx)
  endif
  call insert(v:oldfiles, a:file, 0)
endfunction
