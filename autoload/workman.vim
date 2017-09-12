" vim: set sw=4 ts=4 sts=4 et tw=80 fmr={{,}} fdm=marker nospell:

" 当你有一个workman键盘布局的键盘或者通过软件设置了系统键盘布局为workman布局，然
" 后打开vim发现很顺手的hjkl分布到了键盘的各个地方，这不符合vi设计的初衷，也确实不
" 方便，这里调整了hjkl在workman布局下的位置，仅对普通模式有效

let workman#useworkman = 0

" FUN: qwertt to workman {{
func! workman#toWorkman()
    if g:workman#useworkman == 1
        return
    endif

    " hjkl i zh zl {{2
    noremap h e
    noremap H E
    nnoremap j y
    nnoremap J Y
    noremap y h
    noremap Y H
    noremap n j
    nnoremap N J
    noremap e k
    nnoremap E K
    noremap o l
    noremap O L
    noremap k n
    noremap K N
    nnoremap l o
    nnoremap L O
    " 使用Y复制到行尾
    nnoremap J y$
    " j/k可以移动到软换行上
    nnoremap n gj
    nnoremap e gk
    nnoremap gn j
    nnoremap ge k

    inoremap ne <esc>
    iunmap jk

    noremap Y ^
    noremap O $

    nnoremap zo zH
    nnoremap zy zL
    " 2}}

    " 快捷移动 {{2
    " unmap first
    Map iun <a-j>
    " Map iun <a-k>
    Map iun <a-h>
    " Map iun <a-l>
    " Map iun <a-m>
    " Map iun <a-n>
    " Map iun <a-o>
    " Map iun <a-i>
    Map un <a-j>
    " Map un <a-k>

    Map cun <a-j>
    " Map cun <a-k>
    Map cun <a-h>
    " Map cun <a-l>
    " Map cun <a-m>
    " Map cun <a-n>
    " Map cun <a-i>
    " Map cun <a-o>


    " then map
    Noremap i <a-n> <down>
    Noremap i <a-e> <up>
    Noremap i <a-y> <left>
    Noremap i <a-o> <right>
    " Noremap i <a-m> <s-right>
    Noremap i <a-k> <s-left>
    Noremap i <a-l> <end>
    " Noremap i <a-i> <home>
    Noremap i <a-n> <10gj>
    Noremap i <a-e> <10gk>

    Noremap c <a-n> <down>
    Noremap c <a-e> <up>
    Noremap c <a-y> <left>
    Noremap c <a-o> <right>
    " Noremap c <a-m> <s-right>
    Noremap c <a-k> <s-left>
    Noremap c <a-l> <end>
    " Noremap c <a-i> <home>
    " 2}}

    " file buffer tab and window {{2
    " unmap first
    nunmap <tab>j
    " nunmap <tab>k
    " nunmap <tab>l
    nunmap <tab>h
    " nunmap <tab>o
    " nunmap <tab>n
    " then map
    nnoremap <tab>n <C-w>j
    nnoremap <tab>e <C-w>k
    nnoremap <tab>o <C-w>l
    nnoremap <tab>y <C-w>h
    nnoremap <tab>l :tabnext<cr>
    nnoremap <tab>k :tabnew<cr>
    " 2}}

    let g:workman#useworkman = 1
    echo 'workman: now use workman'
endf " }}

