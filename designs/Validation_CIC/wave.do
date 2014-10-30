onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut_cic/d_delay_number
add wave -noupdate /testbench/dut_cic/s_stage_number
add wave -noupdate /testbench/dut_cic/r_downsampling_decimation_factor
add wave -noupdate -format Analog-Step -height 74 -max 1999.9999999999998 /testbench/chirp_gen/freq_chirp
add wave -noupdate -format Analog-Step -height 74 -max 10000.0 /testbench/chirp_gen/n
add wave -noupdate -format Analog-Step -height 74 -max 200.0 -min -200.0 -radix decimal /testbench/dut_cic/data_in
add wave -noupdate -format Analog-Step -height 74 -max 189.0 -min -172.0 -radix decimal /testbench/dut_cic/data_out
add wave -noupdate -divider COMB
add wave -noupdate -radix decimal -expand -subitemconfig {/testbench/dut_cic/c_data(3) {-format Analog-Step -height 74 -max 6208650.0000000009 -min -5630018.0 -radix decimal} /testbench/dut_cic/c_data(2) {-format Analog-Step -height 74 -max 22640530.0 -radix decimal} /testbench/dut_cic/c_data(1) {-format Analog-Step -height 74 -max 1067269590.0 -min -1072646474.0 -radix decimal} /testbench/dut_cic/c_data(0) {-format Analog-Step -height 74 -max 1071549238.9999998 -min -1068913901.0 -radix decimal}} /testbench/dut_cic/c_data
add wave -noupdate -divider INTEGRATOR
add wave -noupdate -radix decimal -expand -subitemconfig {/testbench/dut_cic/i_data(3) {-format Analog-Step -height 74 -max 1073731108.9999998 -min -1073537753.0 -radix decimal} /testbench/dut_cic/i_data(2) {-format Analog-Step -height 74 -max 164477947.0 -radix decimal} /testbench/dut_cic/i_data(1) {-format Analog-Step -height 74 -max 22580.0 -radix decimal} /testbench/dut_cic/i_data(0) {-format Analog-Step -height 74 -max 200.0 -min -200.0 -radix decimal}} /testbench/dut_cic/i_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3685000 ps} 0}
configure wave -namecolwidth 370
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {110307750 ps}
