vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/fifo_latency_correction.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/fifo_test_dma.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_pkg.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_apbreg.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_ip.vhd
##vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma_fsm.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_dma/lpp_dma.vhd

vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_memory/SSRAM_plugin.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/./lpp_memory/lpp_memory.vhd

vcom -quiet  -93  -work work CY7C1360C/package_utility.vhd
vcom -quiet  -93  -work work CY7C1360C/CY7C1360C.vhd

vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_bootloader/./bootrom.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_bootloader/./lpp_bootloader_pkg.vhd
vcom -quiet  -93  -work lpp ../../lib/lpp/lpp_bootloader/./lpp_bootloader.vhd

vcom -quiet  -93  -work work config.vhd
vcom -quiet  -93  -work work ahbrom.vhd
vcom -quiet  -93  -work work leon3mp.vhd
vcom -quiet  -93  -work work testbench.vhd

vsim work.testbench

log -r *
do wave_bootloader.do
run 20 us
force -freeze sim:/testbench/d3/lpp_bootloader_1/reg.addr_start_execution 00000000000000000000000000000000 0
run 60 ns
force -freeze sim:/testbench/d3/lpp_bootloader_1/reg.config_start_execution 1 0
run -all