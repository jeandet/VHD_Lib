vcom -quiet  -93  -work work MINI_LFR_top.vhd 
vcom -quiet  -93  -work work testbench.vhd

vsim work.testbench

log -r *

do wave.do

run 250 us
