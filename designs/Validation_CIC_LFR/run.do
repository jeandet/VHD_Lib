vcom -quiet -93 -work lpp ../../lib/lpp/dsp/chirp/chirp_pkg.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/chirp/chirp.vhd

vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_pkg.vhd

vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_integrator.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_downsampler.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_comb.vhd


vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_control.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_add_sub.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_address_gen.vhd

vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_r2.vhd
vcom -quiet  -93  -work lpp  ../../lib/lpp/dsp/cic/cic_lfr_control_r2.vhd

vcom -quiet  -93  -work work tb.vhd

vsim work.testbench

log -r *

do wave.do

run -all

