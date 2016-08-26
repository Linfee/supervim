#!/bin/sh

rm -rf ~/.vim ~/.vimrc

mkdir ~/.vim

git clone git@github.com:Linfee/supervim.git ~/.vim/supervim

curl -fLo ~/.vim/supervim/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo 'set runtimepath+=~/.vim

source ~/.vim/supervim/basic.vim
endtry' > ~/.vimrc

echo "Done"

vim -u ~/.vim/supervim/basic.vim -c 'call Init()'

cd ~/.vim/plugged/vimproc.vim

make

echo '
colorscheme molokai
' >> ~/.vim/custom.vim
