OUTPUT_DIR  = $(CURDIR)/out
PROOF_DIR   = $(OUTPUT_DIR)/proof
TREE_DIR    = $(OUTPUT_DIR)/tree
DOC_DIR     = $(OUTPUT_DIR)/doc
BUILD_DIR   = $(OUTPUT_DIR)/build
TARGET_CFG ?= $(OUTPUT_DIR)/target.cfg

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
   -dir=$(SPARK_DIR)/lib/spark

ALL_GOALS = install_local

# SPARK_DIR must be set
ifeq ($(SPARK_DIR),)
$(error SPARK_DIR not defined)
endif

# Feature: NO_PROOF
ifeq ($(NO_PROOF),)
ALL_GOALS += proof
INSTALL_DEPS += install_proof
endif

# Feature: NO_TESTS
ifeq ($(NO_TESTS),)
ALL_GOALS += tests
endif

# Feature: NO_APIDOC
ifeq ($(NO_APIDOC),)
ALL_GOALS += apidoc
endif

###############################################################################

all:   $(ALL_GOALS)
build: $(BUILD_DIR)/libsparkunit.a
proof: $(PROOF_DIR)/libsparkcrypto.sum

$(OUTPUT_DIR)/sparkunit.idx: src/*.ad?
	sparkmake $(SPARKMAKE_OPTS) -index=$@ -nometa

$(OUTPUT_DIR)/sparkunit.sum: $(OUTPUT_DIR)/sparkunit.idx $(TARGET_CFG) src/*.ad?
	spark $(SPARK_OPTS) -index=$< src/sparkunit.ads src/sparkunit.adb
	sparksimp
	pogs -o=$@

$(BUILD_DIR)/libsparkunit.a:
	gnatmake \
		$(GNATMAKE_OPTS) \
		-p -P build/build_sparkunit

install: build
	install -p -m 644 $(BUILD_DIR)/libsparkunit.a $(DESTDIR)/adalib/libsparkunit.a
	install -p -m 644 $(SRC_DIR)/*.ad? $(DESTDIR)/adainclude/

install_local: DESTDIR = $(OUTPUT_DIR)/sparkunit
install_local: install

$(OUTPUT_DIR)/confgen: $(SPARK_DIR)/lib/spark/confgen.adb
	gnatmake -D $(OUTPUT_DIR) -o $@ $^

# Change *_ORDER_FIRST, as casing checks will fail otherwise!
$(OUTPUT_DIR)/target.cfg: $(OUTPUT_DIR)/confgen
	$< | sed -e 's/LOW_ORDER_FIRST/Low_Order_First/g' -e 's/HIGH_ORDER_FIRST/High_Order_First/g' > $@

$(TREE_DIR)/%.adt: $(CURDIR)/src/%.ads
	(cd $(OUTPUT_DIR)/tree && gcc -c -gnatc -gnatt $^)

apidoc: $(ADT_FILES)
	echo $^ | xargs -n1 > $(OUTPUT_DIR)/tree.lst
	adabrowse -T $(TREE_DIR) -f @$(OUTPUT_DIR)/tree.lst -w1 -c doc/adabrowse.conf -o $(DOC_DIR)/
	install -m 644 doc/apidoc.css $(DOC_DIR)/

clean:
	rm -rf $(PROOF_DIR) $(TREE_DIR) $(OUTPUT_DIR)

.PHONY: clean apidoc all install build install_local
