onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/a
add wave -noupdate /testbench/b
add wave -noupdate /testbench/c
add wave -noupdate /testbench/all_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {631245000 ps} 1} {{Cursor 2} {590125000 ps} 0}
configure wave -namecolwidth 424
configure wave -valuecolwidth 119
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
WaveRestoreZoom {0 ps} {2100026250 ps}
