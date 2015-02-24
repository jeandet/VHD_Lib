onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/cnv_clk
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/cnv_rstn
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/rstn
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/adc_data
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/clk
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/adc_data_v
add wave -noupdate -expand -group CNV_GEN /top_ad_conv_rhf1401_withfilter_tb/dut/cnv_cycle_counter
add wave -noupdate -expand -group CNV_GEN /top_ad_conv_rhf1401_withfilter_tb/dut/cnv_s
add wave -noupdate -expand -group CNV_GEN /top_ad_conv_rhf1401_withfilter_tb/cnv
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/dut/cnv_sync
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/dut/cnv_sync_pre
add wave -noupdate -expand -group DATA_GEN_OutputEnable -radix hexadecimal /top_ad_conv_rhf1401_withfilter_tb/dut/adc_noe_reg
add wave -noupdate -expand -group DATA_GEN_OutputEnable /top_ad_conv_rhf1401_withfilter_tb/dut/enable_adc
add wave -noupdate -radix hexadecimal /top_ad_conv_rhf1401_withfilter_tb/adc_noe
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/dut/channel_counter
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/dut/sample_reg
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/sample_val
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/dut/sample_counter
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/dut/adc_data_selected
add wave -noupdate -expand -group ADC_READ_DATA /top_ad_conv_rhf1401_withfilter_tb/dut/adc_data_result
add wave -noupdate /top_ad_conv_rhf1401_withfilter_tb/sample_val
add wave -noupdate -radix hexadecimal /top_ad_conv_rhf1401_withfilter_tb/sample
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {875312 ps} 0} {{Cursor 2} {200000 ps} 0}
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
WaveRestoreZoom {0 ps} {1050 us}
