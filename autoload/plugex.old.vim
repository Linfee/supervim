" pluxex: a vim plugin manager
" ============================
" Doc: {{{
" Plugex is a vim plugin manager
" Plugex uses vim-plug to download/update plugins
" Plugex manages runtimepath and plugin loading itself
"
" Version: 0.1.0
" Author:  Linfee
" Email:   linfee@hotmail.com
"
" Plugex_options:
"     name                 Use different name for the plugin
"     path                 Custom directory for the plugin
"     branch/tag/commit    Branch/tag/commit of the repository to use
"
"     enable               Enable or not
"     frozen               Do not update unless explicitly specified
"     rtp                  Subdirectory that contains Vim plugin
"     deps                 Dependent plugins
"     before               Call this functions before load current plugin
"     after                Call this functions after load current plugin
"     do                   Post-update hook (string or funcref)
"
"     for                  On-demand loading: File types
"     on                   On-demand loading: Commands or <Plug>-mappings
"     on_event             On-demand loading: When event occurs
"     on_func              On-demand loading: When functions called
" Global_options:
"     g:plug_home           Specify a directory for plugins
"     g:plug_path           Specify a path for plug.vim
"                           Default as the first runtimepath autoload/plug.vim
"     g:plugex_param_check  Check param for PlugEx or not, default 0
"     all vim-plug options
" Functions:
"     plugex#begin({plug home}): Call this first then use PlugEx to define plugins
"     plugex#end()             : After define all plugins, call this function
" Commands:
"     PlugEx {plug repo}[, {options}]
"     PlugExInstall [name ...]   Install plugins
"     PlugExUpdate [name ...]    Install or update plugins
"     PlugExClean[!]             Remove unused directories (bang version will clean without prompt)
"     PlugExStatus               Check the status of plugins
"     PlugExinfo [name ...]      Check the status of plugins in plugex way
" Eg:
"     call plugex#begin()
"     PlugEx 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
"     PlugEx 'junegunn/goyo.vim', {'before': function('Before'), 'after': 'After', 'on': 'Goyo', 'deps': ['nerdtree']}
"     PlugEx 'junegunn/vim-easy-align'
"     PlugEx 'https://github.com/junegunn/vim-github-dashboard.git'
"     PlugEx 'SirVer/ultisnips' | PlugEx 'honza/vim-snippets'
"     PlugEx 'tpope/vim-fireplace', {'for': 'clojure'}
"     PlugEx 'rdnetto/YCM-Generator', {'branch': 'stable'}
"     PlugEx 'fatih/vim-go', {'tag': '*'}
"     PlugEx 'nsf/gocode', {'tag': 'v.20150303', 'rtp': 'vim'}
"     PlugEx 'junegunn/fzf', {'path': '~/.fzf', 'do': './install --all'}
"
"     PlugEx '~/my-plugin', {'on_event': ['InsertEnter', 'CorsurHold', 'if &ft=="java"']}
"     PlugEx '~/my-plugin2', {'on_event': ['InsertEnter if &ft=="java"',
"                                        \ 'CorsurHold if &ft=="jsp"',
"                                        \ 'if &ft=="java"||&ft=="jsp"']}
"     PlugEx '~/my-plugin3', {'on_func': ['Test', 'Test2']}
"     call plugex#end()
" }}}

if exists('g:loaded_plugex')
  finish
en
let g:loaded_plugex = 1

let s:cpo_save = &cpo
set cpo&vim

" plug {{{
let s:plug_attrs = ['name', 'path', 'branch', 'tag', 'commit']
let s:plug_attrs += ['enable', 'frozen', 'rtp', 'deps']
let s:plug_attrs += ['before', 'after', 'do'] " funcref/function name
let s:plug_attrs += ['for', 'on', 'on_event', 'on_func'] " lazy
let s:REMOTE_TYPE = 1
let s:LOCAL_TYPE = 0
" ['dir', 'type', 'as', 'uri', 'loaded', 'in_rtp']
" ['is_lazy', 'before_loaded', 'after_loaded']

