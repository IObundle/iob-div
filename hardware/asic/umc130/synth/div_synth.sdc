# ####################################################################

#  Created by Encounter(R) RTL Compiler RC14.25 - v14.20-s046_1 on Wed Mar 21 22:57:28 +0000 2018

# ####################################################################

set sdc_version 1.7

set_units -capacitance 1000.0fF
set_units -time 1000.0ps

# Set the current design
current_design div

create_clock -name "clk" -add -period 5.0 -waveform {0.0 2.5} [get_ports clk]
set_clock_gating_check -setup 0.0 
set_wire_load_mode "enclosed"
set_wire_load_selection_group "DEFAULT" -library "fsc0h_d_generic_core_tt1p2v25c"
set_dont_use [get_lib_cells fsc0h_d_generic_core_tt1p2v25c/BHD1HD]
set_dont_use [get_lib_cells fsc0h_d_generic_core_tt1p2v25c/CKLDHD]
