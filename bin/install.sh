#!/bin/sh
echo 'set runtimepath+=~/.vim

source ~/.vim/supervim/basic.vim

try
    source ~/.vim/custom.vim
catch
endtry' > ~/.vimrc

echo "OK!"
