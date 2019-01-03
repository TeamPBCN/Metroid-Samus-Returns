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
JAP_FNT_FILES = $(addprefix fonts_jp_discardables/, $(JAP_FNT_FILES))
JAP_FNT_FILES += fonts_jp/0x00000080_0x27b15282.mtxt
FNTTOOL = python fnt.py

all: japfnt packages texts

packages: $(PKGS_INST)

texts: $(BTXTS_INST)

japfnt: $(JAP_FNT_FILES)
	$(FNTTOOL) --height 1024 --width 1024 -c ./localization/japanese.txt -t 0x00004fe4_0xce14b482 -x fonts_jp/0x00000080_0x27b15282.mtxt

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

romfs/packs/system/fonts_%.pkg:
	$(PKGTOOL) --mkdir -cf $@ -d fonts_$*

clean:
	rm -rf ./romfs/