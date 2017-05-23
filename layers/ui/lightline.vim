" Layer: lightline
scriptencoding utf8
let layer.plugins += [['itchyny/lightline.vim']]


fu! lightline#after()
  let g:lightline = {
        \ 'colorscheme': 'gruvbox',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive','readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'readonly': 'LightlineReadonly',
        \   'modified': 'LightlineModified',
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'filetype': 'LightlineFiletype',
        \   'fileformat': 'LightlineFileformat',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode',
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \ },
        \ }

  fu! LightlineModified()
    retu &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endf
  fu! LightlineReadonly()
    retu &ft !~? 'help' && &readonly ? 'RO' : ''
  endf
  fu! LightlineFilename()
    let fname = expand('%:t')
    retu fname == '__Tagbar__' ? g:lightline.fname :
          \ fname =~ '__Gundo\|NERD_tree' ? '' :
          \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' != fname ? fname : '[No Name]') .
          \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
  endf
  fu! LightlineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = ''  " edit here for cool mark
        let branch = fugitive#head()
        retu branch !=# '' ? mark.branch : ''
      en
    catch
    endtry
    retu ''
  endf
  if !exists('*LightlineFileformat')
    fu LightlineFileformat()
      retu winwidth(0) > 70 ? &fileformat : ''
    endf
  en
  if !exists('*LightlineFiletype')
    fu LightlineFiletype()
      retu winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
    endf
  en
  fu! LightlineFileencoding()
    retu winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endf
  fu! LightlineMode()
    let fname = expand('%:t')
    retu fname == '__Tagbar__' ? 'Tagbar' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endf
  let g:tagbar_status_func = 'TagbarStatusFunc'
  fu! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    retu lightline#statusline(0)
  endf
  augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
  augroup END
  fu! s:syntastic()
    SyntasticCheck
    call lightline#update()
  endf
endf
