# A cool vim configuration

这个分支版本尝试做些优化，提高启动速度

## 安装

### 必须依赖

-   Vim7.4 +
-   Vim +python or +python3, +lua
-   Git, curl, make

### 非必须依赖

-   Vim +clipboard, 为了和系统共享剪切板。

-   The google-chrome or chromium-browser, 如果你的path中没有这些命令，你需要在
    `~/.vim/custom.vim`中添加这一句，否则你就不能在浏览器中预览markdown。

        let g:mkdp_path_to_chrome = "your browser command"

-   [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher),
    不安装你就不能使用 `Ag` 搜索。查看上面的网址来安装它。

-   Ctags, 不安装你将不能使用tags相关的功能。

### Linux和Mac上安装

如果你的环境已经满足了必须依赖，直接执行[这个脚本](https://github.com/Linfee/supervim/blob/master/bin/install.sh)，
__注意:__如果你不希望丢失你现有的vim配置，请先备份它们。包括`~/.vimrc`和`~/.vim/`
