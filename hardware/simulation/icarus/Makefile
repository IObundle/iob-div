# Simulation frequency
FREQ := 100000000

# File paths
ROOT_DIR := ../../..
HW_DIR := $(ROOT_DIR)/hardware
SRC_DIR := $(HW_DIR)/src
TB_DIR := $(HW_DIR)/testbench
# Testbench defines
TB_DEFINE = -DCLK_FREQ=$(FREQ)
TB_DEFINE += -DVCD

# Icarus verilog simulator
VLOG := iverilog -Wall -g2005-sv

# Hardware sources
SRC_PIPE := $(SRC_DIR)/div_slice.v $(SRC_DIR)/div_pipe.v $(TB_DIR)/div_pipe_tb.v
SRC_SERIAL := $(SRC_DIR)/div_subshift.v $(TB_DIR)/div_subshift_tb.v

all: pipediv subshiftdiv

pipediv: $(SRC_PIPE)
	$(VLOG) $(TB_DEFINE) -o $@ $(SRC_PIPE)
	./$@

subshiftdiv: $(SRC_SERIAL)
	$(VLOG) $(TB_DEFINE) -o $@ $(SRC_SERIAL)
	./$@

waves:
	gtkwave -a ../waves.gtkw div.vcd &

clean: 
	@rm -f *~ *# *.vcd pipediv subshiftdiv

.PHONY: all clean waves
