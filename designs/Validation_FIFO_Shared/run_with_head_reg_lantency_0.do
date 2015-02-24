vcom -quiet  -93  -work work tb_with_head_reg_latency_0.vhd

vsim work.testbench

log -r *

do wave_head_reg_latency_0.do

run -all
