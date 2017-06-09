let s:plugs = plugex#plugs()
let s:plugs_order = plugex#plugs_order()

" functions for plug obj
fu! plug_util#to_str(plug, ...) " {{{
  " obj plug to string
  let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
  let l:b = l:a . '    '
  let l:r = l:a . printf("  [ %s ] %s\n", a:plug.name, a:plug.has('plugs') ? 'Group' : '')
  let l:r .= l:b . printf("name          : %s\n", a:plug.name)
  let l:r .= l:b . printf("path          : %s\n", get(a:plug, 'path', '---'))
  let l:r .= l:b . printf("branch        : %s\n", get(a:plug, 'branch', '---'))
  let l:r .= l:b . printf("tag           : %s\n", get(a:plug, 'tag', '---'))
  let l:r .= l:b . printf("commit        : %s\n", get(a:plug, 'commit', '---'))
  let l:r .= l:b . printf("repo          : %s\n", a:plug.repo)
  let l:r .= l:b . printf("uri           : %s\n", get(a:plug, 'uri', '---'))
  let l:r .= l:b . printf("type          : %s\n", a:plug.type)
  let l:r .= l:b . printf("loaded        : %s\n", a:plug.loaded)
  let l:r .= l:b . printf("in_rtp        : %s\n", a:plug.in_rtp)
  let l:r .= l:b . printf("enable        : %s\n", a:plug.enable)
  let l:r .= l:b . printf("frozen        : %s\n", get(a:plug, 'frozen', 0))
  let l:r .= l:b . printf("rtp           : %s\n", get(a:plug, 'rtp', '---'))
  let l:r .= l:b . printf("dep           : %s\n", get(a:plug, 'dep', '---'))
  let l:r .= l:b . printf("before        : %s\n", string(get(a:plug, 'before'.(has_key(a:plug, 'before')? ', loaded': ', not loaded'), '---')))
  let l:r .= l:b . printf("after         : %s\n", string(get(a:plug, 'after'.(has_key(a:plug, 'after_loaded')? ', loaded': ', not loaded'), '---')))
  let l:r .= l:b . printf("do            : %s\n", get(a:plug, 'do', '---'))
  let l:r .= l:b . printf("[lazy-load]   : %s\n", get(a:plug, 'is_lazy', 0))
  let l:r .= l:b . printf("  |- for      : %s\n", string(get(a:plug, 'for', '---')))
  let l:r .= l:b . printf("  |- on       : %s\n", string(get(a:plug, 'on', '---')))
  let l:r .= l:b . printf("  |- on_event : %s\n", string(get(a:plug, 'on_event', '---')))
  let l:r .= l:b . printf("  |- on_func  : %s\n", string(get(a:plug, 'on_func', '---')))
  if has_key(a:plug, 'plugs')
    let l:r .= l:b . "[plugs]   : %s\n"
    for l:p in a:plug.plugs
      let l:r .= plug_util#to_str(l:p, len(l:a) / 4 + 1)
    endfor
  en
  return l:r
