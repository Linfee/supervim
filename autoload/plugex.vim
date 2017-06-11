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
"     lazy                 On-demand loading: When group loading or other plugin loading.
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
"     PlugExGroup {repo1}, {config1}, {repo2}, {config2}..., {group config}
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
"
"     PlugExGroup 'groupName',
"           \ ['strom3xFeI/vimdoc-cn', {'lazy': 1, 'after': 'After2', 'before': 'Before2'}],
"           \ ['mhinz/vim-sayonara', {'on': 'Sayonara'}],
"           \ ['scrooloose/nerdtree', {'on': 'NERDTreeToggle'}],
"           \ {'on_event': 'InsertEnter', 'after': 'After1', 'before': 'Before1'}
"
"     call plugex#end()
" }}}

if exists('g:loaded_plugex')
  finish
en
let g:loaded_plugex = 1

let s:cpo_save = &cpo
set cpo&vim

let s:type = {
      \ 'string' : type(''),
      \ 'number' : type(1),
      \ 'list'   : type([]),
      \ 'dict'   : type({}),
      \ 'funcref': type(function('call')),
      \ }

" functions for user
fu! plugex#begin(...) " {{{
  if !executable('git')
    return s:err('Please make sure git int your path, plugex depends on that.')
  en
  let s:plug_path = exists('g:plug_path') ? g:plug_path :
        \ expand(s:rstrip_slash(s:split_rtp()[0]).'/autoload/plug.vim')

  " Set s:plug_home
  if a:0 > 0
    let s:plug_home = s:rstrip_slash(expand(a:1))
  elseif exists('g:plug_home')
    let s:plug_home = s:rstrip_slash(expand(g:plug_home))
  elseif !empty(&rtp)
    let s:plug_home = expand(s:rstrip_slash(split(&rtp, ',')[0]) . '/.repo')
  el
    retu s:err('Unable to determine plugex home. Try calling plugex#begin() with a path argument.')
  en
  let s:plugs = {}
  let s:plugs_order = []
  let s:vimenter_plugs = [] " load after VimEnter
  let s:vimenter_queue = [] " do something for lazy or non lazy plugin on VimEnter
  let s:first_rtp = s:rstrip_slash(s:split_rtp()[0])
  let s:is_win = has('win32') || has('win64')
  let g:plugex_param_check = get(g:, 'plugex_param_check', 0)
  let g:plugs_log = []

  " Vars for plug obj
  " properties
  let s:plug_attrs = ['name', 'path', 'branch', 'tag', 'commit']
  let s:plug_attrs += ['enable', 'frozen', 'rtp', 'deps']
  let s:plug_attrs += ['before', 'after', 'do'] " funcref/function name
  let s:plug_attrs += ['for', 'on', 'on_event', 'on_func', 'lazy'] " lazy
  let s:plug_attrs += ['plugs']
  " other properties
  " dir, type, as, uri, loaded, in_rtp
  " is_lazy, before_loaded, after_loaded
  " sourced
  let s:plug_local_type = 'local'
  let s:plug_remote_type = 'remote'
  let s:plug_group_type = 'plug group'

  " Def cmds
  com! -nargs=+ -bar
        \ PlugEx        call plugex#add(<args>)
  com! -nargs=+
        \ PlugExGroup   call plugex#add_group(<args>)
  com! -nargs=* -complete=customlist,plug_util#complete_plugs
        \ PlugExInstall call plug_util#install(<f-args>)
  com! -nargs=* -complete=customlist,plug_util#complete_plugs
        \ PlugExUpdate  call plug_util#update(<f-args>)
  com! -nargs=0 -bang
        \ PlugExClean   call plug_util#clean('<bang>'=='!')
  com! -nargs=0
        \ PlugExStatus  call plug_util#status()
  com! -nargs=* -complete=customlist,plug_util#complete_plugs
        \ PlugExInfo    call plug_util#pluginfo(<f-args>)
