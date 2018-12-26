import os

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
