# Simulation frequency
FREQ := 100000000

# File paths
ROOT_DIR := ../..
RTL_DIR := $(ROOT_DIR)/rtl

# Testbench defines
TB_DEFINE = -DCLK_FREQ=$(FREQ)
TB_DEFINE += -DVCD

# Icarus verilog simulator
VLOG := iverilog -Wall -g2005-sv

# Hardware sources
SRC_PIPE := $(RTL_DIR)/src/div_slice.v $(RTL_DIR)/src/div_pipe.v $(RTL_DIR)/testbench/div_pipe_tb.v
SRC_SERIAL := $(RTL_DIR)/src/div_serial.v $(RTL_DIR)/testbench/div_serial_tb.v

all: pipediv serialdiv

pipediv: $(SRC_PIPE)
	$(VLOG) $(TB_DEFINE) -o $@ $(SRC_PIPE)
	./$@

serialdiv: $(SRC_SERIAL)
	$(VLOG) $(TB_DEFINE) -o $@ $(SRC_SERIAL)
	./$@

clean: 
	@rm -f *~ *# *.vcd pipediv serialdiv

.PHONY: all clean