endf " }}}
fu! plugex#end() " {{{
  if !exists('s:plugs') | return s:err('Call plugex#begin() first') | en
  call s:log('')
  call s:log('[ >>>>> plugex#end >>>>> ]')
  filetype off
  aug PlugEx
    au!
    for l:name in s:plugs_order
      let l:plug = s:plugs[l:name]
      call s:handle_plug(l:plug)
      if has_key(l:plug, 'plugs')
        for l:p in l:plug.plugs
          call s:handle_plug(l:p)
        endfor
      en
    endfor
  aug END
  filetype plugin indent on
  syntax enable
  " on vimenter
  aug PLugExVimEnter
    au!
    au VimEnter * call s:log("") |
          \ call s:log("[ >>>>> handle VimEnter >>>>> ]") |
          \ call s:handle_vimenter() |
          \ call s:log('') |
          \ call s:log("[ >>>>> Load plugins with  {'on_event': 'VimEnter'} >>>>> ]") |
          \ call timer_start(10, function('s:load_vimenter_plugs'))
  aug END
  let g:plugexs = s:plugs
endf " }}}

" functions for plugex#end()
fu! s:handle_plug(plug) " {{{
  let l:name = a:plug.name
  if !a:plug.enable | return | en
  if a:plug.is_lazy
    call s:setup_lazy_load(name, a:plug)
    call plugex#load_ftdetect(a:plug)
  else
    if plugex#call_before(a:plug)
      call s:log('[ call_before ]', '[ non lazy ]', a:plug.name)
    en
    if plugex#add2rtp(a:plug)
      call s:log('[ add2rtp ]', '[ non lazy ]', a:plug.name)
    en
  en
endf " }}}
fu! s:setup_lazy_load(name, plug) " {{{
  " for
  if has_key(a:plug, 'for')
    let l:ft = join(s:plugs[a:name].for, ',')
    exe 'au FileType '.l:ft.' call plug_util#load(s:plugs["'.a:name.'"])'
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
              \ string(a:plug.name))
      el " on_cmd
        exe "com! -nargs=* -range -bang -complete=file " .
              \ l:on . ' call s:fake_cmd(' .
              \ "'" . l:on . "'" .
              \ ', "<bang>", <line1>, <line2>, <q-args>,'.
              \ string(a:plug.name)
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
      if l:event == 'VimEnter'
        call add(s:vimenter_plugs, [l:condition, a:plug])
      else
        exe 'au '.l:event.' *  if '.l:condition.' | call plug_util#load(s:plugs["'.a:name.'"]) | en'
      en
    endfor
  en
  " on_func
  if has_key(a:plug, 'on_func')
    let l:func_pat = join(s:plugs[a:name].on_func, ',')
    exe 'au FuncUndefined '.l:func_pat.' call plug_util#load(s:plugs["'.a:name.'"])'
  en
endf " }}}
fu! s:handle_vimenter() " {{{
  for l:name in s:plugs_order
    let l:plug = s:plugs[l:name]
    if !l:plug.enable | continue | en
    if l:plug.is_lazy
      " add2rtp for lazy
      if plugex#add2rtp(l:plug)
        call s:log('[ add2rtp ]', '[ lazy ]', l:plug.name)
      en
      if s:is_group(l:plug)
        for l:p in l:plug.plugs
          if !l:p.enable | continue | en
          call s:log('[ add2rtp ]', '[ lazy ]', l:p.name)
        endfor
      en
    else
      let l:plug.sourced = 1
      if s:is_group(l:plug)
        " for non lazy group: load plugs and call after
        call plug_util#load(l:plug)
      else
        " for non lazy plug: set loaded, log, call after
        let l:plug.loaded = 1
        call s:log('[ loaded ]', '[ non lazy ]', '[ plug ]', l:plug.name)
        if plugex#call_after(a:plug)
          call s:log('[ call_after ]', '[ non lazy ]', l:plug.name)
        en
      en
    en
  endfor
