BUNDLE  := ./assets.aqr
ALL     := $(BUNDLE)/
CLEAN   := $(ALL)

# build all targets (default)
.PHONY: all
all: $(ALL)

# create project shared asset bundle and copy in system scripts
$(BUNDLE)/:
	mkdir -p $(BUNDLE)/
	cd senplayer; make

# remove files that can be rebuilt
.PHONY: clean
clean:
	rm -r -f $(CLEAN)

# remove targets and rebuild from scratch
.PHONY: force
force: clean all

