import struct
from ctypes import cdll, create_string_buffer
from io import BytesIO

packlib = cdll.LoadLibrary("pack.dll")

class Packer(object):
    def __init__(self, width, height):
        self.width, self.height = width, height
        self.cur_id = 0
        self.rects = {}
    
    def add_rect(self, width, height, rid):
        self.rects[self.cur_id] = [width, height, 0, 0, rid]
        self.cur_id += 1

    def pack(self):
        rect_data = b''
        for k in self.rects:
            rect_data += struct.pack('IHHHHI', k, self.rects[k][0], self.rects[k][1], 0, 0, 0)
        buf = create_string_buffer(rect_data, len(rect_data))
        packlib.pack(buf, len(self.rects), self.width, self.height)

        data = BytesIO(buf.raw)
        for i in range(len(self.rects)):
            idx, w, h, x, y, s = struct.unpack('IHHHHI', data.read(16))
            self.rects[idx][2], self.rects[idx][3] = x, y

    @property
    def rectst(self):
        result = []
        for k in self.rects:
            result.append((0, self.rects[k][2], self.rects[k][3], self.rects[k][0], self.rects[k][1], self.rects[k][4]))
        return result

if __name__ == "__main__":
    pkr = Packer(1024, 512)
    pkr.add_rect(10,12, 'sasa')
    pkr.add_rect(11,14, 're')
    pkr.add_rect(12,23, 'werw')
    pkr.add_rect(13,43, 'rewr')
    pkr.add_rect(120,234, 'rwd')
    pkr.add_rect(12,44, 'rwer')
    pkr.add_rect(11,33, 'rew')
    pkr.pack()
    for r in pkr.rectst:
        print r
    
