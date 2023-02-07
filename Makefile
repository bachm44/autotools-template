SHELL = /bin/sh

BUILD_DIR_DEBUG = build-debug
BUILD_DIR_RELEASE = build-release
TARGET_DEBUG = $(BUILD_DIR_DEBUG)/template
TARGET_RELEASE = $(BUILD_DIR_RELEASE)/template

all: $(TARGET_DEBUG) $(TARGET_RELEASE)

run-debug: $(BUILD_DIR_DEBUG)
	$(MAKE) -C $(BUILD_DIR_DEBUG)
	./$(TARGET_DEBUG)

run-release: $(TARGET_RELEASE)
	$(MAKE) -C $(BUILD_DIR_RELEASE)
	./$(TARGET_RELEASE)

$(TARGET_DEBUG): $(BUILD_DIR_DEBUG)
	$(MAKE) -C $(BUILD_DIR_DEBUG)

$(TARGET_RELEASE): $(BUILD_DIR_RELEASE)
	$(MAKE) -C $(BUILD_DIR_RELEASE)

configure:
	autoreconf --install

dist: $(BUILD_DIR_RELEASE)
	$(MAKE) -C $(BUILD_DIR_RELEASE) dist

distcheck: $(BUILD_DIR_RELEASE)
	$(MAKE) -C $(BUILD_DIR_RELEASE) distcheck

$(BUILD_DIR_DEBUG): configure
	-mkdir -v $(BUILD_DIR_DEBUG)
	cd $(BUILD_DIR_DEBUG) && ../configure CXXFLAGS='-g -Og'

$(BUILD_DIR_RELEASE): configure
	-mkdir -v $(BUILD_DIR_RELEASE)
	cd $(BUILD_DIR_RELEASE) && ../configure CXXFLAGS='-O3'

clean:
	-rm -rfv $(BUILD_DIR_DEBUG)
	-rm -rfv $(BUILD_DIR_RELEASE)
	-rm -rfv autom4te.cache build-aux
	-rm -fv missing install-sh depcomp configure config.h.in aclocal.m4 configure~
	-find . -name "Makefile.in" -type f -delete