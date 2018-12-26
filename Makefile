romfspath = $(subst $(word 1, $(subst romfs/, ,$1)),./,$1)

PKGS = $(shell find ./cia -type f -name "*.pkg")
PKGS_INST := $(call romfspath,$(shell cat packages.txt))
PKGTOOL = python pkg.py

all: $(PKGS_INST)

extract_pkg:
	for pkg in $(PKGS); do \
		upkdir=./unpacks$$(echo $${pkg##*romfs} | cut -f 1 -d '.'); \
		echo $(PKGTOOL) -xf $$pkg -d $$upkdir; \
		$(PKGTOOL) -xf $$pkg -d $$upkdir; \
	done
	echo $(PKGS) > packages.txt

%.pkg:
	$(PKGTOOL) --mkdir -cf $@ -d $(subst .pkg,,$(subst romfs,unpacks,$@))

clean:
	rm -rf ./romfs/