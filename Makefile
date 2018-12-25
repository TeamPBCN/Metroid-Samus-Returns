PKGS = $(shell find ./cia -type f -name "*.pkg")
PKGTOOL = python pkg.py

all:

extract_pkg:
	for pkg in $(PKGS); do \
		echo $(PKGTOOL) -xf $$pkg -d ./unpacks$$(echo $${pkg##*romfs} | cut -f 1 -d '.'); \
		$(PKGTOOL) -xf $$pkg -d ./unpacks$$(echo $${pkg##*romfs} | cut -f 1 -d '.'); \
	done