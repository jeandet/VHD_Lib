onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FIFO_CEL -expand -group COMMON /testbench/cel_clk
add wave -noupdate -expand -group FIFO_CEL -expand -group COMMON /testbench/cel_rstn
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_READ /testbench/cel_data_out
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_READ /testbench/cel_data_ren
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_READ /testbench/cel_empty
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_WRITE /testbench/cel_data_wen
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_WRITE /testbench/cel_full
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_WRITE /testbench/cel_full_almost
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_WRITE /testbench/cel_wdata
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_ERROR /testbench/cel_error_new
add wave -noupdate -expand -group FIFO_CEL -expand -group FIFO_ERROR /testbench/cel_error_now
add wave -noupdate -expand -group FIFO_RAM -group COMMON /testbench/ram_clk
add wave -noupdate -expand -group FIFO_RAM -group COMMON /testbench/ram_rstn
add wave -noupdate -expand -group FIFO_RAM -group FIFO_READ /testbench/ram_data_out
add wave -noupdate -expand -group FIFO_RAM -group FIFO_READ /testbench/ram_data_ren
add wave -noupdate -expand -group FIFO_RAM -group FIFO_READ /testbench/ram_empty
add wave -noupdate -expand -group FIFO_RAM -group FIFO_WRITE /testbench/ram_data_wen
add wave -noupdate -expand -group FIFO_RAM -group FIFO_WRITE /testbench/ram_full
add wave -noupdate -expand -group FIFO_RAM -group FIFO_WRITE /testbench/ram_full_almost
add wave -noupdate -expand -group FIFO_RAM -group FIFO_WRITE /testbench/ram_wdata
add wave -noupdate -expand -group FIFO_RAM -expand -group FIFO_ERROR /testbench/ram_error_new
add wave -noupdate -expand -group FIFO_RAM -expand -group FIFO_ERROR /testbench/ram_error_now
add wave -noupdate -format Analog-Step -height 74 -max 256.0 /testbench/lpp_fifo_ram/lpp_fifo_control_1/space_busy
add wave -noupdate -format Analog-Step -height 74 -max 256.0 /testbench/lpp_fifo_ram/lpp_fifo_control_1/space_free
add wave -noupdate /testbench/fifo_verif_ram/read_stop
add wave -noupdate /testbench/fifo_verif_ram/write_stop
add wave -noupdate -expand -group EMPTY_FIFO_RAM /testbench/lpp_fifo_ram/lpp_fifo_control_1/empty
add wave -noupdate -expand -group EMPTY_FIFO_RAM /testbench/lpp_fifo_ram/lpp_fifo_control_1/empty_threshold
add wave -noupdate -expand -group FULL_FIFO_RAM /testbench/lpp_fifo_ram/lpp_fifo_control_1/full
add wave -noupdate -expand -group FULL_FIFO_RAM /testbench/lpp_fifo_ram/lpp_fifo_control_1/full_almost
add wave -noupdate -expand -group FULL_FIFO_RAM /testbench/lpp_fifo_ram/lpp_fifo_control_1/full_threshold
add wave -noupdate -radix unsigned /testbench/lpp_fifo_ram/lpp_fifo_control_1/waddr_vect
add wave -noupdate -radix unsigned /testbench/lpp_fifo_ram/lpp_fifo_control_1/raddr_vect
add wave -noupdate -radix unsigned /testbench/lpp_fifo_ram/lpp_fifo_control_1/waddr_vect_s
add wave -noupdate -radix unsigned /testbench/lpp_fifo_ram/lpp_fifo_control_1/raddr_vect_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4865000 ps} 0}
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
WaveRestoreZoom {0 ps} {127181250 ps}
