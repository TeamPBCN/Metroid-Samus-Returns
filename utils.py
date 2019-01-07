# coding: utf-8
import codecs
import os
import re


def align(value, alignment):
    return (-value % alignment + alignment) % alignment

def mkdirs(path):
    if not os.path.exists(path):
        os.makedirs(path)

def readstrzt(stream):
    result = u''
    while True:
        c = stream.read(1)
        if c == '\0' or not c:
            break
        result += c
    return result

def read_messages(path): 
    pat = re.compile(u"No\.\d+?\nLabel: .+?\n－+?\n[\s|\S]*?\n－+?\n[\s|\S]*?\n＝+?\n\n") 

    t = codecs.open(path,'r','utf-16').read() 
    blocks = pat.findall(t)

    entries = []
    for b in blocks:
        m = re.match(u"No\.\d+?\nLabel: (.+?)\n－+?\n[\s|\S]*?\n－+?\n([\s|\S]*?)\n＝+?\n\n", b)
        entries.append((m.group(1), m.group(2)))

    return entries
