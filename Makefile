instpath = $(subst $(word 1, $(subst romfs/, ,$1)),./,$1)

ROM_DIR ?= ./cia

PKGS = $(shell find $(ROM_DIR) -type f -name "*.pkg")
PKGS_INST := $(call instpath,$(shell cat packages.txt))
PKGTOOL = python pkg.py

BTXTS = $(shell find $(ROM_DIR) -type f -name "*.txt")
ifeq ($(BTXTS),)
BTXTS = $(shell cat texts.txt)
endif
BTXTS_INST = $(call instpath,$(BTXTS))
ifeq ($(BTXTS_INST),)
BTXTS_INST = $(call instpath,$(shell cat texts.txt))
endif
BTXTS_DIR = $(dir $(word 1, $(BTXTS)))
PTXTS = $(addprefix localization/,$(notdir $(BTXTS)))
TXTTOOL = python btxt.py

JAP_FNT_ENTRY = 0x00000080_0xb9e77682 0x00002880_0xa3db960c 0x0000668c_0xb00cd6f8 0x00006f44_0xbd12a6bf
JAP_MFNT_FILES = $(addsuffix .mfnt,$(JAP_FNT_ENTRY))
JAP_FLTS = $(addprefix font/,$(addsuffix .flt,$(JAP_FNT_ENTRY)))
JAP_FNT_DCB_FILES = 0x00004fe4_0xce14b482.muct $(JAP_MFNT_FILES)
JAP_FNT_TEX = 0x00000080_0x27b15282
JAP_FNT_FILES = fonts_jp/$(JAP_FNT_TEX).mtxt $(addprefix fonts_jp_discardables/,$(JAP_FNT_DCB_FILES))
JAPFONT = font/NotoSansHans-Regular.otf

DEF_FNT_ENTRY = 0x00000080_0xc992c4d5 0x000009d4_0x3ddde0c6 0x00001290_0x5e0dd5fc 0x00001b4c_0x0e32aea1
DEF_MFNT_FILES = $(addsuffix .mfnt,$(DEF_FNT_ENTRY))
DEF_FLTS = $(addprefix font/,$(addsuffix .flt,$(DEF_FNT_ENTRY)))
DEF_FNT_DCB_FILES = 0x00002408_0x03c07881.muct $(DEF_MFNT_FILES)
DEF_FNT_TEX = 0x00000080_0x4bd1f997
DEF_FNT_FILES = fonts/$(DEF_FNT_TEX).mtxt $(addprefix fonts_discardables/,$(DEF_FNT_DCB_FILES))
DEFFONT = font/NotoSansHans-Regular.otf

FNTTOOL = python fnt.py

GUIDIR = romfs/gui/textures
GAMELOGO = $(GUIDIR)/gamelogo.bctex
TEXCOPY = python texcopy.py

all: japfnt deffnt packages texts gamelogo

LUMADIR = luma/titles/00040000001BFC00
luma.zip: all
	if [ ! -d $(LUMADIR) ]; then mkdir -p $(LUMADIR); fi
	cp -r romfs $(LUMADIR)
	zip -9 -r luma.zip luma

packages: $(PKGS_INST)

texts: $(BTXTS_INST)

japfnt: $(JAP_FNT_FILES)

deffnt: $(DEF_FNT_FILES)

$(JAP_FNT_FILES): $(JAP_FLTS)
	if [ ! -d "fonts_jp_discardables" ]; then mkdir fonts_jp_discardables; fi
	$(FNTTOOL) --height 1024 --width 1024 \
	-c ./localization/japanese.txt \
	-t fonts_jp_discardables/0x00004fe4_0xce14b482.muct \
	-x font/$(JAP_FNT_TEX).png \
	-g "path=fonts_jp_discardables/0x00000080_0xb9e77682.mfnt:font=$(JAPFONT):size=16:filter=./font/0x00000080_0xb9e77682.flt" \
	"path=fonts_jp_discardables/0x00002880_0xa3db960c.mfnt:font=$(JAPFONT):size=19:filter=./font/0x00002880_0xa3db960c.flt" \
	"path=fonts_jp_discardables/0x0000668c_0xb00cd6f8.mfnt:font=$(JAPFONT):size=13:filter=./font/0x0000668c_0xb00cd6f8.flt" \
	"path=fonts_jp_discardables/0x00006f44_0xbd12a6bf.mfnt:font=$(JAPFONT):size=20:filter=./font/0x00006f44_0xbd12a6bf.flt" \
	--inner-tex-path "system/fonts/textures/japfnt.bctex" --inner-tbl-path "system/fonts/symbols/glyphtablejap.buct"
	tex3ds -f la8 --raw -z none -o font/$(JAP_FNT_TEX).tex font/$(JAP_FNT_TEX).png
	if [ ! -d "fonts_jp" ]; then mkdir fonts_jp; fi
	cp font/$(JAP_FNT_TEX).mtxt.hdr fonts_jp/$(JAP_FNT_TEX).mtxt
	$(TEXCOPY) font/$(JAP_FNT_TEX).tex fonts_jp/$(JAP_FNT_TEX).mtxt 0x100

