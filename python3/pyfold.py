#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import re
import vim


def getPyIndent(l):
    if isinstance(l, str):
        return len(l) - len(l.lstrip())
    else:
        return int(vim.eval('indent({})'.format(l)))


def isImportLine(line):
    return line.startswith('import ') or (line.startswith('from ') and ' import ' in line)


def isKeywordsLine(line):
    stripLine = line.lstrip()
    return stripLine.startswith('def') or stripLine.startswith('class')


def isDocStartLine(line):
    stripLine = line.lstrip()
    return stripLine.startswith("'''") or stripLine.startswith('"""')


def isDocEndLine(line):
    stripLine = line.lstrip()
    return stripLine.endswith("'''") or stripLine.endswith('"""')


def updateFoldTable():
    cb = vim.current.buffer
    cb.vars['foldTable'] = {}

    def getCbLine(n):
        return cb[n - 1]

    def setCbFoldTable(n, s):
        '''向b:foldTable添加键值对
           n: 键，行号，可以是int或str
           s: 值，vim折叠字符串，str
        '''
        if not isinstance(n, str):
            n = str(n)
        cb.vars['foldTable'][n] = s

    # 整理出特殊的行，并收集这些行号
    importLines = []
    keywordsLines = []
    for lineNum in range(1, len(cb)):
        curLine = getCbLine(lineNum)
        curIndent = getPyIndent(getCbLine(lineNum))

        if isImportLine(curLine): # import foo and from foo import bar
            importLines.append(lineNum)
        elif isKeywordsLine(curLine):  # starts with def or class
            keywordsLines.append(lineNum)
        elif isDocStartLine(curLine):
            if isDocEndLine(curLine):
                continue # NOTE 这个continue跳过下面一个elif isDocEndLine判断
            # docstring 有明确的结束标记，直接使用标记
            setCbFoldTable(lineNum, '>{}'.format(curIndent / 4 + 1))
            n = lineNum
            while n < len(cb):
                if isDocEndLine(getCbLine(n)):
                    setCbFoldTable(n, '<{}'.format(curIndent / 4 + 1))
                    break
                n += 1
        elif isDocEndLine(curLine):
            setCbFoldTable(lineNum, '<{}'.format(curIndent / 4 + 1))

    # deal with importLines
    lastImportLine = -1
    for lineNum in importLines:
        if lastImportLine == -1:
            lastImportLine = lineNum
            setCbFoldTable(lastImportLine, '>1')
        elif lineNum - lastImportLine < 3:
            lastImportLine = lineNum
        else:
            setCbFoldTable(lastImportLine, '<1')
            lastImportLine = -1
    if len(importLines) > 0:
        setCbFoldTable(importLines[-1], '<1')

    # deal with keywordsLines
    lastNonEmptyLine = -1
    for lineNum in keywordsLines:
        curIndent = getPyIndent(lineNum)
        n = lineNum - 1
        while n > 1:
            line = getCbLine(n)
            if line.lstrip().startswith('@'):
                n -= 1
            else:
                break
        setCbFoldTable(n + 1, '>{}'.format(curIndent / 4 + 1))

        # 设置 <n TODO 
        n = lineNum + 1
        while n < len(cb):
            lineN = getCbLine(n)
            if getPyIndent(n) > curIndent:
                lastNonEmptyLine = n
            elif lineN != '':
                setCbFoldTable(lastNonEmptyLine, '<{}'.format(curIndent / 4 + 1))
            n += 1

    # 最后一行是 <1
    setCbFoldTable(len(cb), '<1')
