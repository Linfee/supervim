" translate support
nnoremap <space>t :set operatorfunc=translate#translate<cr>g@
vnoremap <space>t :<c-u>call translate#translate(visualmode())<cr>
command! -nargs=+ Trans call translate#ts(<f-args>)

