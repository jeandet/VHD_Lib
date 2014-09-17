vcom -quiet  -93  -work lpp  ../../lib/lpp/lpp_memory/lpp_FIFO_control.vhd
vcom -quiet  -93  -work work FIFO_Verif.vhd
vcom -quiet  -93  -work work tb.vhd

vsim work.testbench

log -r *

do wave.do

run -all
