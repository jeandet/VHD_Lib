onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Analog-Step -height 74 -max 2147609999.9999995 -min -2104620000.0 -radix decimal /testbench/data_in_a
add wave -noupdate -format Analog-Step -height 74 -max 2147609999.9999995 -min -2104620000.0 -radix decimal /testbench/data_in_b
add wave -noupdate -format Analog-Step -height 74 -max 2147609999.9999995 -min -2104620000.0 -radix decimal /testbench/data_out
add wave -noupdate /testbench/data_out_carry
add wave -noupdate /testbench/all_is_ok
add wave -noupdate -radix hexadecimal /testbench/data_out
add wave -noupdate -radix hexadecimal /testbench/data_out_pre
add wave -noupdate -radix hexadecimal -subitemconfig {/testbench/data_out_diff(31) {-radix hexadecimal} /testbench/data_out_diff(30) {-radix hexadecimal} /testbench/data_out_diff(29) {-radix hexadecimal} /testbench/data_out_diff(28) {-radix hexadecimal} /testbench/data_out_diff(27) {-radix hexadecimal} /testbench/data_out_diff(26) {-radix hexadecimal} /testbench/data_out_diff(25) {-radix hexadecimal} /testbench/data_out_diff(24) {-radix hexadecimal} /testbench/data_out_diff(23) {-radix hexadecimal} /testbench/data_out_diff(22) {-radix hexadecimal} /testbench/data_out_diff(21) {-radix hexadecimal} /testbench/data_out_diff(20) {-radix hexadecimal} /testbench/data_out_diff(19) {-radix hexadecimal} /testbench/data_out_diff(18) {-radix hexadecimal} /testbench/data_out_diff(17) {-radix hexadecimal} /testbench/data_out_diff(16) {-radix hexadecimal} /testbench/data_out_diff(15) {-radix hexadecimal} /testbench/data_out_diff(14) {-radix hexadecimal} /testbench/data_out_diff(13) {-radix hexadecimal} /testbench/data_out_diff(12) {-radix hexadecimal} /testbench/data_out_diff(11) {-radix hexadecimal} /testbench/data_out_diff(10) {-radix hexadecimal} /testbench/data_out_diff(9) {-radix hexadecimal} /testbench/data_out_diff(8) {-radix hexadecimal} /testbench/data_out_diff(7) {-radix hexadecimal} /testbench/data_out_diff(6) {-radix hexadecimal} /testbench/data_out_diff(5) {-radix hexadecimal} /testbench/data_out_diff(4) {-radix hexadecimal} /testbench/data_out_diff(3) {-radix hexadecimal} /testbench/data_out_diff(2) {-radix hexadecimal} /testbench/data_out_diff(1) {-radix hexadecimal} /testbench/data_out_diff(0) {-radix hexadecimal}} /testbench/data_out_diff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55000 ps} 0}
configure wave -namecolwidth 182
configure wave -valuecolwidth 97
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
WaveRestoreZoom {0 ps} {424577 ps}
