onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/run
add wave -noupdate /testbench/read_stop
add wave -noupdate /testbench/write_stop
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/error_now(3) {-height 15 -radix hexadecimal} /testbench/error_now(2) {-height 15 -radix hexadecimal} /testbench/error_now(1) {-height 15 -radix hexadecimal} /testbench/error_now(0) {-height 15 -radix hexadecimal}} /testbench/error_now
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/error_new(3) {-height 15 -radix hexadecimal} /testbench/error_new(2) {-height 15 -radix hexadecimal} /testbench/error_new(1) {-height 15 -radix hexadecimal} /testbench/error_new(0) {-height 15 -radix hexadecimal}} /testbench/error_new
add wave -noupdate /testbench/warning_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41355000 ps} 0}
configure wave -namecolwidth 341
configure wave -valuecolwidth 172
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
WaveRestoreZoom {0 ps} {699496876 ps}
