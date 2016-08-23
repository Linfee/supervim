#!/bin/sh

rm -rf ~/.vim ~/.vimrc

curl -fLo ~/.vim/supervim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cd ~/.vim
git clone https://github.com/Linfee/supervim.git

echo 'set runtimepath+=~/.vim

source ~/.vim/supervim/basic.vim

try
    source ~/.vim/custom.vim
catch
endtry' > ~/.vimrc

echo "Done"

vim -c PlugInstall
