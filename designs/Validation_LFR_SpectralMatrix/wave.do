onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f0_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f1_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f1_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f2_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f2_wdata
add wave -noupdate -expand -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/wen
add wave -noupdate -expand -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/full
add wave -noupdate -expand -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/almost_full
add wave -noupdate -expand -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/empty
add wave -noupdate -expand -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/ren
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/wen
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/almost_full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/empty
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/ren
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/wen
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/almost_full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/empty
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/ren
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
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifoy_im
add wave -noupdate -expand -group FFT_RESULT_INTERFACE /tb/lpp_lfr_ms_1/corefft_1/ifoy_re
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189796403054 ps} 0} {{Cursor 2} {27617887437 ps} 0} {{Cursor 3} {10382020000 ps} 0} {{Cursor 4} {47317662811 ps} 0} {{Cursor 5} {95613018769 ps} 0}
configure wave -namecolwidth 402
configure wave -valuecolwidth 199
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
WaveRestoreZoom {10380205948 ps} {10383691010 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
