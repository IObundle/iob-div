set_attribute lib_search_path [list /opt/ic_tools/pdk/faraday/umc130/HS/fsc0h_d/2009Q1v3.0/GENERIC_CORE/FrontEnd/synopsys]
set_attribute hdl_search_path {../../}
set_attribute library [list fsc0h_d_generic_core_tt1p2v25c.lib]

read_hdl -v2001 div_slice.v div.v

elaborate div
define_clock -name clk -period 5000 [find / -port clk] 

synthesize -to_mapped

report gates > gates_report.txt
report timing > timing_report.txt
write_hdl -mapped > div_synth.v 
write_sdc > div_synth.sdc
exit
