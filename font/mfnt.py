import struct

from PIL import Image, ImageDraw, ImageFont


class MFontEntry(object):
    def __init__(self, data):
        (self.x, self.y,
        self.w, self.h, 
        self.attr1, self.attr2, self.attr3) = struct.unpack('hhhhhhh', data)
    
    def __cmp__(self, other):
        return self.w.__cmp__(other.w)
    
    def __repr__(self):
        return 'x: %d, y: %d, w: %d, h:%d'%(self.x, self.y, self.w, self.h)

class MFont(object):
    def __init__(self, path):
        fs = open(path, 'rb')
        (magic, version, header_size, 
        self.image_width, self.image_height, 
        unk1, unk2,
        entry_count, entry_offset, data_size) = struct.unpack('4siiiiiiiii', 
        fs.read(struct.calcsize('4siiiiiiiii')))

        fs.seek(entry_offset, 0)
        self.entries = []
        for i in range(entry_count):
            self.entries.append(MFontEntry(fs.read(0x0E)))

        fs.close()

if __name__ == "__main__":
    pass
