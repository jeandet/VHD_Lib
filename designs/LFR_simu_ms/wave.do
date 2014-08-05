onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FIFO_IN_f0 /testbench/lpp_lfr_ms_1/memf0/reuse
add wave -noupdate -expand -group FIFO_IN_f0 /testbench/lpp_lfr_ms_1/memf0/wen
add wave -noupdate -expand -group FIFO_IN_f0 /testbench/lpp_lfr_ms_1/memf0/ren
add wave -noupdate -expand -group FIFO_IN_f0 /testbench/lpp_lfr_ms_1/memf0/full
add wave -noupdate -expand -group FIFO_IN_f0 -expand /testbench/lpp_lfr_ms_1/memf0/empty
add wave -noupdate -expand -group FIFO_IN_f1 /testbench/lpp_lfr_ms_1/memf1/reuse
add wave -noupdate -expand -group FIFO_IN_f1 /testbench/lpp_lfr_ms_1/memf1/wen
add wave -noupdate -expand -group FIFO_IN_f1 /testbench/lpp_lfr_ms_1/memf1/ren
add wave -noupdate -expand -group FIFO_IN_f1 /testbench/lpp_lfr_ms_1/memf1/full
add wave -noupdate -expand -group FIFO_IN_f1 /testbench/lpp_lfr_ms_1/memf1/empty
add wave -noupdate -expand -group FIFO_IN_f2 /testbench/lpp_lfr_ms_1/memf2/reuse
add wave -noupdate -expand -group FIFO_IN_f2 /testbench/lpp_lfr_ms_1/memf2/wen
add wave -noupdate -expand -group FIFO_IN_f2 /testbench/lpp_lfr_ms_1/memf2/ren
add wave -noupdate -expand -group FIFO_IN_f2 /testbench/lpp_lfr_ms_1/memf2/full
add wave -noupdate -expand -group FIFO_IN_f2 /testbench/lpp_lfr_ms_1/memf2/empty
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/ect
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/countf1
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/countf0
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/load
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/load_reg
add wave -noupdate -expand -group DMUX /testbench/lpp_lfr_ms_1/dmux0/i
add wave -noupdate -expand -group DRIVE /testbench/lpp_lfr_ms_1/fft0/drive/ect
add wave -noupdate -expand -group DRIVE /testbench/lpp_lfr_ms_1/fft0/drive/load
add wave -noupdate -expand -group DRIVE /testbench/lpp_lfr_ms_1/fft0/drive/sload
add wave -noupdate -expand -group DRIVE /testbench/lpp_lfr_ms_1/fft0/drive/fifocpt
add wave -noupdate -expand -group DRIVE -format Analog-Step -max 256.0 /testbench/lpp_lfr_ms_1/fft0/drive/datacount
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_IN /testbench/lpp_lfr_ms_1/fft0/drive_write
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_IN /testbench/lpp_lfr_ms_1/fft0/drive_datare
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_IN /testbench/lpp_lfr_ms_1/fft0/drive_dataim
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_IN /testbench/lpp_lfr_ms_1/fft0/fft_load
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_OUT /testbench/lpp_lfr_ms_1/fft0/fft_dataim
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_OUT /testbench/lpp_lfr_ms_1/fft0/fft_datare
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_OUT /testbench/lpp_lfr_ms_1/fft0/fft_valid
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_OUT /testbench/lpp_lfr_ms_1/fft0/fft_ready
add wave -noupdate -expand -group CORE_FFT -expand -group FFT_OUT /testbench/lpp_lfr_ms_1/fft0/link_read
add wave -noupdate /testbench/lpp_lfr_ms_1/fft0/fft0/fft_ongoing
add wave -noupdate /testbench/lpp_lfr_ms_1/fft0/link/ect
add wave -noupdate /testbench/lpp_lfr_ms_1/fft0/link/fifocpt
add wave -noupdate /testbench/lpp_lfr_ms_1/fft0/link/full
add wave -noupdate -divider HeaderBuilder
add wave -noupdate -expand -group HeaderBuilder -expand -group in -radix hexadecimal /testbench/lpp_lfr_ms_1/head0/statu
add wave -noupdate -expand -group HeaderBuilder -expand -group in /testbench/lpp_lfr_ms_1/head0/matrix_type
add wave -noupdate -expand -group HeaderBuilder -expand -group in /testbench/lpp_lfr_ms_1/head0/matrix_write
add wave -noupdate -expand -group HeaderBuilder -expand -group in /testbench/lpp_lfr_ms_1/head0/valid
add wave -noupdate -expand -group HeaderBuilder -expand -group data_in /testbench/lpp_lfr_ms_1/head0/datain
add wave -noupdate -expand -group HeaderBuilder -expand -group data_in /testbench/lpp_lfr_ms_1/head0/emptyin
add wave -noupdate -expand -group HeaderBuilder -expand -group data_in /testbench/lpp_lfr_ms_1/head0/renout
add wave -noupdate -expand -group HeaderBuilder -expand -group data_out /testbench/lpp_lfr_ms_1/head0/emptyout
add wave -noupdate -expand -group HeaderBuilder -expand -group data_out /testbench/lpp_lfr_ms_1/head0/renout
add wave -noupdate -expand -group HeaderBuilder -expand -group data_out /testbench/lpp_lfr_ms_1/head0/dataout
add wave -noupdate -expand -group HeaderBuilder -expand -group HeaderOut /testbench/lpp_lfr_ms_1/head0/header_ack
add wave -noupdate -expand -group HeaderBuilder -expand -group HeaderOut /testbench/lpp_lfr_ms_1/head0/header
add wave -noupdate -expand -group HeaderBuilder -expand -group HeaderOut /testbench/lpp_lfr_ms_1/head0/header_val
add wave -noupdate -expand -group HeaderBuilder /testbench/lpp_lfr_ms_1/head0/write_reg
add wave -noupdate -expand -group HeaderBuilder /testbench/lpp_lfr_ms_1/head0/max
add wave -noupdate -expand -group HeaderBuilder -radix hexadecimal /testbench/lpp_lfr_ms_1/head0/matrix_param
add wave -noupdate -expand -group HeaderBuilder /testbench/lpp_lfr_ms_1/head0/data_cpt
add wave -noupdate -expand -group HeaderBuilder /testbench/lpp_lfr_ms_1/head0/ect
add wave -noupdate -divider FSM_DMA
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/state
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_reg_ack
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_reg_val
add wave -noupdate -radix hexadecimal /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_reg
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_ack
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_val
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/state
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_done
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_addr
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_data
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_ren
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_valid
add wave -noupdate -expand -group DMA /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/dma_valid_burst
add wave -noupdate -expand -group FIFO /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_data
add wave -noupdate -expand -group FIFO /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_empty
add wave -noupdate -expand -group FIFO /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_ren
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/component_send
add wave -noupdate /testbench/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_select
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10070925926 ps} 0} {{Cursor 2} {22280568302 ps} 0}
configure wave -namecolwidth 374
configure wave -valuecolwidth 44
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
WaveRestoreZoom {10392795757 ps} {10479958650 ps}
