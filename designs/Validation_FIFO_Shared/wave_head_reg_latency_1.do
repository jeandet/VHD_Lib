onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/run
add wave -noupdate -expand /testbench/empty
add wave -noupdate /testbench/full
add wave -noupdate /testbench/read_stop
add wave -noupdate /testbench/write_stop
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/error_now(3) {-height 15 -radix hexadecimal} /testbench/error_now(2) {-height 15 -radix hexadecimal} /testbench/error_now(1) {-height 15 -radix hexadecimal} /testbench/error_now(0) {-height 15 -radix hexadecimal}} /testbench/error_now
add wave -noupdate -radix hexadecimal /testbench/error_new
add wave -noupdate -expand -group FIFO_IN /testbench/full_almost
add wave -noupdate -expand -group FIFO_IN /testbench/full
add wave -noupdate -expand -group FIFO_IN /testbench/data_wen
add wave -noupdate -expand -group FIFO_IN -radix hexadecimal /testbench/wdata
add wave -noupdate -group internal /testbench/s_empty_almost
add wave -noupdate -group internal -expand /testbench/s_empty
add wave -noupdate -group internal -expand /testbench/s_data_ren
add wave -noupdate -group internal -radix hexadecimal /testbench/s_rdata
add wave -noupdate /testbench/pointer_write
add wave -noupdate -expand -group FIFO_OUT -expand /testbench/empty_almost
add wave -noupdate -expand -group FIFO_OUT -expand /testbench/empty
add wave -noupdate -expand -group FIFO_OUT -radix binary -expand -subitemconfig {/testbench/data_ren(3) {-height 15 -radix binary} /testbench/data_ren(2) {-height 15 -radix binary} /testbench/data_ren(1) {-height 15 -radix binary} /testbench/data_ren(0) {-height 15 -radix binary}} /testbench/data_ren
add wave -noupdate -expand -group FIFO_OUT -radix hexadecimal -expand -subitemconfig {/testbench/data_out(0) {-height 15 -radix hexadecimal} /testbench/data_out(1) {-height 15 -radix hexadecimal} /testbench/data_out(2) {-height 15 -radix hexadecimal} /testbench/data_out(3) {-height 15 -radix hexadecimal}} /testbench/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41365000 ps} 0}
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
WaveRestoreZoom {40912888 ps} {42319723 ps}
