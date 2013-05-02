onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_data_acquisition/sample_f0_wen
add wave -noupdate /tb_data_acquisition/sample_f0_wdata
add wave -noupdate /tb_data_acquisition/sample_f1_wen
add wave -noupdate /tb_data_acquisition/sample_f1_wdata
add wave -noupdate /tb_data_acquisition/sample_f2_wen
add wave -noupdate /tb_data_acquisition/sample_f2_wdata
add wave -noupdate /tb_data_acquisition/sample_f3_wen
add wave -noupdate /tb_data_acquisition/sample_f3_wdata
add wave -noupdate -group TOP /tb_data_acquisition/ahb_master_in
add wave -noupdate -group TOP /tb_data_acquisition/ahb_master_out
add wave -noupdate -group TOP /tb_data_acquisition/coarse_time_0
add wave -noupdate -group TOP /tb_data_acquisition/coarse_time_0_t
add wave -noupdate -group TOP /tb_data_acquisition/coarse_time_0_t2
add wave -noupdate -group TOP /tb_data_acquisition/delta_snapshot
add wave -noupdate -group TOP /tb_data_acquisition/delta_f2_f1
add wave -noupdate -group TOP /tb_data_acquisition/delta_f2_f0
add wave -noupdate -group TOP /tb_data_acquisition/enable_f0
add wave -noupdate -group TOP /tb_data_acquisition/enable_f1
add wave -noupdate -group TOP /tb_data_acquisition/enable_f2
add wave -noupdate -group TOP /tb_data_acquisition/enable_f3
add wave -noupdate -group TOP /tb_data_acquisition/burst_f0
add wave -noupdate -group TOP /tb_data_acquisition/burst_f1
add wave -noupdate -group TOP /tb_data_acquisition/burst_f2
add wave -noupdate -group TOP /tb_data_acquisition/nb_snapshot_param
add wave -noupdate -group TOP /tb_data_acquisition/status_full
add wave -noupdate -group TOP /tb_data_acquisition/status_full_ack
add wave -noupdate -group TOP /tb_data_acquisition/status_full_err
add wave -noupdate -group TOP /tb_data_acquisition/status_new_err
add wave -noupdate -group TOP /tb_data_acquisition/addr_data_f0
add wave -noupdate -group TOP /tb_data_acquisition/addr_data_f1
add wave -noupdate -group TOP /tb_data_acquisition/addr_data_f2
add wave -noupdate -group TOP /tb_data_acquisition/addr_data_f3
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_size
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/nb_snapshot_param_size
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_snapshot_size
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_f2_f0_size
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_f2_f1_size
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/clk
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/rstn
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/ahb_master_in
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/ahb_master_out
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/coarse_time_0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_snapshot
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_f2_f1
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/delta_f2_f0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/enable_f0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/enable_f1
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/enable_f2
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/enable_f3
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/burst_f0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/burst_f1
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/burst_f2
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/nb_snapshot_param
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/status_full
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/status_full_ack
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/status_full_err
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/status_new_err
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/addr_data_f0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/addr_data_f1
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/addr_data_f2
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/addr_data_f3
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f0_in
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f1_in
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f2_in
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f3_in
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f0_in_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f1_in_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f2_in_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f3_in_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/start_snapshot_f0
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/start_snapshot_f1
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/start_snapshot_f2
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f0_out
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f1_out
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f2_out
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f3_out
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f0_out_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f1_out_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f2_out_valid
add wave -noupdate -group waveform_picker /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/data_f3_out_valid
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/clk
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/rstn
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/delta_snapshot
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/delta_f2_f1
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/delta_f2_f0
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/coarse_time_0
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/data_f2_in_valid
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f0
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f1
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/start_snapshot_f2
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/counter_delta_snapshot
add wave -noupdate -group waveform_controler /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_controler_1/coarse_time_0_r
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/clk
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/rstn
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/enable
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/burst_enable
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/nb_snapshot_param
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/start_snapshot
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/data_in
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/data_in_valid
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/data_out
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/data_out_valid
add wave -noupdate -group waveform_snapshot_f0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f0/counter_points_snapshot
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/clk
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/rstn
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/enable
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/burst_enable
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/nb_snapshot_param
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/start_snapshot
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/data_in
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/data_in_valid
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/data_out
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/data_out_valid
add wave -noupdate -group waveform_snapshot_f1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f1/counter_points_snapshot
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/clk
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/rstn
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/enable
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/burst_enable
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/nb_snapshot_param
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/start_snapshot
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/data_in
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/data_in_valid
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/data_out
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/data_out_valid
add wave -noupdate -group waveform_snapshot_f2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_snapshot_f2/counter_points_snapshot
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/clk
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/rstn
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/enable
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/data_in
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/data_in_valid
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/data_out
add wave -noupdate -group waveform_burst____f3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_burst_f3/data_out_valid
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/hclk
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/hresetn
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/valid_in
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/ack_in
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/valid_out
add wave -noupdate -group GEN_VALID_F0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(0)/lpp_waveform_dma_gen_valid_i/error
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/hclk
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/hresetn
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/valid_in
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/ack_in
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/valid_out
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/error
add wave -noupdate -group GEN_VALID_F1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(1)/lpp_waveform_dma_gen_valid_i/state
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/hclk
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/hresetn
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/valid_in
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/ack_in
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/valid_out
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/error
add wave -noupdate -group GEN_VALID_F2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(2)/lpp_waveform_dma_gen_valid_i/state
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/hclk
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/hresetn
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/valid_in
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/ack_in
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/valid_out
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/error
add wave -noupdate -group GEN_VALID_F3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/all_input_valid(3)/lpp_waveform_dma_gen_valid_i/state
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/valid_in
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/valid_out
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/valid_ack
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/status_new_err
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/clk
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/rstn
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/state
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f0_valid
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f1_valid
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f2_valid
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f3_valid
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_valid_ack
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f0
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f1
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f2
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_f3
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/ready
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_wen
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_wen
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_valid_and_ready
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_selected
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_valid_selected
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_ready_to_go
add wave -noupdate -group FIFO_ARB -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/data_temp
add wave -noupdate -group FIFO_ARB /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_en_temp
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/rstn
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/ready
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_ren
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_ren
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/rdata
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_wen
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_wen
add wave -noupdate -expand -group FIFO -expand -group {IN - OUT} -radix hexadecimal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/wdata
add wave -noupdate -expand -group FIFO -expand -group read -radix hexadecimal -subitemconfig {/tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_r(3) {-radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_r(2) {-radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_r(1) {-radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_r(0) {-radix hexadecimal}} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_r
add wave -noupdate -expand -group FIFO -expand -group read /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_mem_addr_r
add wave -noupdate -expand -group FIFO -expand -group read /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_ren
add wave -noupdate -expand -group FIFO -expand -group read /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_mem_ren
add wave -noupdate -expand -group FIFO -expand -group read /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_addr_r
add wave -noupdate -expand -group FIFO -expand -group read /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/ren
add wave -noupdate -expand -group FIFO -group write /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_mem_addr_w
add wave -noupdate -expand -group FIFO -group write /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_addr_w
add wave -noupdate -expand -group FIFO -group write /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_mem_wen
add wave -noupdate -expand -group FIFO -group write /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/time_mem_wen
add wave -noupdate -expand -group FIFO -group write -radix unsigned /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/data_addr_w
add wave -noupdate -expand -group FIFO -group write /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/wen
add wave -noupdate -radix hexadecimal -subitemconfig {/tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(0) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(1) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(2) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(3) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(4) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(5) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(6) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(7) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(8) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(9) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(10) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(11) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(12) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(13) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(14) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(15) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(16) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(17) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(18) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(19) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(20) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(21) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(22) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(23) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(24) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(25) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(26) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(27) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(28) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(29) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(30) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(31) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(32) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(33) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(34) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(35) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(36) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(37) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(38) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(39) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(40) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(41) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(42) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(43) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(44) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(45) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(46) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(47) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(48) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(49) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(50) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(51) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(52) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(53) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(54) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(55) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(56) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(57) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(58) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(59) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(60) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(61) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(62) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(63) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(64) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(65) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(66) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(67) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(68) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(69) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(70) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(71) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(72) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(73) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(74) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(75) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(76) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(77) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(78) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(79) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(80) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(81) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(82) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(83) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(84) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(85) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(86) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(87) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(88) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(89) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(90) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(91) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(92) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(93) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(94) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(95) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(96) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(97) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(98) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(99) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(100) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(101) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(102) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(103) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(104) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(105) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(106) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(107) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(108) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(109) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(110) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(111) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(112) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(113) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(114) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(115) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(116) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(117) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(118) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(119) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(120) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(121) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(122) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(123) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(124) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(125) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(126) {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd(127) {-height 15 -radix hexadecimal}} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/sram/inf/x0/rfd
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/hclk
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/hresetn
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/ahb_master_in
add wave -noupdate -expand -group DMA -expand -group INOUT -subitemconfig {/tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/ahb_master_out.haddr {-height 15 -radix hexadecimal} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/ahb_master_out.hwdata {-height 15 -radix hexadecimal}} /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/ahb_master_out
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group FIFO_interface /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_ready
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group FIFO_interface /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group FIFO_interface /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_data_ren
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group FIFO_interface /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_time_ren
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group REG_CONFIG -radix unsigned /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/nb_burst_available
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group REG_CONFIG /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_f0
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group REG_CONFIG /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_f1
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group REG_CONFIG /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_f2
add wave -noupdate -expand -group DMA -expand -group INOUT -expand -group REG_CONFIG /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_f3
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/status_full
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/status_full_ack
add wave -noupdate -expand -group DMA -expand -group INOUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/status_full_err
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/dmain
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/dmaout
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/state
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/sel_data_s
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/sel_data
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/update
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_select
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_write
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_already_send
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_already_send_s
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_dmai
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_send
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_send_ok
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_send_ko
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_fifo_ren
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/time_ren
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_dmai
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_send
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_send_ok
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_send_ko
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_fifo_ren
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_ren
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/data_address
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/update_and_sel
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_reg_vector
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/addr_data_vector
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/send_16_3_time
add wave -noupdate -expand -group DMA /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/pp_waveform_dma_1/count_send_time
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/ren
add wave -noupdate /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/wen
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/clk
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/rstn
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/ren
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/wen
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/mem_re
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/mem_we
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/mem_addr_ren
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/mem_addr_wen
add wave -noupdate -group fifo_ctrl_time_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(3)/lpp_waveform_fifo_ctrl_time/ready
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/clk
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/rstn
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/ren
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/wen
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/mem_re
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/mem_we
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/mem_addr_ren
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/mem_addr_wen
add wave -noupdate -expand -group fifo_ctrl_time_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(2)/lpp_waveform_fifo_ctrl_time/ready
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/clk
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/rstn
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/ren
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/wen
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/mem_re
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/mem_we
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/mem_addr_ren
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/mem_addr_wen
add wave -noupdate -expand -group fifo_ctrl_time_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(1)/lpp_waveform_fifo_ctrl_time/ready
add wave -noupdate -group fifo_ctrl_time_0 -group IN /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/clk
add wave -noupdate -group fifo_ctrl_time_0 -group IN /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/rstn
add wave -noupdate -group fifo_ctrl_time_0 -group IN /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/ren
add wave -noupdate -group fifo_ctrl_time_0 -group IN /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/wen
add wave -noupdate -group fifo_ctrl_time_0 -group OUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_re
add wave -noupdate -group fifo_ctrl_time_0 -group OUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_we
add wave -noupdate -group fifo_ctrl_time_0 -group OUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_addr_ren
add wave -noupdate -group fifo_ctrl_time_0 -group OUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_addr_wen
add wave -noupdate -group fifo_ctrl_time_0 -group OUT /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/ready
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sfull
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sfull_s
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sempty_s
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sempty
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sren
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/swen
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/sre
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/swe
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/waddr_vect
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/raddr_vect
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/waddr_vect_s
add wave -noupdate -group fifo_ctrl_time_0 -group internal /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/raddr_vect_s
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/clk
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/rstn
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/ren
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/wen
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_re
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_we
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_addr_ren
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/mem_addr_wen
add wave -noupdate -group fifo_ctrl_time_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_time(0)/lpp_waveform_fifo_ctrl_time/ready
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/clk
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/rstn
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/ren
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/wen
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/mem_re
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/mem_we
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/mem_addr_ren
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/mem_addr_wen
add wave -noupdate -group fifo_ctrl_data_3 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(3)/lpp_waveform_fifo_ctrl_data/ready
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/clk
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/rstn
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/ren
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/wen
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/mem_re
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/mem_we
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/mem_addr_ren
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/mem_addr_wen
add wave -noupdate -expand -group fifo_ctrl_data_2 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(2)/lpp_waveform_fifo_ctrl_data/ready
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/clk
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/rstn
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/ren
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/wen
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/mem_re
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/mem_we
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/mem_addr_ren
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/mem_addr_wen
add wave -noupdate -group fifo_ctrl_data_1 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(1)/lpp_waveform_fifo_ctrl_data/ready
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/clk
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/rstn
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/ren
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/wen
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/mem_re
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/mem_we
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/mem_addr_ren
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/mem_addr_wen
add wave -noupdate -group fifo_ctrl_data_0 /tb_data_acquisition/top_data_acquisition_2/lpp_waveform_1/lpp_waveform_fifo_1/gen_fifo_ctrl_data(0)/lpp_waveform_fifo_ctrl_data/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {70458134452 ps} 0}
configure wave -namecolwidth 842
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
WaveRestoreZoom {70455153866 ps} {70464281299 ps}
