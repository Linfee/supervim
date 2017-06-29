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
"     name                 Use a different name for the plugin (string)
"     path                 Custom directory for the plugin (string)
"     branch/tag/commit    Branch/tag/commit of the repository to use (string)
"
"     enable               Enable or not (0 or 1)
"     frozen               Do not update unless explicitly specified (0 or 1)
"     rtp                  Subdirectory that contains Vim plugin (string or list)
"     deps                 Dependent plugins (string or list)
"     before               Call this functions before load current plugin. (string) default: 'config#{plug_name}#before'
"     after                Call this functions after load current plugin. (string) default: 'config#{plug_name}#after'
"                          Note: You won't get any message if 'before' or 'after' function doesn't exists, you can check
"                          it by :PlugExLog
"
"     for                  Lazy load: When set filetype (string or list)
"     on                   Lazy load: When Commands or <Plug>-mappings triggered (string or list)
"     on_event             Lazy load: When event occurs (string or list)
"     on_func              Lazy load: When functions called (string or list)
"
"     do                   Post-update hook (string or funcref)
"
" Global_options:
"     g:plug_home           Specify a directory for plugins
"     g:plug_path           Specify a path for plug.vim
"                           Default as the first runtimepath autoload/plug.vim
"     g:plugex_param_check  Check param for PlugEx or not, default 0
"     g:plugex_use_cache    Use cache can launch faster, set to 1 to enable cache
"                           When you add change plugin config you should exe :PlugExClearCache
"     g:plugex_use_log      Set to 1 to enable log, then use PlugExLog to see all log
"
" Functions:
"     plugex#begin({plug home}) : Call this first then use PlugEx to define plugins
"     plugex#end()              : After define all plugins, call this function
"
"     plugex#new_plug(repo, config : PlugEx command call this function, repo is the plugin repo in string, config is a
"                                    dict with Plugex_options as key
"     plugex#is_loaded(...)        : Return 1 if all given plugins are loaded, accept string
" Commands:
"     PlugEx {plug repo}[, {options}] Add a plugin, {options} is a dict with Plugex_options as key
"     PlugExInstall [name ...]   Install plugins
"     PlugExUpdate [name ...]    Install or update plugins
"     PlugExClean[!]             Remove unused directories (bang version will clean without prompt)
"     PlugExStatus               Check the status of plugins
"     PlugExinfo [name ...]      Check the status of plugins in plugex way
"
"     PlugExLog                  Show the log, don't add any parameter, that will add a log
"     PlugExClearCache[!]        Clear all cache, use [!] will not get error message whether it exists or not
" Eg:
"     let g:plugex_use_log = 0
"     let g:plugex_use_cache = 1
"
"     if plugex#begin()
"       PlugEx 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
"       PlugEx 'junegunn/goyo.vim', {'before': function('Before'), 'after': 'After', 'on': 'Goyo', 'deps': ['nerdtree']}
"       PlugEx 'terryma/vim-expand-region', {'on': ['v<Plug>(expand_region_expand)', 'v<Plug>(expand_region_shrink)']}
"       PlugEx 'junegunn/vim-easy-align', {'on': ['<Plug>(EasyAlign)', 'x<Plug>(EasyAlign)']}
"       PlugEx 'junegunn/vim-easy-align'
"       PlugEx 'https://github.com/junegunn/vim-github-dashboard.git'
"       PlugEx 'SirVer/ultisnips' | PlugEx 'honza/vim-snippets'
"       PlugEx 'Valloric/MatchTagAlways', {'for': ['html', 'xml', 'xhtml', 'jsp']}
"       PlugEx 'rdnetto/YCM-Generator', {'branch': 'stable'}
"       PlugEx 'fatih/vim-go', {'tag': '*'}
"       PlugEx 'nsf/gocode', {'tag': 'v.20150303', 'rtp': 'vim'}
"       PlugEx 'junegunn/fzf', {'path': '~/.fzf', 'do': './install --all'}
"
"       PlugEx '~/my-plugin', {'on_event': ['InsertEnter', 'CorsurHold', 'if &ft=="java"']}
"       PlugEx '~/my-plugin2', {'on_event': ['InsertEnter if &ft=="java"',
"                                          \ 'CorsurHold if &ft=="jsp"',
"                                          \ 'if &ft=="java"||&ft=="jsp"']}
"       PlugEx '~/my-plugin3', {'on_func': ['Test', 'Test2']}
"     endif
"     call plugex#end()
" }}}

if exists('g:loaded_plugex')
  finish
endif
let g:loaded_plugex = 1

let s:cpo_save = &cpo
set cpo&vim

let s:status = {'ready': 0, 'in_rtp': 1, 'called_before': 2, 'loaded': 3, 'called_after': 4}
let s:status_list = ['ready', 'in_rtp', 'called_before', 'loaded', 'called_after']

" for user
fu! plugex#begin(...) " {{{
  PlugExLog '>>> plugex#begin >>>'
  if !executable('git')
    return s:err('Please make sure git in your path, plugex depends on that.')
  endif
  let s:plug_path = exists('g:plug_path') ? g:plug_path :
        \ expand(s:rstrip_slash(s:split_rtp()[0]).'/autoload/plug.vim')

  " Set s:plug_home
  if a:0 > 0
    let s:plug_home = s:rstrip_slash(expand(a:1))
  elseif exists('g:plug_home')
    let s:plug_home = s:rstrip_slash(expand(g:plug_home))
  elseif !empty(&rtp)
    let s:plug_home = expand(s:rstrip_slash(split(&rtp, ',')[0]) . '/.repos')
  el
    return s:err('Unable to determine plugex home. Try calling plugex#begin() with a path argument.')
  endif
  let s:plugs = {}
  let s:plugs_order = []
  let s:vimenter_plugs = [] " load after VimEnter
  let s:first_rtp = s:rstrip_slash(s:split_rtp()[0])
  let s:is_win = has('win32') || has('win64')
  let s:is_win_unix = has('win32unix')
  let s:cache_dir = expand('~/.cache/'.(has('nvim') ? 'nvim' : 'vim'))
  let s:cache_file = expand(s:cache_dir.'/plugex')
  if s:is_win_unix
    let s:cache_file .= '.win_unix'
  endif
  PlugExLog '  Use cache_dir', s:cache_dir
  PlugExLog '  Use cache_file', s:cache_file

  let s:plug_local_type = 'local'
  let s:plug_remote_type = 'remote'

  let g:plugex_param_check = get(g:, 'plugex_param_check', 0)
  let g:plugex_use_cache = get(g:, 'plugex_use_cache', 1)

  " Def cmds
  com! -nargs=+ -bar
        \ PlugEx           call plugex#new_plug(<args>)
  com! -nargs=* -complete=customlist,s:complete_plugs
        \ PlugExInstall    call s:install(<f-args>)
  com! -nargs=* -complete=customlist,s:complete_plugs
        \ PlugExUpdate     call s:update(<f-args>)
  com! -nargs=0 -bang
        \ PlugExClean      call s:clean('<bang>'=='!')
  com! -nargs=0
        \ PlugExStatus     call s:status()
  com! -nargs=* -complete=customlist,s:complete_plugs
        \ PlugExInfo       call s:pluginfo(<f-args>)
  com! -nargs=0 -bang
        \ PlugExClearCache call s:clear_cache('<bang>'=='!')

  " load cache
  if g:plugex_use_cache
    if filereadable(s:cache_file)
      let [l:s1, l:s2] = readfile(s:cache_file)
      let [s:plugs, s:plugs_order] = [eval(l:s1), eval(l:s2)]
      PlugExLog '' | PlugExLog '>>> plugex#begin finished with cache >>>' | PlugExLog ''
      return 0
    endif
  endif

  " Vars for plug obj
  " properties
  "   name, path, branch, tag, commit
  "   enable, frozen, rtp, deps
  "   before, after, do
  "   for, on, on_event, on_func
  " other properties
  "   dir, type, as, uri
  "   is_lazy
  "   sourced

  PlugExLog '' | PlugExLog '>>> plugex#begin finished >>>' | PlugExLog ''
  return 1
