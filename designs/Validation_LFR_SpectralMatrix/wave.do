onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(5)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(4)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(3)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(8)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(7)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(6)
add wave -noupdate -group debug /tb/lpp_lfr_ms_1/debug_reg
add wave -noupdate -group debug /tb/lpp_lfr_apbreg_1/apbi
add wave -noupdate -group debug /tb/lpp_lfr_apbreg_1/apbo
add wave -noupdate -group debug /tb/ready_reg
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate -expand /tb/lpp_lfr_apbreg_1/debug_signal
add wave -noupdate -expand -subitemconfig {/tb/lpp_lfr_ms_1/observation_vector_0(2) {-color Blue} /tb/lpp_lfr_ms_1/observation_vector_0(0) {-color Blue}} /tb/lpp_lfr_ms_1/observation_vector_0
add wave -noupdate -expand /tb/lpp_lfr_ms_1/observation_vector_1
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter_out
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fft_1/corefft_1/counter_wait
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20859515887 ps} 0}
configure wave -namecolwidth 253
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
WaveRestoreZoom {20840058904 ps} {20863099265 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
