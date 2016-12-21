#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''抓取 http://fy.iciba.com 翻译内容实现中英文翻译'''

from urllib import request, parse
import json

url = 'http://fy.iciba.com/ajax.php?a=fy'
UserAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36'
Referer = 'http://fy.iciba.com/'
Origin = Referer
ContentType = 'application/json; charset=utf-8'

wrap = lambda s: ''.join(('[', s, ']'))


def translate(key: str):
    '''翻译给定的字符串，返回适合打印的翻译结果'''
    result = _query(key)['content']
    if 'word_mean' in result.keys():
        return '\n'.join((
            wrap(key),
            '\n'.join(map(lambda s: '  - ' + s, result['word_mean']))))
    elif 'out' in result.keys():
        return '\n'.join((
            wrap(key),
            '  - ' + result['out'].replace('<br/>', '')))
    else:
        return wrap(key) + '\n  - <no data>'


def _query(content: str):
    req = request.Request(url)
    req.add_header('User-Agent', UserAgent)
    req.add_header('Referer', Referer)
    req.add_header('Origin', Origin)
    req.add_header('Content-Type', ContentType)
    form_data = parse.urlencode(
        [('f', 'undefined'), ('t', 'undefined'), ('w', content)])

    try:
        with request.urlopen(url, data=form_data.encode('utf-8')) as f:
            if f.status == 200:
                page = f.read().decode('unicode-escape').replace("\\", "")
                return json.loads(page)
            else:
                return {'content': {}}
    except BaseException:
        return {'content': {}}


def query(key: str):
    '''翻译给定的字符串，返回翻译结果，形如(key, 结果1, 结果2, 结果3, ...)'''
    result = _query(key)['content']
    if 'word_mean' in result.keys():
        return tuple([key] + result['word_mean'])
    elif 'out' in result.keys():
        return (key, result['out'].replace('<br>', ''))
    else:
        return (key, '<no data>')

if __name__ == '__main__':
    import sys
    if len(sys.argv) == 1 or '-h' in sys.argv[1]:
        print(
            "Translation tool(En/Zh).\nUsage: translate.py [words or setences]")
    else:
        args = sys.argv[1:]
        for arg in args:
            print(translate(arg))
