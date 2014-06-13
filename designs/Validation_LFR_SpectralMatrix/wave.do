onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -expand -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -expand -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate -expand -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(5)
add wave -noupdate -expand -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(4)
add wave -noupdate -expand -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(3)
add wave -noupdate -expand -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(8)
add wave -noupdate -expand -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(7)
add wave -noupdate -expand -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(6)
add wave -noupdate -expand -group debug /tb/lpp_lfr_ms_1/debug_reg
add wave -noupdate -expand -group debug /tb/lpp_lfr_apbreg_1/apbi
add wave -noupdate -expand -group debug /tb/lpp_lfr_apbreg_1/apbo
add wave -noupdate -expand -group debug /tb/ready_reg
add wave -noupdate -expand -group Logic /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -expand -group Logic /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -expand -group Logic /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate /tb/lpp_lfr_apbreg_1/debug_signal
add wave -noupdate -expand -subitemconfig {/tb/lpp_lfr_ms_1/observation_vector_0(2) {-color Blue -height 15} /tb/lpp_lfr_ms_1/observation_vector_0(0) {-color Blue -height 15}} /tb/lpp_lfr_ms_1/observation_vector_0
add wave -noupdate -expand /tb/lpp_lfr_ms_1/observation_vector_1
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter_out
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter_wait
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_bad_component_error
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_buffer_full
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_input_fifo_write
add wave -noupdate -expand -group INPUT_FIFO_F1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/wen
add wave -noupdate -expand -group INPUT_FIFO_F1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/ren
add wave -noupdate -expand -group INPUT_FIFO_F1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/empty
add wave -noupdate -expand -group INPUT_FIFO_F1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/full
add wave -noupdate -expand -group INPUT_FIFO_F1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/almost_full
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/lpp_lfr_apbreg_1/reg_sp.config_active_interruption_onnewmatrix {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.config_active_interruption_onerror {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.config_ms_run {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f0_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f1_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f2_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f0_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f1_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_ready_matrix_f2_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_error_bad_component_error {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_error_buffer_full {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.status_error_input_fifo_write {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f0_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f0_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f1_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f1_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f2_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.addr_matrix_f2_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f0_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f0_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f1_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f1_1 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f2_0 {-height 15 -radix hexadecimal} /tb/lpp_lfr_apbreg_1/reg_sp.time_matrix_f2_1 {-height 15 -radix hexadecimal}} /tb/lpp_lfr_apbreg_1/reg_sp
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/sample_valid
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_read
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/sample_data
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/sample_load
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_pong
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_data_im
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_data_re
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_data_valid
add wave -noupdate -expand -group FFT /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/fft_ready
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_load_fft
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_select_channel
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/in_wen
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/in_data
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/in_full
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/in_empty
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/fsm_state
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/reg_data
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/out_wen_s
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/out_wen
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/out_data
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_reg_head_1/out_full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41374417240 ps} 0} {{Cursor 2} {62390873400 ps} 0}
configure wave -namecolwidth 419
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
WaveRestoreZoom {62074549955 ps} {63157132736 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