fu! s:new_plug(repo, config) " {{{2
  let l:plug = {}
  " check args {{{3
  if g:plugex_param_check
    for l:attr in ['name', 'path', 'branch', 'tag', 'commit']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) != s:type.string
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string.')
          unlet a:config[l:attr]
        en
      en
    endfor
    for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) == s:type.string || type(a:config[l:attr]) == s:type.list
          if len(a:config[l:attr] == 0)
            unlet a:config[l:attr]
          en
        else
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string or list.')
          unlet a:config[l:attr]
        en
      en
    endfor
    for l:attr in ['before', 'after', 'do']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) != s:type.string &&
              \ type(a:config[l:attr]) != s:type.funcref
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string or funcref.')
          unlet a:config[l:attr]
        en
      en
    endfor
  en " 3}}}

  " string to list
  for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
    if has_key(a:config, l:attr) && type(a:config[l:attr]) == s:type.string
      let a:config[l:attr] = [a:config[l:attr]]
    en
  endfor

  let l:plug.enable = 1

  " apply config
  for k in keys(a:config)
    if index(s:plug_attrs, k) != -1
      let l:plug[k] = a:config[k]
    else
      call s:err('Unsupported attribute: ' . k . ' for repo ' . a:repo)
    en
  endfor

  " make sure the last item of on_event is a condition
  if has_key(l:plug, 'on_event')
    if l:plug.on_event[-1][:2] != 'if '
      call add(l:plug.on_event, 'if 1')
    en
  en

  " set name path, repo uri type dir
  if has_key(l:plug, 'name') | let l:plug.as = l:plug.name | en
  if has_key(l:plug, 'path') | let l:plug.dir = l:plug.path | en
  let l:plug.repo = a:repo
  if !s:set_repo_info(l:plug) | return | en

  " set loaded in_rtp
  let l:plug.loaded = 0
  let l:plug.in_rtp = 0

  " set l:plug.is_lazy
  let l:plug.is_lazy = has_key(l:plug, 'for') || has_key(l:plug, 'on') ||
        \ has_key(l:plug, 'on_event') || has_key(l:plug, 'on_func')

  return l:plug