$(DEF_FNT_FILES): $(DEF_FLTS)
	if [ ! -d "fonts_discardables" ]; then mkdir fonts_discardables; fi
	$(FNTTOOL) --height 1024 --width 1024 \
	-c ./localization/japanese.txt \
	-t fonts_discardables/0x00002408_0x03c07881.muct \
	-x font/$(DEF_FNT_TEX).png \
	-g "path=fonts_discardables/0x00000080_0xc992c4d5.mfnt:font=$(JAPFONT):size=16:filter=./font/0x00000080_0xc992c4d5.flt" \
	"path=fonts_discardables/0x000009d4_0x3ddde0c6.mfnt:font=$(JAPFONT):size=19:filter=./font/0x000009d4_0x3ddde0c6.flt" \
	"path=fonts_discardables/0x00001290_0x5e0dd5fc.mfnt:font=$(JAPFONT):size=13:filter=./font/0x00001290_0x5e0dd5fc.flt" \
	"path=fonts_discardables/0x00001b4c_0x0e32aea1.mfnt:font=$(JAPFONT):size=20:filter=./font/0x00001b4c_0x0e32aea1.flt" \
	--inner-tex-path "system/fonts/textures/defaultfnt.bctex" --inner-tbl-path "system/fonts/symbols/glyphtable.buct"
	tex3ds -f la8 --raw -z none -o font/$(DEF_FNT_TEX).tex font/$(DEF_FNT_TEX).png
	if [ ! -d "fonts" ]; then mkdir fonts; fi
	cp font/$(DEF_FNT_TEX).mtxt.hdr fonts/$(DEF_FNT_TEX).mtxt
	$(TEXCOPY) font/$(DEF_FNT_TEX).tex fonts/$(DEF_FNT_TEX).mtxt 0x100

%.flt: localization/japanese.txt %.lbl
	python filter.py $@  $^

gamelogo: $(GAMELOGO)

$(GAMELOGO): textures/gamelogo/gamelogo_00.png
	tex3ds -f rgba8 --raw -z none -o $(<:%.png=%.tex) $<
	if [ ! -d $(GUIDIR) ]; then mkdir -p $(GUIDIR); fi
	cp textures/gamelogo/gamelogo.bctex.hdr $@
	$(TEXCOPY) $(<:%.png=%.tex) $@ 0x100

extract_pkg:
	for pkg in $(PKGS); do \
		upkdir=./unpacks$$(echo $${pkg##*romfs} | cut -f 1 -d '.'); \
		echo $(PKGTOOL) -xf $$pkg -d $$upkdir; \
		$(PKGTOOL) -xf $$pkg -d $$upkdir; \
	done
	echo $(PKGS) > packages.txt

plain_txt: $(PTXTS)
	echo $(BTXTS) > texts.txt

localization/%.txt: $(BTXTS_DIR)%.txt
	$(TXTTOOL) --mkdir -xb $< -p $@

romfs/system/localization/%.txt: localization/%.txt
	$(TXTTOOL) --mkdir -cb $@ -p $<

# Make packages depending on their entries is extremely slow, damn.
romfs/%.pkg: # unpacks/%/*.*
	$(PKGTOOL) --mkdir -cf $@ -d unpacks/$*

romfs/packs/system/font%.pkg:
	$(PKGTOOL) --mkdir -cf $@ -d font$*

MTXTS = $(shell find $(ROM_DIR) -type f -name "*.bctex")
TEXDUMP = python texdump.py

export_tex:
	for mtxt in $(MTXTS); do \
		outdir=textures/$$(basename $$mtxt); \
		outdir=$$(echo $$outdir | cut -d '.' -f 1); \
		echo $(TEXDUMP) mtxtdmp $$mtxt $$outdir; \
		if [ ! -d $$outdir ]; then mkdir -p $$outdir; fi; \
		$(TEXDUMP) mtxtdmp $$mtxt $$outdir; \
	done

clean:
	rm -rf ./romfs/ ./fonts_jp ./fonts_jp_discardables ./fonts ./fonts_discardables \
	./luma ./luma.zip font/$(JAP_FNT_TEX).png font/$(JAP_FNT_TEX).tex \
	font/$(DEF_FNT_TEX).png font/$(DEF_FNT_TEX).tex ./font/*.flt