" let ex#option = {}

" DOC: 将整个缓冲区的缩进置为space或tab
"   以参数'space'或'tab'来调用方法，或者直接定义下面的命令
"   com! -nargs=0 ToSpace call tabAndSpace#ToggleTab('space')
"   com! -nargs=0 ToTab call tabAndSpace#ToggleTab('tab')
" Arg: t 'space'或'tab'
func extension#ToggleTab(t)
    if a:t == 'tab'
        setlocal noexpandtab
        retab!
    elseif a:t == 'space'
        setlocal expandtab
        retab
    endif
endf


" DOC: 执行mybatis generate
"   定义下面的选项即可调用该方法执行mybatis generate
"   g:extension#mybatis_generate_core
"   g:extension#driverPath
func extension#MybatisGenerate()
    if !exists(g:extension#mybatis_generate_core) || !exists(g:extension#driverPath)
        echo "你必须设置 g:extension#mybatis_generate_core 和 g:extension#driverPath 才能运行该方法"
        return
    endif
    exe("!java -Xbootclasspath/a:" . g:driverPath . " -jar " . g:mybatis_generate_core . expand(" -configfile %") . " -overwrite")
endf

" DOC: 切换hex编辑模式
func extension#hexToggle()
    if &bin " from hex
        set nobin
        exe 'set display='. b:option_display
        exe 'silent%!xxd -r'
    else " to hex
        let b:option_display = &display
        set bin
        set display=uhex
        exe 'silent%!xxd'
    endif
endf
