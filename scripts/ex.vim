"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim

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

" change font size int gui quickly
if g:is_gui
  if !g:is_nvim
    command! Bigger  :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
    command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')
  endif
endif

" replace :emoji_name: into Emojis
command! -nargs=0 EmojiReplace exe '%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g'
command! -nargs=0 EmojiList for e in emoji#list() | call append(line('$'), printf('%s (%s)', emoji#for(e), e)) | endfor
