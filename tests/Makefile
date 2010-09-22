OUTPUT_DIR ?= $(CURDIR)/out

ifneq ($(MAKECMDGOALS),clean)
ifeq ($(SPARKUNIT_DIR),)
$(error "SPARKUNIT_DIR not set")
endif
endif

ifeq ($(SPARK_DIR),)
$(error "SPARK_DIR not set")
endif

DUMMY := $(shell mkdir -p $(OUTPUT_DIR)/proof)

SPARK_OPTS = \
		-brief \
		-vcg \
      -nosli \
		-warn=warnings.conf \
		-index=$(OUTPUT_DIR)/spark.idx \
      -output_dir=$(OUTPUT_DIR)/proof

SPARKMAKE_OPTS = \
      -include=\*.shs \
      -include=\*.ad[sb] \
      -nometa \
      -duplicates_are_errors \
      -index=$(OUTPUT_DIR)/spark.idx \
      -dir=$(SPARK_DIR)/lib/spark \
      -dir=$(SPARKUNIT_DIR)

GOALS = $(OUTPUT_DIR)/main

ifeq ($(NO_PROOF),)
GOALS += $(OUTPUT_DIR)/main.sum
endif

all: $(GOALS)
	-$(OUTPUT_DIR)/main

$(OUTPUT_DIR)/main:
	gnatmake -aP$(SPARKUNIT_DIR) main -P build.gpr

$(OUTPUT_DIR)/main.sum: $(OUTPUT_DIR)/target.cfg $(OUTPUT_DIR)/spark.idx $(OUTPUT_DIR)/spark.smf
	spark -config=$< $(SPARK_OPTS) main.adb
	(cd $(OUTPUT_DIR) && sparksimp -t -p=5)
	pogs -o=$@
	@tail -n14 $@ | head -n13
	@echo

$(OUTPUT_DIR)/spark.idx $(OUTPUT_DIR)/spark.smf:
	sparkmake $(SPARKMAKE_OPTS)

$(OUTPUT_DIR)/confgen: $(SPARK_DIR)/lib/spark/confgen.adb
	gnatmake -D $(OUTPUT_DIR) -o $@ $^

$(OUTPUT_DIR)/target.cfg: $(OUTPUT_DIR)/confgen
	@$< > $@

clean:
	rm -rf $(OUTPUT_DIR)
