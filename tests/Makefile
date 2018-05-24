OUTPUT_DIR ?= $(CURDIR)/out

ifneq ($(MAKECMDGOALS),clean)
ifeq ($(SPARKUNIT_DIR),)
$(error "SPARKUNIT_DIR not set")
endif
endif

DUMMY := $(shell mkdir -p $(OUTPUT_DIR)/proof)

GOALS = $(OUTPUT_DIR)/main

all: $(GOALS)
	-$(OUTPUT_DIR)/main

$(OUTPUT_DIR)/main:
	gnatmake -aP$(SPARKUNIT_DIR) main -P build.gpr

clean:
	rm -rf $(OUTPUT_DIR)
