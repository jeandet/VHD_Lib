onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/run
add wave -noupdate -expand -group FIFO_IN /testbench/full_almost
add wave -noupdate -expand -group FIFO_IN /testbench/full
add wave -noupdate -expand -group FIFO_IN -expand /testbench/data_wen
add wave -noupdate -expand -group FIFO_IN -radix hexadecimal /testbench/wdata
add wave -noupdate -expand -group internal /testbench/s_empty_almost
add wave -noupdate -expand -group internal -expand /testbench/s_empty
add wave -noupdate -expand -group internal -expand /testbench/s_data_ren
add wave -noupdate -expand -group internal -radix hexadecimal /testbench/s_rdata
add wave -noupdate /testbench/pointer_write
add wave -noupdate -expand -group FIFO_OUT -expand /testbench/empty_almost
add wave -noupdate -expand -group FIFO_OUT -expand /testbench/empty
add wave -noupdate -expand -group FIFO_OUT -radix binary -expand -subitemconfig {/testbench/data_ren(3) {-radix binary} /testbench/data_ren(2) {-radix binary} /testbench/data_ren(1) {-radix binary} /testbench/data_ren(0) {-radix binary}} /testbench/data_ren
add wave -noupdate -expand -group FIFO_OUT -radix hexadecimal -expand -subitemconfig {/testbench/data_out(0) {-height 15 -radix hexadecimal} /testbench/data_out(1) {-height 15 -radix hexadecimal} /testbench/data_out(2) {-height 15 -radix hexadecimal} /testbench/data_out(3) {-height 15 -radix hexadecimal}} /testbench/data_out
add wave -noupdate -expand /testbench/pointer_read
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/testbench/error_now(3) {-height 15 -radix hexadecimal} /testbench/error_now(2) {-height 15 -radix hexadecimal} /testbench/error_now(1) {-height 15 -radix hexadecimal} /testbench/error_now(0) {-height 15 -radix hexadecimal}} /testbench/error_now
add wave -noupdate -radix hexadecimal /testbench/error_new
add wave -noupdate /testbench/read_stop
add wave -noupdate -expand /testbench/empty_reg
add wave -noupdate -expand /testbench/data_ren
add wave -noupdate -expand -group Head_REG /testbench/lpp_fifo_4_shared_headreg_1/o_empty_almost
add wave -noupdate -expand -group Head_REG /testbench/lpp_fifo_4_shared_headreg_1/o_empty
add wave -noupdate -expand -group Head_REG /testbench/lpp_fifo_4_shared_headreg_1/o_data_ren
add wave -noupdate -expand -group Head_REG -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/o_rdata_0
add wave -noupdate -expand -group Head_REG -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/o_rdata_1
add wave -noupdate -expand -group Head_REG -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/o_rdata_2
add wave -noupdate -expand -group Head_REG -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/o_rdata_3
add wave -noupdate -expand -group {HEAD_REG - FIFO_Shared} /testbench/lpp_fifo_4_shared_headreg_1/i_empty_almost
add wave -noupdate -expand -group {HEAD_REG - FIFO_Shared} /testbench/lpp_fifo_4_shared_headreg_1/i_empty
add wave -noupdate -expand -group {HEAD_REG - FIFO_Shared} /testbench/lpp_fifo_4_shared_headreg_1/i_data_ren
add wave -noupdate -expand -group {HEAD_REG - FIFO_Shared} -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/i_rdata
add wave -noupdate -radix hexadecimal /testbench/lpp_fifo_4_shared_headreg_1/reg_head_data
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/reg_head_full
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/i_data_ren_pre
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/o_data_ren_pre
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/i_data_ren_s_temp
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/i_data_ren_s
add wave -noupdate /testbench/lpp_fifo_4_shared_headreg_1/i_empty_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75000 ps} 0}
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
WaveRestoreZoom {0 ps} {215438 ps}
