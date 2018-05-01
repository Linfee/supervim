fu! config#fzf_vim#before()
  " This is the default extra key bindings
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }

  " Default fzf layout
  " - down / up / left / right
  let g:fzf_layout = { 'down': '~40%' }

  " In Neovim, you can set up fzf window using a Vim command
  " let g:fzf_layout = { 'window': 'enew' }
  " let g:fzf_layout = { 'window': '-tabnew' }
  " let g:fzf_layout = { 'window': '10split enew' }

  " Customize fzf colors to match your color scheme
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'], 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

  " Enable per-command history.
  " CTRL-N and CTRL-P will be automatically bound to next-history and
  " previous-history instead of down and up. If you don't like the change,
  " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  let g:fzf_history_dir = '~/.local/share/fzf-history'

  " [Buffers] Jump to the existing window if possible
  let g:fzf_buffers_jump = 1

  " [[B]Commits] Customize the options used by 'git log':
  let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

  " [Tags] Command to generate tags file
  let g:fzf_tags_command = 'ctags -R'

  " [Commands] --expect expression for directly executing the command
  let g:fzf_commands_expect = 'alt-enter,ctrl-x'
endf

fu! config#fzf_vim#after()
  " Mapping selecting mappings
  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)

  " Insert mode completion
  imap <c-x><c-k> <plug>(fzf-complete-word)
  imap <c-x><c-f> <plug>(fzf-complete-path)
  imap <c-x><c-j> <plug>(fzf-complete-file-ag)
  imap <c-x><c-l> <plug>(fzf-complete-line)

  " Advanced customization using autoload functions
  inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

  " Replace the default dictionary completion with fzf-based fuzzy completion
  " inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

  function! s:make_sentence(lines)
    return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
  endfunction

  inoremap <expr> <c-x><c-s> fzf#complete({
    \ 'source':  'cat /usr/share/dict/words',
    \ 'reducer': function('<sid>make_sentence'),
    \ 'options': '--multi --reverse --margin 15%,0',
    \ 'left':    20})

  fu! s:fzf_statusline()
    " Override statusline as you like
    " highlight fzf1 ctermfg=161 ctermbg=251
    " highlight fzf2 ctermfg=23 ctermbg=251
    " highlight fzf3 ctermfg=237 ctermbg=251
    if !g:is_osx
      setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    else
      let &l:stl = '%#fzf1# '.emoji#for('cherry_blossom').' %#fzf2#fz%#fzf3#f'
    endif
  endf

  fu! s:setup_fzf_ft()
    nnoremap <buffer> q :Sayonara<cr>
    setl nonumber
  endf

  augroup fzf
    autocmd!
    autocmd! User FzfStatusLine call <SID>fzf_statusline()
    autocmd! FileType fzf call <SID>setup_fzf_ft()
  augroup END

endf
