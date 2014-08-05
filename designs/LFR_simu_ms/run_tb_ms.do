vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma_pkg.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/fifo_latency_correction.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma_ip.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma_send_16word.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma_send_1word.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_dma/lpp_dma_singleOrBurst.vhd

vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_waveform/lpp_waveform_snapshot.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/lpp_top_lfr/lpp_lfr_pkg.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_top_lfr/lpp_lfr.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_top_lfr/lpp_lfr_ms.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd

vcom -quiet  -93  -work lpp ../../lib/lpp/dsp/iir_filter/RAM_CEL_N.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/dsp/lpp_fft/CoreFFT_simu.vhd

vcom -quiet  -93  -work lpp  testbench_package.vhd
vcom -quiet  -93  -work lpp  tb_memory.vhd
vcom -quiet  -93  -work work tb_ms.vhd

vsim work.testbench

log -r *
do wave_ms.do
##run 15 ms
