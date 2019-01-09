# coding: utf-8
import codecs, re, fire

from utils import read_messages

def create_filter(path, msg_file, lbl_file):
    result = []
    messages = read_messages(msg_file)
    labels = codecs.open(lbl_file, 'r', 'utf-16').read().split('\n')

    for m in messages:
        for label in labels:
            if re.match(label, m[0]):
                result.append(m[1])
    
    codecs.open(path, 'w', 'utf-16').writelines(result)

if __name__ == "__main__":
    fire.Fire(create_filter)