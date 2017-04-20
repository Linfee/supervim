" Layer: fzf
" TODO: finish this layer
echo '[layer] Layer fzf is unfinished'
finish

LayerPlugin 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
LayerPlugin 'junegunn/fzf.vim'

fu! fzf#after()
  " 这三个快捷键指定用什么方式打开选中的内容
  let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  " Default fzf layout
  " - down / up / left / right
  let g:fzf_layout = { 'down': '~40%' }

  " In Neovim, you can set up fzf window using a Vim command
  let g:fzf_layout = { 'window': 'enew' }
  let g:fzf_layout = { 'window': '-tabnew' }

  " 自定义fzf的配色
  let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }

  " Enable per-command history.
  " CTRL-N and CTRL-P will be automatically bound to next-history and
  " previous-history instead of down and up. If you don't like the change,
  " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  let g:fzf_history_dir = '~/.fzf-history'

  " 自定义命令选项
  " [Files] 使用Files命令时使用coderay来预览文件内容(http://coderay.rubychan.de/)
  let g:fzf_files_options =
        \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
  " [Buffers] 使用Buffers命令时如果可能的话自动跳到目标窗口，而不是新打开一个
  let g:fzf_buffers_jump = 1
  " [[B]Commits] 使用[B]Commit时自定义git log输出形式
  let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
  " [Tags] 生成tags文件的命令
  let g:fzf_tags_command = 'ctags -R'
  " [Commands] 使用Commands时候直接执行选中命令的快捷键
  let g:fzf_commands_expect = 'alt-enter, ctrl-x'

  " maps
  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)
  " Insert mode completion
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)
  " Advanced customization using autoload functions
  " inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
  " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

  " status line
  if has('nvim')
    function! s:fzf_statusline()
      " Override statusline as you like
      highlight fzf1 ctermfg=161 ctermbg=251
      highlight fzf2 ctermfg=23 ctermbg=251
      highlight fzf3 ctermfg=237 ctermbg=251
      setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction

    autocmd! User FzfStatusLine call <SID>fzf_statusline()
  endif

  " nnoremap <leader>h  :Helptags<cr>
  " nnoremap <leader>gf :GFiles?<cr>
  " nnoremap <leader>gl :GFiles<cr>
  " nnoremap <leader>gc :Commits<cr>
  " nnoremap <leader>gb :VCommits<cr>
  " nnoremap <leader>gg :Lines<cr>
  " nnoremap <leader>G  :BLines<cr>
  " nnoremap <leader>fs :Snippets<cr>
  " nnoremap <leader>fm :Maps<cr>
  " nnoremap <leader>fh :History<cr>
  " nnoremap <leader>f: :History:<cr>
  " nnoremap <leader>f/ :History/<cr>
  " nnoremap <leader>ff :Ag<cr>
  " nnoremap <leader>fb :Buffers<cr>
  "
  " nnoremap <leader>o :Files<cr>
  " nnoremap <leader>O :Files
  " nnoremap <leader>b :Buffers<cr>
  " nnoremap <leader>a :Ag<cr>
  " nnoremap <leader>l :Lines<cr>

  " Files [PATH]    |  Files (similar to :FZF)
  " GFiles [OPTS]   |  Git files (git ls-files)
  " GFiles?         |  Git files (git status)
  " Buffers         |  Open buffers
  " Colors          |  Color schemes
  " Ag [PATTERN]    |  ag search result (ALT-A to select all, ALT-D to deselect all)
  " Lines [QUERY]   |  Lines in loaded buffers
  " BLines [QUERY]  |  Lines in the current buffer
  " Tags [QUERY]    |  Tags in the project (ctags -R)
  " BTags [QUERY]   |  Tags in the current buffer
  " Marks           |  Marks
  " Windows         |  Windows
  " Locate PATTERN  |  locate command output
  " History         |  v:oldfiles and open buffers
  " History:        |  Command history
  " History/        |  Search history
  " Snippets        |  Snippets (UltiSnips)
  " Commits         |  Git commits (requires fugitive.vim)
  " BCommits        |  Git commits for the current buffer
  " Commands        |  Commands
  " Maps            |  Normal mode mappings
  " Helptags        |  Help tags 1
  " Filetypes       |  File types
endf
