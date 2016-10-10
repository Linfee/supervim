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
    装了chrome即可)，你需要在`~/.vim/custom.vim`中添加这一句，否则你就不能在浏览器
    中预览markdown。

        let g:mkdp_path_to_chrome = "your browser command"

-   [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher),
    不安装你就不能使用 `Ag` 搜索。查看上面的网址来安装它。

-   Ctags, 不安装你将不能使用tags相关的功能。

-   jedi，python补全，没有安装将不能使用python补全，使用`pip install jedi`安装

-   autopep8，用于python的pep8格式化，使用`pip install autopep8`安装

-   flake8，用于python语法检查，使用`pip install flake8`安装

### Linux和Mac上安装

如果你的环境已经满足了必须依赖，直接执行下面的命令
__注意:__如果你不希望丢失你现有的vim配置，请先备份它们。包括`~/.vimrc`和`~/.vim/`

    curl https://raw.githubusercontent.com/Linfee/supervim/master/bin/install.sh -o /tmp/install.sh && bash /tmp/install.sh

### windows上安装

敬请期待

### 安装完成

supervim使用特殊字体来显示文件类型等图标，你需要安装这些字体来使这些图标显示正常，
安装完成后再安装`~/.vim/supervim/fonts`下的字体，并设置终端字体为刚安装的字体，
终端下图标将显示正常，gvim安装完字体就会显示正常。

__注意__: 如果你更换了字体，可能导致这些图标显示不正常，如果你想更换别的字体，可以
从[_这里_](https://github.com/ryanoasis/nerd-fonts)找到。如果你不想使用这项功能，
可以在`~/.vim/before.vim`中添加下面这行来关闭该功能，如果没有这个文件，请自己创建。

    let g:s_no_devicons=1

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

### 如果安装脚本执行报错，或者失败怎么办？

首先检查你的必须依赖是否都有了，如果依赖满足，国内的同胞们多半是网络不好，下载插件
失败，请把手头的代理技术用起来，重新安装。PS: 如果下载失败，但是看到vim-proc已经
下载成功了，可以重新进vim，执行`:call Init()`来继续。
