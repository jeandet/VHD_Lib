onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group COMMON /testbench/clk
add wave -noupdate -expand -group COMMON /testbench/rstn
add wave -noupdate -expand -group COMMON /testbench/run
add wave -noupdate -expand -group FIFO -expand -group FIFO_IN /testbench/full_almost
add wave -noupdate -expand -group FIFO -expand -group FIFO_IN /testbench/full
add wave -noupdate -expand -group FIFO -expand -group FIFO_IN /testbench/data_wen
add wave -noupdate -expand -group FIFO -expand -group FIFO_IN /testbench/wdata
add wave -noupdate -expand -group FIFO -expand -group FIFO_OUT /testbench/empty
add wave -noupdate -expand -group FIFO -expand -group FIFO_OUT /testbench/data_ren
add wave -noupdate -expand -group FIFO -expand -group FIFO_OUT /testbench/data_out
add wave -noupdate -radix hexadecimal /testbench/data_out_obs
add wave -noupdate /testbench/pointer_read
add wave -noupdate /testbench/pointer_write
add wave -noupdate /testbench/error_now
add wave -noupdate /testbench/error_new
add wave -noupdate /testbench/read_stop
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {56085000 ps} 0}
configure wave -namecolwidth 510
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
WaveRestoreZoom {0 ps} {105131250 ps}
