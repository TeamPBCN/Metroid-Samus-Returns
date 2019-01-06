import struct

import fire


def copy(src, dst, dst_pos):
    src = open(src, 'rb')
    src.seek(1)
    size ,= struct.unpack('i', src.read(3)+'\x00')

    dst = open(dst, 'rb+')
    dst.seek(int(dst_pos), 0)
    dst.write(src.read(size))

    dst.close()
    src.close()

if __name__ == "__main__":
    fire.Fire(copy)