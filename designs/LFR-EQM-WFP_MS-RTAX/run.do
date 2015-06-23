vcom -quiet  -93  -work work LFR-em.vhd 
vcom -quiet  -93  -work work testbench.vhd

vsim work.testbench

log -r *

do wave.do

run 65 ms
