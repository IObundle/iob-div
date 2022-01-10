# Simulation frequency
FREQ := 100000000

# File paths
ROOT_DIR := ../..
HW_DIR := $(ROOT_DIR)/hardware
SRC_DIR := $(HW_DIR)/src
TB_DIR := $(HW_DIR)/simulation/testbench
# Testbench defines
TB_DEFINE = -DCLK_FREQ=$(FREQ)
TB_DEFINE += -DVCD

# Icarus verilog simulator
VLOG := iverilog -Wall -g2005-sv

# Hardware sources
SRC_PIPE := $(SRC_DIR)/div_slice.v $(SRC_DIR)/div_pipe.v $(TB_DIR)/div_pipe_tb.v
SRC_SERIAL := $(SRC_DIR)/div_subshift.v $(TB_DIR)/div_subshift_tb.v
SRC_SERIALFRAC := $(SRC_DIR)/div_subshift_frac.v $(SRC_DIR)/div_subshift.v $(TB_DIR)/div_subshift_frac_tb.v

pipediv: $(SRC_PIPE)
	$(VLOG) $(TB_DEFINE) $(SRC_PIPE)
	./a.out

div_subshift: $(SRC_SERIAL)
	$(VLOG) $(TB_DEFINE) $(SRC_SERIAL)
	./a.out

div_subshift_frac: $(SRC_SERIALFRAC)
	$(VLOG) $(TB_DEFINE) $(SRC_SERIALFRAC)
	./a.out

waves:
	gtkwave -a ../waves.gtkw div.vcd &

clean: 
	@rm -f *~ *# *.vcd a.out
