import struct, os, argparse
from io import BytesIO

class PackageEntry(object):
    def __init__(self, data=None):
        self.Hash, self.DataStart, self.DataEnd = (0,0,0)
        self.Data = ''
        if data:
            self.Hash, self.DataStart, self.DataEnd = struct.unpack_from('Iii', data)
    
    def guess_type(self):
        if self.Data:
            try:
                t = self.Data[:4].decode('ascii')
                if self.Data[:4] == '\x1bLua':
                    t = 'lc'
            except:
                t = 'bin'
            return t.lower()
    
    @property
    def filename(self):
        return '0x%08x_0x%08x.%s'%(self.DataStart, self.Hash, self.guess_type())

class Package(object):
    DATA_ALIGNMENTS = {
        'bin': 0,
        'btre': 0x4,
        'cwav': 0x20,
        'lc': 0x4,
        'manm': 0x4,
        'mpsy': 0x4,
        'msad': 0x4,
        'mscd': 0x4,
        'mtxt': 0x80,
    }

    def __init__(self, path=None):
        if path:
            self.load(path)
    
    def create(self, path):
        self.entries = []
        files = os.listdir(path)
        for fp in files:
            entry = PackageEntry()
            offsetstr, hashstr = os.path.splitext(os.path.basename(fp))[0].split('_')
            entry.Hash = int(hashstr, 16)
            fp = os.path.join(path, fp)
            print 'Load:', fp
            entry.Data = open(fp, 'rb').read()
            self.entries.append(entry)

    def import_data(self, path):
        for i in range(len(self.entries)):
            fp = os.path.join(path, self.entries[i].filename)
            if os.path.isfile(fp):
                print 'Load:', fp
                self.entries[i].Data = open(fp, 'rb').read()

    def load(self, path):
        fs = open(path, 'rb')
        head_size ,= struct.unpack('i', fs.read(4))
        head = BytesIO(fs.read(head_size))

        data_size, entry_cnt = struct.unpack('ii', head.read(8))
        if data_size > os.path.getsize(path) - head_size:
            raise Exception("Data size error (%d)"%data_size)
        
        self.entries = []
        for i in range(entry_cnt):
            entry = PackageEntry(head.read(0xC))
            fs.seek(entry.DataStart, 0)
            entry.Data = fs.read(entry.DataEnd - entry.DataStart)
            self.entries.append(entry)
    
    def extract(self, path):
        if not os.path.isdir(path) and not os.path.exists(path):
            os.makedirs(path)
        
        for e in self.entries:
            pathOut = os.path.join(path, e.filename)
            open(pathOut, 'wb').write(e.Data)
            print 'Extract:', pathOut
    
    def save(self, path):
        fs = open(path, 'wb')

        head_size = 0
        data_size = 0
        fs.write(struct.pack('iii', head_size, data_size, len(self.entries)))
        
        fs.write('\x00' * 0xC * len(self.entries))
        if len(self.entries) > 0:
            fs.seek(align(fs.tell(), 0x80), 1)
        head_size = fs.tell() - 4

        for e in self.entries:
            t = e.guess_type()
            if t in self.DATA_ALIGNMENTS:
                fs.seek(align(fs.tell(), self.DATA_ALIGNMENTS[t]), 1)
            
            e.DataStart = fs.tell()
            fs.write(e.Data)
            e.DataEnd = fs.tell()
        data_size = fs.tell() - head_size - 4
        
        fs.seek(0, 0)
        fs.write(struct.pack('iii', head_size, data_size, len(self.entries)))

        for e in self.entries:
            fs.write(struct.pack('Iii', e.Hash, e.DataStart, e.DataEnd))

        fs.close()

def align(value, alignment):
    return (-value % alignment + alignment) % alignment

def main():
    parser = argparse.ArgumentParser(
        description="Package tool for Metroid: Samus Returns.\r\nCreate by LITTOMA, TeamPB, 2018.12")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-x', '--extract', help='Extract package.',
                       action='store_true', default=False)
    group.add_argument('-c', '--create', help='Create package.',
                        action='store_true', default=False)
    parser.add_argument('-f', '--file', help="Set package file.")
    parser.add_argument('-d', '--dir', help='Set dir.')
    options = parser.parse_args()

    if options.create:
        pkg = Package()
        pkg.create(options.dir)
        pkg.save(options.file)
    elif options.extract:
        pkg = Package(options.file)
        pkg.extract(options.dir)

if __name__ == "__main__":
    main()