endf " }}}
fu! s:load_vimenter_plugs(tid) " {{{
  " load 10 plugin each time
  for i in range(len(s:vimenter_plugs) > 5 ? 5 : len(s:vimenter_plugs))
    let l:p = remove(s:vimenter_plugs, 0)
    if eval(l:p[0])
      call plug_util#load(l:p[1])
    en
  endfor
  if len(s:vimenter_plugs) > 0
    call timer_start(10, function('s:load_vimenter_plugs'))
  else
    aug PLugExVimEnter | 
      au!
    aug END
    aug! PLugExVimEnter
    do BufWinEnter
    do BufEnter
    do VimEnter
    call s:log('')
    call s:log("[ >>>>> vim runtime >>>>> ]")
    echohl String | echom 'init finish' | echohl None
  en
endf " }}}
" functions for s:setup_lazy_load
fu! s:fake_cmd(cmd, bang, l1, l2, args, name) " {{{
  if !plug_util#load(s:plugs[a:name]) | return | en
  exe printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endf " }}}
fu! s:fake_map(the_map, with_prefix, prefix, name) " {{{
  " https://github.com/junegunn/vim-plug/blob/master/plug.vim
  if !plug_util#load(s:plugs[a:name]) | return | en
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
endf " }}}
"
" functions for s:handle_plug for plugex#end
fu! plugex#call_before(plug) " for plug obj {{{
  " call plug's before
  if has_key(a:plug, 'before')
    if type(a:plug.before) == s:type.funcref || exists('*'.a:plug.before) || a:plug.before =~ '#'
      call call(a:plug.before, [])
      return 1
    else
      return s:err('Specified after function for plugin ['.a:plug.name.'] does not exists')
    en
  en
endf " }}}
fu! plugex#call_after(plug) " for plug obj {{{
  " call plug's after
  if has_key(a:plug, 'after')
    if type(a:plug.after) == s:type.funcref || exists('*'.a:plug.after) || a:plug.after =~ '#'
      call call(a:plug.after, [])
      return 1
    else
      return s:err('Specified after function for plugin ['.a:plug.name.'] does not exists')
    en
  en
endf " }}}
fu! plugex#add2rtp(plug) " for plug obj {{{
  if has_key(a:plug, 'plugs') | return | en
  if a:plug.in_rtp | return | en
  if !isdirectory(a:plug.path) | return | en
  let l:rtp = s:split_rtp()
  call insert(l:rtp, a:plug.path, 1)
  let l:after = expand(a:plug.path.'/after')
  if isdirectory(l:after) | call add(l:rtp, l:after) | en
  " for vimscripts in plugin's subdir
  if has_key(a:plug, 'rtp')
    for l:r in a:plug.rtp
      let l:sub = expand(a:plug.path . '/' . l:r)
      let l:sub_after = expand(l:sub . '/after')
      if isdirectory(l:sub) | call insert(l:rtp, l:sub, 1) | en
      if isdirectory(l:sub_after) | call add(l:rtp, l:sub_after) | en
    endfor
  en
  let &rtp = join(l:rtp, ',')
  let a:plug.in_rtp = 1
  return 1
endf " }}}
fu! plugex#load_ftdetect(plug) " for plug obj {{{
  if has_key(a:plug, 'plugs') | return | en
  if a:plug.enable
    let l:r = plugex#source(a:plug.path, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
    " for vimscripts in plugin's subdirectory
    if has_key(a:plug, 'rtp')
      for l:rtp in a:plug.rtp
        let l:sub = expand(a:plug.path . '/' . l:rtp)
        let l:r += plugex#source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
      endfor
    en
    call s:log('[ load_ftdetect ]', a:plug.name, l:r)
    return l:r
  en
endf " }}}

