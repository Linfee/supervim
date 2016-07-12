""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This is the personal vimrc file of Linfee
" FILE:     extesion.vim
" Author:   Linfee
" EMAIL:    Linfee@hotmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"  一行超过80列就标红


""""""""""""""""""
"  列参考线  {{{ "
""""""""""""""""""
" ReferenceLine('+') 右移参考线
" ReferenceLine('-') 左移参考线
" ReferenceLine('r') 移除参考线
function! ReferenceLine(t)
	if exists('w:ccnum')
		let ccnum=w:ccnum
	elsei exists('b:ccnum')
		let ccnum=b:ccnum
	else
		let ccnum=0
	endif
	let oldcc=ccnum
	" let ccc=&cc
	" ec oldcc
	let ccc=','.&cc.','
	" add/sub
	if a:t=='+' || a:t=='-'
		" check old cc
		if match(ccc, ','.oldcc.',')<0
			let oldcc=0
			let ccnum=0
		endif
		" step
		let csw=&sw
		if a:t=='add'
			let ccnum=ccnum + csw
		elsei a:t=='sub'
			let ccnum=ccnum - csw
			if ccnum < 0 | let ccnum=0 | endif
		endif
		if oldcc > 0 | let ccc=substitute(ccc, ','.oldcc.',', ',', '') | endif
		let ccc=ccc.ccnum
		" ec ccc
		" ec ccnum
		let ccc=substitute(ccc, '^0,\|,0,\|,0$', ',', 'g')
		let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
		" ec ccc
		let w:ccnum=ccnum
		let b:ccnum=ccnum
		exec "setl cc=".ccc
		" del
	elsei a:t=='r'
		let ccc=substitute(ccc, ','.oldcc.',', ',', '')
		let ccc=substitute(ccc, '^,\+\|,\+$', '', 'g')
		" ec ccc
		let w:ccnum=0
		let b:ccnum=0
		exec "setl cc=".ccc
	endif
endf
" 外部接口，调用它来设置列参考线，0表示没有参考线
function! SetRL(n)
	if !exists('b:is_rl_added')
		call ReferenceLine('+')
		let &cc = 0
		let b:is_rl_added = 1
	endif
	let &cc = a:n
endfunction
" Bug: 新建立的缓冲区会继承之前的参考线
" 外部接口，删除列参考线
function! RemoveRL()
	if b:is_rl_added == 0
		return
	endif
	let &cc = 0
endfunction
" 自动添加80列参考线
augroup RL
	autocmd!
	autocmd FileType * call SetRL(80)
augroup END

" }}}


" >>>>> 方法 {{{1
""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
	let g:cmd = getcmdline()

	if has("win16") || has("win32")
		let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
	else
		let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
	endif

	if g:cmd == g:cmd_edited
		if has("win16") || has("win32")
			let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
		else
			let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
		endif
	endif   

	return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
	return a:cmd . " " . expand("%:p:h") . "/"
endfunc

" 调用mybatis逆向工程的
let g:mybatis_gnenerate_core="none"
func! MybatisGenerate()
	if g:mybatis_gnenerate_core == "none"
		echo "你必须设置 g:mysql_connector 和 g:mybatis_gnenerate_core 才能运行该方法"
		return
	endif
	exec("!java -jar " . g:mybatis_gnenerate_core . expand(" -configfile %") . " -overwrite")
endfunc

" }}}1

