# coding: utf-8
import codecs, re, fire

from utils import read_messages

def create_filter(path, msg_file, lbl_file):
    result = []
    messages = read_messages(msg_file)
    labels = codecs.open(lbl_file, 'r', 'utf-16').read().replace('\r\n', '\n').split('\n')

    for m in messages:
        for label in labels:
            if label and re.match(label, m[0]):
                result.append(m[1])
    
    nums = '%d'*10
    nums = nums%tuple(range(10))
    result.append(nums)

    alphabet = ''
    for i in range(ord('a'), ord('z')+1):
        alphabet += chr(i)
    for i in range(ord('A'), ord('Z')+1):
        alphabet += chr(i)
    result.append(alphabet)
    
    codecs.open(path, 'w', 'utf-16').writelines(result)

if __name__ == "__main__":
    fire.Fire(create_filter)