fu! config#markdown_preview_nvim#after()
  if g:is_osx
    let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
    " path to the chrome or the command to open chrome(or other modern browsers)
  elseif g:is_linux
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
