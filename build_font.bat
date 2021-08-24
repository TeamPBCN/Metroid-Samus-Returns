set LOC_TXT=localization\japanese.txt
set JAP_FNT_TEX=0x00000080_0x27b15282
set DEF_FNT_TEX=0x00000080_0x4bd1f997
set JAPFONT=font\NotoSansHans-Regular.otf
set DEFFONT=font\NotoSansHans-Regular.otf

md build
md build\font
md build\fonts
md build\fonts_discardables
md build\fonts_jp
md build\fonts_jp_discardables

python filter.py .\build\font\0x00000080_0xb9e77682.flt %LOC_TXT% .\font\0x00000080_0xb9e77682.lbl
python filter.py .\build\font\0x00002880_0xa3db960c.flt %LOC_TXT% .\font\0x00002880_0xa3db960c.lbl
python filter.py .\build\font\0x0000668c_0xb00cd6f8.flt %LOC_TXT% .\font\0x0000668c_0xb00cd6f8.lbl
python filter.py .\build\font\0x00006f44_0xbd12a6bf.flt %LOC_TXT% .\font\0x00006f44_0xbd12a6bf.lbl

python filter.py .\build\font\0x00000080_0xc992c4d5.flt %LOC_TXT% .\font\0x00000080_0xc992c4d5.lbl
python filter.py .\build\font\0x000009d4_0x3ddde0c6.flt %LOC_TXT% .\font\0x000009d4_0x3ddde0c6.lbl
python filter.py .\build\font\0x00001290_0x5e0dd5fc.flt %LOC_TXT% .\font\0x00001290_0x5e0dd5fc.lbl
python filter.py .\build\font\0x00001b4c_0x0e32aea1.flt %LOC_TXT% .\font\0x00001b4c_0x0e32aea1.lbl


python fnt.py --height 512 --width 1024 -c %LOC_TXT% -t build\fonts_jp_discardables\0x00004fe4_0xce14b482.muct -x build\font\%JAP_FNT_TEX%.png -g "path=build\fonts_jp_discardables\0x00000080_0xb9e77682.mfnt:font=%JAPFONT%:size=14:filter=.\build\font\0x00000080_0xb9e77682.flt" "path=build\fonts_jp_discardables\0x00002880_0xa3db960c.mfnt:font=%JAPFONT%:size=20:filter=.\build\font\0x00002880_0xa3db960c.flt" "path=build\fonts_jp_discardables\0x0000668c_0xb00cd6f8.mfnt:font=%JAPFONT%:size=11:filter=.\build\font\0x0000668c_0xb00cd6f8.flt" "path=build\fonts_jp_discardables\0x00006f44_0xbd12a6bf.mfnt:font=%JAPFONT%:size=17:filter=.\build\font\0x00006f44_0xbd12a6bf.flt" --inner-tex-path "system/fonts/textures/japfnt.bctex" --inner-tbl-path "system/fonts/symbols/glyphtablejap.buct"
.\bin\tex3ds -f la8 --raw -z none -o build\font\%JAP_FNT_TEX%.tex build\font\%JAP_FNT_TEX%.png
copy font\%JAP_FNT_TEX%.mtxt.hdr build\fonts_jp\%JAP_FNT_TEX%.mtxt
python texcopy.py build\font\%JAP_FNT_TEX%.tex build\fonts_jp\%JAP_FNT_TEX%.mtxt 0x100
python fnt.py --height 512 --width 1024 -c %LOC_TXT% -t build\fonts_discardables\0x00002408_0x03c07881.muct -x build\font\%DEF_FNT_TEX%.png -g "path=build\fonts_discardables\0x00000080_0xc992c4d5.mfnt:font=%DEFFONT%:size=14:filter=.\build\font\0x00000080_0xc992c4d5.flt" "path=build\fonts_discardables\0x000009d4_0x3ddde0c6.mfnt:font=%DEFFONT%:size=10:filter=.\build\font\0x000009d4_0x3ddde0c6.flt" "path=build\fonts_discardables\0x00001290_0x5e0dd5fc.mfnt:font=%DEFFONT%:size=16:filter=.\build\font\0x00001290_0x5e0dd5fc.flt" "path=build\fonts_discardables\0x00001b4c_0x0e32aea1.mfnt:font=%DEFFONT%:size=17:filter=.\build\font\0x00001b4c_0x0e32aea1.flt" --inner-tex-path "system/fonts/textures/defaultfnt.bctex" --inner-tbl-path "system/fonts/symbols/glyphtable.buct"
.\bin\tex3ds -f la8 --raw -z none -o build\font\%DEF_FNT_TEX%.tex build\font\%DEF_FNT_TEX%.png
copy font\%DEF_FNT_TEX%.mtxt.hdr build\fonts\%DEF_FNT_TEX%.mtxt
python texcopy.py build\font\%DEF_FNT_TEX%.tex build\fonts\%DEF_FNT_TEX%.mtxt 0x100


md build\romfs\packs\system
python pkg.py --mkdir -cf build\romfs\packs\system\fonts_jp.pkg -d build\fonts_jp
python pkg.py --mkdir -cf build\romfs\packs\system\fonts_jp_discardables.pkg -d build\fonts_jp_discardables
python pkg.py --mkdir -cf build\romfs\packs\system\fonts.pkg -d build\fonts
python pkg.py --mkdir -cf build\romfs\packs\system\fonts_discardables.pkg -d build\fonts_discardables