endf " 2}}}
fu! s:load_plug(plug) " {{{2
  if !a:plug.enable || a:plug.loaded | return | en

  " check and load deps
  if has_key(a:plug, 'deps')
    let l:plugs = s:pick_plugs(a:plug.deps)
    if len(l:plugs) < len(a:plug.deps)
      let l:pns = []
      for l:pn in l:plugs | call add(l:pns, l:pn.name) | endfor
      return s:err('Plugin '.a:plug.name.' depends on '.string(a:plug.deps).
            \ ', but only found '.string(l:pns).'.')
    en
    for l:p in l:plugs
      if !l:p.loaded
        if !s:load_plug(l:p)
          return s:err('When load '.a:plug.name.' , dependency plugin '.l:p.name.' load fail.')
        en
      en
    endfor
  en

  " del on_cmd and on_map
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

  " call before function
  call s:call_before(a:plug)

  call s:add2rtp(a:plug)
  let l:r = s:source(a:plug.path, 'plugin/**/*.vim', 'after/plugin/**/*.vim')

  " for vimscripts in plugin's subdirectory
  if has_key(a:plug, 'rtp')
    for l:rtp in a:plug.rtp
      let l:sub = expand(a:plug.path . '/' . l:rtp)
      let l:r += s:source(l:sub, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
    endfor
  en
  let a:plug.loaded = 1

  " call after function
  call s:call_after(a:plug)
  return l:r
endf " 2}}}
fu! s:load_ftdetect(plug) " {{{2
  if a:plug.enable
    let l:r = s:source(a:plug.path, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
    " for vimscripts in plugin's subdirectory
    if has_key(a:plug, 'rtp')
      for l:rtp in a:plug.rtp
        let l:sub = expand(a:plug.path . '/' . l:rtp)
        let l:r += s:source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
      endfor
    en
    return l:r
  en
endf " 2}}}
fu! s:add2rtp(plug) " {{{2
  if a:plug.in_rtp | return | en
  if isdirectory(a:plug.path)
    let l:rtp = s:split_rtp()
    call insert(l:rtp, a:plug.path, 1)
    let l:after = expand(a:plug.path . '/after')
    if isdirectory(l:after)
      call add(l:rtp, l:after)
    en

    " for vimscripts in plugin's subdirectory
    if has_key(a:plug, 'rtp')
      for l:r in a:plug.rtp
        let l:sub = expand(a:plug.path . '/' . l:r)
        let l:sub_after = expand(l:sub . '/after')
        if isdirectory(l:sub)
          call insert(l:rtp, l:sub, 1)
        en
        if isdirectory(l:sub_after)
          call add(l:rtp, l:sub_after)
        en
      endfor
    en

    let &rtp = join(l:rtp, ',')
    let a:plug.in_rtp = 1
  en
endf " 2}}}
fu! s:set_repo_info(plug) " {{{2
  if a:plug.repo =~ '^[[:alnum:]-]\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$'
    " 1.normal github repo: foo/bar[.git][/]
    let l:repo = s:strip_git_url(a:plug.repo)
    let l:idx = stridx(l:repo, '/')
    let a:plug.uri = 'https://github.com/' . a:plug.repo . '.git'
    let a:plug.type = s:REMOTE_TYPE

    if !has_key(a:plug, 'name') | let a:plug.name = l:repo[l:idx+1:] | en
    if !has_key(a:plug, 'path') | let a:plug.path = expand(s:plug_home . '/' . a:plug.name) | en
  elseif a:plug.repo =~ '^\(\/\|\w:\|file:\)'
    " TODO: recognize ~/foo/bar
    " 2. local file repo: c:/foo/bar  /path/to/repo.git/  file:///path/to/repo.git/  file:///c:/foo/bar
    let l:path = s:strip_git_url(a:plug.repo)
    let l:path = substitute(l:path, '^file://', '', '')
    if l:path[2] == ':' " for some windows path
      let l:path = l:path[1:]
    en
    let a:plug.uri = l:path
    let a:plug.path = expand(l:path)
    let a:plug.type = s:LOCAL_TYPE
    if !has_key(a:plug, 'name') | let a:plug.name = fnamemodify(l:path, ':t') | en

  elseif stridx(a:plug.repo, ':') != -1
    " 3. other git url:
    " use '\w\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$' to get author/project[.git][/]
    let l:repo = s:strip_git_url(matchstr(a:plug.repo, '\w\+\/[[:alnum:].-]\+\(\.git\)\=\(\/\)\=$'))
    let l:idx = stridx(l:repo, '/')
    let a:plug.uri = a:plug.repo
    let a:plug.type = s:REMOTE_TYPE
    if !has_key(a:plug, 'name') | let a:plug.name = l:repo[l:idx+1:] | en
    if !has_key(a:plug, 'path') | let a:plug.path = expand(s:plug_home . '/' . a:plug.name) | en
  el
    return s:err("Could't recognize plugin repo: " . a:plug.repo)
  en
  return 1
endf " 2}}}
fu! s:call_before(plug) " {{{2
  if has_key(a:plug, 'before')
    if type(a:plug.before) == s:type.funcref || exists('*'.a:plug.before)
      call call(a:plug.before, [])
      let a:plug.before_loaded = 1
    el
      call s:err('Specified before function for plugin ['.a:plug.name.'] does not exists')
    en
  en
endf " 2}}}
fu! s:call_after(plug) " {{{2
  if has_key(a:plug, 'after')
    if type(a:plug.after) == s:type.funcref || exists('*'.a:plug.after)
      call call(a:plug.after, [])
      let a:plug.after_loaded = 1
    el
      call s:err('Specified after function for plugin ['.a:plug.name.'] does not exists')
    en
  en
endf " 2}}}
fu! s:plug_to_s(plug) " {{{2
  let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
  let l:b = l:a . '    '
  let l:r = l:a . printf("[ %s ]\n", a:plug.name)
  let l:r .= l:b . printf("name          : %s\n", a:plug.name)
  let l:r .= l:b . printf("path          : %s\n", a:plug.path)
  let l:r .= l:b . printf("branch        : %s\n", has_key(a:plug, 'branch') ? a:plug.branch : 'master')
  let l:r .= l:b . printf("tag           : %s\n", has_key(a:plug, 'tag') ? a:plug.tag : '---')
  let l:r .= l:b . printf("commit        : %s\n", has_key(a:plug, 'commit') ? a:plug.commit : '---')
  let l:r .= l:b . printf("repo          : %s\n", a:plug.repo)
  let l:r .= l:b . printf("uri           : %s\n", a:plug.uri)
  let l:r .= l:b . printf("type          : %s\n", a:plug.type == s:REMOTE_TYPE ? 'remote' : 'local')
  let l:r .= l:b . printf("loaded        : %s\n", a:plug.loaded)
  let l:r .= l:b . printf("in_rtp        : %s\n", a:plug.in_rtp)
  let l:r .= l:b . printf("enable        : %s\n", a:plug.enable)
  let l:r .= l:b . printf("frozen        : %s\n", has_key(a:plug, 'frozen') ? a:plug.frozen : 0)
  let l:r .= l:b . printf("rtp           : %s\n", has_key(a:plug, 'rtp') ? string(a:plug.rtp) : '---')
  let l:r .= l:b . printf("dep           : %s\n", has_key(a:plug, 'dep') ? string(a:plug.dep) : '---')
  let l:r .= l:b . printf("before        : %s\n", has_key(a:plug, 'before') ? string(a:plug.before) . (has_key(a:plug, 'before_loaded')? ', loaded': ', not loaded') : '---')
  let l:r .= l:b . printf("after         : %s\n", has_key(a:plug, 'after') ? string(a:plug.after) . (has_key(a:plug, 'after_loaded')? ', loaded': ', not loaded') : '---')
  let l:r .= l:b . printf("do            : %s\n", has_key(a:plug, 'do') ? a:plug.do : '---')
  let l:r .= l:b . printf("[lazy-load]   : %s\n", has_key(a:plug, 'is_lazy') ? a:plug.is_lazy : 0)
  let l:r .= l:b . printf("  |- for      : %s\n", has_key(a:plug, 'for') ? string(a:plug.for) : '---')
  let l:r .= l:b . printf("  |- on       : %s\n", has_key(a:plug, 'on') ? string(a:plug.on) : '---')
  let l:r .= l:b . printf("  |- on_event : %s\n", has_key(a:plug, 'on_event') ? string(a:plug.on_event) : '---')
  let l:r .= l:b . printf("  |- on_func  : %s\n", has_key(a:plug, 'on_func') ? string(a:plug.on_func) : '---')
  return l:r
endf " 2}}}
fu! s:plug_config(plug) " {{{2
  let l:r = {}
  for l:attr in ['branch', 'tag', 'commmit', 'do', 'frozen', 'as', 'dir']
    if has_key(a:plug, l:attr)
      let l:r[l:attr] = a:plug[l:attr]
    en
  endfor
  return l:r
endf " 2}}}
" }}}

fu! plugex#begin(...) " {{{
  if !executable('git')
    return s:err('Please make sure git int your path, plugex depends on that.')
  en
  let s:plug_path = exists('g:plug_path') ? g:plug_path :
        \ expand(s:rstrip_slash(s:split_rtp()[0]).'/autoload/plug.vim')

  let s:type = {}
  let s:type.string = type('')
  let s:type.number = type(1)
  let s:type.list = type([])
  let s:type.dict = type({})
  let s:type.funcref = type(function('call'))
  let s:type.boolean =  type(v:true)

  if a:0 > 0
    let l:plug_home = s:rstrip_slash(expand(a:1))
  elseif exists('g:plug_home')
    let l:plug_home = s:rstrip_slash(expand(g:plug_home))
  elseif !empty(&rtp)
    let l:plug_home = expand(s:rstrip_slash(split(&rtp, ',')[0]) . '/plugs')
  el
    retu s:err('Unable to determine plugex home. Try calling plugex#begin() with a path argument.')
  en

  " init vars
  let s:plug_home = l:plug_home   " where to store plugins
  let s:plugs = []
  let s:first_rtp = s:rstrip_slash(s:split_rtp()[0])
  let s:is_win = has('win32') || has('win64')
  let g:plugex_param_check = get(g:, 'plugex_param_check', 0)

  " def cmds
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

  return 1
endf " }}}

fu! plugex#end() " {{{
  if !exists('s:plugs')
    return s:err('Call plugex#begin() first')
  endif
  filetype off
  augroup PlugEx
    autocmd!
    for l:i in range(len(s:plugs))
      let l:plug = s:plugs[l:i]
      if !l:plug.enable | continue | en
      if l:plug.is_lazy
        call s:setup_lazy_load(l:i, l:plug)
        " call add(s:plugs, l:plug)
        exe 'au VimEnter * if !s:plugs['.l:i.'].in_rtp | call s:add2rtp(s:plugs['.l:i.']) | en'
        call s:load_ftdetect(l:plug)
      else
        call s:call_before(l:plug)
        call s:add2rtp(l:plug)
        exe 'au VimEnter * if !has_key(s:plugs['.l:i.'], "after_loaded") | '.
              \ 'call s:call_after(s:plugs['.l:i.']) | '.
              \ 'let s:plugs['.l:i.'].loaded = 1 | '.
              \ 'en'
      endif
    endfor
  augroup END
  filetype plugin indent on
  syntax enable
  let g:plugexs = s:plugs
endf " }}}

fu! s:setup_lazy_load(idx, plug) " {{{
  " for
  if has_key(a:plug, 'for')
    let l:ft = join(s:plugs[a:idx].for, ',')
    exe 'au FileType '.l:ft.' call s:load_plug(s:plugs['.a:idx.'])'
  en
  " on
  if has_key(a:plug, 'on')
    for l:on in a:plug.on
      if l:on =~? '<plu.*$' " on_map
        if l:on[0] == 'n'
          let [l:mode, l:map_prefix, l:key_prefix] = ['n', '', '']
        elseif l:on[0] == 'i'
          let [l:mode, l:map_prefix, l:key_prefix] = ['i', '<C-O>', '']
        elseif l:on[0] == 'v'
          let [l:mode, l:map_prefix, l:key_prefix] = ['v', '', 'gv']
        elseif l:on[0] == 'o'
          let [l:mode, l:map_prefix, l:key_prefix] = ['o', '', '']
        elseif l:on[0] == 'x'
          let [l:mode, l:map_prefix, l:key_prefix] = ['x', '', '']
        else
          let [l:mode, l:map_prefix, l:key_prefix] = ['n', '', '']
        endif
        let l:m = matchstr(l:on, '<Plu.*$')
        exe printf(
              \ '%snoremap <silent> %s %s:<C-U>call <SID>fake_map(%s, %s, "%s", %s)<CR>',
              \ l:mode, l:m, l:map_prefix, string(l:m), l:mode != 'i', l:key_prefix,
              \ string(a:plug))
      el " on_cmd
        exe "com! -nargs=* -range -bang -complete=file " .
              \ l:on . ' call s:fake_cmd(' .
              \ "'" . l:on . "'" .
              \ ', "<bang>", <line1>, <line2>, <q-args>,'.
              \ string(a:plug)
              \ ')'
      en
    endfor
  en
  " on_event
  if has_key(a:plug, 'on_event')
    for l:e in a:plug.on_event[:-2]
      let l:ec = split(l:e . ' if 1', ' if ')
      let l:event = l:ec[0]
      let l:condition = '('.a:plug.on_event[-1][3:].') && ('.l:ec[1].')'
      exe 'au '.l:event.' *  if '.l:condition.' | call s:load_plug(s:plugs['.a:idx.']) | en'
    endfor
  en
  " on_func
  if has_key(a:plug, 'on_func')
    let l:func_pat = join(s:plugs[a:idx].on_func, ',')
    exe 'au FuncUndefined '.l:func_pat.' call s:load_plug(s:plugs['.a:idx.'])'
  en
endf " }}}

" functions for command {{{
fu! plugex#add(repo, ...) " {{{2
  " for Plug command
  if a:0 == 0
    let l:plug = s:new_plug(a:repo, {})
  elseif a:0 == 1
    let l:plug = s:new_plug(a:repo, a:1)
  el
    return s:err('Too many arguments for Plug')
  en
  call add(s:plugs, l:plug)
endf " 2}}}
fu! plugex#pluginfo(...) " {{{2
  " for PlugInfo command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
  tabnew
  setl nolist nospell wfh bt=nofile bh=unload fdm=indent
  call setline(1, repeat('-', 40))
  call append(line('$'), repeat(' ', 13).'PlugInfo')
  call append(line('$'), repeat('-', 40))
  for l:p in l:plugs
    call append(line('$'), split(s:plug_to_s(l:p), '\n'))
  endfor
endf " 2}}}
fu! plugex#install(...) " {{{2
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  en
  " for PlugExInstall command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
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
    call s:load_ftdetect(l:p)
    call s:load_plug(l:p)
  endfor
endf " 2}}}
fu! plugex#update(...) " {{{2
  " for PlugExUpdate command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  en
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
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
endf " 2}}}
fu! plugex#clean(bang) " {{{2
  " for PlugExClean
  let l:old_rtp = &rtp
  call s:init_plug(g:plugexs)
  if a:bang
    PlugClean!
  el
    PlugClean
  en
  let &rtp = l:old_rtp
endf " 2}}}
fu! plugex#status() " {{{2
  " for PlugExStatus
  let l:old_rtp = &rtp
  call s:init_plug(s:plugs)
  PlugStatus
  let &rtp = l:old_rtp
endf " 2}}}
" complete
fu! s:complete_plugs(a, l, p) " {{{2
  " complete all plugin names
  let r = []
  for i in s:plugs
    if i.name =~? a:a
      call add(r, i.name)
    en
  endfor
  return r
endf " 2}}}
" }}}

" private functions {{{
fu! s:fake_cmd(cmd, bang, l1, l2, args, plug) " {{{2
  if !s:load_plug(a:plug) | return | en
  " endfor
  exe printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endf " 2}}
fu! s:fake_map(the_map, with_prefix, prefix, plug) " {{{2
  " https://github.com/junegunn/vim-plug/blob/master/plug.vim
  if !s:load_plug(a:plug) | return | en
  let extra = ''
  while 1
    let c = getchar(0)
    if c == 0
      break
    en
    let extra .= nr2char(c)
  endwhile

  if a:with_prefix
    let prefix = v:count ? v:count : ''
    let prefix .= '"'.v:register.a:prefix
    if mode(1) == 'no'
      if v:operator == 'c'
        let prefix = "\<esc>" . prefix
      en
      let prefix .= v:operator
    en
    call feedkeys(prefix, 'n')
  en
  call feedkeys(substitute(a:the_map, '^<Plug>', "\<Plug>", '') . extra)
endf " 2}}}
fu! s:update_plug(...) " {{{2
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
    exe "normal! gg/! s:source\<cr>4j0r\":w\<cr>:bd\<cr>"
    return 1
  en
endf " 2}}}
fu! s:source(dir, ...) " {{{2
  " source file from dir with patterns
  let found = 0
  for pattern in a:000
    for script in split(globpath(a:dir, pattern))
      execute 'source '. script
      let found = 1
    endfor
  endfor
  return found
endf " 2}}}
fu! s:check_plug() " {{{2
  if !filereadable(s:plug_path)
    echo 'can not found plug.vim, download now...'
    call s:update_plug()
  en
endf " 2}}}
fu! s:init_plug(plugs) " {{{2
  call s:check_plug()
  call plug#begin(s:plug_home)
  for l:p in a:plugs
    call plug#(l:p.repo, s:plug_config(l:p))
  endfor
  call plug#end()
endf " 2}}}
fu! s:system_at(path, cmd) abort " {{{2
  " cd to path, exe cmd, then cd back
  let l:cd = getcwd()
  exe 'cd ' . a:path
  let l:r =  system(a:cmd)
  exe 'cd ' . a:path
  return r
endf " 2}}}
fu! s:pick_plugs(names) " {{{2
  " get plug obj list from s:plugs for each plug name in arg
  let l:plugs = []
  for l:p in s:plugs
    if index(a:names, l:p.name) != -1
      call add(l:plugs, l:p)
    en
  endfor
  return l:plugs
endf " 2}}}
fu! s:err(msg) " {{{2
  " echo err
  echohl ErrorMsg
  echom '[plugex] ' . a:msg
  echohl None
endf " 2}}}
fu! s:split_rtp() " {{{2
  " &rtp -> [first, rest]
  let idx = stridx(&rtp, ',')
  return [&rtp[:idx-1], &rtp[idx+1:]]
endf " 2}}}
fu! s:rstrip_slash(str) " {{{2
  " foo/bar/\//\\ -> /foo/bar
  return substitute(a:str, '[\/\\]\+$', '', '')
endf " 2}}}
fu! s:lstrip_slash(str) " {{{2
  " /\//\\foo/bar -> foo/bar
  return substitute(a:str, '^[\/\\]\+', '', '')
endf " 2}}}
fu! s:strip_git_url(str) " {{{2
  " foo/bar[.git][/] -> foo/bar
  return substitute(a:str, '\(.git\)\=[\/]\=$', '', '')
endf " 2}}}
" }}}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: fmr={{{,}}} fdm=marker:
