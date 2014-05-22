LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
LIBRARY techmap;
USE techmap.gencomp.ALL;

PACKAGE lpp_lfr_pkg IS
  -----------------------------------------------------------------------------
  -- TEMP
  -----------------------------------------------------------------------------
  COMPONENT lpp_lfr_ms_test
    GENERIC (
      Mem_use : INTEGER);
    PORT (
      clk              : IN  STD_LOGIC;
      rstn             : IN  STD_LOGIC;
    
    -- TIME
    coarse_time     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    --
    sample_f0_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f1_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f2_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);



    ---------------------------------------------------------------------------
    error_input_fifo_write        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    
    --
    --sample_ren   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    --sample_full  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    --sample_empty : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    --sample_rdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

    --status_channel : IN STD_LOGIC_VECTOR(49 DOWNTO 0);
    
    -- IN
    MEM_IN_SM_locked      : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
  
    -----------------------------------------------------------------------------
    
    status_component : OUT STD_LOGIC_VECTOR(53 DOWNTO 0);
    SM_in_data : OUT STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
    SM_in_ren : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    SM_in_empty : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

    SM_correlation_start : OUT STD_LOGIC;
    SM_correlation_auto : OUT STD_LOGIC;
    SM_correlation_done : IN STD_LOGIC
    );
  END COMPONENT;

  
  -----------------------------------------------------------------------------
  COMPONENT lpp_lfr_ms
    GENERIC (
      Mem_use : INTEGER 
      );
    PORT (
      clk                                    : IN  STD_LOGIC;
      rstn                                   : IN  STD_LOGIC;

      coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
      fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo

      sample_f0_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

      sample_f1_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f1_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

      sample_f2_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f2_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

      dma_addr        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_data        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_valid       : OUT STD_LOGIC;
      dma_valid_burst : OUT STD_LOGIC;
      dma_ren         : IN STD_LOGIC;
      dma_done        : IN STD_LOGIC;
      
      ready_matrix_f0                      : OUT STD_LOGIC;
--      ready_matrix_f0_1                      : OUT STD_LOGIC;
      ready_matrix_f1                        : OUT STD_LOGIC;
      ready_matrix_f2                        : OUT STD_LOGIC;
--      error_anticipating_empty_fifo          : OUT STD_LOGIC;
      error_bad_component_error              : OUT STD_LOGIC;
      error_buffer_full                      : OUT STD_LOGIC;
      error_input_fifo_write                 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      debug_reg                              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0               : IN  STD_LOGIC;
--      status_ready_matrix_f0_1               : IN  STD_LOGIC;
      status_ready_matrix_f1                 : IN  STD_LOGIC;
      status_ready_matrix_f2                 : IN  STD_LOGIC;
--      status_error_anticipating_empty_fifo   : IN  STD_LOGIC;
--      status_error_bad_component_error       : IN  STD_LOGIC;
      config_active_interruption_onNewMatrix : IN  STD_LOGIC;
      config_active_interruption_onError     : IN  STD_LOGIC;
      addr_matrix_f0                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--      addr_matrix_f0_1                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

      matrix_time_f0                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
--      matrix_time_f0_1                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f1                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f2                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_lfr_ms_fsmdma
    PORT (
      HCLK                                   : IN  STD_ULOGIC;
      HRESETn                                : IN  STD_ULOGIC;
      fifo_matrix_type      : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      fifo_matrix_component : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      fifo_matrix_time      : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      fifo_data  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fifo_empty : IN  STD_LOGIC;
      fifo_ren   : OUT STD_LOGIC;
      --data_time                              : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      --fifo_data                              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      --fifo_empty                             : IN  STD_LOGIC;
      --fifo_ren                               : OUT STD_LOGIC;
      --header                                 : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      --header_val                             : IN  STD_LOGIC;
      --header_ack                             : OUT STD_LOGIC;
      dma_addr                               : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_data                               : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      dma_valid                              : OUT STD_LOGIC;
      dma_valid_burst                        : OUT STD_LOGIC;
      dma_ren                                : IN  STD_LOGIC;
      dma_done                               : IN  STD_LOGIC;
      ready_matrix_f0                      : OUT STD_LOGIC;
--      ready_matrix_f0_1                      : OUT STD_LOGIC;
      ready_matrix_f1                        : OUT STD_LOGIC;
      ready_matrix_f2                        : OUT STD_LOGIC;
--      error_anticipating_empty_fifo          : OUT STD_LOGIC;
      error_bad_component_error              : OUT STD_LOGIC;
      error_buffer_full                      : OUT STD_LOGIC;
      debug_reg                              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0               : IN  STD_LOGIC;
--      status_ready_matrix_f0_1               : IN  STD_LOGIC;
      status_ready_matrix_f1                 : IN  STD_LOGIC;
      status_ready_matrix_f2                 : IN  STD_LOGIC;
--      status_error_anticipating_empty_fifo   : IN  STD_LOGIC;
--      status_error_bad_component_error       : IN  STD_LOGIC;
      config_active_interruption_onNewMatrix : IN  STD_LOGIC;
      config_active_interruption_onError     : IN  STD_LOGIC;
      addr_matrix_f0                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
--      addr_matrix_f0_1                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);

      matrix_time_f0                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
--      matrix_time_f0_1                       : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f1                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f2                         : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT lpp_lfr_ms_FFT
    PORT (
      clk            : IN  STD_LOGIC;
      rstn           : IN  STD_LOGIC;
      sample_valid   : IN  STD_LOGIC;
      fft_read       : IN  STD_LOGIC;
      sample_data    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      sample_load    : OUT STD_LOGIC;
      fft_pong       : OUT STD_LOGIC;
      fft_data_im    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fft_data_re    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      fft_data_valid : OUT STD_LOGIC;
      fft_ready      : OUT STD_LOGIC);
  END COMPONENT;  

  COMPONENT lpp_lfr_filter
    GENERIC (
      Mem_use : INTEGER);
    PORT (
      sample           : IN  Samples(7 DOWNTO 0);
      sample_val       : IN  STD_LOGIC;
      clk              : IN  STD_LOGIC;
      rstn             : IN  STD_LOGIC;
      data_shaping_SP0 : IN  STD_LOGIC;
      data_shaping_SP1 : IN  STD_LOGIC;
      data_shaping_R0  : IN  STD_LOGIC;
      data_shaping_R1  : IN  STD_LOGIC;
      sample_f0_val    : OUT STD_LOGIC;
      sample_f1_val    : OUT STD_LOGIC;
      sample_f2_val    : OUT STD_LOGIC;
      sample_f3_val    : OUT STD_LOGIC;
      sample_f0_wdata  : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f1_wdata  : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f2_wdata  : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f3_wdata  : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_lfr
    GENERIC (
      Mem_use                : INTEGER;
      nb_data_by_buffer_size : INTEGER;
      nb_word_by_buffer_size : INTEGER;
      nb_snapshot_param_size : INTEGER;
      delta_vector_size      : INTEGER;
      delta_vector_size_f0_2 : INTEGER;
      pindex                 : INTEGER;
      paddr                  : INTEGER;
      pmask                  : INTEGER;
      pirq_ms                : INTEGER;
      pirq_wfp               : INTEGER;
      hindex                 : INTEGER;
      top_lfr_version        : STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      sample_B        : IN  Samples(2 DOWNTO 0);
      sample_E        : IN  Samples(4 DOWNTO 0);
      sample_val      : IN  STD_LOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      ahbi            : IN  AHB_Mst_In_Type;
      ahbo            : OUT AHB_Mst_Out_Type;
      coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_shaping_BW : OUT STD_LOGIC;
      observation_reg : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
  END COMPONENT;

  -----------------------------------------------------------------------------
  -- LPP_LFR with only WaveForm Picker (and without Spectral Matrix Sub System)
  -----------------------------------------------------------------------------
  COMPONENT lpp_lfr_WFP_nMS
    GENERIC (
      Mem_use                : INTEGER;
      nb_data_by_buffer_size : INTEGER;
      nb_word_by_buffer_size : INTEGER;
      nb_snapshot_param_size : INTEGER;
      delta_vector_size      : INTEGER;
      delta_vector_size_f0_2 : INTEGER;
      pindex                 : INTEGER;
      paddr                  : INTEGER;
      pmask                  : INTEGER;
      pirq_ms                : INTEGER;
      pirq_wfp               : INTEGER;
      hindex                 : INTEGER;
      top_lfr_version        : STD_LOGIC_VECTOR(23 DOWNTO 0));
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      sample_B        : IN  Samples(2 DOWNTO 0);
      sample_E        : IN  Samples(4 DOWNTO 0);
      sample_val      : IN  STD_LOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      ahbi            : IN  AHB_Mst_In_Type;
      ahbo            : OUT AHB_Mst_Out_Type;
      coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_shaping_BW : OUT STD_LOGIC;
      observation_reg : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;
  -----------------------------------------------------------------------------
  COMPONENT lpp_lfr_apbreg
    GENERIC (
      nb_data_by_buffer_size : INTEGER;
      nb_word_by_buffer_size : INTEGER;
      nb_snapshot_param_size : INTEGER;
      delta_vector_size      : INTEGER;
      delta_vector_size_f0_2 : INTEGER;
      pindex                 : INTEGER;
      paddr                  : INTEGER;
      pmask                  : INTEGER;
      pirq_ms                : INTEGER;
      pirq_wfp               : INTEGER;
      top_lfr_version        : STD_LOGIC_VECTOR(23 DOWNTO 0));
    PORT (
      HCLK                                   : IN  STD_ULOGIC;
      HRESETn                                : IN  STD_ULOGIC;
      apbi                                   : IN  apb_slv_in_type;
      apbo                                   : OUT apb_slv_out_type;
      run_ms                                 : OUT STD_LOGIC;
      ready_matrix_f0_0                      : IN  STD_LOGIC;
      ready_matrix_f1                        : IN  STD_LOGIC;
      ready_matrix_f2                        : IN  STD_LOGIC;
      error_bad_component_error              : IN  STD_LOGIC;
      error_buffer_full                      : in  STD_LOGIC;
      error_input_fifo_write                 : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
      debug_reg                              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0_0               : OUT STD_LOGIC;
      status_ready_matrix_f1                 : OUT STD_LOGIC;
      status_ready_matrix_f2                 : OUT STD_LOGIC;
      config_active_interruption_onNewMatrix : OUT STD_LOGIC;
      config_active_interruption_onError     : OUT STD_LOGIC;
      addr_matrix_f0_0                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--      addr_matrix_f0_1                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      matrix_time_f0_0                       : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
--      matrix_time_f0_1                       : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f1                         : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f2                         : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
      status_full                            : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack                        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err                        : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_new_err                         : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      data_shaping_BW                        : OUT STD_LOGIC;
      data_shaping_SP0                       : OUT STD_LOGIC;
      data_shaping_SP1                       : OUT STD_LOGIC;
      data_shaping_R0                        : OUT STD_LOGIC;
      data_shaping_R1                        : OUT STD_LOGIC;
      delta_snapshot                         : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      delta_f0                               : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      delta_f0_2                             : OUT STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
      delta_f1                               : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      delta_f2                               : OUT STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
      nb_data_by_buffer                      : OUT STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
      nb_word_by_buffer                      : OUT STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
      nb_snapshot_param                      : OUT STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      enable_f0                              : OUT STD_LOGIC;
      enable_f1                              : OUT STD_LOGIC;
      enable_f2                              : OUT STD_LOGIC;
      enable_f3                              : OUT STD_LOGIC;
      burst_f0                               : OUT STD_LOGIC;
      burst_f1                               : OUT STD_LOGIC;
      burst_f2                               : OUT STD_LOGIC;
      run                                    : OUT STD_LOGIC;
      addr_data_f0                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      start_date                             : OUT STD_LOGIC_VECTOR(30 DOWNTO 0);
      debug_reg0                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg1                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg2                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg3                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg4                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg5                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg6                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg7                             : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;
  
  

  COMPONENT lpp_top_ms
    GENERIC (
      Mem_use                 : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      pindex                  : INTEGER;
      paddr                   : INTEGER;
      pmask                   : INTEGER;
      pirq_ms                 : INTEGER;
      pirq_wfp                : INTEGER;
      hindex_wfp              : INTEGER;
      hindex_ms               : INTEGER);
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      sample_B        : IN  Samples14v(2 DOWNTO 0);
      sample_E        : IN  Samples14v(4 DOWNTO 0);
      sample_val      : IN  STD_LOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      ahbi_ms         : IN  AHB_Mst_In_Type;
      ahbo_ms         : OUT AHB_Mst_Out_Type;
      data_shaping_BW : OUT STD_LOGIC;
      matrix_time_f0_0                       : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f0_1                       : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f1                         : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
      matrix_time_f2                         : IN STD_LOGIC_VECTOR(47 DOWNTO 0)
     
      );
  END COMPONENT;
  
END lpp_lfr_pkg;
