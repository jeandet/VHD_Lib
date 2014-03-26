onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/tb_string
add wave -noupdate /tb/assertion_1
add wave -noupdate /tb/assertion_2
add wave -noupdate /tb/assertion_3
add wave -noupdate /tb/apb_lfr_time_management_1/lfr_time_management_1/state
add wave -noupdate -format Analog-Step -height 74 -max 66000.0 -radix hexadecimal /tb/apb_lfr_time_management_1/lfr_time_management_1/fine_time
add wave -noupdate /tb/apb_lfr_time_management_1/lfr_time_management_1/coarse_time_new
add wave -noupdate -radix hexadecimal /tb/apb_lfr_time_management_1/lfr_time_management_1/coarse_time
add wave -noupdate /tb/apb_lfr_time_management_1/grspw_tick
add wave -noupdate -group OUTPUT /tb/apb_lfr_time_management_1/fine_time
add wave -noupdate -group OUTPUT /tb/apb_lfr_time_management_1/coarse_time
add wave -noupdate /tb/apb_lfr_time_management_1/lfr_time_management_1/fine_time_new
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{FT 1} {15279095 ps} 1} {{FT 1 + 1s} {1000012719095 ps} 1} {{Cursor 3} {369333380000 ps} 0} {TRANSITION {169333245705 ps} 1}
configure wave -namecolwidth 512
configure wave -valuecolwidth 139
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
WaveRestoreZoom {0 ps} {243152392641 ps}