endf " }}}
fu! plugex#end() " {{{
  if !exists('s:plugs') | return s:err('Call plugex#begin() first') | endif
  PlugExLog '' | PlugExLog '>>> plugex#end >>>'

  " save cache
  if g:plugex_use_cache
    if !filereadable(s:cache_file)
      if !isdirectory(s:cache_dir)
        call mkdir(s:cache_dir, 'p')
      endif
      if writefile([string(s:plugs), string(s:plugs_order)], s:cache_file)
        call s:err('Write cache file '.s:cache_file.' fail.')
      else
        PlugExLog 'Write cache file', s:cache_file
      endif
    endif
  endif

  if &compatible
    set nocompatible
  endif
  aug PlugEx
    au!
    call s:handle_plug()
  aug END
  filetype plugin indent on
  syntax enable

  " on vimenter
  aug PlugExVimEnter
    au!
    au VimEnter * PlugExLog '' | PlugExLog '>>> Handle vimenter >>>' |
          \ call s:handle_vimenter() |
          \ PlugExLog '' | PlugExLog '>>> Load plugin with {''on_event'': ''VimEnter''} >>>' |
          \ call timer_start(10, function('s:load_vimenter_plugs'))
  aug END
  PlugExLog '>>> plugex#end finished >>>'
endf " }}}

" for plugex#end
fu! s:handle_plug() " {{{
  for l:name in s:plugs_order
    let l:plug = s:plugs[l:name]
    if !l:plug.enable
      continue
    endif
    call s:load_ftdetect(l:plug)
    if l:plug.is_lazy
      " lazy plug
      call s:setup_lazy_load(l:plug)
    else
      " non lazy plug
      if s:add2rtp(l:plug)
        call s:call_before(l:plug)
      endif
      " will be loaded by vim
    endif
  endfor
endf " }}}
fu! s:handle_vimenter() " {{{
  for l:name in s:plugs_order
    let l:plug = s:plugs[l:name]
    if !l:plug.enable
      continue
    endif
    if l:plug.is_lazy
      " lazy plug
      call s:add2rtp(l:plug)
    else
      " non lazy plug
      let l:plug.status = s:status.loaded
      call s:call_after(l:plug)
    endif
  endfor
endf " }}}
fu! s:load_vimenter_plugs(tid) " {{{
  " load 10 plugin each time
  for i in range(len(s:vimenter_plugs) > 5 ? 5 : len(s:vimenter_plugs))
    let l:p = remove(s:vimenter_plugs, 0)
    if eval(l:p[0])
      call s:load(l:p[1])
    endif
  endfor
  if len(s:vimenter_plugs) > 0
    call timer_start(10, function('s:load_vimenter_plugs'))
  else
    aug PlugExVimEnter | 
      au!
    aug END
    aug! PlugExVimEnter
    do BufWinEnter
    do BufEnter
    do VimEnter
    call s:log('')
    call s:log(">>>>> vim runtime >>>>>")
    echohl String | echom 'init finish' | echohl None
  endif
endf " }}}
fu! s:setup_lazy_load(plug) " {{{
  let l:name = a:plug.name
  " for
  if has_key(a:plug, 'for')
    let l:ft = join(s:plugs[l:name].for, ',')
    exe 'au FileType '.l:ft.' call s:load(s:plugs["'.l:name.'"])'
  endif
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
      endif
    endfor
  endif
  " on_event
  if has_key(a:plug, 'on_event')
    for l:e in a:plug.on_event[:-2]
      let l:ec = split(l:e . ' if 1', ' if ')
      let l:event = l:ec[0]
      let l:condition = '('.a:plug.on_event[-1][3:].') && ('.l:ec[1].')'
      if l:event == 'VimEnter'
        call add(s:vimenter_plugs, [l:condition, a:plug])
      else
        exe 'au '.l:event.' *  if '.l:condition.' | call s:load(s:plugs["'.l:name.'"]) | en'
      endif
    endfor
  endif
  " on_func
  if has_key(a:plug, 'on_func')
    let l:func_pat = join(s:plugs[l:name].on_func, ',')
    exe 'au FuncUndefined '.l:func_pat.' call s:load(s:plugs["'.l:name.'"])'
  endif
