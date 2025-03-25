--                                       _
--     ___ _   _ _ __  ___ _ ___.__   __(_)_ __ ___
--    / __| | | | '_ \/ _ \ '__/ \ \ / /| | '_ ` _ \
--    \__ | |_| | |_) | __/ |     \ V / | | | | | | |
--    |___/\___/| .__/\___|_|      \_/  |_|_| |_| |_|
--              |_|
--
-- Author: Linfee
-- REPO:   https://github.com/Linfee/supervim
-- Layer: BetterDefault

-- --------------------------------------
-- better default
-- --------------------------------------

vim.o.compatible = false                 -- 关闭vi兼容性
vim.cmd('filetype plugin indent on')     -- 自动指定文件类型、缩进
vim.cmd('syntax on')                     -- 开启语法高亮

vim.o.encoding = 'utf8'
vim.o.scriptencoding = 'utf-8'
vim.o.number = true                      -- 显示绝对行号
vim.o.relativenumber = true              -- 显示相对行号
vim.o.mouse = ''                         -- 允许使用鼠标
vim.o.mousehide = true                   -- 输入时隐藏鼠标
vim.o.virtualedit = 'onemore'            -- 虚拟编辑意味着光标可以定位在没有实际字符的地方
vim.o.history = 1000                     -- 设置命令行历史记录
vim.o.shortmess = vim.o.shortmess .. 'cfilmnrxoOtT' -- 避免一部分 hit enter 的提示
vim.o.showmode = false                   -- 不显示模式，由插件显示模式
-- vim.o.swapfile = false                -- 不要使用swp文件做备份
vim.o.hidden = true                      -- 隐藏缓冲区而不是卸载缓冲区
vim.o.backspace = 'indent,eol,start'     -- 删除在插入模式可以删除的特殊内容
vim.o.laststatus = 2                     -- 最后一个窗口总有状态行
vim.o.wildmode = 'list:longest,full'     -- 设置命令行模式补全模式
vim.o.foldcolumn = '2'                   -- 在左端添加额外折叠列
vim.o.winminheight = 0                   -- 窗口的最小高度
vim.o.tabpagemax = 15                    -- 最多打开的标签数目
vim.o.scrolljump = 1                     -- 光标离开屏幕时(比如j)，最小滚动的行数，这样看起来舒服
vim.o.scrolloff = 5                      -- 使用j/k的时候，光标到窗口的最小行数
vim.o.lazyredraw = true                  -- 执行完宏之后不要立刻重绘
vim.o.linespace = 0                      -- 设置行间距
vim.o.whichwrap = 'b,s,h,l,<,>,[,]'      -- 左右移动光标键可以移动到的额外虚拟位置
vim.o.autoread = true                    -- 当文件被改变时自动载入
vim.o.cursorline = true                  -- 高亮显示当前行
-- vim.o.cursorcolumn = true             -- 高亮显示当前列
-- vim.o.cmdheight = 2                   -- 命令行高度
vim.o.fileformats = 'unix'               -- 文件类型(使用的结尾符号)
-- vim.o.confirm = true                  -- 退出需要确认
vim.o.synmaxcol = 200

vim.o.list = true
vim.o.magic = true

-- 新的分割窗口总是在右边和下边打开
vim.o.splitright = true
vim.o.splitbelow = true

-- 显示配对的括号，引号等，以及显示时光标的闪烁频率
vim.o.showmatch = true
vim.o.matchtime = 2

-- 关掉错误声音，这个设置仅仅对gui有效
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.t_vb = ''
vim.o.timeoutlen = 500

-- 命令行补全和忽略补全的文件类型
vim.o.wildmenu = true
vim.o.wildignore = '*.o,*~,*.pyc,*.class'
vim.o.wildignore = vim.o.wildignore .. ',*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,.git*,.hg*,.svn*'
vim.o.wildignore = vim.o.wildignore .. ',*.sw*'
-- 防止连接命令时，在 '.'、'?' 和 '!' 之后插入两个空格。如果 'cpoptions'
-- vim.o.joinspaces = false
vim.o.cpoptions = vim.o.cpoptions

