" Supervim.layer
" For markdown
let layer.plugins += [['godlygeek/tabular',
      \ {'on_cmd': ['Tabularize', 'AddTabularPattern', 'AddTabularPipeline']}]]
let layer.plugins += ['plasticboy/vim-markdown'] " no plugin dir, no need to lazyload
let layer.plugins += [['iamcco/markdown-preview.vim',
      \ {'on_ft': 'markdown', 'on_cmd': 'MarkdownPreview'}]]

" before
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0

let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_emphasis_multiline = 0
" let g:vim_markdown_conceal = 0
let g:vim_markdown_fenced_languages = ['java=java', 'sh=sh', 'xml=xml', 'js=javascript']


" after
fu! markdown#after()
  " for vim-markdown
  " let g:vim_markdown_folding_style_pythonic = 1
  let g:vim_markdown_override_foldtext = 1
  " let g:vim_markdown_toc_autofit = 1
  let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
  " Syntax extensions
  let g:vim_markdown_json_frontmatter = 1
  let g:vim_markdown_new_list_item_indent = 2
  " let g:vim_markdown_no_extensions_in_markdown = 1
  let g:vim_markdown_autowrite = 1


  " for markdown-preview
  if IsOSX()
    let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
    " path to the chrome or the command to open chrome(or other modern browsers)
  elseif IsLinux()
    if executable('chrome')
      let g:mkdp_path_to_chrome = "chrome"
    elseif executable('chromium')
      let g:mkdp_path_to_chrome = "chromium"
    elseif executable('chromium-browser')
      let g:mkdp_path_to_chrome = "chromium-browser"
    endif
  else " for win
    if executable('chrome')
      let g:mkdp_path_to_chrome = "chrome"
    else
      let g:mkdp_path_to_chrome = 'C:\Program Files (x86)\Google\Chrome\Application\chrome'
    endif
  endif
  " path to the chrome or the command to open chrome(or other modern browsers)
  let g:mkdp_auto_start = 0
  " set to 1, the vim will open the preview window once enter the markdown
  " buffer
  let g:mkdp_auto_open = 0
  " set to 1, the vim will auto open preview window when you edit the
  " markdown file
  let g:mkdp_auto_close = 1
  " set to 1, the vim will auto close current preview window when change
  " from markdown buffer to another buffer
  let g:mkdp_refresh_slow = 0
  " set to 1, the vim will just refresh markdown when save the buffer or
  " leave from insert mode, default 0 is auto refresh markdown as you edit or
  " move the cursor
  let g:mkdp_command_for_global = 0
  " set to 1, the MarkdownPreview command can be use for all files,
  " by default it just can be use in markdown file vim-instant-markdown
endf
