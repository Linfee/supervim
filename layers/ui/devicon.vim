" Layer: devicon
" This layer should load after lightline
let layer.plugins += [['ryanoasis/vim-devicons']]

fu! devicon#after()
  let g:airline_powerline_fonts = 1
  let g:vimfiler_as_default_explorer = 1
  " font use double width glyphs
  let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
  " enable open and close folder/directory glyph flags
  let g:DevIconsEnableFoldersOpenClose = 1
  " specify OS to decide an icon for unix fileformat, Darwin for osx
  let g:WebDevIconsOS = 'Darwin'

  " patch font for lightline
  function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction
  " path font for nerd git
  let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

  " nerd icon
  augroup nerdColor
    autocmd!
    " NERDTress File highlighting only the glyph/icon
    " test highlight just the glyph (icons) in nerdtree:
    autocmd FileType nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
    autocmd FileType nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
    autocmd FileType nerdtree highlight go_icon ctermbg=none ctermfg=Red guifg=#ffa500

    autocmd FileType nerdtree syn match haskell_icon ## containedin=NERDTreeFile
    " if you are using another syn highlight for a given line (e.g.
    " NERDTreeHighlightFile) need to give that name in the 'containedin' for this
    " other highlight to work with it
    autocmd FileType nerdtree syn match html_icon ## containedin=NERDTreeFile,html
    autocmd FileType nerdtree syn match go_icon ## containedin=NERDTreeFile
  augroup END

  if g:is_gui
    if g:is_win()
      set guifont=SauceCodePro\ NF:h9
    elsei g:is_osx()
      set guifont=SauceCodePro\ NF:h11
    else
      set guifont=SauceCodePro\ NF\ 9
    en
  en
endf
