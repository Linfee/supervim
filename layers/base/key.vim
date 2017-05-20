"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ v / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: linfee
" Repo: https://github.com/linfee/supervim
" Doc: Map/Noremap mode map-args <lhs> <rhs>
"      Map/Noremap mode <lhs> <rhs>
"      used to unmap:
"      Map mode+un <lhs>
"
"      support map commands: map, nmap, vmap, xmap, smap, omap, imap, lmap, cmap
"                            unmpa, nunmap, vunmap, xunmap, sunmap, ounmap,
"                            iunmap, lunmap, cunmap
" Example:
"      Noremap n Y y$  
"       --> noremap Y y$
"      Noremap n <buffer> <slient> <leader>h :echo 'hello'<cr>
"       --> nnoremap <buffer> <silent> <leader>h :echo 'hello'<cr>
"      Map nun Y
"       --> unmap Y
"
scriptencoding utf-8
let s:cpo_save = &cpo
set cpo&vim

let s:keys =      "abcdefghijklmnopqrtuvwxyzABCDEFGHIJKLMNOPQRsSTUVWXYZ-=[];'" . ',./_+{}:"<>?1234567890'
let s:alt_keys =  "å∫ ∂ ƒ©˙ ∆˚¬µ øπœ®† √∑≈¥ΩÅıÇÎ´Ï˝ÓˆÔÒÂ˜Ø∏Œ‰ßÍˇ¨◊„˛Á¸–≠“‘…æ" . '≤≥÷—±”’æÆ¯˘¿¡™£¢∞§¶•ªº'
let s:map_args = ["<buffer>", "<nowait>", "<silent>", "<special>", "<script>", "<expr>", "<unique>"]
let s:cmds = ['_', 'n', 'v', 'x', 's', 'o', 'i', 'l', 'c', 'nun', '_un', 'vun', 'xun', 'sun', 'oun', 'iun', 'lun', 'cun', 'un']
let s:unsupposed_alt_key = "ineu" " unsupposed alt key on osx

com! -nargs=+ -bang Noremap call s:do_map(1, <bang>0, [<f-args>])
com! -nargs=+ -bang Map call s:do_map(0, <bang>0, [<f-args>])

fu! s:do_map(nore, bang, args)
  if index(s:cmds, a:args[0]) == -1
    echo 'Map and Noremap: first argument only support '.string(s:cmds).'. Use _ mean map and noremap.'
    retu
  en
  let cmd = a:args[0].(a:nore?'nore':'').'map'.(a:bang ? '!' : '')
  if cmd[0] == '_'
    let cmd = cmd[1:]
  en

  let map_args = ''
  let i = 1
  while i < len(a:args) && index(s:map_args, a:args[i]) != -1
    let map_args = map_args.' '.a:args[i]
    let i += 1
  endw
  let cmd = cmd.map_args

  let lhs = ''
  if i < len(a:args)
    let lhs = a:args[i]
  en
  let lhs = ' '.lhs

  let rhs = ''
  for arg in a:args[i+1:-1]
    let rhs = rhs.' '.arg
  endfo

  let wraped_lhs = s:wrap_lhs(lhs)
  if wraped_lhs =~ '^\s*$'
    echom lhs . ' can not work on osx, please use another key.'
    return
  end
  let cmd = cmd.wraped_lhs.rhs
  exe cmd
  " echo cmd
  " echo lhs
endf

fu! s:wrap_lhs(lhs)
  let lhs = a:lhs
  let m = match(lhs, '<a-.>')
  while m != -1
    let char = lhs[m+3]
    let lhs = s:do_wrap(lhs, char)
    if lhs == 0
      break
    en
    let m = match(lhs, '<a-.>')
  endw
  retu lhs
endf

if has('macunix')
  fu! s:do_wrap(lhs, char)
    retu substitute(a:lhs, '<a-' . a:char . '>', tr(a:char, s:keys, s:alt_keys), '')
  endf
elsei has('nvim')
  fu! s:do_wrap(lhs, char)
    retu a:lhs
  endf
elsei has('unix') && !has('macunix') && !has('gui_running')
  fu! s:do_wrap(lhs, char)
    retu substitute(a:lhs, '<a-' . a:char . '>', '' . a:char, '')
  endf
el
  fu! s:do_wrap(lhs, char)
    retu a:lhs
  endf
en

let &cpo = s:cpo_save
unlet s:cpo_save
