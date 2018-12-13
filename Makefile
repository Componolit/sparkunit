OUTPUT_DIR  = $(CURDIR)/out
TREE_DIR    = $(OUTPUT_DIR)/tree
DOC_DIR     = $(OUTPUT_DIR)/doc
BUILD_DIR   = $(OUTPUT_DIR)/build

VERSION     ?= 0.1.0
TAG         ?= v$(VERSION)

DUMMY      := $(shell mkdir -p $(OUTPUT_DIR) $(PROOF_DIR) $(TREE_DIR) $(DOC_DIR))
ADT_FILES   = $(addprefix $(OUTPUT_DIR)/tree/,$(notdir $(patsubst %.ads,%.adt,$(wildcard src/*.ads))))

RST2HTML_OPTS = \
   --generator \
   --date \
   --time \
   --stylesheet=doc/sparkunit.css

# Feature: NO_TESTS
ifeq ($(NO_TESTS),)
ALL_GOALS += test
endif

ALL_GOALS += install_local


###############################################################################

all:   $(ALL_GOALS)
build: $(BUILD_DIR)/libsparkunit.a

$(BUILD_DIR)/libsparkunit.a:
	gnatmake $(GNATMAKE_OPTS) -p -P build/build_sparkunit

test: install_local
	$(MAKE) SPARKUNIT_DIR=$(OUTPUT_DIR)/sparkunit -C tests

install: build
	install -d -m 755 $(DESTDIR)/adalib $(DESTDIR)/adainclude
	install -p -m 644 $(BUILD_DIR)/adalib/libsparkunit.a $(BUILD_DIR)/adalib/*.ali $(DESTDIR)/adalib/
	install -p -m 644 src/*.ads $(DESTDIR)/adainclude/
	install -p -m 644 src/*.shs $(DESTDIR)/adainclude/
	install -p -m 644 build/SPARKUnit.gpr $(DESTDIR)/

install_local: DESTDIR = $(OUTPUT_DIR)/sparkunit
install_local: install

$(TREE_DIR)/%.adt: $(CURDIR)/src/%.ads
	(cd $(OUTPUT_DIR)/tree && gcc -c -gnatc -gnatt $^)

archive: $(OUTPUT_DIR)/doc/SPARKUnit-$(VERSION).tgz

$(OUTPUT_DIR)/doc/SPARKUnit-$(VERSION).tgz:
	git archive --format tar --prefix libsparkcrypto-$(VERSION)/ $(TAG) | gzip -c > $@

doc:
	rst2html $(RST2HTML_OPTS) README $(OUTPUT_DIR)/doc/index.html
	rst2html $(RST2HTML_OPTS) CHANGES $(OUTPUT_DIR)/doc/CHANGES.html
	rst2html $(RST2HTML_OPTS) TODO $(OUTPUT_DIR)/doc/TODO.html

clean:
	$(MAKE) -C tests clean
	rm -rf $(PROOF_DIR) $(TREE_DIR) $(OUTPUT_DIR)

.PHONY: clean all install build install_local
