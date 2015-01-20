vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_pkg.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_add_sub.vhd

vcom -quiet  -93  -work work tb_cic_lfr_add_sub.vhd

vsim work.testbench

log -r *

do wave_add_sub.do

run -all
