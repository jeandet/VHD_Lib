vcom -quiet  -93  -work work tb.vhd

vsim work.testbench

log -r *

do wave.do

run -all
