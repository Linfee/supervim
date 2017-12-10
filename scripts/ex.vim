" bcakup
call ex#backup#cursor()
call ex#backup#undo()
" call ex#backup#view()
" call ex#backup#undo()

" color preview
com! -nargs=0 -bar ColorPreview exe 'w | syn include syntax/colorful.vim | e'

" fcitx
if executable('fcitx')
  call ex#fcitx#fcitx_support_on()
en

" translate
nnoremap <space>t :set operatorfunc=ex#translate#translate<cr>g@
vnoremap <space>t :<c-u>call ex#translate#translate(visualmode())<cr>
command! -nargs=+ Trans call ex#translate#ts(<f-args>)

" execute vimscript
nnoremap <space>e<cr> :@*<cr>
nnoremap <space>e :set operatorfunc=ex#vimscript#execute<cr>g@
vnoremap <space>e :<c-u>call ex#vimscript#execute(visualmode())<cr>

" run shell command
command! -complete=file -nargs=+ Shell call util#shell_run(<q-args>)
