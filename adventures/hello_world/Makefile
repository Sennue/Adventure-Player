LOCALE   := en ja
OBJS     := info.lua MazeDB.lua quest.lua
LOBJS    := author.lua tag.lua message.lua

TARGET   := quest.aqd
LTARGET  := message.aqd
SYSTEM   := ./system
SYS_BIN  := ../..
ASSETS   := ./assets
BUNDLE   := ../assets.aqr
SRC      := ./src
BIN      := ./bin
LUAC     := luac
LUAFLAGS := -s -o
ALL      := $(patsubst %,$(BIN)/%,$(TARGET)) $(patsubst %,$(BIN)/%/$(LTARGET),$(LOCALE))
CLEAN    := $(ALL) $(patsubst %,$(BUNDLE)/%,$(TARGET)) $(patsubst %,$(BUNDLE)/%/$(LTARGET),$(LOCALE))

# build all targets (default)
.PHONY: all
all: mkdir $(ALL) bundle

# shared scripts
$(BIN)/$(TARGET): $(patsubst %,$(SRC)/%,$(OBJS))
	$(LUAC) $(LUAFLAGS) $@ $+

# locale specific scripts
$(BIN)/%/$(LTARGET): $(foreach dep,$(LOBJS),$(SRC)/%/$(dep))
	$(LUAC) $(LUAFLAGS) $@ $+

# copy scripts and assets to project asset bundle
.PHONY: bundle
bundle:
	cp -R $(SYSTEM)/ $(SYS_BIN)/
	cp -R $(ASSETS)/ $(BUNDLE)/
	cp -R $(BIN)/    $(BUNDLE)/

# run shared project asset bundle makefile and then create all requisite directories for this specific project
.PHONY: mkdir
mkdir:
	cd ../; make force
	mkdir -p $(BIN)/    $(patsubst %,$(BIN)/%/,   $(LOCALE))
	mkdir -p $(BUNDLE)/ $(patsubst %,$(BUNDLE)/%/,$(LOCALE))

# remove files that can be rebuilt, clean bin directory to make sure junk is not copied into the project
.PHONY: clean
clean:
	rm    -f $(CLEAN)
	rm -r -f $(BIN)/

# remove targets and rebuild from scratch
.PHONY: force
force: clean all

