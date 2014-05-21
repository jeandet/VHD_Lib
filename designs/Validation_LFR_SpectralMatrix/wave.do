onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f0_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f1_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f1_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f2_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f2_wdata
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/wen
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/full
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/almost_full
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/empty
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/ren
add wave -noupdate -group FIFO_f0_A -radix decimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/raddr_vect
add wave -noupdate -group FIFO_f0_A -radix decimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/waddr_vect
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/more_16data
add wave -noupdate -group FIFO_f0_A -radix hexadecimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/wen
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/almost_full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/empty
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/ren
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/wen
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/memcel/cram/rwclk
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/almost_full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/empty
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/ren
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/more_16data
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/sfull
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/sfull_s
add wave -noupdate -expand -group FIFO_f1 -radix hexadecimal /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/wen
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/full
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/almost_full
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/empty
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/ren
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_select_channel
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_load_fft
add wave -noupdate /tb/lpp_lfr_ms_1/corefft_1/ifoload
add wave -noupdate /tb/lpp_lfr_ms_1/corefft_1/ifid_im
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/corefft_1/ifid_re
add wave -noupdate /tb/lpp_lfr_ms_1/corefft_1/ifid_valid
add wave -noupdate /tb/lpp_lfr_ms_1/corefft_1/ifinreset
add wave -noupdate /tb/lpp_lfr_ms_1/corefft_1/ifistart
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f0
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f1
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f2
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifiread_y
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifopong
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifoy_rdy
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifoy_valid
add wave -noupdate -expand -group FFT_RESULT_INTERFACE -radix hexadecimal /tb/lpp_lfr_ms_1/corefft_1/ifoy_im
add wave -noupdate -expand -group FFT_RESULT_INTERFACE -radix hexadecimal /tb/lpp_lfr_ms_1/corefft_1/ifoy_re
add wave -noupdate -expand -group FFT_RESULT_INTERFACE -radix hexadecimal /tb/lpp_lfr_ms_1/corefft_1/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate /tb/lpp_lfr_ms_1/status_channel
add wave -noupdate -expand -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(1)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(2)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(3)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(4)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/current_fifo_load
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_load_ms_memory
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/almost_full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/empty
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/wdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/wen
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_locked
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_rdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_ren
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_auto
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_done
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_start
add wave -noupdate -expand -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_data
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_empty
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_ren
add wave -noupdate -expand -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_data
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_full
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_wen
add wave -noupdate -expand -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/op1
add wave -noupdate -expand -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/op2
add wave -noupdate -expand -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/res
add wave -noupdate -expand -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/state
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/empty
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wen
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/raddr_vect
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/raddr_vect_s
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/waddr_vect
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/waddr_vect_s
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/raddr_vect
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/raddr_vect_s
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/waddr_vect
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/waddr_vect_s
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0_end
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0_new
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1_end
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1_new
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_0_ready
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_1_ready
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_ongoing
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_data
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_empty
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_ren
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_status
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_addr
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_data
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_done
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_ren
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_valid
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_valid_burst
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f0_0
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f0_1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f2
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f0_0
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f0_1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f2
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/state
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/matrix_type
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/component_type_pre
add wave -noupdate -radix unsigned /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/component_type
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_check_ok
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_empty
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/log_empty_fifo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189796403054 ps} 0} {{Cursor 2} {44837900611 ps} 0} {{Cursor 3} {10445420000 ps} 0} {{Cursor 4} {61378464308 ps} 0} {{Cursor 5} {99992359332 ps} 0}
configure wave -namecolwidth 469
configure wave -valuecolwidth 112
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
WaveRestoreZoom {10380584292 ps} {10668763932 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