" FUN: workman to qwerty {{1
func! workman#toQwerty()
    if g:workman#useworkman == 0
        return
    endif

    " hjkl i zh zl {{2
    noremap h h
    noremap H H
    nnoremap j j
    nnoremap J J
    noremap y y
    noremap Y Y
    noremap n n
    nnoremap N N
    noremap e e
    nnoremap E E
    noremap o o
    noremap O O
    noremap k k
    noremap K K
    nnoremap l l
    nnoremap L L
    " 使用Y复制到行尾
    nnoremap Y y$
    " j/k可以移动到软换行上
    nnoremap j gj
    nnoremap k gk
    nnoremap gj j
    nnoremap gk k

    inoremap jk <esc>
    iunmap ne

    noremap H ^
    noremap L $

    nunmap zo
    nunmap zy
    nnoremap zh zH
    nnoremap zl zL
    " 2}}

    " 快捷移动 {{2
    " unmap first
    Map iun <a-n>
    Map iun <a-e>
    Map iun <a-y>
    " Map iun <a-o>
    " Map iun <a-m>
    " Map iun <a-k>
    " Map iun <a-l>
    " Map iun <a-i>
    Map iun <a-n>
    Map iun <a-e>

    Map cun <a-n>
    Map cun <a-e>
    Map cun <a-y>
    " Map cun <a-o>
    " Map cun <a-m>
    " Map cun <a-k>
    " Map cun <a-l>
    " Map cun <a-i>

    " then map
    Noremap i <a-j> <down>
    Noremap i <a-k> <up>
    Noremap i <a-h> <left>
    Noremap i <a-l> <right>
    Noremap i <a-m> <s-right>
    Noremap i <a-N> <s-left>
    Noremap i <a-o> <end>
    Noremap i <a-i> <home>
    Noremap n <a-j> 10gj
    Noremap n <a-k> 10gk

    Noremap c <a-j> <down>
    Noremap c <a-k> <up>
    Noremap c <a-h> <left>
    Noremap c <a-l> <right>
    Noremap c <a-m> <s-right>
    Noremap c <a-N> <s-left>
    Noremap c <a-o> <end>
    Noremap c <a-i> <home>
    " 2}}

    " file buffer tab and window {{2
    " unmap first
    " nunmap <tab>n
    nunmap <tab>e
    " nunmap <tab>o
    nunmap <tab>y
    " nunmap <tab>l
    " nunmap <tab>k
    " then map
    nnoremap <tab>j <C-w>j
    nnoremap <tab>k <C-w>k
    nnoremap <tab>l <C-w>l
    nnoremap <tab>h <C-w>h
    nnoremap <tab>o :tabnext<cr>
    nnoremap <tab>n :tabnew<cr>
    " 2}}

    let g:workman#useworkman = 0
    echo 'workman: now use qwerty'
endf " }}

" FUN: toggle workman and qwerty {{
func! workman#workmanToggle()
    if g:workman#useworkman == 1
        call workman#toQwerty()
    elseif g:workman#useworkman == 0
        call workman#toWorkman()
    else
        echo 'workman: toggle error'
    endif
endf " }}

finish
" 示意图:
qwerty:
  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------------+
  |esc  |1    |2    |3    |4    |5    |6    |7    |8    |9    |0    |-    |=    |Backspace    |
  |`    |!    |@    |#    |$    |%    |^    |&    |*    |(    |)    |_    |+    |             |
  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------------+
  |Tab     |Q    |W    |E    |R    |T    |Y    |U    |I    |O    |P    |[    |}    ||         |
  |        |     |     |     |     |     |     |     |     |     |     |{    |]    |\         |
  +--------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----------+
  |Caps      |A    |S    |D    |F    |G    |H    |J    |K    |L    |;    |'    |Enter         |
  |          |     |     |     |     |     |     |     |     |     |:    |"    |              |
  +----------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+--------------+
  |Shift        |Z    |X    |C    |V    |B    |N    |M    |,    |.    |/    |Shift            |
  |             |     |     |     |     |     |     |     |<    |>    |?    |                 |
  +------+------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----------------+
  |Ctrl   |Win    |Alt    |                                   |Alt    |Fn     |Pn     |Ctrl   |
  |       |       |       |                                   |       |       |       |       |
  +-------+-------+-------+-----------------------------------+-------+-------+-------+-------+

workman:
  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------------+
  |esc  |1    |2    |3    |4    |5    |6    |7    |8    |9    |0    |-    |=    |Backspace    |
  |`    |!    |@    |#    |$    |%    |^    |&    |*    |(    |)    |_    |+    |             |
  +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-------------+
  |Tab     |Q    |D    |R    |W    |B    |J    |F    |U    |P    |;    |[    |}    ||         |
  |        |     |     |     |     |     |    y|     |     |     |:    |{    |]    |\         |
  +--------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+----------+
  |Caps      |A    |S    |H    |T    |G    |Y    |N    |E    |O    |I    |'    |Enter         |
  |          |     |     |    e|     |     |    h|    j|    k|    l|     |"    |              |
  +----------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+--------------+
  |Shift        |Z    |X    |M    |C    |V    |K    |L    |,    |.    |/    |Shift            |
  |             |     |     |     |     |     |    n|    o|<    |>    |?    |                 |
  +------+------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----------------+
  |Ctrl   |Win    |Alt    |                                   |Alt    |Fn     |Pn     |Ctrl   |
  |       |       |       |                                   |       |       |       |       |
  +-------+-------+-------+-----------------------------------+-------+-------+-------+-------+