endf " }}}
fu! plug_util#load(plug) " {{{
  " load plug
  if !a:plug.enable || a:plug.loaded | return | en
  " deps
  if has_key(a:plug, 'deps')
    for name in a:plug.deps
      if has_key(plugex#plugs, name)
        let plug = plugex#plugs[name]
        if !plug.load()
          return s:err('When load ['.a:plug.name.'], dependency plugin '.plug.name.' load fail.')
        en
      else
        return s:err('When load ['.a:plug.name.'], can not found dependency plugin '.plug.name.'.')
      end
    endfor
  en

  " on
  if has_key(a:plug, 'on')
    for l:on in a:plug.on
      if l:on =~? '<plug>' " on_map
        let l:map = matchstr(l:on, '<plug.*$')
        let l:mode = l:on[0]
        if hasmapto(l:map, l:mode)
          exe l:mode.'unmap '.l:map
        en
      el " on_cmd
        if exists(':'.l:on)
          exe 'delcommand '.l:on
        en
      en
    endfor
  en

  " call before, add2rtp, load, after
  call plugex#call_before(a:plug)
  call plugex#add2rtp(a:plug)
  let l:r = plugex#source(a:plug.path, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
  if has_key(a:plug, 'rtp')
    for l:rtp in a:plug.rtp
      let l:sub = expand(a:plug.path . '/' . l:rtp)
      let l:r += plugex#source(l:sub, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
    endfor
  en
  let a:plug.loaded = 1
  call plugex#call_after(a:plug)
  return l:r
endf " }}}

" functions for command
fu! plug_util#plug_info(...) " {{{
  " for PlugInfo command
  let l:plugs = a:0 == 0 ? plugex#plugs : plugex#pick_plugs(a:000)
  tabnew
  setl nolist nospell wfh bt=nofile bh=unload fdm=indent wrap
  call setline(1, repeat('-', 40))
  call append(line('$'), repeat(' ', 13).'PlugInfo')
  call append(line('$'), repeat('-', 40))
  let l:loaded = []
  let l:lazy_num = 0
  for l:pn in plugex#plugs_order()
    let l:p = plugex#plugs[l:pn]
    call append(line('$'), split(plug_util#to_str(l:p), '\n'))
    if l:p.loaded
      call add(l:loaded, l:p.name)
    en
    if l:p.is_lazy
      let l:lazy_num += 1
    en
  endfor
  call append(3, '')
  call append(3, 'Total: '.len(plugex#plugs))
  call append(4, 'Loaded: '.len(l:loaded))
  call append(5, 'Lazy load: '.l:lazy_num)
  call append(6, 'These plugins have been loades: ')
  call append(7, '  '.string(l:loaded))
endf " }}}
fu! plug_util#install(...) " {{{
  " for PlugExInstall command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  en
  " for PlugExInstall command
  let l:plugs = a:0 == 0 ? values(s:plugs) : plugex#pick_plugs(a:000)
  if &ft == 'startify'
    tabnew
    exe "normal! i\<esc>"
  el
    exe "normal! i\<esc>"
  en
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugInstall
  let &rtp = l:old_rtp
  for l:p in l:plugs
    call plugex#load_ftdetect(l:p)
    call plug_util#load(l:p)
  endfor
endf " }}}
fu! plug_util#update(...) " {{{
  " for PlugExUpdate command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  en
  let l:plugs = a:0 == 0 ? values(s:plugs) : plugex#pick_plugs(a:000)
  if &ft == 'startify'
    tabnew
    exe "normal! i\<esc>"
  el
    exe "normal! i\<esc>"
  en
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugUpdate
  let &rtp = l:old_rtp
endf " }}}
fu! plug_util#clean(bang) " {{{
  " for PlugExClean
  let l:old_rtp = &rtp
  call s:init_plug(values(s:plugs))
  if a:bang
    PlugClean!
  el
    PlugClean
  en
  let &rtp = l:old_rtp
endf " }}}
fu! plug_util#status() " {{{
  " for PlugExStatus
  let l:old_rtp = &rtp
  call s:init_plug(values(s:plugs))
  PlugStatus
  let &rtp = l:old_rtp
endf " }}}
fu! plug_util#complete_plugs(a, l, p) " {{{
  " complete all plugin names
  let r = []
  for name in s:plugs_order
    if niame =~? a:a
      call add(r, name)
    en
  endfor
  return r
endf " }}}
fu! s:pick_plugs(names) " {{{
  " get plug obj list from s:plugs for each plug name in arg
  let l:plugs = []
  for name in a:names
    call add(l:plugs, s:plugs[name])
  endfor
  return l:plugs
endf " }}}


" other functions
fu! s:init_plug(plugs) " {{{
  call s:check_plug()
  call plug#begin(s:plug_home)
  for l:p in a:plugs
    call plug#(l:p.repo, s:get_plug_config(l:p))
  endfor
  call plug#end()
endf " }}}
fu! s:get_plug_config(plug) " {{{
  " get config for plug.vim
  let l:r = {}
  for l:attr in ['branch', 'tag', 'commmit', 'do', 'frozen', 'as', 'dir']
    if has_key(a:plug, l:attr)
      let l:r[l:attr] = a:plug[l:attr]
    en
  endfor
  return l:r
endf " }}}
fu! s:check_plug() " {{{
  if !filereadable(s:plug_path)
    echo 'can not found plug.vim, download now...'
    call s:update_plug()
  en
endf " }}}
fu! s:update_plug(...) " {{{
  " install/update plug.vim
  let l:path = a:0 == 0 ? expand(s:first_rtp.'/autoload') : a:1
  if !isdirectory(l:path)
    call mkdir(l:path, "p")
  en
  let l:path = expand(l:path.'/plug.vim')
  let l:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if s:is_win
    let l:cmd = '@powershell -NoProfile -Command "((New-Object Net.WebClient)'.
          \ ".DownloadFile('".l:url."', $ExecutionContext.SessionState.Path".
          \ ".GetUnresolvedProviderPathFromPSPath('".l:path.''')))"'
  el
    let l:cmd = 'curl -fLo '.l:path.' --create-dirs '.l:url
  en
  if filereadable(l:path)
    call delete(l:path)
  en
  call s:system_at('.', l:cmd)
  if filereadable(l:path)
    exe 'tabnew ' . l:path
    exe "normal! gg/! plugex#source\<cr>4j0r\":w\<cr>:bd\<cr>"
    return 1
  en
endf " }}}
fu! s:system_at(path, cmd) abort " {{{
  " cd to path, exe cmd, then cd back
  let l:cd = getcwd()
  exe 'cd ' . a:path
  let l:r =  system(a:cmd)
  exe 'cd ' . a:path
  return r
endf " }}}
fu! s:system_at(path, cmd) abort " {{{
  " cd to path, exe cmd, then cd back
  let l:cd = getcwd()
  exe 'cd ' . a:path
  let l:r =  system(a:cmd)
  exe 'cd ' . a:path
  return r
endf " }}}
fu! s:err(msg) " {{{
  " echo err
  echohl ErrorMsg
  echom '[plugex][plug_util] ' . a:msg
  echohl None
endf " }}}

" vim: fmr={{{,}}} fdm=marker:
