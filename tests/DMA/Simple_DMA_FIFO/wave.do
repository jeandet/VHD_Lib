onerror {resume}
quietly WaveActivateNextPane {} 0
add wave sim:/testbench/*
radix signal sim:/testbench/rdata h
radix signal sim:/testbench/wdata h
add wave -divider FIFO_CTRL
add wave -position end sim:/testbench/DUT/lpp_fifo_control_1/*
radix signal sim:/testbench/DUT/lpp_fifo_control_1/mem_r_addr  h
radix signal sim:/testbench/DUT/lpp_fifo_control_1/mem_w_addr  h
radix signal sim:/testbench/DUT/lpp_fifo_control_1/Waddr_vect  h
radix signal sim:/testbench/DUT/lpp_fifo_control_1/Raddr_vect  h
radix signal sim:/testbench/DUT/lpp_fifo_control_1/Waddr_vect_s h
radix signal sim:/testbench/DUT/lpp_fifo_control_1/Raddr_vect_s h
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141151108000 fs} 0}
configure wave -namecolwidth 234
configure wave -valuecolwidth 77
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
WaveRestoreZoom {0 fs} {525 us}