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

  COMPONENT lpp_lfr_ms
    GENERIC (
      hindex : INTEGER);
    PORT (
      clk                                    : IN  STD_LOGIC;
      rstn                                   : IN  STD_LOGIC;
      sample_f0_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f0_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      sample_f1_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f1_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      sample_f3_wen                          : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
      sample_f3_wdata                        : IN  STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
      AHB_Master_In                          : IN  AHB_Mst_In_Type;
      AHB_Master_Out                         : OUT AHB_Mst_Out_Type;
      ready_matrix_f0_0                      : OUT STD_LOGIC;
      ready_matrix_f0_1                      : OUT STD_LOGIC;
      ready_matrix_f1                        : OUT STD_LOGIC;
      ready_matrix_f2                        : OUT STD_LOGIC;
      error_anticipating_empty_fifo           : OUT STD_LOGIC;
      error_bad_component_error              : OUT STD_LOGIC;
      debug_reg                              : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0_0               : IN  STD_LOGIC;
      status_ready_matrix_f0_1               : IN  STD_LOGIC;
      status_ready_matrix_f1                 : IN  STD_LOGIC;
      status_ready_matrix_f2                 : IN  STD_LOGIC;
      status_error_anticipating_empty_fifo   : IN  STD_LOGIC;
      status_error_bad_component_error       : IN  STD_LOGIC;
      config_active_interruption_onNewMatrix : IN  STD_LOGIC;
      config_active_interruption_onError     : IN  STD_LOGIC;
      addr_matrix_f0_0                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f0_1                       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
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
      top_lfr_version        : STD_LOGIC_VECTOR(31 DOWNTO 0)
      );
    PORT (
      clk             : IN  STD_LOGIC;
      rstn            : IN  STD_LOGIC;
      sample_B        : IN  Samples14v(2 DOWNTO 0);
      sample_E        : IN  Samples14v(4 DOWNTO 0);
      sample_val      : IN  STD_LOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      ahbi            : IN  AHB_Mst_In_Type;
      ahbo            : OUT AHB_Mst_Out_Type;
      coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      data_shaping_BW : OUT STD_LOGIC;

    --debug
    debug_f0_data                : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    debug_f0_data_valid          : OUT STD_LOGIC;
    debug_f1_data                : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    debug_f1_data_valid          : OUT STD_LOGIC;
    debug_f2_data                : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    debug_f2_data_valid          : OUT STD_LOGIC;
    debug_f3_data                : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    debug_f3_data_valid          : OUT STD_LOGIC );
  END COMPONENT;

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
      top_lfr_version        : STD_LOGIC_VECTOR(31 DOWNTO 0));
    PORT (
      HCLK                                   : IN  STD_ULOGIC;
      HRESETn                                : IN  STD_ULOGIC;
      apbi                                   : IN  apb_slv_in_type;
      apbo                                   : OUT apb_slv_out_type;
      ready_matrix_f0_0                      : IN  STD_LOGIC;
      ready_matrix_f0_1                      : IN  STD_LOGIC;
      ready_matrix_f1                        : IN  STD_LOGIC;
      ready_matrix_f2                        : IN  STD_LOGIC;
      error_anticipating_empty_fifo          : IN  STD_LOGIC;
      error_bad_component_error              : IN  STD_LOGIC;
      debug_reg                              : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      status_ready_matrix_f0_0               : OUT STD_LOGIC;
      status_ready_matrix_f0_1               : OUT STD_LOGIC;
      status_ready_matrix_f1                 : OUT STD_LOGIC;
      status_ready_matrix_f2                 : OUT STD_LOGIC;
      status_error_anticipating_empty_fifo   : OUT STD_LOGIC;
      status_error_bad_component_error       : OUT STD_LOGIC;
      config_active_interruption_onNewMatrix : OUT STD_LOGIC;
      config_active_interruption_onError     : OUT STD_LOGIC;
      addr_matrix_f0_0                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f0_1                       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f1                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_matrix_f2                         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
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
      ---------------------------------------------------------------------------
      debug_reg0   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg1   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg2   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg3   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg4   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg5   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg6   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      debug_reg7   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
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
      data_shaping_BW : OUT STD_LOGIC);
  END COMPONENT;
  
END lpp_lfr_pkg;