# coding: utf-8
import os
import struct

import pygame
from pygame import Color, Rect, Surface, freetype, image

from rectpack.packer import SORT_NONE, PackingBin, newPacker

freetype.init()


class Glyph(object):
    char = u''
    x = 0
    y = 0

    @property
    def surface(self):
        return self.font.render(self.char, fgcolor=Color('white'), style=freetype.STYLE_NORMAL)[0]
    
    @property
    def rect(self):
        return self.font.get_rect(self.char)

    def __init__(self, group, char, font):
        self.char = char
        self.group = group
        self.font = font

class Font(object):
    glyphs = []
    font = None
    used_rect = []

    def __init__(self, font_name, font_size, image_size=(512, 256)):
        self.font = freetype.Font(font_name, font_size)
        self.img_w, self.img_h = image_size

    def add_chars(self, group, chars):
        for char in chars:
            if not char in self.chars:
                self.add_char(group, char)
        self.remap()
    
    def add_char(self, group, char):
        glyph = Glyph(group, char, self.font)
        self.glyphs.append(glyph)
    
    def extend(self, glyphs):
        self.glyphs.extend(glyphs)
        self.remap()

    def remap(self):
        packer = newPacker(sort_algo=SORT_NONE, rotation=False, bin_algo=PackingBin.Global)

        for g in self.glyphs:
            packer.add_rect(g.rect.width, g.rect.height, g.char)
        
        packer.add_bin(self.img_w, self.img_h)
        packer.pack()
        rect_list = packer.rect_list()
        for r in rect_list:
            for g in self.glyphs:
                if g.char == r[5]:
                    g.x = r[1]
                    g.y = r[2]
    
    def save(self):
        self.save_image()
    
    def save_image(self):
        surface = Surface((self.img_w, self.img_h), pygame.SRCALPHA, 32)
        for g in self.glyphs:
            surface.blit(g.surface, Rect(g.x, g.y, g.rect.width, g.rect.height))
        image.save(surface, "Font.png")

    @property
    def chars(self):
        return [g.char for g in self.glyphs]
    
    @property
    def rects(self):
        return [g.rect for g in self.glyphs]

if __name__ == "__main__":
    pass