" functions for s:new_plug
fu! s:new_plug(repo, config) " for plug obj {{{
  if g:plugex_param_check | call s:check_param(a:repo, a:config) | en

  if has_key(a:config, 'dir') | unlet a:config.dir | en
  if has_key(a:config, 'as') | unlet a:config.as | en
  if has_key(a:config, 'uri') | unlet a:config.uri | en
  if has_key(a:config, 'before_loaded') | unlet a:config.before_loaded | en
  if has_key(a:config, 'after_loade') | unlet a:config.after_loaded | en

  " dir, type, as, uri, loaded, in_rtp
  " is_lazy, before_loaded, after_loaded
  " string to list
  for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
    if has_key(a:config, l:attr) && type(a:config[l:attr]) == s:type.string
      let a:config[l:attr] = [a:config[l:attr]]
    en
  endfor

  let a:config.enable = get(a:config, 'enable', 1)
  if !has_key(a:config, 'plugs')
    let a:config.repo = s:trim_repo(a:repo)
  endif
  " make sure the last item of on_event is a condition
  if has_key(a:config, 'on_event')
    if a:config.on_event[-1][:2] != 'if '
      call add(a:config.on_event, 'if 1')
    en
  en

  " set name, path, uri, type, dir
  if has_key(a:config, 'plugs')
    " for plugin group
    let a:config.type = s:plug_group_type
    let a:config.repo = a:config.name
    for i in range(len(a:config.plugs))
      let l:p = call(function('s:new_plug'), a:config.plugs[i])
      let a:config.plugs[i] = l:p
      let s:plugs[l:p.name] = l:p
    endfor
  else
    " for normal plugin
    if has_key(a:config, 'name') | let a:config.as = a:config.name | en
    if has_key(a:config, 'path') | let a:config.dir = a:config.path | en
    let a:config.repo = a:repo
    if !s:set_plug_repo_info(a:config) | return | en
  en

  " set loaded
  let a:config.loaded = 0
  let a:config.in_rtp = 0

  " set a:config.is_lazy
  let a:config.is_lazy = has_key(a:config, 'for') || has_key(a:config, 'on') ||
        \ has_key(a:config, 'on_event') || has_key(a:config, 'on_func') ||
        \ (has_key(a:config, 'lazy') && a:config.lazy == 1)

  call s:log('[ new plug ]', a:config.name, string(a:config))
  return a:config
endf " }}}
fu! s:set_plug_repo_info(plug) " for plug obj {{{
  let a:plug.repo = s:trim_repo(a:plug.repo)
  if a:plug.repo =~ '^\(\w:\|\~\)\?[\\\/]' " local repo
    if !has_key(a:plug, 'name') | let a:plug.name = fnamemodify(a:plug.repo, ':t:s?\.git$??') | en
    let a:plug.type = s:plug_local_type
    let a:plug.path = expand(substitute(a:plug.repo, '^file://', '', ''))
    if a:plug.path[2] == ':'
      let a:plug.path = a:plug.path[1:]
    en
    let a:plug.uri = a:plug.path
  else " remote repo
    if a:plug.repo !~ '/'
      return s:err(printf('Invalid argument: %s (implicit `vim-scripts'' expansion is deprecated)', a:plug.repo))
    en
    let a:plug.type = s:plug_remote_type
    let a:plug.uri = stridx(a:plug.repo, '/') == strridx(a:plug.repo, '/') ?
          \ 'https://github.com/' . a:plug.repo . '.git' :
          \ a:plug.repo
    if !has_key(a:plug, 'name') | let a:plug.name = fnamemodify(a:plug.repo, ':t:s?\.git$??') | en
    if !has_key(a:plug, 'path')
      let a:plug.path = expand(s:plug_home.'/'.a:plug.name)
    else
      let a:plug.path = expand(a:plug.path)
    en
  en
  return 1
endf " }}}
fu! s:check_param(repo, config) " for plug obj {{{
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
  en
endf " }}}

