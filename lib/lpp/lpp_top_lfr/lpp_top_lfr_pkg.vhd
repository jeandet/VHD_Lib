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

PACKAGE lpp_top_lfr_pkg IS

  COMPONENT lpp_top_acq
  GENERIC(
    tech : INTEGER := 0
    );
  PORT (
    -- ADS7886
    cnv_run         : IN  STD_LOGIC;
    cnv             : OUT STD_LOGIC;
    sck             : OUT STD_LOGIC;
    sdo             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    --
    cnv_clk         : IN  STD_LOGIC;    -- 49 MHz
    cnv_rstn        : IN  STD_LOGIC;
    --
    clk             : IN  STD_LOGIC;    -- 25 MHz
    rstn            : IN  STD_LOGIC;
    --
    sample_f0_wen : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f1_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f2_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    --
    sample_f3_wen   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f3_wdata : OUT STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT lpp_top_apbreg
    GENERIC (
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      pindex                  : INTEGER;
      paddr                   : INTEGER;
      pmask                   : INTEGER;
      pirq                    : INTEGER);
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
      delta_snapshot                         : OUT STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1                            : OUT STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0                            : OUT STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      nb_burst_available                     : OUT STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      nb_snapshot_param                      : OUT STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      enable_f0                              : OUT STD_LOGIC;
      enable_f1                              : OUT STD_LOGIC;
      enable_f2                              : OUT STD_LOGIC;
      enable_f3                              : OUT STD_LOGIC;
      burst_f0                               : OUT STD_LOGIC;
      burst_f1                               : OUT STD_LOGIC;
      burst_f2                               : OUT STD_LOGIC;
      addr_data_f0                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_top_lfr_wf_picker
    GENERIC (
      hindex                  : INTEGER;
      pindex                  : INTEGER;
      paddr                   : INTEGER;
      pmask                   : INTEGER;
      pirq                    : INTEGER;
      tech                    : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      ENABLE_FILTER           : STD_LOGIC);
    PORT (
      cnv_run         : IN  STD_LOGIC;
      cnv             : OUT STD_LOGIC;
      sck             : OUT STD_LOGIC;
      sdo             : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
      cnv_clk         : IN  STD_LOGIC;
      cnv_rstn        : IN  STD_LOGIC;
      HCLK            : IN  STD_ULOGIC;
      HRESETn         : IN  STD_ULOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      AHB_Master_In   : IN  AHB_Mst_In_Type;
      AHB_Master_Out  : OUT AHB_Mst_Out_Type;
      coarse_time_0   : IN  STD_LOGIC;
      data_shaping_BW : OUT STD_LOGIC);
  END COMPONENT;


  COMPONENT lpp_top_lfr_wf_picker_ip
    GENERIC (
      hindex                  : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      tech                    : INTEGER;
      Mem_use                 : INTEGER);
    PORT (
    sample               : IN Samples(7 DOWNTO 0);
    sample_val           : IN STD_LOGIC;
      cnv_clk            : IN  STD_LOGIC;
      cnv_rstn           : IN  STD_LOGIC;
      clk                : IN  STD_LOGIC;
      rstn               : IN  STD_LOGIC;
      sample_f0_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f0_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f1_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f1_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f2_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f2_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f3_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f3_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      AHB_Master_In      : IN  AHB_Mst_In_Type;
      AHB_Master_Out     : OUT AHB_Mst_Out_Type;
      coarse_time_0      : IN  STD_LOGIC;
      data_shaping_SP0   : IN  STD_LOGIC;
      data_shaping_SP1   : IN  STD_LOGIC;
      data_shaping_R0    : IN  STD_LOGIC;
      data_shaping_R1    : IN  STD_LOGIC;
      delta_snapshot     : IN  STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1        : IN  STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0        : IN  STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      enable_f0          : IN  STD_LOGIC;
      enable_f1          : IN  STD_LOGIC;
      enable_f2          : IN  STD_LOGIC;
      enable_f3          : IN  STD_LOGIC;
      burst_f0           : IN  STD_LOGIC;
      burst_f1           : IN  STD_LOGIC;
      burst_f2           : IN  STD_LOGIC;
      nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      nb_snapshot_param  : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      status_full        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_new_err     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_data_f0       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT lpp_top_lfr_wf_picker_ip_whitout_filter
    GENERIC (
      hindex                  : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      tech                    : INTEGER);
    PORT (
      sample             : IN  Samples(7 DOWNTO 0);
      sample_val         : IN  STD_LOGIC;
      cnv_clk            : IN  STD_LOGIC;
      cnv_rstn           : IN  STD_LOGIC;
      clk                : IN  STD_LOGIC;
      rstn               : IN  STD_LOGIC;
      sample_f0_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f0_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f1_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f1_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f2_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f2_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      sample_f3_wen      : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      sample_f3_wdata    : OUT STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
      AHB_Master_In      : IN  AHB_Mst_In_Type;
      AHB_Master_Out     : OUT AHB_Mst_Out_Type;
      coarse_time_0      : IN  STD_LOGIC;
      data_shaping_SP0   : IN  STD_LOGIC;
      data_shaping_SP1   : IN  STD_LOGIC;
      data_shaping_R0    : IN  STD_LOGIC;
      data_shaping_R1    : IN  STD_LOGIC;
      delta_snapshot     : IN  STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
      delta_f2_f1        : IN  STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
      delta_f2_f0        : IN  STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
      enable_f0          : IN  STD_LOGIC;
      enable_f1          : IN  STD_LOGIC;
      enable_f2          : IN  STD_LOGIC;
      enable_f3          : IN  STD_LOGIC;
      burst_f0           : IN  STD_LOGIC;
      burst_f1           : IN  STD_LOGIC;
      burst_f2           : IN  STD_LOGIC;
      nb_burst_available : IN  STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
      nb_snapshot_param  : IN  STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
      status_full        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_ack    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_full_err    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      status_new_err     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      addr_data_f0       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f1       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f2       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      addr_data_f3       : IN  STD_LOGIC_VECTOR(31 DOWNTO 0));
  END COMPONENT;

  COMPONENT top_wf_picker
    GENERIC (
      hindex                  : INTEGER;
      pindex                  : INTEGER;
      paddr                   : INTEGER;
      pmask                   : INTEGER;
      pirq                    : INTEGER;
      tech                    : INTEGER;
      nb_burst_available_size : INTEGER;
      nb_snapshot_param_size  : INTEGER;
      delta_snapshot_size     : INTEGER;
      delta_f2_f0_size        : INTEGER;
      delta_f2_f1_size        : INTEGER;
      ENABLE_FILTER           : STD_LOGIC);
    PORT (
      cnv_clk         : IN  STD_LOGIC;
      cnv_rstn        : IN  STD_LOGIC;
      sample          : IN  Samples14v(7 DOWNTO 0);
      sample_val      : IN  STD_LOGIC;
      HCLK            : IN  STD_ULOGIC;
      HRESETn         : IN  STD_ULOGIC;
      apbi            : IN  apb_slv_in_type;
      apbo            : OUT apb_slv_out_type;
      AHB_Master_In   : IN  AHB_Mst_In_Type;
      AHB_Master_Out  : OUT AHB_Mst_Out_Type;
      coarse_time_0   : IN  STD_LOGIC;
      data_shaping_BW : OUT STD_LOGIC);
  END COMPONENT;

END lpp_top_lfr_pkg;