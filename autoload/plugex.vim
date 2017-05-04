" pluxex: a vim plugin manager
" ============================
" Doc: "{{
" Plugex is a vim plugin manager
" Plugex uses vim-plug to download/update plugins
" Plugex manages runtimepath and plugin loading itself
" Plugex_options:
"     as
"     branch/tag/commit
"     path
"     frozen
"     rtp
"     enable
"     do
"     after
"     on_ft
"     onc_cmd
"     on_event
"     on_if
"     on_func
"     on_map
" Global_options:
"     g:plug_home           specify a directory for plugins
"     g:plug_path           specify a path for plug.vim
"                           default as the first runtimepath autoload/plug.vim
"     all vim-plug options
" Functions:
"     plugex#begin({plug home}): call this first then use PlugEx to define plugins
"     plugex#end()             : after define all plugins, call this function
" Commands:
"     PlugEx {plug repo}[, {options}]
"     PlugExInstall [name ...]
"     PlugExUpdate [name ...]
"     PlugExClean[!]
"     PlugExStatus
"     PlugExinfo [name ...]
" }}

if exists('g:loaded_plugex')
  finish
endif
let g:loaded_plugex = 1

let s:cpo_save = &cpo
set cpo&vim

fu! plugex#begin(...) " < plugex#begin> {{
  if !executable('git')
    return s:err('Please make sure git int your path, plugex depends on that.')
  endif
  let s:plug_path = exists('g:plug_path') ? g:plug_path :
        \ expand(s:rstrip_slash(s:split_rtp()[0]).'/autoload/plug.vim')

  let s:TYPE = {
        \   'string':  type(''),
        \   'list':    type([]),
        \   'dict':    type({}),
        \   'funcref': type(function('call'))
        \ }

  if a:0 > 0
    let l:plug_home = s:rstrip_slash(expand(a:1))
  elseif exists('g:plug_home')
    let l:plug_home = s:rstrip_slash(expand(s:plug_home))
  elseif !empty(&rtp)
    let l:plug_home = expand(s:rstrip_slash(split(&rtp, ',')[0]) . '/plugs')
  else
    retu s:err('Unable to determine plugex home. Try calling plugex#begin() with a path argument.')
  endif

  " init vars
  let s:plug_home = l:plug_home   " where to store plugins
  let s:plugs = []
  let s:first_rtp = s:rstrip_slash(s:split_rtp()[0])
  let s:is_win = has('win32') || has('win64')

  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  endif

  call s:def_class()
  call s:def_cmd()
  return 1
endf " }}

fu! plugex#end() " < plugex#end > {{
  if !exists('s:plugs')
    return s:err('Call plugex#begin() first')
  endif
  filetype off
  for l:plug in s:plugs
    if !l:plug.is_lazy
      call l:plug.add2rtp()
    else
      call l:plug.load_ftdetect()
    endif
  endfo
  filetype plugin indent on
  syntax enable
  call s:setup_lazy_load()
  let g:plugexs = s:plugs
endf " }}

fu! s:def_class() " < class plugin > {{1
  " variables " {{2
  let s:plug_attrs = [
        \ 'as', 'branch', 'tag', 'commit',
        \ 'path', 'frozen', 'rtp', 'enable', 'do', 'after',
        \ 'on_ft', 'on_cmd', 'on_event', 'on_if', 'on_func', 'on_map']
  let s:TYPE_REMOTE = 1
  let s:TYPE_LOCAL = 0
  let s:fake_cmd_map = {}
  let s:fake_map_map = {}
  " 2}}
  fu! s:load() dict " {{2
    if !self.enable || self.loaded
      return
    endif
    if self.has('on_ft') && index(self.on_ft, &ft) == -1
      return
    endif
    call self.add2rtp()
    let l:r = s:source(self.path, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
    " for vimscripts in plugin's subdirectory
    if self.has('rtp')
      for l:rtp in self.rtp
        let l:sub = expand(self.path . '/' . l:rtp)
        let l:r += s:source(l:sub, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
      endfor
    endif
    let self.loaded = 1
    if self.has('after')
      if exists('*'.self.after)
        exe 'call ' . self.after . '()'
      else
        call s:err('Specified after function for plugin ['.self.name.'] does not exists')
      endif
    endif
    return l:r
  endf " 2}}
  fu! s:load_ftdetect() dict " {{2
    if self.enable
      let l:r = s:source(self.path, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
      " for vimscripts in plugin's subdirectory
      if self.has('rtp')
        if type(self.rtp) == s:TYPE.string
          let l:sub = expand(self.path . '/' . self.rtp)
          let l:r += s:source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
        elseif type(self.rtp) == s:TYPE.list
          for l:rtp in self.rtp
            let l:sub = expand(self.path . '/' . l:rtp)
            let l:r += s:source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
          endfor
        endif
      endif
      return l:r
    endif
  endf " 2}}
  fu! s:add2rtp() dict " {{2
    " only called by self.load
    if isdirectory(self.path)
      let l:rtp = s:split_rtp()
      call insert(l:rtp, self.path, 1)
      let l:after = expand(self.path . '/after')
      if isdirectory(l:after)
        call add(l:rtp, l:after)
      endif
      " for vimscripts in plugin's subdirectory
      if self.has('rtp')
        if type(self.rtp) == s:TYPE.string
          let l:sub = expand(self.path . '/' . self.rtp)
          let l:sub_after = expand(l:sub . '/after')
          if isdirectory(l:sub)
            call insert(l:rtp, l:sub, 1)
          endif
          if isdirectory(l:sub_after)
            call add(l:rtp, l:sub_after)
          endif
        elseif type(self.rtp) == s:TYPE.list
          for l:r in self.rtp
            let l:sub = expand(self.path . '/' . l:r)
            let l:sub_after = expand(l:sub . '/after')
            if isdirectory(l:sub)
              call insert(l:rtp, l:sub, 1)
            endif
            if isdirectory(l:sub_after)
              call add(l:rtp, l:sub_after)
            endif
          endfor
        endif
      endif
      let &rtp = join(l:rtp, ',')
    endif
  endf " 2}}
  fu! s:to_str(...) dict " {{2
    let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
    let l:b = l:a . '    '
    let l:r = l:a . printf("[ %s ]\n", self.name)
    let l:r .= l:b . printf("name          : %s\n", self.name)
    let l:r .= l:b . printf("author        : %s\n", self.author)
    let l:r .= l:b . printf("path          : %s\n", self.path)
    let l:r .= l:b . printf("repo          : %s\n", self.repo)
    let l:r .= l:b . printf("original_repo : %s\n", self.original_repo)
    let l:r .= l:b . printf("branch        : %s\n", self.has('branch') ? self.branch : 'master')
    let l:r .= l:b . printf("tag           : %s\n", self.has('tag') ? self.tag : '---')
    let l:r .= l:b . printf("commit        : %s\n", self.has('commit') ? self.commit : '---')
    let l:r .= l:b . printf("enable        : %s\n", self.enable)
    let l:r .= l:b . printf("loaded        : %s\n", self.loaded)
    let l:r .= l:b . printf("frozen        : %s\n", self.has('frozen') ? self.frozen : 0)
    let l:r .= l:b . printf("rtp           : %s\n", self.has('rtp') ? self.rtp : '---')
    let l:r .= l:b . printf("type          : %s\n", self.type == s:TYPE_REMOTE ? 'remote' : 'local')
    let l:r .= l:b . printf("do            : %s\n", self.has('do') ? self.do : '---')
    let l:r .= l:b . printf("[lazy-load]   : %s\n", self.has('is_lazy') ? self.is_lazy : 0)
    let l:r .= l:b . printf("  |- on_ft    : %s\n", self.has('on_ft') ? string(self.on_ft) : '---')
    let l:r .= l:b . printf("  |- on_cmd   : %s\n", self.has('on_cmd') ? string(self.on_cmd) : '---')
    let l:r .= l:b . printf("  |- on_event : %s\n", self.has('on_event') ? string(self.on_event) : '---')
    let l:r .= l:b . printf("  |- on_if    : %s\n", self.has('on_if') ? string(self.on_if) : '---')
    let l:r .= l:b . printf("  |- on_func  : %s\n", self.has('on_func') ? string(self.on_func) : '---')
    let l:r .= l:b . printf("  |- on_map   : %s\n", self.has('on_map') ? string(self.on_map) : '---')
    return l:r
  endf " 2}}
  fu! s:plug_has(attr) dict " {{2
    return has_key(self, a:attr) && len(self[a:attr]) > 0
  endf " 2}}
  fu! s:set_repo(repo) dict " {{2
    if a:repo =~ '^[[:alnum:]-]\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$'
      " 1.normal github repo: foo/bar[.git][/]
      let l:repo = s:strip_git_url(a:repo)
      let l:idx = stridx(l:repo, '/')
      let self.repo = 'https://github.com/' . a:repo . '.git'
      let self.type = s:TYPE_REMOTE
      let self.name = l:repo[l:idx+1:]
      let self.author = l:repo[:l:idx-1]
      let self.path = expand(s:plug_home . '/' . self.name)
    elseif a:repo =~ '^\(\/\|\w:\|file:\)'
      " 2. local file repo: c:/foo/bar  /path/to/repo.git/  file:///path/to/repo.git/  file:///c:/foo/bar
      let l:path = s:strip_git_url(a:repo)
      let l:path = substitute(l:path, '^file://', '', '')
      if l:path[2] == ':' " for some windows path
        let l:path = l:path[1:]
      endif
      let self.repo = l:path
      let self.path = expand(l:path)
      let self.type = s:TYPE_LOCAL
      let self.name = fnamemodify(l:path, ':t')
      let self.author = $USERNAME
    elseif stridx(a:repo, ':') != -1
      " 3. other git url:
      " use '\w\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$' to get author/project[.git][/]
      let l:repo = s:strip_git_url(matchstr(a:repo, '\w\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$'))
      let l:idx = stridx(l:repo, '/')
      let self.repo = a:repo
      let self.type = s:TYPE_REMOTE
      let self.name = l:repo[l:idx+1:]
      let self.author = l:repo[:l:idx-1]
      let self.path = expand(s:plug_home . '/' . self.name)
    else
      return s:err("Could't recognize plugin repo: " . a:repo)
    endif
    let self.original_repo = a:repo
    return 1
  endf " 2}}
  fu! s:plug_config() dict " {{
    let l:r = {}
    if self.has('branch') && self.branch != 'master'
      let l:r.branch = self.branch
    endif
    if self.has('tag')
      let l:r.tag = self.tag
    endif
    if self.has('commit')
      let l:r.commit = self.commit
    endif
    if self.has('do')
      let l:r.do = self.do
    endif
    if self.has('frozen')
      let l:r.frozen = self.frozen
    endif
    if self.has('as')
      let l:r.as = self.as
    endif
    if self.has('dir')
      let l:r.dir = self.dir
    endif
    return l:r
  endf " }}
  fu! s:mk_plug() " {{2
    let l:plug = {}
    let l:plug.load = function('s:load')
    let l:plug.load_ftdetect = function('s:load_ftdetect')
    let l:plug.add2rtp = function('s:add2rtp')
    let l:plug.to_str = function('s:to_str')
    let l:plug.has = function('s:plug_has')
    let l:plug.set_repo = function('s:set_repo')
    let l:plug.plug_config = function('s:plug_config')
    " attributes
    let l:plug.enable = 1
    let l:plug.loaded = 0
    return l:plug
  endf " 2}}
  fu! s:new_plug(repo, config) " {{2
    let l:plug = s:mk_plug()
    call l:plug.set_repo(a:repo)
    " apply config
    let l:path = l:plug.path
    for [k, v] in items(a:config)
      if index(s:plug_attrs, k) != -1
        let l:plug[k] = v
      else
        call s:err('Unsupported attribute: ' . k . ' for plug ' . l:plug.name)
      endif
    endfor
    if l:plug.path != l:path
      let l:plug.dir = l:plug.path
    endif
    if l:plug.has('as')
      let l:plug.name = l:plug.as
    endif
    " conver these attributes to list if user use string
    " rtp, on_ft, on_cmd, on_event, on_func, on_map
    for l:attr in ['rtp', 'on_ft', 'on_cmd', 'on_event', 'on_func', 'on_map']
      if l:plug.has(l:attr) && type(l:plug[l:attr]) == s:TYPE.string
        let l:plug[l:attr] = [l:plug[l:attr]]
      endif
    endfor
    let l:plug.is_lazy = l:plug.has('on_ft') || l:plug.has('on_event') ||
          \ l:plug.has('on_cmd') || l:plug.has('on_func') || l:plug.has('on_map')
    return plug
  endf " 2}}
  fu! s:fake_cmd(cmd, bang, l1, l2, args, plugs) " {{2
    exe 'delcommand '.a:cmd
    for l:p in s:pick_plugs(a:plugs)
      call l:p.load()
    endfor
    exe printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
  endf " 2}}
  fu! s:fake_map(the_map, with_prefix, prefix, plugs)" {{2
    " https://github.com/junegunn/vim-plug/blob/master/plug.vim
    for l:p in s:pick_plugs(a:plugs)
      call l:p.load()
    endfor
    let extra = ''
    while 1
      let c = getchar(0)
      if c == 0
        break
      endif
      let extra .= nr2char(c)
    endwhile

    if a:with_prefix
      let prefix = v:count ? v:count : ''
      let prefix .= '"'.v:register.a:prefix
      if mode(1) == 'no'
        if v:operator == 'c'
          let prefix = "\<esc>" . prefix
        endif
        let prefix .= v:operator
      endif
      call feedkeys(prefix, 'n')
    endif
    call feedkeys(substitute(a:the_map, '^<Plug>', "\<Plug>", '') . extra)
  endf " 2}}
endf " 1}}

fu! s:def_cmd() " < user interface > {{
  com! -nargs=+ -bar                                  PlugEx
        \ call plugex#add(<args>)
  com! -nargs=* -complete=customlist,s:complete_plugs PlugExInstall
        \ call plugex#install(<f-args>)
  com! -nargs=* -complete=customlist,s:complete_plugs PlugExUpdate
        \ call plugex#update(<f-args>)
  com! -nargs=0 -bang                                 PlugExClean
        \ call plugex#clean('<bang>'=='!')
  com! -nargs=0                                       PlugExStatus
        \ call plugex#status()
  com! -nargs=* -complete=customlist,s:complete_plugs PlugExInfo
        \ call plugex#pluginfo(<f-args>)
endf " }}

fu! s:setup_lazy_load() " < setup lazyload > {{
  " this function only execute once
  augroup PlugExLazyLoad
    autocmd!
    for l:i in range(len(s:plugs))
      let l:plug = s:plugs[l:i]
      if l:plug.is_lazy
        " ------------ on_ft -------------
        if l:plug.has('on_ft')
          let l:ft = join(s:plugs[l:i].on_ft, ',')
          if !(l:plug.has('on_cmd') || l:plug.has('on_event') || l:plug.has('on_func') || l:plug.has('on_map'))
            exe 'au FileType '.l:ft.' call s:plugs['.l:i.'].load()'
          endif
        endif
        " ------------ on_cmd ------------
        if l:plug.has('on_cmd')
          for l:cmd in l:plug.on_cmd
            " add to fake_cmd_map
            if has_key(s:fake_cmd_map, l:cmd)
              call add(s:fake_cmd_map[l:cmd], l:plug.name)
            else
              let s:fake_cmd_map[l:cmd] = [l:plug.name]
            endif
          endfor
        endif
        " ------------ on_event ----------
        if l:plug.has('on_event')
          " on_if option work with on_event option
          let l:event = join(s:plugs[l:i].on_event, ',')
          if l:plug.has('on_if')
            exe 'au '.l:event.' *  if ('.s:plugs[l:i].on_if.') | call s:plugs['.l:i.'].load() | en'
          else
            exe 'au '.l:event.' * call s:plugs['.l:i.'].load()'
          endif
        endif
        " ------------ co_func -----------
        if l:plug.has('on_func')
          let l:func_pat = join(s:plugs[l:i].on_func, ',')
          exe 'au FuncUndefined '.l:func_pat.' call s:plugs['.l:i.'].load()'
        endif
        " ------------ on_map ------------
        if l:plug.has('on_map')
          for l:map in l:plug.on_map
            if has_key(s:fake_map_map, l:map)
              call add(s:fake_map_map[l:map], l:plug.name)
            else
              let s:fake_map_map[l:map] = [l:plug.name]
            endif
          endfor
        endif
      endif
    endfor
  augroup END
  " ---- handle fake_cmd_map -----
  for l:k in keys(s:fake_cmd_map)
    exe "com! -nargs=* -range -bang -complete=file " .
          \ l:k . ' call s:fake_cmd(' .
          \ "'" . l:k . "'" .
          \ ', "<bang>", <line1>, <line2>, <q-args>,'.
          \ string(s:fake_cmd_map[l:k]).
          \ ')'
  endfor
  " ---- handle fake_map_map -----
  for l:k in keys(s:fake_map_map)
    if l:k[0] == 'n'
      let [l:mode, l:map_prefix, l:key_prefix] = ['n', '', '']
    elseif l:k[0] == 'i'
      let [l:mode, l:map_prefix, l:key_prefix] = ['i', '<C-O>', '']
    elseif l:k[0] == 'v'
      let [l:mode, l:map_prefix, l:key_prefix] = ['v', '', 'gv']
    elseif l:k[0] == 'o'
      let [l:mode, l:map_prefix, l:key_prefix] = ['o', '', '']
    elseif l:k[0] == 'x'
      let [l:mode, l:map_prefix, l:key_prefix] = ['x', '', '']
    else
      let [l:mode, l:map_prefix, l:key_prefix] = ['n', '', '']
    endif
    let l:m = matchstr(l:k, '<Plu.*$')
    exe printf(
          \ '%snoremap <silent> %s %s:<C-U>call <SID>fake_map(%s, %s, "%s", %s)<CR>',
          \ l:mode, l:m, l:map_prefix, string(l:m), l:mode != 'i', key_prefix,
          \ string(s:fake_map_map[l:k]))
  endfor
endf " }}

" s:functions " {{1
" for command {{2
fu! plugex#add(repo, ...)
  " for Plug command
  if a:0 == 0
    let l:plug = s:new_plug(a:repo, {})
  elseif a:0 == 1
    let l:plug = s:new_plug(a:repo, a:1)
  else
    return s:err('Too many arguments for Plug')
  endif
  call add(s:plugs, l:plug)
endf

fu! plugex#pluginfo(...)
  " for PlugInfo command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
  tabnew
  setl nolist nospell wfh bt=nofile bh=unload fdm=indent
  call setline(1, repeat('-', 40))
  call append(line('$'), repeat(' ', 13).'PlugInfo')
  call append(line('$'), repeat('-', 40))
  for l:p in l:plugs
    call append(line('$'), split(l:p.to_str(), '\n'))
  endfor
endf

fu! plugex#install(...)
  " for PlugExInstall command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugInstall
  for l:p in l:plugs
    call l:p.load_ftdetect()
    call l:p.load()
  endfor
  let &rtp = l:old_rtp
endf

fu! plugex#update(...)
  " for PlugExUpdate command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugUpdate
  " for l:p in l:plugs
  "   call l:p.load_ftdetect()
  "   call l:p.load()
  " endfor
  let &rtp = l:old_rtp
endf

fu! plugex#clean(bang)
  " for PlugExClean
  let l:old_rtp = &rtp
  call s:init_plug(g:plugexs)
  if a:bang
    PlugClean!
  else
    PlugClean
  endif
  let &rtp = l:old_rtp
endf

fu! plugex#status()
  " for PlugExStatus
  let l:old_rtp = &rtp
  call s:init_plug(s:plugs)
  PlugStatus
  let &rtp = l:old_rtp
endf
" 2}}

" complete {{2
fu! s:complete_plugs(a, l, p)
  " complete all plugin names
  let r = []
  for i in s:plugs
    if i.name =~? a:a
      call add(r, i.name)
    endif
  endfor
  return r
endf
" 2}}

" s: {{2
fu! s:update_plug(...)
  " install/update plug.vim
  let l:path = a:0 == 0 ? expand(s:first_rtp.'/autoload') : a:1
  if !isdirectory(l:path)
    call mkdir(l:path, "p")
  endif
  let l:path = expand(l:path.'/plug.vim')
  let l:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if s:is_win
    let l:cmd = '@powershell -NoProfile -Command "((New-Object Net.WebClient)'.
          \ ".DownloadFile('".l:url."', $ExecutionContext.SessionState.Path".
          \ ".GetUnresolvedProviderPathFromPSPath('".l:path.''')))"'
  else
    let l:cmd = 'curl -fLo '.l:path.' --create-dirs '.l:url
  endif
  if filereadable(l:path)
    call delete(l:path)
  endif
  call s:system_at('.', l:cmd)
  if filereadable(l:path)
    exe 'tabnew ' . l:path
    exe "normal! gg/! s:source\<cr>4j0r\":w\<cr>:bd\<cr>"
    return 1
  endif
endf

fu! s:source(dir, ...)
  " source file from dir with patterns
  let found = 0
  for pattern in a:000
    for script in split(globpath(a:dir, pattern))
      execute 'source '. script
      let found = 1
    endfor
  endfor
  return found
endf

fu! s:check_plug()
  if !filereadable(s:plug_path)
    echo 'can not found plug.vim, download now...'
    call s:update_plug()
  endif
endf

fu! s:init_plug(plugs)
  call s:check_plug()
  call plug#begin(s:plug_home)
  for l:p in a:plugs
    call plug#(l:p.original_repo, l:p.plug_config())
  endfor
  call plug#end()
endf

fu! s:system_at(path, cmd) abort
  " cd to path, exe cmd, then cd back
  let l:cd = getcwd()
  exe 'cd ' . a:path
  let l:r =  system(a:cmd)
  exe 'cd ' . a:path
  return r
endf

fu! s:pick_plugs(names)
  " get plug obj list from s:plugs for each plug name in arg
  let l:plugs = []
  for l:p in s:plugs
    if index(a:names, l:p.name) != -1
      call add(l:plugs, l:p)
    endif
  endfor
  return l:plugs
endf

fu! s:err(msg)
  " echo err
  echohl ErrorMsg
  echom '[plugex] ' . a:msg
  echohl None
endf

fu! s:split_rtp()
  " &rtp -> [first, rest]
  let idx = stridx(&rtp, ',')
  return [&rtp[:idx-1], &rtp[idx+1:]]
endf

fu! s:rstrip_slash(str)
  " foo/bar/\//\\ -> /foo/bar
  return substitute(a:str, '[\/\\]\+$', '', '')
endf
fu! s:lstrip_slash(str)
  " /\//\\foo/bar -> foo/bar
  return substitute(a:str, '^[\/\\]\+', '', '')
endf
fu! s:strip_git_url(str)
  " foo/bar[.git][/] -> foo/bar
  return substitute(a:str, '\(.git\)\=[\/]\=$', '', '')
endf
" 2}}
" 1}}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: fmr={{,}} fdm=marker:
