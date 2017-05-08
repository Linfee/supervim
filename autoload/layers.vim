" Note: unstable now
let s:cpo_save = &cpo
set cpo&vim

" g:layres
" g:layers_dir
" g:layers_dir_user
"
" s:layers
" s:layers_dir
" s:available_layers
" s:loaded_layers
" s:all_loaded_layers

" for test
" com! -nargs=0 ShowLayers echo s:layers
" com! -nargs=0 ShowLayersDir echo s:layers_dir
" com! -nargs=0 ShowAvLayers echo s:available_layers
" com! -nargs=0 ShowLoadedLayers echo s:loaded_layers
" com! -nargs=0 ShowAllLoadedLayers echo s:all_loaded_layers
" com! -nargs=0 Test for i in s:all_loaded_layers | echo i.to_str() | endfor

let s:TYPE = {
      \   'string':  type(''),
      \   'list':    type([]),
      \   'dict':    type({}),
      \   'funcref': type(function('call'))
      \ }

fu! layers#init(...) " {{
  " call layers#init([layer_dir ...])
  if exists('g:layer_inited')
    return s:err('layers#init should be called only once')
  endif
  let g:layer_inited = 1

  " init s:layers
  if !exists('g:layers')
    echom 'Set g:layers to enable layer.'
    return
  endif
  if type(g:layers) == s:TYPE.string
    let g:layers = [g:layers]
  endif
  let s:layers = g:layers

  " init s:layers_dir
  if a:0 != 0
    let s:layers_dir = map(a:000, 'expand(v:val)')
  else
    if exists('g:layers_dir')
      if type(g:layers_dir) == s:TYPE.string
        let s:layers_dir = expand(g:layers_dir)
      elseif type(g:layers_dir) == s:TYPE.list
        let s:layers_dir = map(g:layers_dir, 'expand(v:val)')
      endif
    else
      let s:layers_dir = [expand(s:rstrip_slash(s:split_rtp()[0]).'/layers')]
    endif
    if exists('g:layers_dir_user')
      if type(g:layers_dir_user) == s:TYPE.string
        call add(s:layers_dir, expand(g:layers_dir_user))
        let s:layers_dir = + s:layers_dir
      elseif type(g:layers_dir_user) == s:TYPE.list
        let s:layers_dir +=  map(g:layers_dir_user, 'expand(v:val)')
      endif
    endif
  endif

  " init available layers
  let s:available_layers = {}
  for l:l in split(globpath(join(s:layers_dir, ','), '**/*.vim'), '\n')
    let s:available_layers[fnamemodify(fnamemodify(l:l, ':t'), ':r')] = l:l
  endfor

  " def class
  call s:def_class()

  " init all layers
  let s:loaded_layers = []     " all loaded top level layers
  let s:all_loaded_layers = [] " all loaded layers
  let s:all_loaded_layers_name = [] " all loaded layers
  call s:init_all_layers()

  " init plugin manager
  call s:init_plugex()

  " exe layer config
  call s:exe_config()
endf " }}

fu! s:def_class() " {{
  fu! s:to_str(...) dict " {{2
    let l:a  = a:0 == 0 ? '' : repeat(' ', a:1 * 4)
    let l:b = l:a . '    '
    let l:r = l:a . printf("[ %s ]\n", self.name)
    let l:r .= l:b . printf("name          : %s\n", self.name)
    let l:r .= l:b . printf("path          : %s\n", self.path)
    let l:r .= l:b . printf("dep           : %s\n", self.has('dep') ? self.dep : '---')
    let l:r .= l:b . printf("conflic       : %s\n", self.has('conflic') ? self.conflic : '---')
    let l:r .= l:b . printf("conditoin     : %s\n", self.has('condition') ? self.condition : '---')
    let l:r .= l:b . printf("config        : %s\n", self.config)
    let l:i = a:0 == 0 ? 1 : a:1 + 1
    let l:subs = join(map(deepcopy(self.sub_layers), 'v:val.to_str('.l:i.')'), '\n')
    let l:r .= l:b . printf("sub_layers    : %s\n", l:subs)
    let l:r .= l:b . printf("plugins       : %s\n", self.has('plugins') ? self.plugins : '---')
    return l:r
  endf " 2}}
  fu! s:check_dep() dict " {{2
    " return 0 when dependency satisfied
    if !self.has('dep')
      return
    endif
    let l:d = []
    for l:n in self.dep
      if index(s:all_loaded_layers_name, l:n) == -1
        call add(l:d, l:n)
      endif
    endfor
    if len(l:d) > 0
      call s:err('When load layer ['.self.name.
            \ '] found dependent layer has not been loaded: ' . join(l:d, ','))
      return len(l:d)
    endif
  endf " 2}}
  fu! s:check_conflic() dict " {{2
    " return 0 when no conflic
    if !self.has('conflic')
      return
    endif
    let l:c = []
    for l:l in s:all_loaded_layers
      if index(self.conflic, l:l.name) != -1
        call add(l:c, l:l.name)
      endif
    endfor
    if len(l:c) > 0
      call s:err('When load layer ['.self.name.
            \ '] found conflic layer has been loaded: ' . join(l:c, ','))
      return len(l:l)
    endif
  endf " 2}}
  fu! s:check_condition() dict " {{2
    " return 0 if condition satisfied
    if self.has('conditoin')
      exe 'return !(' . self.condition . ')'
    endif
    return 0
  endf " 2}}
  fu! s:has(attr) dict " {{2
    return has_key(self, a:attr) && len(self[a:attr]) > 0
  endf " 2}}
  fu! s:add2plugex() dict " {{2
    " call plugex#add()
    " 1st, add its plugins
    if self.has('plugins')
      for l:plug in self.plugins
        call plugex#add(l:plug[0], get(l:plug, 1, {}))
      endfor
    endif
    " 2nd, add sub layers' plugins
    for l:l in self.sub_layers
      call l:l.add2plugex()
    endfor
  endf " 2}}
  fu! s:apply_config() dict " 2{{
    " 1st, sub_layers
    for l:l in self.sub_layers
      call l:l.apply_config()
    endfor
    " 2nd, itself
    if exists('*'.self.config)
      exe 'call '.self.config.'()'
    endif
  endf " 2}}
  fu! s:init_layer_obj() dict " {{2
    " return 1 if success, or 0 if fail
    " find layer and source
    let g:layer = {}
    let g:layer.plugins = []
    exe 'source ' . self.path
    " set attribute
    if exists('g:layer')
      for l:attr in ['desc', 'dep', 'conflic', 'condition', 'config', 'sub_layers', 'plugins']
        if has_key(g:layer, l:attr)
          let self[l:attr] = g:layer[l:attr]
        endif
      endfor
    endif
    unlet! g:layer
    for l:attr in ['dep', 'conflic', 'sub_layers']
      if self.has(l:attr)
        if type(self[l:attr]) == s:TYPE.string
          let self[l:attr] = [self[l:attr]]
        endif
      endif
    endfor
    if self.has('plugins')
      for i in range(len(self.plugins))
        if type(self.plugins[i]) == s:TYPE.string
          let self.plugins[i] = [self.plugins[i]]
        endif
      endfor
    endif
    if !self.has('config')
      let self.config = 'after'
    endif
    let self.config = substitute(self.name, '-', '_', 'g') . '#' . self.config
    if !self.has('sub_layers')
      let self.sub_layers = []
    endif
    " check
    if self.check_condition()
      return 0
    endif
    if index(s:all_loaded_layers_name, self.name) != -1
      return s:err('Layer ['.self.name.'] has been inited before.')
    endif
    if self.check_conflic()
      return 0
    endif
    if self.check_dep()
      return 0
    endif
    call add(s:all_loaded_layers, self)
    call add(s:all_loaded_layers_name, self.name)
    " init sub_layers
    call filter(
          \ map(self.sub_layers, 's:mk_layer(v:val)'),
          \ 'type(v:val)==type({})'
          \ )
    return 1
  endf " 2}}
  fu! s:mk_layer(name) " {{2
    " return layer_obj if success, or 0 if fail
    let l:path = get(s:available_layers, a:name)
    if type(l:path) != s:TYPE.string | return | en
    let l:l = {}
    let l:l.to_str = function('s:to_str')
    let l:l.check_dep = function('s:check_dep')
    let l:l.check_conflic = function('s:check_conflic')
    let l:l.check_condition = function('s:check_condition')
    let l:l.has = function('s:has')
    let l:l.add2plugex = function('s:add2plugex')
    let l:l.apply_config = function('s:apply_config')
    let l:l.init = function('s:init_layer_obj')
    let l:l.path = l:path
    let l:l.name = a:name
    if l:l.init()
      return l:l
    endif
  endf " 2}}
endf " }}

fu! s:init_all_layers() " {{
  for l:l in s:layers
    let l:r = s:mk_layer(l:l)
    if type(l:r) == s:TYPE.dict
      call add(s:loaded_layers, l:r)
    endif
  endfor
endf " }}
fu! s:init_plugex() " {{
  call plugex#begin()
  for l:l in s:loaded_layers
    call l:l.add2plugex()
  endfor
  call plugex#end()
endf " }}
fu! s:exe_config() " {{
  for l:l in s:loaded_layers
    call l:l.apply_config()
  endfor
endf " }}

fu! s:err(msg) " {{2
  " echo err
  echohl ErrorMsg
  echom '[Layer] ' . a:msg
  echohl None
endf " 2}}
fu! s:rstrip_slash(str) " {{2
  " foo/bar/\//\\ -> /foo/bar
  return substitute(a:str, '[\/\\]\+$', '', '')
endf " 2}}
fu! s:split_rtp() " {{2
  " &rtp -> [first, rest]
  let idx = stridx(&rtp, ',')
  return [&rtp[:idx-1], &rtp[idx+1:]]
endf " 2}}

fu! layers#is_layer_loaded(layer) " {{
  return index(s:all_loaded_layers_name, a:layer) != -1
endf " }}

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: fmr={{,}} fdm=marker nospell:
