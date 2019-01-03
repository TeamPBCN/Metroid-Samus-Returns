import os
import struct

import fire

from utils import readstrzt

PIXEL_FMTS = {
    0: 'rgba8',
    1: 'rgb8',
    2: 'rgba5551',
    3: 'rgb565',
    4: 'rgba4',
    5: 'la8',
    6: 'hilo8',
    7: 'l8',
    8: 'a8',
    9: 'la4',
    10: 'l4',
    11: 'a4',
    12: 'etc1',
    13: 'etc1a4',
}

# This function support neither mipmap nor multiple texture package.
def mtxtdmpcmd(path, outdir=None):
    fs = open(path, 'rb')
    if fs.read(4) != 'MTXT':
        return False
    
    fs.seek(0x1C, 0)
    ctpk_offset ,= struct.unpack('i', fs.read(4))

    fs.seek(ctpk_offset + 8, 0)
    tex_offset ,= struct.unpack('i', fs.read(4))
    tex_offset += ctpk_offset

    fs.seek(ctpk_offset + 0x20, 0)
    (name_offset, data_size, 
    data_offset, tex_format,
    width, height) = struct.unpack('iiiihh', fs.read(0x14))
    tex_offset = data_offset + tex_offset

    fs.seek(ctpk_offset + name_offset, 0)
    name = readstrzt(fs)
    output = os.path.join(os.path.splitext(path)[0], os.path.basename(name).replace('.tga', '.png'))
    if outdir:
        output = os.path.join(outdir, os.path.basename(name).replace('.tga', '.png'))

    return 'texdump -i {input} -f {fmt} -p {pos} -l {length} -w {width} -h {height} -o {output}'.format(
        input=path, fmt=PIXEL_FMTS[tex_format], pos=tex_offset, length=data_size,
        width=width, height=height, output=output
    )

def mtxtdmp(path, outdir=None):
    cmd = mtxtdmpcmd(path, outdir)
    print cmd
    os.system(cmd)

if __name__ == "__main__":
    fire.Fire()
