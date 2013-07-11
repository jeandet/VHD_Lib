onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_wf_picker/clk49_152mhz
add wave -noupdate /tb_wf_picker/clkm
add wave -noupdate /tb_wf_picker/rstn
add wave -noupdate /tb_wf_picker/coarse_time_0
add wave -noupdate /tb_wf_picker/bias_fail_sw
add wave -noupdate /tb_wf_picker/adc_oeb_bar_ch
add wave -noupdate /tb_wf_picker/adc_smpclk
add wave -noupdate /tb_wf_picker/adc_data
add wave -noupdate /tb_wf_picker/apbi
add wave -noupdate /tb_wf_picker/apbo
add wave -noupdate /tb_wf_picker/ahbmi
add wave -noupdate /tb_wf_picker/sample
add wave -noupdate /tb_wf_picker/sample_val
add wave -noupdate -group RHF1401_DRIVER /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/cnv_clk
add wave -noupdate -group RHF1401_DRIVER /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/clk
add wave -noupdate -group RHF1401_DRIVER /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/rstn
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/adc_data
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/chanelcount
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/adc_noe_reg_shift
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/adc_noe_reg
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/sample_reg
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/cnv_clk_reg
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/start_readout
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/state
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/adc_index
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/adc_noe
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/sample_val
add wave -noupdate -group RHF1401_DRIVER -radix hexadecimal /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/sample
add wave -noupdate -group RHF1401_DRIVER /tb_wf_picker/top_ad_conv_rhf1401_1/rhf1401_drvr_1/cnv_clk
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f3
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f3_val
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f2
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f2_val
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f1
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f1_val
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f0
add wave -noupdate -expand -group SAMPLE_VAL /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/sample_f0_val
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/time_ren
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/data_ren
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/ren
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/ready
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/rdata
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/data_wen
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/time_wen
add wave -noupdate -group WaveForm_fifo /tb_wf_picker/waveform_picker0/wf_picker_without_filter/lpp_top_lfr_wf_picker_ip_2/lpp_waveform_1/lpp_waveform_fifo_1/wdata
add wave -noupdate /tb_wf_picker/ahbmo(2)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27385336150 ps} 0}
configure wave -namecolwidth 644
configure wave -valuecolwidth 534
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
WaveRestoreZoom {2342005961 ps} {4381125074 ps}
