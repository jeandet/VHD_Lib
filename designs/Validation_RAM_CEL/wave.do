onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group COMMON /tb/clk
add wave -noupdate -expand -group COMMON /tb/rstn
add wave -noupdate -expand -group COMMON /tb/random_vector
add wave -noupdate -expand -group WRITE -radix hexadecimal /tb/write_data
add wave -noupdate -expand -group WRITE -radix hexadecimal /tb/write_addr
add wave -noupdate -expand -group WRITE -radix hexadecimal /tb/write_enable
add wave -noupdate -expand -group WRITE -radix hexadecimal /tb/write_enable_n
add wave -noupdate -expand -group READ -radix hexadecimal /tb/read_data_ram
add wave -noupdate -expand -group READ -radix hexadecimal /tb/read_data_cel
add wave -noupdate -expand -group READ -radix hexadecimal /tb/read_addr
add wave -noupdate -expand -group READ -radix hexadecimal /tb/read_enable
add wave -noupdate -expand -group READ -radix hexadecimal /tb/read_enable_n
add wave -noupdate -radix hexadecimal /tb/warning_value
add wave -noupdate -radix hexadecimal /tb/warning_value_clocked
add wave -noupdate -radix hexadecimal /tb/error_value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5926078 ps} 0} {{Cursor 2} {200000 ps} 0}
configure wave -namecolwidth 403
configure wave -valuecolwidth 198
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
WaveRestoreZoom {0 ps} {25526182 ps}
