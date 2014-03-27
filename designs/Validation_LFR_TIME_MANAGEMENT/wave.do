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
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/apbi.psel {-radix hexadecimal} /tb/apbi.psel(0) {-radix hexadecimal} /tb/apbi.psel(1) {-radix hexadecimal} /tb/apbi.psel(2) {-radix hexadecimal} /tb/apbi.psel(3) {-radix hexadecimal} /tb/apbi.psel(4) {-radix hexadecimal} /tb/apbi.psel(5) {-radix hexadecimal} /tb/apbi.psel(6) {-radix hexadecimal} /tb/apbi.psel(7) {-radix hexadecimal} /tb/apbi.psel(8) {-radix hexadecimal} /tb/apbi.psel(9) {-radix hexadecimal} /tb/apbi.psel(10) {-radix hexadecimal} /tb/apbi.psel(11) {-radix hexadecimal} /tb/apbi.psel(12) {-radix hexadecimal} /tb/apbi.psel(13) {-radix hexadecimal} /tb/apbi.psel(14) {-radix hexadecimal} /tb/apbi.psel(15) {-radix hexadecimal} /tb/apbi.penable {-radix hexadecimal} /tb/apbi.paddr {-radix hexadecimal} /tb/apbi.pwrite {-radix hexadecimal} /tb/apbi.pwdata {-radix hexadecimal} /tb/apbi.pirq {-radix hexadecimal} /tb/apbi.testen {-radix hexadecimal} /tb/apbi.testrst {-radix hexadecimal} /tb/apbi.scanen {-radix hexadecimal} /tb/apbi.testoen {-radix hexadecimal} /tb/apbi.testin {-radix hexadecimal}} /tb/apbi
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/apbo.prdata {-radix hexadecimal} /tb/apbo.pirq {-radix hexadecimal} /tb/apbo.pconfig {-radix hexadecimal} /tb/apbo.pindex {-radix hexadecimal}} /tb/apbo
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/apb_lfr_time_management_1/r.ctrl {-radix hexadecimal} /tb/apb_lfr_time_management_1/r.coarse_time_load {-radix hexadecimal} /tb/apb_lfr_time_management_1/r.coarse_time {-radix hexadecimal} /tb/apb_lfr_time_management_1/r.fine_time {-radix hexadecimal}} /tb/apb_lfr_time_management_1/r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{FT 1} {15279095 ps} 1} {{FT 1 + 1s} {1000012719095 ps} 1} {{Cursor 3} {750199620000 ps} 0} {TRANSITION {169333245705 ps} 1}
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
WaveRestoreZoom {0 ps} {1185800469 ns}
