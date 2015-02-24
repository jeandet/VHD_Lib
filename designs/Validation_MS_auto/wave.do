onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group DATA_GEN_F0 /testbench/data_read_with_timer_f0/data_out_val
add wave -noupdate -expand -group DATA_GEN_F0 /testbench/data_read_with_timer_f0/end_of_file
add wave -noupdate -expand -group DATA_GEN_F0 /testbench/data_read_with_timer_f0/data_out
add wave -noupdate -expand -group DATA_GEN_F1 /testbench/data_read_with_timer_f1/data_out_val
add wave -noupdate -expand -group DATA_GEN_F1 /testbench/data_read_with_timer_f1/end_of_file
add wave -noupdate -expand -group DATA_GEN_F1 /testbench/data_read_with_timer_f1/data_out
add wave -noupdate -expand -group DATA_GEN_F2 /testbench/data_read_with_timer_f2/data_out_val
add wave -noupdate -expand -group DATA_GEN_F2 /testbench/data_read_with_timer_f2/end_of_file
add wave -noupdate -expand -group DATA_GEN_F2 /testbench/data_read_with_timer_f2/data_out
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_buffer_addr
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_buffer_full
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_buffer_full_err
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_buffer_length
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_buffer_new
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_fifo_burst_valid
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_fifo_data
add wave -noupdate -expand -group DMA_interface /testbench/lpp_lfr_ms_1/dma_fifo_ren
add wave -noupdate /testbench/dma_ren_counter
add wave -noupdate /testbench/dma_output_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10933060000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 339
configure wave -valuecolwidth 100
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {42718685333 ps}
