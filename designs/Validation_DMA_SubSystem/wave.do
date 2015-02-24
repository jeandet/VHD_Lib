onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group APB_REG -expand -group BUFFER_CONFIG /tb/lpp_lfr_apbreg_tb_1/buffer_new
add wave -noupdate -expand -group APB_REG -expand -group BUFFER_CONFIG /tb/lpp_lfr_apbreg_tb_1/buffer_length
add wave -noupdate -expand -group APB_REG -expand -group BUFFER_CONFIG /tb/lpp_lfr_apbreg_tb_1/buffer_addr
add wave -noupdate -expand -group APB_REG /tb/lpp_lfr_apbreg_tb_1/buffer_full
add wave -noupdate -expand -group APB_REG /tb/lpp_lfr_apbreg_tb_1/buffer_full_err
add wave -noupdate -expand -group APB_REG /tb/lpp_lfr_apbreg_tb_1/grant_error
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_wen
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_wdata
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_full
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_full_almost
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_empty
add wave -noupdate -expand -group APB_REG -expand -group FIFO_WRITE&STATUS /tb/lpp_lfr_apbreg_tb_1/fifo_empty_threshold
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group AHB /tb/dma_subsystem_1/ahbi
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group AHB /tb/dma_subsystem_1/ahbo
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group FIFO_READ /tb/dma_subsystem_1/fifo_burst_valid
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group FIFO_READ /tb/dma_subsystem_1/fifo_data
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group FIFO_READ /tb/dma_subsystem_1/fifo_ren
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group BUFFER_CONFIG&STATUS /tb/dma_subsystem_1/buffer_new
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group BUFFER_CONFIG&STATUS /tb/dma_subsystem_1/buffer_addr
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group BUFFER_CONFIG&STATUS /tb/dma_subsystem_1/buffer_length
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group BUFFER_CONFIG&STATUS /tb/dma_subsystem_1/buffer_full
add wave -noupdate -expand -group DMA_SUBSYSTEM -expand -group BUFFER_CONFIG&STATUS /tb/dma_subsystem_1/buffer_full_err
add wave -noupdate -expand -group DMA_SUBSYSTEM /tb/dma_subsystem_1/grant_error
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/async_1mx16_0/mem_array_0(31) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(30) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(29) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(28) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(27) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(26) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(25) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(24) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(23) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(22) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(21) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(20) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(19) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(18) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(17) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(16) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(15) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(14) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(13) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(12) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(11) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(10) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(9) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(8) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(7) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(6) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(5) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(4) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(3) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(2) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(1) {-radix hexadecimal} /tb/async_1mx16_0/mem_array_0(0) {-radix hexadecimal}} /tb/async_1mx16_0/mem_array_0
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/async_1mx16_1/mem_array_0(31) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(30) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(29) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(28) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(27) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(26) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(25) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(24) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(23) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(22) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(21) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(20) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(19) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(18) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(17) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(16) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(15) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(14) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(13) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(12) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(11) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(10) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(9) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(8) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(7) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(6) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(5) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(4) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(3) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(2) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(1) {-radix hexadecimal} /tb/async_1mx16_1/mem_array_0(0) {-radix hexadecimal}} /tb/async_1mx16_1/mem_array_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189796403054 ps} 0} {{Cursor 2} {44999193701 ps} 0} {{Cursor 3} {1151509 ps} 0} {{Cursor 4} {69917366400 ps} 0} {{Cursor 5} {27526990683 ps} 0}
configure wave -namecolwidth 618
configure wave -valuecolwidth 472
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {2011303 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
