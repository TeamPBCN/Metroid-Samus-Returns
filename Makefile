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

JAP_FNT_FILES = 0x00004fe4_0xce14b482.muct 0x00006f44_0xbd12a6bf.mfnt 0x00000080_0xb9e77682.mfnt 0x0000668c_0xb00cd6f8.mfnt 0x00002880_0xa3db960c.mfnt
JAP_FNT_FILES := $(addprefix fonts_jp_discardables/,$(JAP_FNT_FILES))
JAP_FNT_FILES += fonts_jp/0x00000080_0x27b15282.mtxt
FNTTOOL = python fnt.py

TEXCOPY = python texcopy.py

all: japfnt packages texts

luma.zip: all
	if [ ! -d luma/titles/00040000001BFC00 ]; then mkdir -p luma/titles/00040000001BFC00; fi
	cp -r romfs luma/titles/00040000001BFC00
	zip -9 -r luma.zip luma

packages: $(PKGS_INST)

texts: $(BTXTS_INST)

japfnt: $(JAP_FNT_FILES)

$(JAP_FNT_FILES):
	if [ ! -d "fonts_jp_discardables" ]; then mkdir fonts_jp_discardables; fi
	$(FNTTOOL) --height 1024 --width 1024 \
	-c ./localization/japanese.txt \
	-t fonts_jp_discardables/0x00004fe4_0xce14b482.muct \
	-x ./0x00000080_0x27b15282.png \
	-g "path=fonts_jp_discardables/0x00006f44_0xbd12a6bf.mfnt:font=NotoSansHans-Regular.otf:size=20:filter=./localization/japanese.txt" \
	"path=fonts_jp_discardables/0x00000080_0xb9e77682.mfnt:font=NotoSansHans-Regular.otf:size=16:filter=./localization/japanese.txt" \
	"path=fonts_jp_discardables/0x0000668c_0xb00cd6f8.mfnt:font=NotoSansHans-Regular.otf:size=13:filter=./localization/japanese.txt" \
	"path=fonts_jp_discardables/0x00002880_0xa3db960c.mfnt:font=NotoSansHans-Regular.otf:size=19:filter=./localization/japanese.txt" \
	--inner-tex-path "system/fonts/textures/japfnt.bctex" --inner-tbl-path "system/fonts/symbols/glyphtablejap.buct"
	tex3ds -f la8 --raw -z none -o ./0x00000080_0x27b15282.tex ./0x00000080_0x27b15282.png
	if [ ! -d "fonts_jp" ]; then mkdir fonts_jp; fi
	cp 0x00000080_0x27b15282.mtxt.hdr fonts_jp/0x00000080_0x27b15282.mtxt
	$(TEXCOPY) ./0x00000080_0x27b15282.tex fonts_jp/0x00000080_0x27b15282.mtxt 0x100

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

romfs/packs/system/fonts%.pkg:
	$(PKGTOOL) --mkdir -cf $@ -d fonts$*

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
	rm -rf ./romfs/ ./fonts_jp ./fonts_jp_discardables ./luma ./luma.zip