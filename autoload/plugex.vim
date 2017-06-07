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

fu! plugex#begin(...) " {{{
  if !executable('git')
    return s:err('Please make sure git int your path, plugex depends on that.')
  en
  let s:plug_path = exists('g:plug_path') ? g:plug_path :
        \ expand(s:rstrip_slash(s:split_rtp()[0]).'/autoload/plug.vim')

  " s:plug_home
  if a:0 > 0
    let s:plug_home = s:rstrip_slash(expand(a:1))
  elseif exists('g:plug_home')
    let s:plug_home = s:rstrip_slash(expand(g:plug_home))
  elseif !empty(&rtp)
    let s:plug_home = expand(s:rstrip_slash(split(&rtp, ',')[0]) . '/plugs')
  el
    retu s:err('Unable to determine plugex home. Try calling plugex#begin() with a path argument.')
  en
  let s:plugs = {}
  let s:plugs_order = []
  let s:first_rtp = s:rstrip_slash(s:split_rtp()[0])
  let s:is_win = has('win32') || has('win64')
  let g:plugex_param_check = get(g:, 'plugex_param_check', 0)


  call s:def_cmd()
  call s:def_class()
endf " }}}

fu! plugex#end() " {{{
  let g:ap = s:plugs
  let g:apo = s:plugs_order

  " if !exists('s:plugs') | return s:err('Call plugex#begin() first') | en
  "
  " " del autocmd and autogroup
  " if exists('#PlugLOD') | aug PlugLOD | au! | aug END | aug! PlugLOD | en
  "
  " for name in s:plugs_order
  "   if !has_key(s:plugs, name) | continue | en
  " endfor
  "
  " let plug = s:plugs[name]
endf " }}}

fu! s:def_cmd() " {{{
  com! -nargs=+ -bar                                  PlugEx
        \ call plugex#add(<args>)
  com! -nargs=+ -bar                                  PlugExGroup
        \ call plugex#add_group(<args>)
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
endf " }}}

