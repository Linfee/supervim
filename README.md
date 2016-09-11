# A cool vim configuration

```text
                                       _
     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
              |_|
```

## 安装

### 必须依赖

-   Vim7.4 +
-   Vim +python or +python3, +lua (不知道怎么看，点[这里](#user-content-faq))
-   Git, curl, make

### 非必须依赖

-   Vim +clipboard, 为了和系统共享剪切板。

-   google-chrome 或者 chromium-browser, 如果你的path中没有这些命令(如果是mac，安
    装了chrom即可)，你需要在`~/.vim/custom.vim`中添加这一句，否则你就不能在浏览器
    中预览markdown。

        let g:mkdp_path_to_chrome = "your browser command"

-   [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher),
    不安装你就不能使用 `Ag` 搜索。查看上面的网址来安装它。

-   Ctags, 不安装你将不能使用tags相关的功能。

### Linux和Mac上安装

如果你的环境已经满足了必须依赖，直接执行下面的命令
__注意:__如果你不希望丢失你现有的vim配置，请先备份它们。包括`~/.vimrc`和`~/.vim/`

    curl https://raw.githubusercontent.com/Linfee/supervim/master/bin/install.sh -o /tmp/install.sh && bash /tmp/install.sh

### windows上安装

敬请期待

## FAQ

### 我不知道如何查看像 +python 这样的依赖?

在你的终端输入`vim --version`回车，会看到很多输出，找到下面这行，说明已经支持
python3了，其他也是这样，如果看到的是`-python3`说明不支持

    +cscope          +lispindent      +python3         +wildignore

### 如果我没有这些依赖该怎么办?

有些发行版只要把vim和vim-gtk(或vim的其他图形终端)装了，并且系统安装了python等，
vim就会支持这个特性。mac下使用brew安装macvim，并加入相关选项，如下，即可支持这些
特性。Windows下可以寻找别人编译好的具有这些特性的vim包，通常还需要安装python。利
用搜索引擎寻找相关内容，最后，任何系统下都可以自己编译vim，使其支持这些特性。

    brew install macvim --with-cscope --with-lua --override-system-vim
