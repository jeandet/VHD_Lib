onerror {resume}
quietly WaveActivateNextPane {} 0
add wave sim:/testbench/*
add wave -divider AHBUART
add wave sim:/testbench/d3/dcomgen/dcom0/*
radix signal sim:/testbench/d3/dcomgen/dcom0/duarto.data h
radix signal sim:/testbench/d3/dcomgen/dcom0/uarto.scaler h
add wave -divider DMA0
add wave sim:/testbench/d3/dma/dma0/*
add wave -divider DMA0_REGS
add wave sim:/testbench/d3/dma/dma0/apb_regs/*
radix signal sim:/testbench/d3/dma/dma0/apb_regs/DMA_Address h
radix signal sim:/testbench/d3/dma/dma0/apb_regs/DMA_Size d
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