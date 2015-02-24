vcom -quiet  -93  -work work tb_calc.vhd

vsim work.testbench

log -r *

do wave_calc.do

run -all