fu! s:def_class() " {{{
  let s:plug = {}
  let s:plug_attrs = ['name', 'path', 'branch', 'tag', 'commit']
  let s:plug_attrs += ['enable', 'frozen', 'rtp', 'deps']
  let s:plug_attrs += ['before', 'after', 'do'] " funcref/function name
  let s:plug_attrs += ['for', 'on', 'on_event', 'on_func'] " lazy
  let s:plug.remote_type = 1
  let s:plug.local_type = 0

  " other properties
  " dir, type, as, uri, loaded, in_rtp
  " is_lazy, before_loaded, after_loaded
  fu! s:plug.new(repo, config) " {{{2
    let l:plug = copy(s:plug)
    " check param
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

    " string to list
    for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
      if has_key(a:config, l:attr)
        let a:config[l:attr] = s:to_list(a:config[l:attr]) 
      en
    endfor

    let l:plug.enable = 1

    " apply config
    let l:plug.repo = s:trim_repo(a:repo)
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
    if !l:plug.set_repo_info() | return | en

    " set loaded in_rtp
    let l:plug.loaded = 0
    let l:plug.in_rtp = 0

    " set l:plug.is_lazy
    let l:plug.is_lazy = has_key(l:plug, 'for') || has_key(l:plug, 'on') ||
          \ has_key(l:plug, 'on_event') || has_key(l:plug, 'on_func')

    return l:plug
  endf " 2}}}
  fu! s:plug.load() dict " {{{2
    if !self.enable || self.loaded | return | en
    " deps
    if self.has('deps')
      for name in self.deps
        if has_key(s:plugs, name)
          let plug = s:plugs[name]
          if !plug.load()
            return s:err('When load ['.self.name.'], dependency plugin '.plug.name.' load fail.')
          en
        else
          return s:err('When load ['.self.name.'], can not found dependency plugin '.plug.name.'.')
        end
      endfor
    en

    " on
    if self.has('on')
      for l:on in self.on
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
    call self.call_before()
    call self.call_add2rtp()
    let l:r = s:source(self.path, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
    if self.has('rtp')
      for l:rtp in self.rtp
        let l:sub = expand(self.path . '/' . l:rtp)
        let l:r += s:source(l:sub, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
      endfor
    en
    let self..loaded = 1
    call self.after()
    return l:r
  endf " 2}}}
  fu! s:plug.load_ftdetect() dict " {{{2
    if self.enable
      let l:r = s:source(self.path, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
      " for vimscripts in plugin's subdirectory
      if has_key(self, 'rtp')
        for l:rtp in self.rtp
          let l:sub = expand(self.path . '/' . l:rtp)
          let l:r += s:source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
        endfor
      en
      return l:r
    en
  endf " 2}}}
  fu! s:plug.add2rtp() dict " {{{2
    if self.in_rtp | return | en
    if !isdirectory(self.path) | return | en
    let l:rtp = s:split_rtp()
    call insert(l:rtp, self.path, 1)
    let l:after = expand(self.path.'/after')
    if isdirectory(l:after) | call add(l:rtp, l:after) | en
    " for vimscripts in plugin's subdir
    if self.has('rtp')
      for l:r in self.rtp
        let l:sub = expand(self.path . '/' . l:r)
        let l:sub_after = expand(l:sub . '/after')
        if isdirectory(l:sub) | call insert(l:rtp, l:sub, 1) | en
        if isdirectory(l:sub_after) | call add(l:rtp, l:sub_after) | en
      endfor
    en
    let &rtp = join(l:rtp, ',')
  endf " 2}}}
  fu! s:plug.set_repo_info() dict " {{{2
    let self.repo = s:trim_repo(self.repo)
    if s:is_local_plug(self) " local repo
      if !self.has('name') | let self.name = fnamemodify(self.repo, ':t:s?\.git$??') | en
      let self.type = self.local_type
      let self.path = substitute(self.repo, '^file://', '', '')
      if self.path[2] == ':'
        let self.path = self.path[1:]
      en
      let self.uri = self.path
    else " remote repo
      if self.repo !~ '/'
        return s:err(printf('Invalid argument: %s (implicit `vim-scripts'' expansion is deprecated)', self.repo))
      en
      let self.type = self.remote_type
      let self.uri = stridx(self.repo, '/') == strridx(self.repo, '/') ?
            \ 'https://github.com/' . self.repo . '.git' :
            \ self.repo
      if !self.has('name') | let self.name = fnamemodify(self.repo, ':t:s?\.git$??') | en
      if !self.has('path') | let self.path = expand(s:plug_home.'/'.self.name) | en
    en
    return 1
  endf " 2}}}
  fu! s:plug.call_before() dict " {{{2
    if has_key(a:plug, 'before')
      if self.has('before')
        if type(self.before) == s:type.funcref || exists('*'.self.before)
          call call(self.before, [])
        else
          call s:err('Specified before function for plugin ['.self.name.'] does not exists')
        en
      en
    en
  endf " 2}}}
  fu! s:plug.call_after() dict " {{{2
    if self.has('after')
      if type(self.after) == s:type.funcref || exists('*'.self.after)
        call call(self.after, [])
      else
        call s:err('Specified after function for plugin ['.self.name.'] does not exists')
      en
    en
  endf " 2}}}
  fu! s:plug.has(...) dict " {{{2
    for p in a:000
      if !has_key(self, p)
        return 0
      en
    endfor
    return 1
  endf " 2}}}
  fu! s:plug.to_str() dict " {{{2
    let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
    let l:b = l:a . '    '
    let l:r = l:a . printf("[ %s ]\n", self.name)
    let l:r .= l:b . printf("name          : %s\n", self.name)
    let l:r .= l:b . printf("path          : %s\n", self.path)
    let l:r .= l:b . printf("branch        : %s\n", has_key(self, 'branch') ? self.branch : 'master')
    let l:r .= l:b . printf("tag           : %s\n", has_key(self, 'tag') ? self.tag : '---')
    let l:r .= l:b . printf("commit        : %s\n", has_key(self, 'commit') ? self.commit : '---')
    let l:r .= l:b . printf("repo          : %s\n", self.repo)
    let l:r .= l:b . printf("uri           : %s\n", self.uri)
    let l:r .= l:b . printf("type          : %s\n", self.type == self.remote_type ? 'remote' : 'local')
    let l:r .= l:b . printf("loaded        : %s\n", self.loaded)
    let l:r .= l:b . printf("in_rtp        : %s\n", self.in_rtp)
    let l:r .= l:b . printf("enable        : %s\n", self.enable)
    let l:r .= l:b . printf("frozen        : %s\n", has_key(self, 'frozen') ? self.frozen : 0)
    let l:r .= l:b . printf("rtp           : %s\n", has_key(self, 'rtp') ? string(self.rtp) : '---')
    let l:r .= l:b . printf("dep           : %s\n", has_key(self, 'dep') ? string(self.dep) : '---')
    let l:r .= l:b . printf("before        : %s\n", has_key(self, 'before') ? string(self.before) . (has_key(self, 'before_loaded')? ', loaded': ', not loaded') : '---')
    let l:r .= l:b . printf("after         : %s\n", has_key(self, 'after') ? string(self.after) . (has_key(self, 'after_loaded')? ', loaded': ', not loaded') : '---')
    let l:r .= l:b . printf("do            : %s\n", has_key(self, 'do') ? self.do : '---')
    let l:r .= l:b . printf("[lazy-load]   : %s\n", has_key(self, 'is_lazy') ? self.is_lazy : 0)
    let l:r .= l:b . printf("  |- for      : %s\n", has_key(self, 'for') ? string(self.for) : '---')
    let l:r .= l:b . printf("  |- on       : %s\n", has_key(self, 'on') ? string(self.on) : '---')
    let l:r .= l:b . printf("  |- on_event : %s\n", has_key(self, 'on_event') ? string(self.on_event) : '---')
    let l:r .= l:b . printf("  |- on_func  : %s\n", has_key(self, 'on_func') ? string(self.on_func) : '---')
    return l:r
  endf " 2}}}
  fu! s:plug.get_plug_config() dict "{{{2
    let l:r = {}
    for l:attr in ['branch', 'tag', 'commmit', 'do', 'frozen', 'as', 'dir']
      if has_key(self, l:attr)
        let l:r[l:attr] = self[l:attr]
      en
    endfor
    return l:r
  endf "2}}}
endf " }}}

" functions for command
fu! plugex#add(repo, ...) " {{{
  " for Plug command
  if a:0 == 0
    let l:plug = s:plug.new(a:repo, {})
  elseif a:0 == 1
    let l:plug = s:plug.new(a:repo, a:1)
  el
    return s:err('Too many arguments for Plug')
  en
  let l:name = l:plug.name
  let s:plugs[l:name] = l:plug
  call add(s:plugs_order, l:name)
endf " }}}
fu! plugex#add_group(name, ...) " {{{
endf " }}}
fu! plugex#pluginfo(...) " {{{
  " for PlugInfo command
  let l:plugs = a:0 == 0 ? s:plugs : s:pick_plugs(a:000)
  tabnew
  setl nolist nospell wfh bt=nofile bh=unload fdm=indent
  call setline(1, repeat('-', 40))
  call append(line('$'), repeat(' ', 13).'PlugInfo')
  call append(line('$'), repeat('-', 40))
  for l:p in values(l:plugs)
    call append(line('$'), split(l:p.to_str(), '\n'))
  endfor
endf " }}}
fu! plugex#install(...) " {{{
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
endf " }}}
fu! plugex#update(...) " {{{
  " for PlugExUpdate command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  en
  let l:plugs = a:0 == 0 ? s:pick_plug(s:plugs_order) : s:pick_plugs(a:000)
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
fu! plugex#clean(bang) " {{{
  " for PlugExClean
  let l:old_rtp = &rtp
  call s:init_plug(g:plugexs)
  if a:bang
    PlugClean!
  el
    PlugClean
  en
  let &rtp = l:old_rtp
endf " }}}
fu! plugex#status() " {{{
  " for PlugExStatus
  let l:old_rtp = &rtp
  call s:init_plug(s:pick_plug(s:plugs_order))
  PlugStatus
  let &rtp = l:old_rtp
endf " }}}
fu! s:complete_plugs(a, l, p) " {{{
  " complete all plugin names
  let r = []
  for name in s:plugs_order
    if niame =~? a:a
      call add(r, name)
    en
  endfor
  return r
endf " }}}

" private functions
fu! s:fake_cmd(cmd, bang, l1, l2, args, plug) " {{{
  if !s:load_plug(a:plug) | return | en
  exe printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endf " }}}
fu! s:fake_map(the_map, with_prefix, prefix, plug) " {{{
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
    exe "normal! gg/! s:source\<cr>4j0r\":w\<cr>:bd\<cr>"
    return 1
  en
endf " }}}
fu! s:source(dir, ...) " {{{
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
fu! s:check_plug() " {{{
  if !filereadable(s:plug_path)
    echo 'can not found plug.vim, download now...'
    call s:update_plug()
  en
endf " }}}
fu! s:init_plug(plugs) " {{{
  call s:check_plug()
  call plug#begin(s:plug_home)
  for l:p in a:plugs
    call plug#(l:p.repo, s:plug_config(l:p))
  endfor
  call plug#end()
endf " }}}
fu! s:system_at(path, cmd) abort " {{{
  " cd to path, exe cmd, then cd back
  let l:cd = getcwd()
  exe 'cd ' . a:path
  let l:r =  system(a:cmd)
  exe 'cd ' . a:path
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
fu! s:to_list(v) " {{{
  return type(a:v) == s:type.list ? a:v : [a:v]
endf " }}}
fu! s:is_local_plug(plug) " {{{
  return a:plug.repo =~ '^\(\w:\|\~\)\?[\\\/]'
endf " }}}
fu! s:rstrip_slash(str) " {{{
  " foo/bar/\//\\ -> /foo/bar
  return substitute(a:str, '[\/\\]\+$', '', '')
endf " }}}
fu! s:lstrip_slash(str) " {{{
  " /\//\\foo/bar -> foo/bar
  return substitute(a:str, '^[\/\\]\+', '', '')
endf " }}}
fu! s:trim_repo(str) " {{{
  " foo/bar[.git][/] -> foo/bar
  return substitute(a:str, '\(.git\)\=[\/]\=$', '', '')
endf " }}}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: fmr={{{,}}} fdm=marker:
