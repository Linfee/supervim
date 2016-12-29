#!/bin/sh

rm -rf ~/.vim ~/.vimrc

mkdir ~/.vim

git clone https://github.com/Linfee/supervim.git ~/.vim

curl -fLo ~/.vim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo 'set runtimepath+=~/.vim

source ~/.vim/basic.vim

' > ~/.vimrc

echo "Done"

vim -u ~/.vim/basic.vim -c 'call Init()'

cd ~/.vim/plugged/vimproc.vim

make
