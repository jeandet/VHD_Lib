vcom -quiet  -93  -work work data_read.vhd 
vcom -quiet  -93  -work work data_write.vhd 
vcom -quiet  -93  -work work data_read_with_timer.vhd 
vcom -quiet  -93  -work work data_write_with_burstCounter.vhd
vcom -quiet  -93  -work work tb.vhd

vsim work.testbench

log -r *

do wave.do

run -all
