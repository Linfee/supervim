# A cool vim configuration

## Install(for most features)

### 1.Install dependence

for linux(fedora):
- `sudo dnf install neovim git curl python3 ctags global fzf the_silver_searcher tmux`
- `pip3 install neovim jedi autopep8 yapf`

for osx:
- first of all, you need have brew
- `brew install neovim git curl python3 ctags global fzf the_silver_searcher tmux`
- `pip3 install neovim jedi autopep8 yapf`

### 2.clone this repo

- clone `git clone --depth=1 https://github.com/Linfee/supervim.git ~/.vim`
- Optional, switch to dev branch `cd .vim && git fetch --depth=1 origin dev:dev && git checkout dev && cd ..`
- let it work for neovim `mkdir -p ~/.config/nvim && echo 'source ~/.vim/vimrc' > ~/.config/nvim/init.vim`

### 3.launch nvim and install plugins

- `nvim`
- execute in nvim `:PlugExInstall`, then wait
  * if it's fail, just restart nvim and execute `:PlugExInstall` again

### 4.Install fonts

- `cp -r ~/.vim/res/fonts ~/supervim_fonts`
- Install fonts in `~/supervim_fonts` by yourself
  * for linux and osx, it's: `Sauce Code Pro Nerd Font Complete Mono.ttf` and `Sauce Code Pro Nerd Font Complete.ttf`
- `rm -rf ~/supervim_fonts`

