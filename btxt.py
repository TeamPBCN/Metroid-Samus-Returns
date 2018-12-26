# coding: utf-8
import argparse
import binascii
import codecs
import os
import re
import struct
from io import BytesIO

from utils import mkdirs, readstrzt


class FileTypeError(Exception):
    pass

class FileVersionError(Exception):
    pass

class BinaryTextEntry(object):
    Label = ''
    Text = u''

    def __init__(self, lbl, txt):
        self.Label = lbl
        self.Text = txt
    
    def ToBin(self):
        return (self.Label + '\0').encode('ascii') + (self.Text.replace('\n', '|') + '\0').encode('utf-16le')

    def ToString(self, fmt):
        return fmt.format(lbl=self.Label, txt=self.Text.replace(u'|', u'\n'))

class BinaryText(object):
    Magic = 'BTXT'
    Version = binascii.a2b_hex("01000800")

    def __init__(self, path=None):
        self.entries = []
        if path:
            self.load(path)

    def export_text(self, path):
        result = []
        for e in self.entries:
            fmt = u'''No.%d
Label: {lbl}
－－－－－－－－－－－－－－－－－－－－
{txt}
－－－－－－－－－－－－－－－－－－－－
{txt}
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝


'''%len(result)
            result.append(e.ToString(fmt))

        codecs.open(path, 'w', 'utf-16').write(u''.join(result))

        return result

    def import_text(self, path):
        messages = read_messages(path)

        for m in messages:
            for i in range(len(self.entries)):
                if self.entries[i].Label == m[0]:
                    self.entries[i].Text = m[1]

    def from_text(self, path):
        messages = read_messages(path)
        self.entries = []

        for m in messages:
            self.entries.append(BinaryTextEntry(m[0], m[1]))

    def load(self, path):
        fs = open(path, 'rb')
        lblrdr = codecs.getreader('ascii')(fs)
        txtrdr = codecs.getreader('utf-16le')(fs)

        mg = fs.read(4)
        if mg != self.Magic:
            raise FileTypeError("Except magic: %s, actual (hex): %s"%(self.Magic, binascii.b2a_hex(mg)))
        
        ver = fs.read(4)
        if ver != self.Version:
            raise FileVersionError("Supportted version: %s, input file version: %s"%(self.verstr(), self.verstr(ver)))
        
        while True:
            lbl = readstrzt(lblrdr)
            txt = readstrzt(txtrdr)

            if not lbl and not txt:
                break

            entry = BinaryTextEntry(lbl, txt)
            self.entries.append(entry)
        
        fs.close()
    
    def save(self, path):
        fs = open(path, 'wb')
        fs.write(self.Magic)
        fs.write(self.Version)
        for e in self.entries:
            fs.write(e.ToBin())
        fs.close()

    def verstr(self, bstr=None):
        if not bstr:
            bstr = self.Version
        return '%d.%d.%d-%d'%struct.unpack_from('bbbb', bstr)

def read_messages(path): 
    pat = re.compile(u"No\.\d+?\nLabel: .+?\n－+?\n[\s|\S]*?\n－+?\n[\s|\S]*?\n＝+?\n\n") 

    t = codecs.open(path,'r','utf-16').read() 
    blocks = pat.findall(t)

    entries = []
    for b in blocks:
        m = re.match(u"No\.\d+?\nLabel: (.+?)\n－+?\n[\s|\S]*?\n－+?\n([\s|\S]*?)\n＝+?\n\n", b)
        entries.append((m.group(1), m.group(2)))

    return entries

def main():
    parser = argparse.ArgumentParser(
        description="Binary text tool for Metroid: Samus Returns.\r\nCreate by LITTOMA, TeamPB, 2018.12")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-x', '--export', help='Export messages.',
                       action='store_true', default=False)
    group.add_argument('-c', '--create', help='Convert plain text to binary text.',
                        action='store_true', default=False)
    parser.add_argument('-b', '--binary', help="Set binary text file.")
    parser.add_argument('-p', '--plain', help='Set plain text file.')
    parser.add_argument('-m', '--mkdir', help='Make directory for output.', action='store_true', default=False)
    options = parser.parse_args()

    if options.export:
        if(options.mkdir):
            mkdirs(os.path.split(options.plain)[0])
        btxt = BinaryText(options.binary)
        btxt.export_text(options.plain)
    elif options.create:
        if(options.mkdir):
            mkdirs(os.path.split(options.binary)[0])
        btxt = BinaryText()
        btxt.from_text(options.plain)
        btxt.save(options.binary)

if '__main__' == __name__:
    main()
