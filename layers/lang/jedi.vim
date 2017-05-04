" Layer: jedi
" for python completion

let layer.plugins += [['davidhalter/jedi-vim',
      \ {'on_ft': 'python', 'on_event': 'InsertEnter'}]]

fu! jedi#after()
  " for jedi
  " jedi 补全快捷键, 有补全插件就不需要了
  " let g:jedi#completions_command = "<c-n>"
  let g:jedi#goto_command = "<leader>d"
  let g:jedi#goto_assignments_command = "<leader>g"
  let g:jedi#documentation_command = "K"
  let g:jedi#max_doc_height = 15
  let g:jedi#rename_command = "<leader>r"
  let g:jedi#usages_command = "<leader>n"
  " 在vim中打开模块(源码) :Pyimport
  let g:jedi#auto_initialization = 1
  " 关掉jedi的补全样式，使用自定义的
  let g:jedi#auto_vim_configuration = 0
  " 输入点的时候自动补全
  let g:jedi#popup_on_dot = 1
  " 自动选中第一个
  " let g:jedi#popup_select_first = 0
  " 补全结束后自动关闭文档窗口
  let g:jedi#auto_close_doc = 1
  " 显示参数列表
  let g:jedi#show_call_signatures = 1
  " 延迟多久显示参数列表
  let g:jedi#show_call_signatures_delay = 300
  " 使用go to的时候使用tab而不是buffer
  let g:jedi#use_tabs_not_buffers = 1
  " 指定使用go to使用split的方式，并指定split位置
  let g:jedi#use_splits_not_buffers = 'bottom'
  " 强制使用python3运行jedi
  let g:jedi#force_py_version = 3
  " 自动完成from .. import ..
  let g:jedi#smart_auto_mappings = 1
endf
