#!/usr/bin/env python
# -*- coding: utf-8 -*-

# import vim
import urllib
import re
import collections
import xml.etree.ElementTree as ET

WARN_NOT_FIND = " 找不到该单词的释义".decode('utf-8')
ERROR_QUERY = " 有道翻译查询出错!".decode('utf-8')
NETWORK_ERROR = " 无法连接有道服务器!".decode('utf-8')
QUERY_BLACK_LIST = ['.', '|', '^', '$', '\\', '[', ']', '{', '}', '*', '+',
                    '?', '(', ')', '&', '=', '\"', '\'', '\t']


def preprocess_word(word):
    word = word.strip()
    for i in QUERY_BLACK_LIST:
        word = word.replace(i, ' ')
    array = word.split('_')
    word = []
    p = re.compile('[a-z][A-Z]')
    for piece in array:
        lastIndex = 0
        for i in p.finditer(piece):
            word.append(piece[lastIndex:i.start() + 1])
            lastIndex = i.start() + 1
        word.append(piece[lastIndex:])
    return ' '.join(word).strip()


def get_word_info(word):
    word = preprocess_word(word)
    if not word:
        return ''
    try:
        r = urllib.urlopen("http://dict.youdao.com" +
                           "/fsearch?q=" + word.encode('utf-8'))
    except IOError, e:
        return NETWORK_ERROR
    if r.getcode() == 200:
        doc = ET.fromstring(r.read())

        phrase = doc.find(".//return-phrase").text
        p = re.compile(r"^%s$" % word, re.IGNORECASE)
        if p.match(phrase):
            info = collections.defaultdict(list)

            if not len(doc.findall(".//content")):
                return WARN_NOT_FIND

            for el in doc.findall(".//"):
                if el.tag in ('return-phrase', 'phonetic-symbol'):
                    if el.text:
                        info[el.tag].append(el.text.encode("utf-8"))
                elif el.tag in ('content', 'value'):
                    if el.text:
                        info[el.tag].append(el.text.encode("utf-8"))

            for k, v in info.items():
                info[k] = ' | '.join(v) if k == "content" else ' '.join(v)

            tpl = ' %(return-phrase)s'
            if info["phonetic-symbol"]:
                tpl = tpl + ' [%(phonetic-symbol)s]'
            tpl = tpl + ' %(content)s'

            return tpl % info
        else:
            try:
                r = urllib.urlopen("http://fanyi.youdao.com" +
                                   "/translate?i=" + word.encode('utf-8'))
            except IOError, e:
                return NETWORK_ERROR
            p = re.compile(r"\"translateResult\":\[\[{\"src\":\"%s\",\"tgt\":\"(?P<result>.*)\"}\]\]"
                           % word.encode('utf-8'))
            s = p.search(r.read())
            if s:
                return " %s" % s.group('result').decode('utf-8')
            else:
                return ERROR_QUERY
    else:
        return ERROR_QUERY


def translate_visual_selection(lines):
    lines = lines.decode('utf-8')
    for line in lines.split('\n'):
        info = get_word_info(line)
        # vim.command('echo "' + info + '"')
        print info

if __name__ == '__main__':
    translate_visual_selection('better')