-- 让vim和系统共享默认剪切板
if vim.fn.has('clipboard') == 1 then
  if vim.fn.has('unnamedplus') == 1 then -- When possible use + register for copy-paste
    vim.o.clipboard = 'unnamed,unnamedplus'
  else -- On mac and Windows, use * register for copy-paste
    vim.o.clipboard = 'unnamed'
  end
end

-- --------------------------------------
-- format
-- --------------------------------------
vim.o.wrap = false                       -- 不要软换行
vim.o.formatoptions = vim.o.formatoptions:gsub('t', '') -- 输入的时候不要自动软换行
vim.o.autoindent = true                  -- 自动缩进
vim.o.expandtab = true                   -- 将制表符扩展为空格
vim.o.smarttab = true                    -- 只能缩进
vim.o.shiftwidth = 4                     -- 格式化时制表符占几个空格位置
vim.o.tabstop = 4                        -- 编辑时制表符占几个空格位置
vim.o.softtabstop = 4                    -- 把连续的空格看做制表符
vim.o.matchpairs = vim.o.matchpairs .. ',<:>' -- 设置形成配对的字符
vim.o.spell = false                      -- 默认不要开启拼写检查
vim.o.foldenable = true                  -- 基于缩进或语法进行代码折叠
vim.o.linebreak = true
vim.o.textwidth = 500

-- --------------------------------------
-- look and feel
-- --------------------------------------
vim.o.ignorecase = true                  -- 搜索时候忽略大小写
vim.o.smartcase = true                   -- 智能匹配大小写
vim.o.hlsearch = true                    -- 高亮显示搜索结果
vim.o.incsearch = true                   -- 使用增量查找
vim.o.colorcolumn = '80,120'             -- 80列和120列参考线
vim.cmd('highlight ColorColumn ctermbg=233')
vim.o.guicursor = 'a:block-blinkon0'     -- 让gui光标不要闪
vim.cmd('highlight clear SignColumn')    -- 高亮列要匹配背景色
vim.cmd('highlight clear LineNr')        -- 移除当前行号处的高亮色
vim.cmd('highlight clear CursorLineNr')  -- 删掉当前行号上的高亮

-- 高亮某些特殊位置的特殊字符
vim.o.listchars = 'tab:\\|\\ ,trail:.,nbsp:.,extends:#,precedes:#'
-- vim.o.listchars = 'tab:\\|\\ ,trail:.,nbsp:.,extends:#,precedes:#,eol:$'

if vim.fn.has('gui_running') == 0 and vim.fn.has('win32unix') == 0 then
  if vim.o.term == 'xterm' or vim.o.term == 'screen' then
    -- Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    vim.o.t_Co = 256
  end
end

-- 设置补全菜单样式
vim.o.completeopt = 'longest,menu,preview'

-- --------------------------------------
-- keymap
-- --------------------------------------
-- 使用jk退出插入模式
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap = true})
-- 使用Y复制到行尾
vim.api.nvim_set_keymap('n', 'Y', 'y$', {noremap = true})
-- j/k可以移动到软换行上
vim.api.nvim_set_keymap('n', 'j', 'gj', {noremap = true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {noremap = true})
vim.api.nvim_set_keymap('n', 'gj', 'j', {noremap = true})
vim.api.nvim_set_keymap('n', 'gk', 'k', {noremap = true})

-- H, L移动到行首行尾
vim.api.nvim_set_keymap('n', 'H', '^', {noremap = true})
vim.api.nvim_set_keymap('n', 'L', '$', {noremap = true})

-- vmode下能连续使用 < >
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true})

-- 允许使用 . 对选中的行执行上一个命令
vim.api.nvim_set_keymap('v', '.', ':normal! .<cr>', {noremap = true})

vim.api.nvim_set_keymap('n', 'Q', 'gqap', {noremap = true})
vim.api.nvim_set_keymap('v', 'Q', 'gq', {noremap = true})

-- quick set tab size
vim.cmd([[
  command! -nargs=1 TabSize lua require('scripts.betterdefault').tab_size(<args>)
]])

local M = {}

function M.tab_size(n)
  vim.cmd('setl shiftwidth=' .. n)
  vim.cmd('setl tabstop=' .. n)
  vim.cmd('setl softtabstop=' .. n)
end

return M
