onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f3_wdata
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f2_wdata
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f1_wdata
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f0_wdata
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f3_val
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f2_val
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f1_val
add wave -noupdate -expand -group FILTER_OUTPUT /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f0_val
add wave -noupdate -expand -group SNAPSHOT_F0 /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_f0/enable
add wave -noupdate -expand -group SNAPSHOT_F0 /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_f0/burst_enable
add wave -noupdate -expand -group SNAPSHOT_F0 /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_f0/start_snapshot
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/state_on
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/wfp_on_s
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f0_pre
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/first_decount
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/first_init
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/counter_delta_snapshot
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/counter_delta_f0
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/send_start_snapshot_f0
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/data_f0_valid
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/data_f2_valid
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f0
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f1
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f2
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_snapshot_controler_1/wfp_on
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/ahb_master_in
add wave -noupdate -group temp -subitemconfig {/tb/lpp_lfr_1/lpp_dma_singleorburst_1/ahb_master_out.haddr {-height 15 -radix hexadecimal} /tb/lpp_lfr_1/lpp_dma_singleorburst_1/ahb_master_out.hwdata {-height 15 -radix hexadecimal}} /tb/lpp_lfr_1/lpp_dma_singleorburst_1/ahb_master_out
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/send
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/valid_burst
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/done
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/ren
add wave -noupdate -group temp -radix hexadecimal /tb/lpp_lfr_1/lpp_dma_singleorburst_1/address
add wave -noupdate -group temp -radix hexadecimal /tb/lpp_lfr_1/lpp_dma_singleorburst_1/data
add wave -noupdate -group temp /tb/lpp_lfr_1/lpp_dma_singleorburst_1/debug_dmaout_okay
add wave -noupdate -group temp /tb/async_1mx16_0/ce1_b
add wave -noupdate -group temp /tb/async_1mx16_0/ce2
add wave -noupdate -group temp /tb/async_1mx16_0/we_b
add wave -noupdate -group temp /tb/async_1mx16_0/oe_b
add wave -noupdate -group temp /tb/async_1mx16_0/bhe_b
add wave -noupdate -group temp /tb/async_1mx16_0/ble_b
add wave -noupdate -group temp /tb/async_1mx16_0/a
add wave -noupdate -group temp /tb/async_1mx16_0/dq
add wave -noupdate -radix hexadecimal -subitemconfig {/tb/async_1mx16_0/mem_array_0(31) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(30) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(29) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(28) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(27) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(26) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(25) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(24) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(23) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(22) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(21) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(20) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(19) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(18) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(17) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(16) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(15) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(14) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(13) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(12) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(11) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(10) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(9) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(8) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(7) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(6) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(5) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(4) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(3) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(2) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(1) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_0(0) {-height 15 -radix hexadecimal}} /tb/async_1mx16_0/mem_array_0
add wave -noupdate -radix hexadecimal -subitemconfig {/tb/async_1mx16_0/mem_array_1(31) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(30) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(29) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(28) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(27) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(26) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(25) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(24) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(23) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(22) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(21) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(20) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(19) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(18) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(17) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(16) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(15) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(14) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(13) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(12) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(11) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(10) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(9) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(8) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(7) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(6) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(5) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(4) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(3) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(2) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(1) {-height 15 -radix hexadecimal} /tb/async_1mx16_0/mem_array_1(0) {-height 15 -radix hexadecimal}} /tb/async_1mx16_0/mem_array_1
add wave -noupdate -radix hexadecimal /tb/async_1mx16_0/mem_array_2
add wave -noupdate -radix hexadecimal /tb/async_1mx16_0/mem_array_3
add wave -noupdate -format Analog-Step -height 70 -max 256.0 -radix unsigned /tb/lpp_lfr_1/lpp_lfr_ms_1/lppfifoxn_f0_b/fifos(0)/lpp_fifo_1/waddr_vect
add wave -noupdate -radix hexadecimal -subitemconfig {/tb/ahbmi.hirq(31) {-radix hexadecimal} /tb/ahbmi.hirq(30) {-radix hexadecimal} /tb/ahbmi.hirq(29) {-radix hexadecimal} /tb/ahbmi.hirq(28) {-radix hexadecimal} /tb/ahbmi.hirq(27) {-radix hexadecimal} /tb/ahbmi.hirq(26) {-radix hexadecimal} /tb/ahbmi.hirq(25) {-radix hexadecimal} /tb/ahbmi.hirq(24) {-radix hexadecimal} /tb/ahbmi.hirq(23) {-radix hexadecimal} /tb/ahbmi.hirq(22) {-radix hexadecimal} /tb/ahbmi.hirq(21) {-radix hexadecimal} /tb/ahbmi.hirq(20) {-radix hexadecimal} /tb/ahbmi.hirq(19) {-radix hexadecimal} /tb/ahbmi.hirq(18) {-radix hexadecimal} /tb/ahbmi.hirq(17) {-radix hexadecimal} /tb/ahbmi.hirq(16) {-radix hexadecimal} /tb/ahbmi.hirq(15) {-radix hexadecimal} /tb/ahbmi.hirq(14) {-radix hexadecimal} /tb/ahbmi.hirq(13) {-radix hexadecimal} /tb/ahbmi.hirq(12) {-radix hexadecimal} /tb/ahbmi.hirq(11) {-radix hexadecimal} /tb/ahbmi.hirq(10) {-radix hexadecimal} /tb/ahbmi.hirq(9) {-radix hexadecimal} /tb/ahbmi.hirq(8) {-radix hexadecimal} /tb/ahbmi.hirq(7) {-radix hexadecimal} /tb/ahbmi.hirq(6) {-radix hexadecimal} /tb/ahbmi.hirq(5) {-radix hexadecimal} /tb/ahbmi.hirq(4) {-radix hexadecimal} /tb/ahbmi.hirq(3) {-radix hexadecimal} /tb/ahbmi.hirq(2) {-radix hexadecimal} /tb/ahbmi.hirq(1) {-radix hexadecimal} /tb/ahbmi.hirq(0) {-radix hexadecimal}} /tb/ahbmi.hirq
add wave -noupdate /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/status_full
add wave -noupdate /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/status_full_ack
add wave -noupdate /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/status_full_err
add wave -noupdate -radix unsigned /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/nb_data_by_buffer
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_p(3) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_p(2) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_p(1) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_p(0) {-radix hexadecimal}} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_p
add wave -noupdate -radix hexadecimal -expand -subitemconfig {/tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_b(3) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_b(2) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_b(1) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_b(0) {-radix hexadecimal}} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_v_b
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_data_f0
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_data_f1
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_data_f2
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/addr_data_f3
add wave -noupdate /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_gen_address_1/run
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189796403054 ps} 0} {{Cursor 2} {44999193701 ps} 0} {{Cursor 3} {265000 ps} 0} {{Cursor 4} {69917366400 ps} 0} {{Cursor 5} {27526990683 ps} 0}
configure wave -namecolwidth 518
configure wave -valuecolwidth 227
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
WaveRestoreZoom {0 ps} {966012 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
