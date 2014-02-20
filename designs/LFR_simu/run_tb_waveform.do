vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/fifo_latency_correction.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma_ip.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd
vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_dma/lpp_dma_singleOrBurst.vhd

vcom -quiet  -93  -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd

vcom -quiet -93 -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_top_lfr/lpp_lfr_ms_test.vhd
vcom -quiet -93 -work lpp ../../../grlib-ft-fpga-grlfpu-spw-1.2.4-b4126/lib/../../tortoiseHG_vhdlib/lib/lpp/./lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd

vcom -quiet  -93  -work lpp ../../lib/../../tortoiseHG_vhdlib/lib/lpp/./dsp/iir_filter/RAM_CEL_N.vhd

vcom -quiet  -93  -work lpp testbench_package.vhd

vcom -quiet  -93  -work work tb_waveform.vhd

vsim work.testbench

log -r *

do wave_waveform_longsim.do

run 40 ms
