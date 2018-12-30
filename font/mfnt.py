import struct,os

from PIL import Image, ImageDraw, ImageFont


class MFontEntry(object):
    def __init__(self, data):
        (self.x, self.y,
        self.width, self.height, 
        self.attr1, self.attr2, self.attr3) = struct.unpack('hhhhhhh', data)
    
    def __cmp__(self, other):
        return self.width.__cmp__(other.width)
    
    def __repr__(self):
        return 'x: %d, y: %d, w: %d, h:%d'%(self.x, self.y, self.width, self.height)

    @property
    def right(self):
        return self.x + self.width
    @property
    def bottom(self):
        return self.y + self.height
    @property
    def box(self):
        return (self.x, self.y, self.right, self.bottom)
    @property
    def rect(self):
        return (self.x, self.y, self.width, self.height)

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
    
    def export_images(self, img_path, out_dir, char_table=None):
        img = Image.open(img_path)

        for i in range(len(self.entries)):
            im = img.crop(self.entries[i].box)
            path = '%d.png'%i
            if char_table:
                path = '%s.png'%unichr(char_table[i])
            path = os.path.join(out_dir, path)
            try:
                if not os.path.exists(out_dir):
                    os.makedirs(out_dir)
                im.save(path)
                print 'Save:', path
            except:
                print ''
                continue

class CharTable(object):
    def __init__(self, path):
        fs = open(path, 'rb')
        (magic, version, entries_cnt, tbl_offset) = struct.unpack('4siii', fs.read(16))
        fs.seek(tbl_offset, 0)

        self.entries = {}
        for i in range(entries_cnt):
            char, id = struct.unpack('ii', fs.read(8))
            self.entries[id] = char

if __name__ == "__main__":
    tbl = CharTable('0x00004fe4_0xce14b482.muct')

    mfnt = MFont('0x00006f44_0xbd12a6bf.mfnt')
    mfnt.export_images('japfnt_00.png', '0x00006f44_0xbd12a6bf', tbl.entries)
    
    mfnt = MFont('0x00000080_0xb9e77682.mfnt')
    mfnt.export_images('japfnt_00.png', '0x00000080_0xb9e77682', tbl.entries)
    
    mfnt = MFont('0x0000668c_0xb00cd6f8.mfnt')
    mfnt.export_images('japfnt_00.png', '0x0000668c_0xb00cd6f8', tbl.entries)
    
    mfnt = MFont('0x00002880_0xa3db960c.mfnt')
    mfnt.export_images('japfnt_00.png', '0x00002880_0xa3db960c', tbl.entries)