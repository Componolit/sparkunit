OUTPUT_DIR  = $(CURDIR)/out
PROOF_DIR   = $(OUTPUT_DIR)/proof
TREE_DIR    = $(OUTPUT_DIR)/tree
DOC_DIR     = $(OUTPUT_DIR)/doc
BUILD_DIR   = $(OUTPUT_DIR)/build
TARGET_CFG ?= $(OUTPUT_DIR)/target.cfg

VERSION     ?= 0.1.0
TAG         ?= v$(VERSION)

DUMMY      := $(shell mkdir -p $(OUTPUT_DIR) $(PROOF_DIR) $(TREE_DIR) $(DOC_DIR))
ADT_FILES   = $(addprefix $(OUTPUT_DIR)/tree/,$(notdir $(patsubst %.ads,%.adt,$(wildcard src/*.ads))))

SPARK_OPTS = \
   -vcg \
   -noswitch \
   -dpc \
   -brief=fullpath \
   -nolistings \
   -nosli \
   -warning=build/warning.conf \
   -casing=si \
   -config=$(TARGET_CFG) \
   -output_directory=$(PROOF_DIR)

SPARKMAKE_OPTS = \
   -include=\*.shs \
   -include=\*.ad[sb] \
   -dir=$(SPARK_DIR)/lib/spark

RST2HTML_OPTS = \
   --generator \
   --date \
   --time \
   --stylesheet=doc/sparkunit.css

# SPARK_DIR must be set
ifeq ($(SPARK_DIR),)
$(error SPARK_DIR not defined)
endif

# Feature: NO_PROOF
ifeq ($(NO_PROOF),)
ALL_GOALS    += proof
INSTALL_DEPS += install_proof
endif

# Feature: NO_TESTS
ifeq ($(NO_TESTS),)
ALL_GOALS += test
endif

# Feature: NO_APIDOC
ifeq ($(NO_APIDOC),)
ALL_GOALS += apidoc
endif

ALL_GOALS += install_local


###############################################################################

all:   $(ALL_GOALS)
build: $(BUILD_DIR)/libsparkunit.a
proof: $(PROOF_DIR)/sparkunit.sum

$(OUTPUT_DIR)/sparkunit.idx: src/*.ad?
	sparkmake $(SPARKMAKE_OPTS) -index=$@ -nometa

$(PROOF_DIR)/sparkunit.sum: $(OUTPUT_DIR)/sparkunit.idx $(TARGET_CFG) src/*.ad?
	spark $(SPARK_OPTS) -index=$< src/sparkunit.ads src/sparkunit.adb
	(cd $(PROOF_DIR) && sparksimp -t -p=5 -sargs -norenum)
	pogs -d=$(PROOF_DIR) -o=$@
	@tail -n14 $@ | head -n13
	@echo

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

$(OUTPUT_DIR)/confgen: $(SPARK_DIR)/lib/spark/confgen.adb
	gnatmake -D $(OUTPUT_DIR) -o $@ $^

# Change *_ORDER_FIRST, as casing checks will fail otherwise!
$(OUTPUT_DIR)/target.cfg: $(OUTPUT_DIR)/confgen
	$< | sed -e 's/LOW_ORDER_FIRST/Low_Order_First/g' -e 's/HIGH_ORDER_FIRST/High_Order_First/g' > $@

$(TREE_DIR)/%.adt: $(CURDIR)/src/%.ads
	(cd $(OUTPUT_DIR)/tree && gcc -c -gnatc -gnatt $^)

archive: $(OUTPUT_DIR)/doc/SPARKUnit-$(VERSION).tgz

$(OUTPUT_DIR)/doc/SPARKUnit-$(VERSION).tgz:
	git archive --format tar --prefix libsparkcrypto-$(VERSION)/ $(TAG) | gzip -c > $@

apidoc: $(ADT_FILES)
	echo $^ | xargs -n1 > $(OUTPUT_DIR)/tree.lst
	adabrowse -T $(TREE_DIR) -f @$(OUTPUT_DIR)/tree.lst -w1 -c doc/adabrowse.conf -o $(DOC_DIR)/
	install -m 644 doc/apidoc.css $(DOC_DIR)/

doc: apidoc
	rst2html $(RST2HTML_OPTS) README $(OUTPUT_DIR)/doc/index.html
	rst2html $(RST2HTML_OPTS) CHANGES $(OUTPUT_DIR)/doc/CHANGES.html
	rst2html $(RST2HTML_OPTS) TODO $(OUTPUT_DIR)/doc/TODO.html

clean:
	$(MAKE) -C tests clean
	rm -rf $(PROOF_DIR) $(TREE_DIR) $(OUTPUT_DIR)

.PHONY: clean apidoc all install build install_local
