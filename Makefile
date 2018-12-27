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

all: $(PKGS_INST) $(BTXTS_INST)

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

clean:
	rm -rf ./romfs/