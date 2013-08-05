onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Data Acq & Filter} -expand -group DIGITAL_ACQ /tb_data_acquisition/top_data_acquisition_1/digital_acquisition/sample
add wave -noupdate -expand -group {Data Acq & Filter} -expand -group DIGITAL_ACQ /tb_data_acquisition/top_data_acquisition_1/digital_acquisition/sample_val
add wave -noupdate -expand -group {Data Acq & Filter} -group FILTER /tb_data_acquisition/top_data_acquisition_1/iir_cel_ctrlr_v2_1/sample_in_val
add wave -noupdate -expand -group {Data Acq & Filter} -group FILTER /tb_data_acquisition/top_data_acquisition_1/iir_cel_ctrlr_v2_1/sample_in
add wave -noupdate -expand -group {Data Acq & Filter} -group FILTER /tb_data_acquisition/top_data_acquisition_1/iir_cel_ctrlr_v2_1/sample_out_val
add wave -noupdate -expand -group {Data Acq & Filter} -group FILTER /tb_data_acquisition/top_data_acquisition_1/iir_cel_ctrlr_v2_1/sample_out
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f0} /tb_data_acquisition/top_data_acquisition_1/downsampling_f0/sample_in_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f0} /tb_data_acquisition/top_data_acquisition_1/downsampling_f0/sample_in
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f0} /tb_data_acquisition/top_data_acquisition_1/downsampling_f0/sample_out_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f0} /tb_data_acquisition/top_data_acquisition_1/downsampling_f0/sample_out
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f1} /tb_data_acquisition/top_data_acquisition_1/downsampling_f1/sample_in_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f1} /tb_data_acquisition/top_data_acquisition_1/downsampling_f1/sample_in
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f1} /tb_data_acquisition/top_data_acquisition_1/downsampling_f1/sample_out_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f1} /tb_data_acquisition/top_data_acquisition_1/downsampling_f1/sample_out
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f2} /tb_data_acquisition/top_data_acquisition_1/downsampling_f2/sample_in_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f2} /tb_data_acquisition/top_data_acquisition_1/downsampling_f2/sample_in
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f2} /tb_data_acquisition/top_data_acquisition_1/downsampling_f2/sample_out_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f2} /tb_data_acquisition/top_data_acquisition_1/downsampling_f2/sample_out
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f3} /tb_data_acquisition/top_data_acquisition_1/downsampling_f3/sample_in_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f3} /tb_data_acquisition/top_data_acquisition_1/downsampling_f3/sample_in
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f3} /tb_data_acquisition/top_data_acquisition_1/downsampling_f3/sample_out_val
add wave -noupdate -expand -group {Data Acq & Filter} -group {Down f3} /tb_data_acquisition/top_data_acquisition_1/downsampling_f3/sample_out
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f0_wen
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f0_wdata
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f1_wen
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f1_wdata
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f2_wen
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f2_wdata
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f3_wen
add wave -noupdate -expand -group {OUTPUT to FIFO} /tb_data_acquisition/top_data_acquisition_1/sample_f3_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 430
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {754717 ps}