" functions for command
fu! plugex#add(repo, ...) " {{{
  " for PlugEx command
  if a:0 == 0
    let l:plug = s:new_plug(a:repo, {})
  elseif a:0 == 1
    let l:plug = s:new_plug(a:repo, a:1)
  el
    return s:err('Too many arguments for Plug')
  en
  let l:name = l:plug.name
  let s:plugs[l:name] = l:plug
  call add(s:plugs_order, l:name)
endf " }}}
fu! plugex#add_group(name, ...) " {{{
  " for PlugExGroup command
  if a:0 == 0 | return s:err('['.a:name.'] A plug group shoud have one plugin at least.') | en
  if type(a:000[-1]) == s:type.dict
    let l:plugs = a:000[0:-2]
    let l:config = a:000[-1]
  else
    let l:plugs = a:000
    let l:config = {}
  en
  if len(l:plugs) == 0 | return s:err('['.a:name.'] A plug group shoud have one plugin at least.') | en
  for i in range(len(l:plugs))
    let l:p = l:plugs[i]
    if type(l:p) == s:type.string
      let l:plugs[i] = [l:p, {'lazy': 1}]
    elseif type(l:p) == s:type.list
      if len(l:p) == 1
        let l:plugs[i] = [l:p[0], {'lazy': 1}]
      elseif len(l:p) == 2
        let l:plugs[i][1].lazy = get(l:plugs[i][1], 'lazy', 1)
      else
        return s:err('['.a:name.'] Format error: PlugExGroup '.a:name.', '.string(a:000)[1:-2])
      en
    else
      return s:err('['.a:name.'] Plugin in plug group must be a list or string')
    en
  endfor
  let l:config.plugs = l:plugs
  let l:config.name = a:name

  call plugex#add(a:name, l:config)
endf " }}}

" other functions
fu! s:err(msg) " {{{
  " echo err
  echohl ErrorMsg
  echom '[plugex] ' . a:msg
  echohl None
endf " }}}
fu! s:split_rtp() " {{{
  " &rtp -> [first, rest]
  let idx = stridx(&rtp, ',')
  return [&rtp[:idx-1], &rtp[idx+1:]]
endf " }}}
fu! s:rstrip_slash(str) " {{{
  " foo/bar/\//\\ -> /foo/bar
  return substitute(a:str, '[\/\\]\+$', '', '')
endf " }}}
fu! s:lstrip_slash(str) " unused {{{
  " /\//\\foo/bar -> foo/bar
  return substitute(a:str, '^[\/\\]\+', '', '')
endf " }}}
fu! s:trim_repo(str) " {{{
  " foo/bar[.git][/] -> foo/bar
  return substitute(a:str, '\(.git\)\=[\/]\=$', '', '')
endf " }}}
fu! s:is_group(plug) " {{{
  return has_key(a:plug, 'plugs')
endf " }}}
fu! s:log(...) " {{{
  if get(g:, 'plugex_log', 0)
    cal add(g:plugs_log, join(a:000, ' '))
  en
endf
com! -nargs=0 PlugExLog tabnew |
      \ setl bt=nofile bh=unload nowrap |
      \ call setline(1, '[ PlugExLog ]') |
      \ for l in g:plugs_log |
      \ call append(line('$'), '  '.l) |
      \ endfor
" }}}

" api
fu! plugex#vars() " {{{
  return [s:plug_home, s:plug_path, s:plugs, s:plugs_order]
endf " }}}
fu! plugex#source(dir, ...) " {{{
  " source file from dir with patterns
  let found = 0
  for pattern in a:000
    for script in split(globpath(a:dir, pattern))
      execute 'source '. script
      let found = 1
    endfor
  endfor
  return found
endf " }}}
fu! plugex#is_loaded(...) " {{{
  for l:n in a:000
    if !has_key(s:plugs) || !s:plugs[l:n].loaded
      return 0
    en
  endfor
  return 1
endf " }}}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: fmr={{{,}}} fdm=marker:
