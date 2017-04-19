"                                       _
"     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
"    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
"    \__ | |_| | |_) | __/ |     \ v / | | | | | | |
"    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
"              |_|
"
" Author: linfee
" Repo: https://github.com/linfee/supervim
" Module: Layer support
"

let s:cpo_save = &cpo
set cpo&vim

fu! layer#init_layer() " {{
  " 1.init vars
  cal s:init_vars()
  " 2.read user config
  cal s:load_user_config()
  " 3.init available_layers
  cal s:init_available_layers()
  " 4.load layers
  cal s:load_layers()
  " 5.init plugin manager
  let s:status = 'pluginManage'
  cal s:init_plugin_manager()
  " 6.call layer after function
  let s:status = 'after'
  cal s:call_layer_after(s:using_layers)
  " 7.finish
  let s:status = 'finish'
endf " }}

" User interface {{
" Functions
fu! s:show_layer_info() " {{2
  ec '[layer#layer_dir]'
  for i in g:layer#layer_dir
    ec '    ' . i
  endfo
  ec "\n"
  ec "[Layer#plugin Manager]"
  ec "    " . g:layer#plugin_manager
  ec "\n"
  ec "[Available Layers]"
  ec "    " . string(s:available_layers)
  ec "\n"
  ec '[Use Layer]'
  ec "    " . string(g:layer#use_layers)
  ec "\n"
  ec '[Loaded Layer]'
  ec "    " . string(s:loaded_layers)
  ec "\n"
  ec "[Using Layer]"
  for i in s:using_layers
    ec "    " . string(i)
  endfo
  ec "\n"
  ec "[Layer Plugin]"
  for i in s:layer_plugins
    ec "    " . string(i)
  endfo
  ec "\n"
  ec "[Layer Without After Function]"
  ec "    " . string(s:layer_with_no_after)
  ec "\n"
  ec "[Disabled Layer]"
  ec "    " . string(s:disabled_layers)
  ec "\n"
  ec "[Options]"
  if g:layer#ignore_reduplicate
    ec "    ignore_repetition"
  en
  if g:layer#ignore_invalid_layer
    ec "    ignore_invalid_layer"
  en
  ec "\n"
endf " 2}}
fu! s:add_layer_dir(...) " {{2
  for dir in a:000
    cal s:add_a_layer_dir(dir)
  endfo
endf " 2}}
fu! s:use_layer_dir(...) " {{2
  let g:layer#layer_dir = []
  for dir in a:000
    cal s:add_a_layer_dir(dir)
  endfo
endf " 2}}
fu! s:add_a_layer_dir(dir) " {{2
  let dir = expand(g:layer#vimfile.a:dir)
  if isdirectory(dir)
    call add(g:layer#layer_dir, dir)
    retu
  en
  let dir = expand(a:dir)
  if isdirectory(dir)
    call add(g:layer#layer_dir, dir)
    retu
  en
  call s:info('Specified layer dir ['.a:dir."] doesn't exists.")
endf " 2}}
fu! s:use_default_layer_dir() " {{2
  let g:layer#layer_dir = [g:layer#vimfile.'layer/base', g:layer#vimfile.'layer/plugin', g:layer#vimfile.'layer/extension',]
endf " 2}}
fu! s:edit_layer(layer_name) " {{2
  let layer = s:search_layer(s:using_layers, a:layer_name)
  if s:is_obj_valid(layer)
    exe 'vsp '.layer.path
  el
    call s:err('Layer ['.a:layer_name."] doesn't exists.")
  en
endf " 2}}
fu! s:search_layer(layers, layer_name) " {{2
  let ret = ''
  for layer in a:layers
    if layer.name == a:layer_name
      let ret = layer
      break
    el
      let ret =  s:search_layer(layer.layers, a:layer_name)
      if s:is_obj_valid(ret) | break | en
    en
  endfo
  return ret
endf " 2}}
fu! s:complete_loaded_layers(a, l, p) " {{2
  " TODO: this should show all available layers
  " custom complete func for EditLayer
  retu filter(copy(s:loaded_layers), 'v:val=~"'.a:a.'"')
endf " 2}}
fu! s:create_layer(...) " {{2
  let filename = a:0 == 0 ? input("Input a layer name: ") : a:1
  let filename = filename !~ '\.vim$' ? filename . '.vim' : filename
  echo "Which layer-dir would you like to store this file?"
  let ans = inputlist(g:layer#layer_dir)
  if ans == '' || ans > len(g:layer#layer_dir)
    retu
  end
  let path = g:layer#layer_dir[ans-1]
  let filepath = path . (path !~ '/$' && path !~ '\\$' ? '/' : '') . filename
  exe 'vsp '.filepath
endf " 2}}

" Commands {{2
com! -nargs=1 UseLayer cal add(g:layer#use_layers, <args>)
" ShowUsingLayers
com! -nargs=0 LayerInfo cal s:show_layer_info()
com! -nargs=0 UsePlug let g:layer#plugin_manager = 'plug'
com! -nargs=0 UseDein let g:layer#plugin_manager = 'dein'

com! -nargs=+ AddLayerDir call s:add_layer_dir(<args>)
com! -nargs=+ UseLayerDir call s:use_layer_dir(<args>)

com! -nargs=0 LayerConfig exe 'vsp '.g:layer#config_abs
com! -complete=customlist,s:complete_loaded_layers -nargs=1 EditLayer 
      \ call s:edit_layer(<f-args>)
com! -nargs=? NewLayer call s:create_layer(<f-args>)
" 2}}
" }}

" Layer development interface {{1
fu! s:layer_plugin(repo, ...) " {{2
  " Param: string, map(plug-option), map(dein-option)
  let p = s:mk_plugin(a:repo)
  if a:0 > 0 | let p.plug_option = a:1 | en
  if a:0 > 1 | let p.dein_options = a:2 | en
  if a:0 > 2 | cal s:err('LayerPlugin accept no more than 3 parameters') | en
  cal add(g:current_layer.plugins, p)
endf " 2}}
fu! s:dep_layers(...) " {{2
  " Param: one or more string
  " Note: check dependency and confliction when load layers
  if index(a:000, g:current_layer.name) != -1
    call s:err('Layer ' . g:current_layer.name . ' can not depend on itself.')
    retu
  en
  let g:current_layer.dep_layers += a:000
endf " 2}}
fu! s:layer_when(expression) " {{2
  " Param: string
  let g:current_layer.when = a:expression
endf " 2}}
fu! s:conflict_layer(...) " {{2
  " Param: one or more string
  " Note: check dependency and confliction when load layers
  if index(a:000, g:current_layer.name) != -1
    call s:err('Layer ' . g:current_layer.name . ' can not conflict with itself.')
    retu
  en
  let g:current_layer.conflict_layers += a:000
endf " 2}}
fu! s:layer_after(after) " {{2
  " Param: string
  let g:current_layer.after = g:current_layer.name . '#' . a:after
endf " 2}}
fu! s:sub_layers(...) " {{2
  " Param: one or more string
  " Note: check dependency and confliction when load layeas
  if index(a:000, g:current_layer.name) != -1
    call s:err('Layer ' . g:current_layer.name . ' can not contain itself as sub-layer.')
    retu
  en
  let g:current_layer.layers += a:000
endf " 2}}

" Commands {{2
com! -nargs=1 LayerPlugin cal s:layer_plugin(<args>)
com! -nargs=1 LayerWhen cal s:layer_when(<args>)
com! -nargs=1 LayerAfter cal s:layer_after(<args>)
com! -nargs=+ LayerSubLayers cal s:sub_layers(<args>)

com! -nargs=+ DepLayers cal s:dep_layers(<args>)
com! -nargs=+ ConflicLayers cal s:conflict_layer(<args>)
" 2}}
" 1}}

" Functions {{
" Init layer functions
fu! s:init_vars() " {{2
  " var with default value
  filetype plugin indent on        " 自动指定文件类型、缩进
  syntax on                        " 开启语法高亮
  if !exists('g:layer#vimfile')
    let g:layer#vimfile = split(&rtp, ',')[0]
  en
  if !exists('g:layer#config_abs')
    if !exists('g:layer_config')
      let g:layer#config = 'layer.vim'
    en
    let g:layer#config_abs = expand(g:layer#vimfile . 'layer.vim')
  en

  " Public var
  let g:layer#vimfile = g:layer#vimfile . (g:layer#vimfile !~ '/$' && g:layer#vimfile !~ '\\$' ? '/' : '')
  " will find layer in these dirs
  let g:layer#layer_dir = []
  " plugin manager, support plug(vim-plug) and dein(dein.vim), use vim-plug default 
  let g:layer#plugin_manager = ''
  " layers will be used
  let g:layer#use_layers = []

  " Private var
  let s:available_layers = []         " all layers found in g:layer#layer_dir
  let s:layer_plugins = []            " all plugins define by using layer
  let s:status = 'init'               " init/pluginManager/after/finish
  let s:using_layers = []             " layers is used naw
  let s:loaded_layers = []            " layers has been loaded
  let s:layer_with_no_after = []      " layers with no after function in loaded layers
  let s:disabled_layers = []          " layers which declareed but not using, layer.when == 0

  " Options
  let g:layer#ignore_reduplicate = 0   " if set to 1, will not reminder user about reduplicate loading
  let g:layer#ignore_invalid_layer = 0 " if set to 1, will not reminder user about invalid layer

endf " 2}}
fu! s:load_user_config() " {{2
  if !s:try_load_abs(g:layer#config_abs)
    call s:info("The layer config [" . g:layer#config_abs . "] is'n readable.")
  en
endf " 2}}
fu! s:init_available_layers() " {{2
  if len(g:layer#layer_dir) == 0
    " use default layer_dir
    call s:use_default_layer_dir()
  en
  " Note: layer with the same name is allowed, user can override default layers
  for dir in g:layer#layer_dir
    let s:available_layers += map(split(layer#ls(dir)), 'fnamemodify(v:val, ":r")')
  endfo
endf " 2}}
fu! s:load_layers() " {{2
  for layer in g:layer#use_layers
    let layer_obj = s:load_layer(layer)
    " Note: check dependency and confliction for layers
    if s:is_layer_valid(layer_obj)
      if s:is_layer_loaded(layer_obj)
        if !g:layer#ignore_reduplicate
          call s:info('Found layer ['.layer_obj.name.'] has been loaded but declare again.')
        en
        con
      en
      cal add(s:using_layers, layer_obj)
      cal add(s:loaded_layers, layer_obj.name)
    el
      call s:err('layer [' . layer . '] is not available.')
    en
  endfo
endf " 2}}
fu! s:init_plugin_manager() " {{2
  try
    if g:layer#plugin_manager == ''
      let g:layer#plugin_manager = 'plug'
    en
    " cal init_plug() or call InitDein()
    exe 'cal s:init_' . g:layer#plugin_manager . '()'
  cat /^Vim\%((\a\+)\)\=:E117/
    call s:err('Unsupport plugin manager ' . g:layer#plugin_manager)
  endt
endf " 2}}
fu! s:call_layer_after(layers) " {{2
  " Param: list
  for layer in a:layers
    " 1.sub layers
    cal s:call_layer_after(layer.layers)
    " 2.current layer
    if layer.load
      try
        if layer.after == ''
          exe 'cal '.layer.name.'#after'.'()'
        el
          exe 'cal ' . layer.after . '()'
        en
      cat /^Vim\%((\a\+)\)\=:E117/
        " ignore
        call add(s:layer_with_no_after, layer.name)
      endt
    en
  endfo
endf " 2}}

" Private functions
fu! s:mk_layer() " {{2
  " A layer object:
  " 'layer': {
  "   'name': 'layer_name',
  "   'when': '',  " vim expression return 0 or 1, layer will be load when this value equaal 1
  "   'load': 0,
  "   'path' '',
  "   'after': 'layer_name#after', " after method will be called after all layers have been loaded
  "   'dep_layers': ['layer1', 'layer2'], (dependencies)
  "   'conflict_layers': ['layer3', 'layer4'], " conflict layers
  "   'plugins': [ " layer can contain plugins
  "     {'repo', 'repo1', 'plug_option': {}, 'dein_options', {} },
  "     {'repo', 'repo2', 'plug_option': {}, 'dein_options': {} }
  "   ],
  "   'layers': [ " layer can contain other layers
  "     'layer1', 'layer2'
  "   ]
  " }
  retu {'name': '', 'when': '', 'load': 0,'path': '', 'after': '', 'dep_layers': [], 'conflict_layers': [], 'plugins': [], 'layers': []}
endf " 2}}
fu! s:mk_plugin(...) " {{2
  " Param: string, dictionary, dictionary
  if a:0 == 0
    retu {'repo': '', 'plug_option': {}, 'dein_options': {} }
  elsei a:0 == 1
    retu {'repo': a:1, 'plug_option': {}, 'dein_options': {} }
  elsei a:0 == 2
    retu {'repo': a:1, 'plug_option': a:2, 'dein_options': {} }
  el
    retu {'repo': a:1, 'plug_option': a:2, 'dein_options': a:3 }
  en
endf " 2}}
fu! s:load_layer(layer_name) " {{2
  " Source layer file and get layer information as a map
  " Every layer is loaded by this function
  " Param: string
  " Return: layer_obj or 0, layer may be 0, sub layer won't be 0
  for dir in g:layer#layer_dir
    let path = expand(dir . (dir !~ '/$' && dir !~ '\\$' ? '/' : '') . a:layer_name . '.vim')
    let g:current_layer = s:mk_layer()
    let g:current_layer.name = a:layer_name

    if s:try_load_abs(path)
      let result = g:current_layer
      unl g:current_layer

      " deal with sub-layer
      let sub_layers = []
      for layer in result.layers
        let sub_layer = s:load_layer(layer)
        " Note: check dependency and confliction for sub layers
        if s:is_layer_valid(sub_layer)
          " check repetition
          if s:is_layer_loaded(sub_layer)
            if !g:layer#ignore_reduplicate
              call s:info('When load ['.result.name.'] found sub-layer ['.sub_layer.name.'] has been loaded.')
            en
            con
          en
          cal add(sub_layers, sub_layer)
          cal add(s:loaded_layers, sub_layer.name)
        el
          call s:err('sub-layer [' . layer . '] is not available.')
        en
      endfo
      let result.layers = sub_layers
      let result.path = path
      retu result
    en
  endfo
  retu 0
endf " 2}}

" Judgement
fu! s:is_obj_valid(obj) " {{2
  " when use map as obj, len == 0 mean invalid 
  retu len(a:obj) > 1
endf " 2}}
fu! s:is_layer_valid(layer) " {{2
  " Param: layer_obj
  " check layer's dependency and confliction
  if !s:is_obj_valid(a:layer)
    call s:info('Because can not found layer, so')
    retu 0
  en
  for l in a:layer.dep_layers
    if index(s:loaded_layers, l) == -1
      call s:info('Because the dependent layer [' . l .'] has not been loaded, so')
      retu 0
    en
  endfo
  for l in a:layer.conflict_layers
    if index(s:loaded_layers, l) != -1
      call s:info('Because the conflicion layer [' . l .'] has been loaded, so')
      retu 0
    en
  endfo
  for l in a:layer.layers
    if !s:is_layer_valid(l)
      call s:info('Because the sub-layer [' . l .'] is not valid, so')
      retu 0
    en
  endfo
  retu 1
endf " 2}}
fu! s:clean_disabled_layer(layers) " {{2
  " remove disabled layer from given list and g:loaded_layers,
  " then add their name to s:disabled_layers
  " Param: layer_obj list
  for i in reverse(range(len(a:layers)))
    let l = a:layers[i]
    " clean sub-layers
    cal s:clean_disabled_layer(l.layers)
    " clean itself
    if !l.load
      cal add(s:disabled_layers ,remove(a:layers, i).name)
      cal remove(s:loaded_layers, index(s:loaded_layers, l.name))
    en
  endfo
endf " 2}}

" Message and tostring
fu! s:err(msg) " {{2
  echohl Error
  echom '[layer] ' . a:msg
  echohl None
endf " 2}}
fu! s:info(msg) " {{2
  echohl Comment
  echom '[layer] ' . a:msg
  echohl None
endf " 2}}
fu! s:is_layer_loaded(layer_obj) " {{2
  " return whether a layer in s:loaded_layers
  retu index(s:loaded_layers, a:layer_obj.name) != -1
endf " 2}}

" Useful functions
"  fu! s:try_load(file) try load a .vim file from your vim config dir {{2
let s:scripts_load_time = {}
fu! s:try_load(file)
  " Param: string(eg. betterdefalut, extension.vim, ...)
  let filename = a:file !~ '\.vim$' ? a:file . '.vim' : a:file
  retu s:try_load_abs(expand(g:layer#vimfile . filename))
endf
fu! s:try_load_abs(path)
  " Param: string
  let s:scripts_load_time[a:path] = 0
  if filereadable(a:path)
    let s:scripts_load_time[a:path] = reltime()[1]
    exe 'source ' . a:path
    let s:scripts_load_time[a:path] = (reltime()[1] - s:scripts_load_time[a:path]) / 1000000.0
    retu 1
  en
  retu 0
endf " 2}}
fu! layer#ls(...) " ls on unix and dir on win {{2
  let path = expand(a:0 == 0 ? '.' : a:1)
  retu has('win32') || has('win64') ? system('dir /b ' . path) : system('ls ' . path)
endf " 2}}

" Apis
fu! layer#is_layer_loaded(layer_name) " {{2
  " return whether a layer in s:loaded_layers
  retu index(s:loaded_layers, a:layer_name) != -1
endf " 2}}

" Commands {{2
com! -nargs=0 ShowScripts for k in keys(s:scripts_load_time) | ec k . " : " . string(s:scripts_load_time[k]) | endfo
" 2}}

" }}

" Plugin Manager {{
fu! s:init_plug() " {{2
  cal plug#begin(expand(g:layer#vimfile.'plugged'))
  for layer in s:using_layers
    cal s:plug_parse_layer(layer)
  endfo
  cal plug#end()

  cal s:clean_disabled_layer(s:using_layers)
endf " 2}}
fu! s:plug_parse_layer(layer) " {{2
  " when
  if a:layer.when != ''
    exe "if !(".a:layer.when.") | retu | en"
  en
  " 1.sub-layer recursive
  for layer in a:layer.layers
    if s:is_obj_valid(layer)
      cal s:plug_parse_layer(layer)
    en
  endfo
  " 2.plugin
  let s:layer_plugins += a:layer.plugins
  for plugin in a:layer.plugins
    if s:is_obj_valid(plugin)
      exe "Plug '" . plugin.repo . "', " . string(plugin.plug_option)
      " call add(s:layer_plugins, plugin.repo)
    en
  endfo
  let a:layer.load = 1
endf " 2}}

fu! s:init_dein() " {{2
endf " 2}}
fu! s:dein_parse_layer(layer) " {{2
endf " 2}}
" }}

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: sw=2 ts=2 sts=2 fmr={{,}} fdm=marker nospell:
