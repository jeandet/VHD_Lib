onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f3_wdata
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f2_wdata
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f1_wdata
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f0_wdata
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f3_val
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f2_val
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f1_val
add wave -noupdate -expand -group FILTER_OUTPUT -radix hexadecimal /tb/lpp_lfr_1/lpp_lfr_filter_1/sample_f0_val
add wave -noupdate /tb/lpp_lfr_1/rstn
add wave -noupdate /tb/lpp_lfr_1/run
add wave -noupdate /tb/lpp_lfr_1/run_dma
add wave -noupdate /tb/lpp_lfr_1/run_ms
add wave -noupdate -expand -group MS /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_sp
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/reuse
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/run
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/ren
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/rdata
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/wen
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/wdata
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/full
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/full_threshold
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/full_almost
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/empty
add wave -noupdate -expand -group MS -group MS_MEM_OUT_0 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(0)/mem_out_spectralmatrix_i/empty_threshold
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/reuse
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/run
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/ren
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/rdata
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/wen
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/wdata
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/empty
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/full
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/full_almost
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/empty_threshold
add wave -noupdate -expand -group MS -group MEM_OUT_1 /tb/lpp_lfr_1/lpp_lfr_ms_1/all_mem_out_spectralmatrix(1)/mem_out_spectralmatrix_i/full_threshold
add wave -noupdate -expand -group MS -group FSM_Dma_FIFO /tb/lpp_lfr_1/lpp_lfr_ms_1/fsm_dma_fifo_ren
add wave -noupdate -expand -group MS -group FSM_Dma_FIFO /tb/lpp_lfr_1/lpp_lfr_ms_1/fsm_dma_fifo_empty
add wave -noupdate -expand -group MS -group FSM_Dma_FIFO /tb/lpp_lfr_1/lpp_lfr_ms_1/fsm_dma_fifo_empty_threshold
add wave -noupdate -expand -group MS -group FSM_Dma_FIFO /tb/lpp_lfr_1/lpp_lfr_ms_1/fsm_dma_fifo_data
add wave -noupdate -expand -group MS -group FSM_Dma_FIFO /tb/lpp_lfr_1/lpp_lfr_ms_1/fsm_dma_fifo_status
add wave -noupdate /tb/lpp_lfr_1/dma_subsystem_1/fifo_ren
add wave -noupdate /tb/lpp_lfr_1/dma_subsystem_1/dma_ren
add wave -noupdate /tb/lpp_lfr_1/dma_subsystem_1/fifo_burst_valid
add wave -noupdate /tb/lpp_lfr_1/dma_subsystem_1/fifo_data
add wave -noupdate /tb/lpp_lfr_1/dma_subsystem_1/fifo_ren
add wave -noupdate -radix hexadecimal -subitemconfig {/tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_new_err {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_bw {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_sp0 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_sp1 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_r0 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_r1 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.data_shaping_r2 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.delta_snapshot {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.delta_f0 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.delta_f0_2 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.delta_f1 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.delta_f2 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.nb_data_by_buffer {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.nb_snapshot_param {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.enable_f0 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.enable_f1 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.enable_f2 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.enable_f3 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.burst_f0 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.burst_f1 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.burst_f2 {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.run {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f {-radix hexadecimal -expand} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(7) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(6) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(5) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(4) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(3) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(2) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(1) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.status_ready_buffer_f(0) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.addr_buffer_f {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.time_buffer_f {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.length_buffer {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.error_buffer_full {-radix hexadecimal} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp.start_date {-radix hexadecimal}} /tb/lpp_lfr_1/lpp_lfr_apbreg_1/reg_wp
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/reuse
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/run
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/ren
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/rdata
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/wen
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/wdata
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/empty
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/full
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/full_almost
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/empty_threshold
add wave -noupdate -group FIFO_0 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(0)/lpp_fifo_1/full_threshold
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/reuse
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/run
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/ren
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/rdata
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/wen
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/wdata
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/empty
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/full
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/full_almost
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/empty_threshold
add wave -noupdate -group FIFO_1 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(1)/lpp_fifo_1/full_threshold
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/reuse
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/run
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/ren
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/rdata
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/wen
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/wdata
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/empty
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/full
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/full_almost
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/empty_threshold
add wave -noupdate -group FIFO_2 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(2)/lpp_fifo_1/full_threshold
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/reuse
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/run
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/ren
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/rdata
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/wen
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/wdata
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/empty
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/full
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/full_almost
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/empty_threshold
add wave -noupdate -group FIFO_3 /tb/lpp_lfr_1/lpp_waveform_1/generate_all_fifo(3)/lpp_fifo_1/full_threshold
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_fifo_valid_burst
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_fifo_data
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_fifo_ren
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_buffer_new
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_buffer_addr
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_buffer_length
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_buffer_full
add wave -noupdate -expand -group WFP_FSMDMA_0 -group WFP_FSMDMA_dma -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/dma_buffer_full_err
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_fifo -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/fifo_buffer_time
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_fifo /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/fifo_data
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_fifo /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/fifo_empty
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_fifo /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/fifo_empty_threshold
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_fifo /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/fifo_ren
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/status_buffer_ready
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/addr_buffer
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/length_buffer
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/ready_buffer
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/buffer_time
add wave -noupdate -expand -group WFP_FSMDMA_0 -expand -group WFP_FSMDMA_reg /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/error_buffer_full
add wave -noupdate -expand -group WFP_FSMDMA_0 /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/state
add wave -noupdate -expand -group WFP_FSMDMA_0 /tb/lpp_lfr_1/lpp_waveform_1/all_channel(0)/lpp_waveform_fsmdma_i/burst_valid_s
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/wfp_status_buffer_ready
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg0_status_ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg0_ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg0_addr_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg0_matrix_time
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg1_status_ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg1_ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg1_addr_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/reg1_matrix_time
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/status_ready_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/addr_matrix
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/matrix_time
add wave -noupdate /tb/lpp_lfr_1/lpp_lfr_apbreg_1/all_wfp_pointer(0)/lpp_apbreg_wfp_pointer_fi/current_reg
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/fifo_buffer_time
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/arbiter_time_out
add wave -noupdate /tb/lpp_lfr_1/lpp_waveform_1/arbiter_time_out_new
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_sel
add wave -noupdate -expand -subitemconfig {/tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_in(3) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_in(2) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_in(1) {-radix hexadecimal} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_in(0) {-radix hexadecimal}} /tb/lpp_lfr_1/lpp_waveform_1/lpp_waveform_fifo_arbiter_1/time_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {111345088346 ps} 0} {{Cursor 2} {50435974615 ps} 0} {{Cursor 3} {4065545 ps} 0} {{Cursor 4} {83087041514 ps} 0} {{Cursor 5} {16894875474 ps} 0}
configure wave -namecolwidth 618
configure wave -valuecolwidth 205
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
WaveRestoreZoom {4057109 ps} {4131134 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
