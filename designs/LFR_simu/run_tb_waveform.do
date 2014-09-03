vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_top_lfr/lpp_lfr_apbreg_simu.vhd

vcom -quiet  -93  -work lpp testbench_package.vhd

vcom -quiet  -93  -work work tb_waveform.vhd

vsim work.testbench

log -r *

do wave_ms.do

run 2 ms
