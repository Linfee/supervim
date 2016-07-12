#!/bin/sh

echo 'set runtimepath+=~/.vim

source ~/.vim/supervim/basic.vim
source ~/.vim/supervim/plugins_config.vim
source ~/.vim/supervim/filetype.vim
source ~/.vim/supervim/extesion.vim

try
    source ~/.vim/custom.vim
catch
endtry' > ~/.vimrc

echo "OK!"
