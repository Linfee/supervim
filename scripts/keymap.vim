"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: Linfee
" REPO: https://github.com/Linfee/supervim

scriptencoding utf-8

" use ; as mapleader
let g:mapleader = ';'
let g:maplocalleader = "\\"
" use alt-; as ;
Noremap n <a-;> ;

" File and Editing {{1
" switch cursor word case
nnoremap <c-u> g~iw
inoremap <c-u> <esc>g~iwea

" delete the windows' ^M
nnoremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" switch vim to paste mode
nnoremap <leader>tp :set paste!<cr>

" switch cwd to current file
cnoremap cwd lcd %:p:h
cnoremap cd. lcd %:p:h
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" save and quit
nnoremap <space>q :close<cr>
nnoremap <space>w :update<cr>
nnoremap <tab>Q :bufdo bd<cr>

" save as sudo
if !g:is_win
  cnoremap W! !sudo tee % > /dev/null<cr>
  nnoremap <space>W :!sudo tee % /dev/null<cr>
en

" switch linewise-visual mode
nnoremap <space><space> V
vnoremap <space><space> V

" switch tab and space
com! -nargs=0 ToSpace setl et | ret
com! -nargs=0 ToTab setl noet | ret!

" hex edit mode
com! -nargs=0 ToggleHex call util#hex_toggle()

" <alt-=> Expression register
Noremap i <a-=> <c-r>=
Noremap c <a-=> <c-r>=

" complate
Noremap i <a-p> <c-n>

" <a-d> delete word backward
Noremap i <a-d> <c-w>
Noremap c <a-d> <c-w>

" alt-s switch to cmd-line mode
Noremap n <a-s> :
Noremap i <a-s> <c-o>:
Noremap v <a-s> :

" use alt+. to repeat last macro
Noremap n <a-.> @@

" Fold {{2
" switch fold
nnoremap - za
nnoremap _ zf
" set foldlevel quickly
nnoremap <tab>0 :set foldlevel=0<cr>
nnoremap <tab>1 :set foldlevel=1<cr>
nnoremap <tab>2 :set foldlevel=2<cr>
nnoremap <tab>3 :set foldlevel=3<cr>
nnoremap <tab>4 :set foldlevel=4<cr>
nnoremap <tab>5 :set foldlevel=5<cr>
nnoremap <tab>6 :set foldlevel=6<cr>
" 2}}

" Spell Check {{2
" switch spell check
noremap <c-f11> :setlocal spell!<cr>
" spell check
noremap <leader>sn ]s
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=
" 2}}

" 1}}

" search and replace all
nnoremap <leader>r :call util#visual_selection('replace', '')<cr>
" non whole world
nnoremap gR :call util#replace(0, 0, input('Replace '.expand('<cword>').' with: '))<cr>
" whole world
nnoremap grw :call util#replace(0, 1, input('Replace '.expand('<cword>').' with: '))<cr>
" confirm, non whole word
nnoremap grc :call util#replace(1, 0, input('Replace '.expand('<cword>').' with: '))<cr>
" confirm, non whole word
nnoremap grwc :call util#replace(1, 1, input('Replace '.expand('<cword>').' with: '))<cr>

" Find and merge conflicts
nnoremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" quick search cursor word
nnoremap <leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" disable the highlight of search result for now
nnoremap <space><cr> :nohlsearch<cr>

" use * and # to search selected content in visual mode
vnoremap <silent> * :<C-u>call util#visual_selection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call util#visual_selection('', '')<CR>?<C-R>=@/<CR><CR>

" buffer, window and tab {{
" buffer and window
nnoremap <tab><cr> <c-w>_
nnoremap <tab>= <c-w>=
nnoremap <tab>j <C-w>j
nnoremap <tab>k <C-w>k
nnoremap <tab>l <C-w>l
nnoremap <tab>h <C-w>h

nnoremap <tab><up> <C-w>-
nnoremap <tab><down> <C-w>+
nnoremap <tab><left> <C-w><
nnoremap <tab><right> <C-w>>

nnoremap <tab>[ :bprevious<cr>
nnoremap <tab>] :bnext<cr>
nnoremap <tab>b :execute "ls"<cr>
nnoremap <tab>- :split<cr>
nnoremap <tab>\ :vsplit<cr>

" tab
nnoremap <tab>i :tabprevious<cr>
nnoremap <tab>o :tabnext<cr>
nnoremap <tab>{ :tabfirst<cr>
nnoremap <tab>} :tablast<cr>
nnoremap <tab>n :tabnew<cr>
nnoremap <tab>q :close<cr>

nnoremap <tab>x :tabclose<cr>
nnoremap <tab>c :close<cr>
nnoremap <tab>s :tabs<cr>
nnoremap <tab>f :tabfind<space>
nnoremap <tab>m :tabmove<space>
nnoremap <tab>m :tabmove
nnoremap <tab>t :tabonly<cr> 

" Horizontal scrolling
nnoremap zl zL
nnoremap zh zH

" alt+n switch tab
Noremap n <a-1> 1gt
Noremap n <a-2> 2gt
Noremap n <a-3> 3gt
Noremap n <a-4> 4gt
Noremap n <a-5> 5gt
Noremap n <a-6> 6gt
" }}

" Map g* keys in Normal, Operator-pending, and Visual+select
noremap <silent> $ :call util#wrap_relative_motion("$")<CR>
noremap <silent> <End> :call util#wrap_relative_motion("$")<CR>
noremap <silent> 0 :call util#wrap_relative_motion("0")<CR>
noremap <silent> <Home> :call util#wrap_relative_motion("0")<CR>
noremap <silent> ^ :call util#wrap_relative_motion("^")<CR>
" Overwrite the operator pending $/<End> mappings from above
" to force inclusive motion with :execute normal!
onoremap <silent> $ v:call util#wrap_relative_motion("$")<CR>
onoremap <silent> <End> v:call util#wrap_relative_motion("$")<CR>
" Overwrite the Visual+select mode mappings from above
" to ensure the correct vis_sel flag is passed to function
vnoremap <silent> $ :<C-U>call util#wrap_relative_motion("$", 1)<CR>
vnoremap <silent> <End> :<C-U>call util#wrap_relative_motion("$", 1)<CR>
vnoremap <silent> 0 :<C-U>call util#wrap_relative_motion("0", 1)<CR>
vnoremap <silent> <Home> :<C-U>call util#wrap_relative_motion("0", 1)<CR>
vnoremap <silent> ^ :<C-U>call util#wrap_relative_motion("^", 1)<CR>

Noremap i <a-j> <down>
Noremap i <a-k> <up>
Noremap i <a-h> <left>
Noremap i <a-l> <right>
Noremap i <a-N> <s-left>
Noremap i <a-m> <s-right>
Noremap i <a-o> <end>
Noremap i <a-I> <home>

Noremap n <a-j> 10gj
Noremap n <a-k> 10gk
Noremap v <a-j> 10gj
Noremap v <a-k> 10gk

Noremap c <a-j> <down>
Noremap c <a-k> <up>
Noremap c <a-h> <left>
Noremap c <a-l> <right>
Noremap c <a-m> <s-right>
Noremap c <a-N> <s-left>
Noremap c <a-o> <end>
Noremap c <a-I> <home>
" 1}}

" Other {{1
Noremap c <a-p> <c-r>=substitute(@*.'', '\n', '', 'g')<cr>
" 1}}

" term {{1
try
  " use jk to exit insert mode for terminal
  tnoremap jk <C-\><C-n>
catch
endtry
if exists('##TermOpen')
  fu! s:term_setup()
    setlocal statusline=%{b:term_title}
  endf
  aug vim_term
    au!
    au TermOpen * :call s:term_setup()
  aug END
en
" 1}}

noremap ， ,<space>
noremap 。 .<space>
noremap ： :<space>
noremap ； ;<space>
noremap “ "<space>
noremap ‘ '<space>
noremap ？ ?<space>
noremap 、 \<space>
noremap 《 <
noremap 》 >
noremap （ (
noremap ） )
noremap —— _


" inoremap ， ,<space>
" inoremap 。 .<space>
" inoremap ： :<space>
" inoremap ； ;<space>
" inoremap “ "<space>
" inoremap ‘ '<space>
" inoremap ？ ?<space>
" inoremap 、 \<space>
" inoremap 《 <
" inoremap 》 >
" inoremap （ (
" inoremap ） )
" inoremap —— _
