vcom -quiet  -93  -work lpp ../../../grlib/lib/../../tortoiseHG_vhdlib/lib/lpp/./dsp/iir_filter/iir_filter.vhd

vcom -quiet  -93  -work lpp ../../../grlib/lib/../../tortoiseHG_vhdlib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3_DATAFLOW.vhd
vcom -quiet  -93  -work lpp ../../../grlib/lib/../../tortoiseHG_vhdlib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3.vhd

vcom -quiet  -93  -work lpp ../../../grlib/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_top_lfr/lpp_lfr_filter_coeff.vhd
vcom -quiet  -93  -work lpp ../../../grlib/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd

vcom -quiet  -93  -work work IIR_CEL_TEST.vhd
vcom -quiet  -93  -work work IIR_CEL_TEST_v3.vhd
vcom -quiet  -93  -work work tb.vhd

vsim work.testbench

log -r *

do wave.do

run -all