endf " }}}
fu! s:fake_cmd(cmd, bang, l1, l2, args, name) " {{{
  if !s:load(s:plugs[a:name]) | return | endif
  exe printf('%s%s%s %s', (a:l1 == a:l2 ? '' : (a:l1.','.a:l2)), a:cmd, a:bang, a:args)
endf " }}}
fu! s:fake_map(the_map, with_prefix, prefix, name) " {{{
  " https://github.com/junegunn/vim-plug/blob/master/plug.vim
  if !s:load(s:plugs[a:name]) | return | endif
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
endf " }}}

" for plug obj
fu! s:to_str(plug, ...) " {{{
  " obj plug to string
  let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
  let l:b = l:a . '    '
  let l:r  = l:a . printf("  [ %s ]\n", a:plug.name)
  let l:r .= l:b . printf("name          : %s\n", a:plug.name)
  let l:r .= l:b . printf("path          : %s\n", get(a:plug, 'path', '---'))
  let l:r .= l:b . printf("branch        : %s\n", get(a:plug, 'branch', '---'))
  let l:r .= l:b . printf("tag           : %s\n", get(a:plug, 'tag', '---'))
  let l:r .= l:b . printf("commit        : %s\n", get(a:plug, 'commit', '---'))
  let l:r .= l:b . printf("repo          : %s\n", a:plug.repo)
  let l:r .= l:b . printf("uri           : %s\n", get(a:plug, 'uri', '---'))
  let l:r .= l:b . printf("type          : %s\n", a:plug.type)
  let l:r .= l:b . printf("status        : %s\n", s:status_list[a:plug.status])
  let l:r .= l:b . printf("enable        : %s\n", a:plug.enable)
  let l:r .= l:b . printf("frozen        : %s\n", get(a:plug, 'frozen', 0))
  let l:r .= l:b . printf("rtp           : %s\n", get(a:plug, 'rtp', '---'))
  let l:r .= l:b . printf("dep           : %s\n", get(a:plug, 'dep', '---'))
  let l:r .= l:b . printf("before        : %s\n", string(get(a:plug, 'called_before', '---')))
  let l:r .= l:b . printf("after         : %s\n", string(get(a:plug, 'called_after', '---')))
  let l:r .= l:b . printf("do            : %s\n", get(a:plug, 'do', '---'))
  let l:r .= l:b . printf("[lazy-load]   : %s\n", get(a:plug, 'is_lazy', 0))
  let l:r .= l:b . printf("  |- for      : %s\n", string(get(a:plug, 'for', '---')))
  let l:r .= l:b . printf("  |- on       : %s\n", string(get(a:plug, 'on', '---')))
  let l:r .= l:b . printf("  |- on_event : %s\n", string(get(a:plug, 'on_event', '---')))
  let l:r .= l:b . printf("  |- on_func  : %s\n", string(get(a:plug, 'on_func', '---')))
  return l:r
