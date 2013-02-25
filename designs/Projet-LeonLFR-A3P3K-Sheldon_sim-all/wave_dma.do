onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/gpio
add wave -noupdate -format Literal -radix hexadecimal -expand /testbench/d3/lpp_dma_1/ahb_master_in
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/ahb_master_out
add wave -noupdate -format Logic -radix hexadecimal /testbench/clk
add wave -noupdate -format Logic -radix hexadecimal /testbench/rst
add wave -noupdate -expand -group AHB_BUS
add wave -noupdate -group AHB_BUS -format Logic -radix hexadecimal /testbench/d3/ahb0/rst
add wave -noupdate -group AHB_BUS -format Logic -radix hexadecimal /testbench/d3/ahb0/clk
add wave -noupdate -group AHB_BUS -format Literal -radix hexadecimal /testbench/d3/ahb0/msti
add wave -noupdate -group AHB_BUS -format Literal -radix hexadecimal /testbench/d3/ahb0/msto
add wave -noupdate -group AHB_BUS -format Literal -radix hexadecimal /testbench/d3/ahb0/slvi
add wave -noupdate -group AHB_BUS -format Literal -radix hexadecimal /testbench/d3/ahb0/slvo
add wave -noupdate -divider GPIO_TEST
add wave -noupdate -divider DMA
add wave -noupdate -expand -group DMA
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/hclk
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/hresetn
add wave -noupdate -group DMA -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/fifo_data
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/fifo_empty
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/fifo_ren
add wave -noupdate -group DMA -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/header
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/header_val
add wave -noupdate -group DMA -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/header_ack
add wave -noupdate -expand -group APB_s
add wave -noupdate -group APB_s -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/apbi
add wave -noupdate -group APB_s -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/apbo
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/state
add wave -noupdate -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/send_matrix
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/matrix_type
add wave -noupdate -format Logic /testbench/d3/lpp_dma_1/status_ready_matrix_f0_0
add wave -noupdate -format Logic /testbench/d3/lpp_dma_1/status_ready_matrix_f0_1
add wave -noupdate -format Logic /testbench/d3/lpp_dma_1/status_ready_matrix_f1
add wave -noupdate -format Logic /testbench/d3/lpp_dma_1/status_ready_matrix_f2
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f0_0
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f0_1
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f1
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f2
add wave -noupdate -divider FIFO_DMA_TEST
add wave -noupdate -group APB
add wave -noupdate -group APB -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/apbi
add wave -noupdate -group APB -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/apbo
add wave -noupdate -group fifo
add wave -noupdate -group fifo -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/fifo_data
add wave -noupdate -group fifo -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/fifo_empty
add wave -noupdate -group fifo -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/fifo_ren
add wave -noupdate -group header
add wave -noupdate -group header -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/header
add wave -noupdate -group header -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/header_val
add wave -noupdate -group header -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/header_ack
add wave -noupdate -group lpp_DMA_APB_REGISTER
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/pindex
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/paddr
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/pmask
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/pirq
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/hclk
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/hresetn
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(7)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(6)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(5)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(4)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(3)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(2)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.penable
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.psel(4)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.pwrite
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbi.paddr(7)
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/error_bad_component_error
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/ready_matrix_f0_0
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/ready_matrix_f0_1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/ready_matrix_f1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/ready_matrix_f2
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/error_anticipating_empty_fifo
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/reg
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/prdata
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_ready_matrix_f0_1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_ready_matrix_f1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_ready_matrix_f2
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_error_anticipating_empty_fifo
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_error_bad_component_error
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/config_active_interruption_onnewmatrix
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/config_active_interruption_onerror
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f0_0
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f0_1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f1
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/addr_matrix_f2
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/apbo
add wave -noupdate -group lpp_DMA_APB_REGISTER -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_apbreg_2/status_ready_matrix_f0_0
add wave -noupdate -group fifo_test_out
add wave -noupdate -group fifo_test_out -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/full
add wave -noupdate -group fifo_test_out -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/rdata
add wave -noupdate -group fifo_test_out -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/empty
add wave -noupdate -group fifo_test_out -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/raddr
add wave -noupdate -group fifo_test_out -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/waddr
add wave -noupdate -group fifo_test_in
add wave -noupdate -group fifo_test_in -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/tech
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/enable_reuse
add wave -noupdate -group fifo_test_in -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/datasz
add wave -noupdate -group fifo_test_in -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/abits
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/rstn
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/reuse
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/rclk
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/ren
add wave -noupdate -group fifo_test_in -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/wdata
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/wen
add wave -noupdate -group fifo_test_in -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/wclk
add wave -noupdate -group fifo_test_internal
add wave -noupdate -group fifo_test_internal -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/sempty
add wave -noupdate -group fifo_test_internal -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/waddr_vect_d
add wave -noupdate -group fifo_test_internal -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/raddr_vect
add wave -noupdate -group fifo_test_internal -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/waddr_vect
add wave -noupdate -group fifo_test_internal -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/swen
add wave -noupdate -group fifo_test_internal -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/sfull
add wave -noupdate -group fifo_test_internal -format Literal -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/raddr_vect_d
add wave -noupdate -group fifo_test_internal -format Logic -radix hexadecimal /testbench/d3/fifo_test_dma_1/lpp_fifo_i/sren
add wave -noupdate -group DMA_BURST_16w
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/hclk
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/hresetn
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/dmain
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/dmaout
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/send
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/address
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/data
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/ren
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/send_ok
add wave -noupdate -group DMA_BURST_16w -format Logic -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/send_ko
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/state
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/data_counter
add wave -noupdate -group DMA_BURST_16w -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/lpp_dma_send_16word_1/grant_counter
add wave -noupdate -group FIFO_LATENCY_CORRECTION
add wave -noupdate -group FIFO_LATENCY_CORRECTION -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/hclk
add wave -noupdate -group FIFO_LATENCY_CORRECTION -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/hresetn
add wave -noupdate -group FIFO_LATENCY_CORRECTION -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_ren_s
add wave -noupdate -group fifo_part
add wave -noupdate -group fifo_part -format Literal -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_data
add wave -noupdate -group fifo_part -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_empty
add wave -noupdate -group fifo_part -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_ren
add wave -noupdate -group dma_part
add wave -noupdate -group dma_part -format Literal -radix hexadecimal /testbench/d3/fifo_latency_correction_1/dma_data
add wave -noupdate -group dma_part -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/dma_empty
add wave -noupdate -group dma_part -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/dma_ren
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/header
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/matrix_type
add wave -noupdate -format Literal -radix hexadecimal /testbench/d3/lpp_dma_1/component_type
add wave -noupdate -format Literal /testbench/d3/lpp_dma_1/component_type_pre
add wave -noupdate -expand -group {LATENCY CORRECTION}
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/hclk
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/hresetn
add wave -noupdate -group {LATENCY CORRECTION} -group FIFO
add wave -noupdate -group {LATENCY CORRECTION} -format Literal -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_data
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/fifo_ren_s
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/ren_s2
add wave -noupdate -group {LATENCY CORRECTION} -group S1
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/valid_s1
add wave -noupdate -group {LATENCY CORRECTION} -group S2
add wave -noupdate -group {LATENCY CORRECTION} -format Logic -radix hexadecimal /testbench/d3/fifo_latency_correction_1/valid_s2
add wave -noupdate -group {LATENCY CORRECTION} -group DMA
add wave -noupdate -group {LATENCY CORRECTION} -format Literal -radix hexadecimal /testbench/d3/fifo_latency_correction_1/dma_data
add wave -noupdate -expand -group CY7C1360C
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/izz
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/imode
add wave -noupdate -group CY7C1360C -format Literal /testbench/cy7c1360c_2/iaddr
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/ingw
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inbwe
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inbwd
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inbwc
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inbwb
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inbwa
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/ince1
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/ice2
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/ince3
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inadsp
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inadsc
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inadv
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/inoe
add wave -noupdate -group CY7C1360C -format Logic /testbench/cy7c1360c_2/iclk
add wave -noupdate -group CY7C1360C -format Literal /testbench/cy7c1360c_2/iodq
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {178173000 ps} 0}
configure wave -namecolwidth 471
configure wave -valuecolwidth 117
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
WaveRestoreZoom {0 ps} {3975227550 ps}
