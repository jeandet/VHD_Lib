onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -group debug -expand -group FSM_MS_DMA_state /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(5)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(4)
add wave -noupdate -group debug -expand -group status_ready_matrix /tb/lpp_lfr_ms_1/debug_reg(3)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(8)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(7)
add wave -noupdate -group debug -expand -group matrix_ready /tb/lpp_lfr_ms_1/debug_reg(6)
add wave -noupdate -group debug /tb/lpp_lfr_ms_1/debug_reg
add wave -noupdate -group debug /tb/lpp_lfr_apbreg_1/apbi
add wave -noupdate -group debug /tb/lpp_lfr_apbreg_1/apbo
add wave -noupdate -group debug /tb/ready_reg
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(0)
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(1)
add wave -noupdate -group Logic /tb/lpp_lfr_ms_1/debug_reg(2)
add wave -noupdate -expand /tb/lpp_lfr_apbreg_1/debug_signal
add wave -noupdate -expand /tb/lpp_lfr_ms_1/observation_vector_0
add wave -noupdate -expand /tb/lpp_lfr_ms_1/observation_vector_1
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f0_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f1_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f1_wdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f2_wen
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/sample_f2_wdata
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/wen
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/full
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/almost_full
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/empty
add wave -noupdate -group FIFO_f0_A /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/ren
add wave -noupdate -group FIFO_f0_A -radix decimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/raddr_vect
add wave -noupdate -group FIFO_f0_A -radix decimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/waddr_vect
add wave -noupdate -group FIFO_f0_A -radix hexadecimal /tb/lpp_lfr_ms_1/lppfifoxn_f0_a/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/wen
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/almost_full
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/empty
add wave -noupdate -expand -group FIFO_f0_B /tb/lpp_lfr_ms_1/lppfifoxn_f0_b/ren
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/wen
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/memcel/cram/rwclk
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/almost_full
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/empty
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/ren
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/sfull
add wave -noupdate -expand -group FIFO_f1 /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/sfull_s
add wave -noupdate -expand -group FIFO_f1 -radix hexadecimal /tb/lpp_lfr_ms_1/lppfifoxn_f1/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/wen
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/full
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/almost_full
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/empty
add wave -noupdate -expand -group FIFO_f2 /tb/lpp_lfr_ms_1/lppfifoxn_f2/ren
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_select_channel
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_load_fft
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f0
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f1
add wave -noupdate -expand -group ERROR /tb/lpp_lfr_ms_1/error_wen_f2
add wave -noupdate /tb/lpp_lfr_ms_1/status_channel
add wave -noupdate -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(1)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(2)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(3)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -group FIFO_MS_INPUT -radix hexadecimal /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/fifos(4)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/current_fifo_load
add wave -noupdate /tb/lpp_lfr_ms_1/state_fsm_load_ms_memory
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/almost_full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/empty
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/wdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_spectralmatrix/wen
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_locked
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_rdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_in_sm_ren
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_auto
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_done
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/correlation_start
add wave -noupdate -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_data
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_empty
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_in_ren
add wave -noupdate -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_data
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_full
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/fifo_out_wen
add wave -noupdate -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/op1
add wave -noupdate -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/op2
add wave -noupdate -group MS_CALCULATION -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/res
add wave -noupdate -group MS_CALCULATION /tb/lpp_lfr_ms_1/ms_calculation_1/state
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/empty
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/full
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wdata
add wave -noupdate /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wen
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/raddr_vect
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/raddr_vect_s
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/waddr_vect
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/waddr_vect_s
add wave -noupdate -expand -group FIFO_1 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/raddr_vect
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/raddr_vect_s
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/waddr_vect
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/waddr_vect_s
add wave -noupdate -expand -group FIF0_0 -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0_end
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1_end
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_0_ready
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_1_ready
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fifo_ongoing
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_data
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_empty
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_ren
add wave -noupdate -expand -group FSM_DMA_FIFO_IN -radix hexadecimal /tb/lpp_lfr_ms_1/fsm_dma_fifo_status
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_addr
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_data
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_done
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_ren
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_valid
add wave -noupdate -expand -group DMA_OUTPUT /tb/dma_valid_burst
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/matrix_time_f2
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f1
add wave -noupdate -expand -group DMA_OUTPUT -radix hexadecimal /tb/ready_matrix_f2
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/state
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/matrix_type
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/component_type_pre
add wave -noupdate -radix unsigned /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/component_type
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/header_check_ok
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_empty
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/log_empty_fifo
add wave -noupdate /tb/lpp_lfr_ms_1/error_bad_component_error
add wave -noupdate /tb/lpp_lfr_ms_1/error_buffer_full
add wave -noupdate /tb/lpp_lfr_ms_1/error_input_fifo_write
add wave -noupdate -group ALU -radix decimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/op1
add wave -noupdate -group ALU -radix decimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/op2
add wave -noupdate -group ALU -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/res
add wave -noupdate -group ALU -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/comp
add wave -noupdate -group ALU -radix hexadecimal -expand -subitemconfig {/tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/ctrl(2) {-height 15 -radix hexadecimal} /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/ctrl(1) {-height 15 -radix hexadecimal} /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/ctrl(0) {-height 15 -radix hexadecimal}} /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/ctrl
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/reuse
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wen
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/wdata
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/ren
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/rdata
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/empty
add wave -noupdate -group MEM_OUT_WRITE -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/full
add wave -noupdate -group MEM_OUT_WRITE /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/almost_full
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(0)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/mem_out_spectralmatrix/fifos(1)/lpp_fifo_1/memcel/cram/ramarray
add wave -noupdate -group MULT /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/multiplieri_nst/mult
add wave -noupdate -group MULT -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/multiplieri_nst/op1
add wave -noupdate -group MULT -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/multiplieri_nst/op2
add wave -noupdate -group MULT -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/multiplieri_nst/res
add wave -noupdate -group ADD /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/add
add wave -noupdate -group ADD /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/clr
add wave -noupdate -group ADD /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/load
add wave -noupdate -group ADD -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/op1
add wave -noupdate -group ADD -radix hexadecimal /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/op2
add wave -noupdate -group ADD /tb/lpp_lfr_ms_1/ms_calculation_1/alu_ms/arith/macinst/adder_inst/res
add wave -noupdate -expand /tb/lpp_lfr_apbreg_1/reg_sp
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/clk
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/rstn
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_status_ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_addr_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_matrix_time
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_status_ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_addr_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_matrix_time
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/status_ready_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/addr_matrix
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 -radix hexadecimal /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/matrix_time
add wave -noupdate -expand -group APB_REG_MS_POInTER_F0 /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/current_reg
add wave -noupdate /tb/lpp_lfr_ms_1/coarse_time
add wave -noupdate /tb/lpp_lfr_ms_1/fine_time
add wave -noupdate /tb/lpp_lfr_ms_1/lpp_lfr_ms_fsmdma_1/fifo_matrix_time
add wave -noupdate /tb/lpp_lfr_ms_1/fsm_dma_fifo_status
add wave -noupdate /tb/lpp_lfr_ms_1/status_component
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_0
add wave -noupdate /tb/lpp_lfr_ms_1/status_component_fifo_1
add wave -noupdate /tb/lpp_lfr_ms_1/ms_control_1/current_status_ms
add wave -noupdate /tb/lpp_lfr_ms_1/ms_control_1/current_status_component
add wave -noupdate -radix hexadecimal /tb/lpp_lfr_ms_1/status_channel
add wave -noupdate /tb/lpp_lfr_ms_1/all_time
add wave -noupdate /tb/lpp_lfr_ms_1/time_reg_f0_a
add wave -noupdate /tb/lpp_lfr_ms_1/time_reg_f0_b
add wave -noupdate /tb/lpp_lfr_ms_1/time_reg_f1
add wave -noupdate /tb/lpp_lfr_ms_1/time_reg_f2
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_a_wen
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_a_ren
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_a_rdata
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_a_full
add wave -noupdate /tb/lpp_lfr_ms_1/sample_f0_a_empty
add wave -noupdate /tb/matrix_time_f0
add wave -noupdate /tb/matrix_time_f1
add wave -noupdate /tb/matrix_time_f2
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/clk
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/rstn
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_status_ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_addr_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg0_matrix_time
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_status_ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_addr_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/reg1_matrix_time
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/status_ready_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/addr_matrix
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/matrix_time
add wave -noupdate /tb/lpp_lfr_apbreg_1/lpp_apbreg_ms_pointer_f0/current_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {137412164208 ps} 0}
configure wave -namecolwidth 486
configure wave -valuecolwidth 112
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
WaveRestoreZoom {0 ps} {787501102500 ps}
bookmark add wave bookmark0 {{61745287067 ps} {63754655343 ps}} 0
bookmark add wave bookmark1 {{61745287067 ps} {63754655343 ps}} 0