endf " }}}
fu! s:load_ftdetect(plug) " {{{
  let l:r = s:source(a:plug.path, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
  " for vimscripts in plugin's subdirectory
  if has_key(a:plug, 'rtp')
    for l:rtp in a:plug.rtp
      let l:sub = expand(a:plug.path . '/' . l:rtp)
      let l:r += s:source(l:sub, 'ftdetect/**/*.vim', 'after/ftdetect/**/*.vim')
    endfor
  endif
  PlugExLog 'Load ftdetect for plug:', a:plug.name, '[ finish ]', l:r, 'files.'
  return l:r
endf " }}}
fu! s:add2rtp(plug) " {{{
  if a:plug.status >= s:status.in_rtp
    return
  endif
  if a:plug.status == s:status.ready
    if !isdirectory(a:plug.path)
      let a:plug.enable = 0
      return s:err('Can not found dir ['.a:plug.path.'] for plug ['.a:plug.name.']. use :PlugExInstall install it first')
    endif
    let l:rtp = s:split_rtp()
    call insert(l:rtp, a:plug.path, 1)
    let l:after = expand(a:plug.path.'/after')
    if isdirectory(l:after)
      call add(l:rtp, l:after)
    endif
    " for vimscripts in plugin's subdir
    if has_key(a:plug, 'rtp')
      for l:r in a:plug.rtp
        let l:sub = expand(a:plug.path . '/' . l:r)
        let l:sub_after = expand(l:sub . '/after')
        if isdirectory(l:sub) | call insert(l:rtp, l:sub, 1) | en
        if isdirectory(l:sub_after) | call add(l:rtp, l:sub_after) | en
      endfor
    endif
    let &rtp = join(l:rtp, ',')
    let a:plug.status = s:status.in_rtp
    PlugExLog 'Add2rtp for', a:plug.is_lazy ? 'lazy' : 'non lazy' , 'plug:', a:plug.name, '[ finish ]'
    return 1
  else
    return s:err('Plug should be ready before add2rtp')
  endif
endf " }}}
fu! s:load(plug) " {{{
  if a:plug.status >= s:status.loaded
    return
  endif
  " deps
  if has_key(a:plug, 'deps')
    for name in a:plug.deps
      if has_key(s:plugs, name)
        let l:plug = s:plugs[name]
        if !s:load(l:plug)
          return s:err('When load ['.a:plug.name.'], dependency plugin '.l:plug.name.' load fail.')
        endif
      else
        return s:err('When load ['.a:plug.name.'], can not found dependency plugin '.l:plug.name.'.')
      end
    endfor
  endif

  " delete fake_cmd and fake_map
  if has_key(a:plug, 'on')
    for l:on in a:plug.on
      if l:on =~? '<plug>' " on_map
        let l:map = matchstr(l:on, '<plug.*$')
        let l:mode = l:on[0]
        if hasmapto(l:map, l:mode)
          exe l:mode.'unmap '.l:map
        endif
      el " on_cmd
        if exists(':'.l:on)
          exe 'delcommand '.l:on
        endif
      endif
    endfor
  endif

  " call before, add2rtp, load, after
  let l:lazy = a:plug.is_lazy ? 'lazy' : 'non lazy'
  call s:add2rtp(a:plug)
  call s:call_before(a:plug)
  " for normal plugin
  if !get(a:plug, 'sourced')
    call s:source(a:plug.path, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
    if has_key(a:plug, 'rtp')
      for l:rtp in a:plug.rtp
        let l:sub = expand(a:plug.path . '/' . l:rtp)
        call s:source(l:sub, 'plugin/**/*.vim', 'after/plugin/**/*.vim')
      endfor
    endif
  endif
  let a:plug.status = s:status.loaded
  PlugExLog 'Loaded', l:lazy, 'plug', a:plug.name
  call s:call_after(a:plug)
  return 1
endf " }}}
fu! s:call_before(plug) " {{{
  if a:plug.status >= s:status.called_before
    return
  endif
  if a:plug.status != s:status.in_rtp
    return s:err('Plug status should be in_rtp when call_before, but it is '.s:status_list[a:plug.status].' for plug '.a:plug.name)
  endif
  let l:before = has_key(a:plug, 'before') ? a:plug.before : 'config#'.substitute(a:plug.name, '[.-]', '_', 'g').'#before'
  try
    call call(l:before, [])
    let a:plug.called_before = l:before
    PlugExLog 'Call before for plug', a:plug.name.',', l:before
    return 1
  catch /^Vim\%((\a\+)\)\=:E117/
    PlugExLog 'Call before for', a:plug.name.',', 'can not found function', l:before
  finally
    let a:plug.status = s:status.called_before
  endtry
endf " }}}
fu! s:call_after(plug) " {{{
  if a:plug.status == s:status.called_after
    return
  endif
  if a:plug.status != s:status.loaded
    return s:err('Plug status should be loaded when call_after, but it is '.s:status_list[a:plug.status].' for plug '.a:plug.name)
  endif
  let l:after = has_key(a:plug, 'after') ? a:plug.after : 'config#'.substitute(a:plug.name, '[.-]', '_', 'g').'#after'
  try
    call call(l:after, [])
    let a:plug.called_after = l:after
    PlugExLog 'Call after for plug', a:plug.name.',', l:after
    return 1
  catch /^Vim\%((\a\+)\)\=:E117/
    PlugExLog 'Call after for plug', a:plug.name.',', 'can not found function', l:after
  finally
    let a:plug.status = s:status.called_after
  endtry
endf " }}}

" for commands
fu! plugex#new_plug(repo, ...) " {{{
  " handle arguments
  if a:0 > 1
    return s:err('Too many arguments for PlugEx')
  endif
  let l:config = a:0 == 0 ? {} : a:1

  call s:pretreatment(a:repo, l:config)

  " set enable, repo, name, path, uri, type, dir, is_lazy
  let l:config.enable = get(l:config, 'enable', 1)
  let l:config.repo = s:trim_repo(a:repo)
  if has_key(l:config, 'name') | let l:config.as = l:config.name | en
  if has_key(l:config, 'path') | let l:config.dir = l:config.path | en
  let l:config.repo = a:repo
  if !s:set_plug_repo_info(l:config) | return | en
  let l:config.is_lazy = has_key(l:config, 'for') || has_key(l:config, 'on') ||
        \ has_key(l:config, 'on_event') || has_key(l:config, 'on_func') ||
        \ get(l:config, 'lazy', 0)
  let l:config.status = s:status.ready

  " add to s:plugs and s:plugs_order
  let s:plugs[l:config.name] = l:config
  call add(s:plugs_order, l:config.name)

  PlugExLog 'New plug', l:config.name, string(l:config)
  return l:config
endf " }}}
fu! s:pretreatment(repo, config) " for new_plug {{{
  " check config
  if g:plugex_param_check | call s:check_param(a:repo, a:config) | en
  if has_key(a:config, 'dir') | unlet a:config.dir | en
  if has_key(a:config, 'as') | unlet a:config.as | en
  if has_key(a:config, 'uri') | unlet a:config.uri | en
  if has_key(a:config, 'called_before') | unlet a:config.called_before | en
  if has_key(a:config, 'called_after') | unlet a:config.called_after | en

  " string to list
  " dir, type, as, uri
  " is_lazy
  for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
    if has_key(a:config, l:attr) && type(a:config[l:attr]) == v:t_string
      let a:config[l:attr] = [a:config[l:attr]]
    endif
  endfor

  " make sure the last item of on_event is a condition
  if has_key(a:config, 'on_event')
    if a:config.on_event[-1][:2] != 'if '
      call add(a:config.on_event, 'if 1')
    endif
  endif
endf " }}}
fu! s:complete_plugs(a, l, p) " {{{
  " complete all plugin names
  let r = []
  for name in s:plugs_order
    if name =~? a:a
      call add(r, name)
    endif
  endfor
  return r
endf " }}}
fu! s:pluginfo(...) " {{{
  " for PlugInfo command
  let l:plugs = a:0 == 0 ? values(s:plugs) : s:pick_plugs(a:000)
  tabnew
  setl nolist nospell wfh bt=nofile bh=unload fdm=indent wrap
  call setline(1, repeat('-', 40))
  call append(line('$'), repeat(' ', 13).'PlugInfo')
  call append(line('$'), repeat('-', 40))
  let l:loaded = []
  let l:lazy_num = 0
  let l:enable_num = 0
  for l:p in l:plugs
    call append(line('$'), split(s:to_str(l:p), '\n'))
    if l:p.status >= s:status.loaded
      call add(l:loaded, l:p.name)
    endif
    if l:p.is_lazy | let l:lazy_num += 1 | en
    if l:p.enable | let l:enable_num += 1 | en
  endfor
  if a:0 == 0
    call append(3, '')
    call append(3, 'Total: '.len(s:plugs))
    call append(4, 'Enable: '.l:enable_num)
    call append(5, 'Lazy: '.l:lazy_num)
    call append(6, 'Loaded: '.len(l:loaded))
    call append(7, 'These plugins have been loaded: ')
    call append(8, '  '.string(l:loaded))
    call append(9, 'Plugs order')
    call append(10, '  '.string(s:plugs_order))
  endif
endf " }}}
fu! s:install(...) " {{{
  " for PlugExInstall command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  endif
  " for PlugExInstall command
  let l:plugs = a:0 == 0 ? values(s:plugs) : s:pick_plugs(a:000)
  if &ft == 'startify'
    tabnew
    exe "normal! i\<esc>"
  el
    exe "normal! i\<esc>"
  endif
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugInstall
  let &rtp = l:old_rtp
  " for l:p in l:plugs
  "   call s:load_ftdetect(l:p)
  "   call s:load(l:p)
  " endfor
  PlugExClearCache!
endf " }}}
fu! s:update(...) " {{{
  " for PlugExUpdate command
  " create plug_home if not exists
  if !isdirectory(s:plug_home)
    call mkdir(s:plug_home, 'p')
  endif
  let l:plugs = a:0 == 0 ? values(s:plugs) : s:pick_plugs(a:000)
  if &ft == 'startify'
    tabnew
    exe "normal! i\<esc>"
  el
    exe "normal! i\<esc>"
  endif
  let l:old_rtp = &rtp
  call s:init_plug(l:plugs)
  PlugUpdate
  let &rtp = l:old_rtp
  PlugExClearCache!
endf " }}}
fu! s:clean(bang) " {{{
  " for PlugExClean
  let l:old_rtp = &rtp
  call s:init_plug(values(s:plugs))
  if a:bang
    PlugClean!
  el
    PlugClean
  endif
  let &rtp = l:old_rtp
  PlugExClearCache!
endf " }}}
fu! s:status() " {{{
  " for PlugExStatus
  let l:old_rtp = &rtp
  call s:init_plug(values(s:plugs))
  PlugStatus
  let &rtp = l:old_rtp
endf " }}}
fu! s:clear_cache(bang) " {{{
  if a:bang
    return delete(s:cache_file)
  else
    if !filereadable(s:cache_file)
      return s:err('Cache file '.s:cache_file.' does not exists.')
    endif
    if delete(s:cache_file)
      return s:err('Delete cache file '.s:cache_file.' fail.')
    else
      echom 'Delete cache file '.s:cache_file.' success.'
      return 1
    endif
  endif
endf " }}}
fu! s:set_plug_repo_info(plug) " {{{
  let a:plug.repo = s:trim_repo(a:plug.repo)
  if a:plug.repo =~ '^\(\w:\|\~\)\?[\\\/]' " local repo
    if !has_key(a:plug, 'name') | let a:plug.name = fnamemodify(a:plug.repo, ':t:s?\.git$??') | en
    let a:plug.type = s:plug_local_type
    let a:plug.path = expand(substitute(a:plug.repo, '^file://', '', ''))
    if a:plug.path[2] == ':'
      let a:plug.path = a:plug.path[1:]
    endif
    let a:plug.uri = a:plug.path
  else " remote repo
    if a:plug.repo !~ '/'
      return s:err(printf('Invalid argument: %s (implicit `vim-scripts'' expansion is deprecated)', a:plug.repo))
    endif
    let a:plug.type = s:plug_remote_type
    let a:plug.uri = stridx(a:plug.repo, '/') == strridx(a:plug.repo, '/') ?
          \ 'https://github.com/' . a:plug.repo . '.git' :
          \ a:plug.repo
    if !has_key(a:plug, 'name') | let a:plug.name = fnamemodify(a:plug.repo, ':t:s?\.git$??') | en
    if !has_key(a:plug, 'path')
      let a:plug.path = expand(s:plug_home.'/'.a:plug.name)
    else
      let a:plug.path = expand(a:plug.path)
    endif
  endif
  return 1
endf " }}}
fu! s:check_param(repo, config) " {{{
  if g:plugex_param_check
    for l:attr in ['name', 'path', 'branch', 'tag', 'commit']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) != v:t_string
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string.')
          unlet a:config[l:attr]
        endif
      endif
    endfor
    for l:attr in ['rtp', 'deps', 'for', 'on', 'on_event', 'on_func']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) == v:t_string || type(a:config[l:attr]) == v:t_list
          if len(a:config[l:attr] == 0)
            unlet a:config[l:attr]
          endif
        else
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string or list.')
          unlet a:config[l:attr]
        endif
      endif
    endfor
    for l:attr in ['before', 'after', 'do']
      if has_key(a:config, l:attr)
        if type(a:config[l:attr]) != v:t_string &&
              \ type(a:config[l:attr]) != v:t_func
          call s:err('['.a:repo.'] Attribute '.l:attr.' can only be string or funcref.')
          unlet a:config[l:attr]
        endif
      endif
    endfor
  endif
endf " }}}

" other functions
fu! s:init_plug(plugs) " {{{
  let l:plugs = a:plugs
  call s:check_plug()
  call plug#begin(s:plug_home)
  for l:p in l:plugs
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
fu! s:err(msg) " {{{
  " echo err
  echohl ErrorMsg
  echom '[plugex] ' . a:msg
  echohl None
  PlugExLog '[plugex]', a:msg
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
fu! s:trim_repo(str) " {{{
  " foo/bar[.git][/] -> foo/bar
  return substitute(a:str, '\(.git\)\=[\/]\=$', '', '')
endf " }}}
fu! s:source(dir, ...) " {{{
  " source file from dir with patterns
  let l:found = 0
  for pattern in a:000
    for script in split(globpath(a:dir, pattern))
      execute 'source '. script
      let l:found = 1
    endfor
  endfor
  return l:found
endf " }}}
fu! s:pick_plugs(names) " {{{
  let l:plugs = []
  for l:name in a:names
    call add(l:plugs, s:plugs[l:name])
  endfor
  return l:plugs
endf " }}}
fu! plugex#is_loaded(...) " {{{
  for l:n in a:000
    if !has_key(s:plugs) || s:plugs[l:n].status < loaded
      return 0
    endif
  endfor
  return 1
endf " }}}

" log {{{
let g:plugex_use_log = get(g:, 'plugex_use_log', 0)
let s:plugs_log = []
if g:plugex_use_log
  fu! s:log(...)
    if a:0 == 0
      tabnew
      setl bt=nofile bh=unload nowrap
      call setline(1, '[ PlugExLog ]')
      for l in s:plugs_log
        call append(line('$'), '  '.l)
      endfor |
    else
      let l:log = ''
      for l:a in a:000
        let l:log .= ' '.(type(l:a) == v:t_string ? l:a : string(l:a))
      endfor
      call add(s:plugs_log, l:log)
    endif
  endf
else
  fu! s:log(...)
    if a:0 == 0
      call s:err('Note: let g:plugex_use_log = 1 to enable log')
    endif
  endf
endif
com! -nargs=* -bar PlugExLog call s:log(<args>)
" }}}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: fmr={{{,}}} fdm=marker:
