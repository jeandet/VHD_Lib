LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY lpp_top_lfr_wf_picker IS
  GENERIC (
    hindex                  : INTEGER   := 2;
    pindex                  : INTEGER   := 15;
    paddr                   : INTEGER   := 15;
    pmask                   : INTEGER   := 16#fff#;
    pirq                    : INTEGER   := 15;
    tech                    : INTEGER   := 0;
    nb_burst_available_size : INTEGER   := 11;
    nb_snapshot_param_size  : INTEGER   := 11;
    delta_snapshot_size     : INTEGER   := 16;
    delta_f2_f0_size        : INTEGER   := 10;
    delta_f2_f1_size        : INTEGER   := 10;
    ENABLE_FILTER           : STD_LOGIC := '1'
    );
  PORT (
    -- ADS7886
    cnv_run  : IN  STD_LOGIC;
    cnv      : OUT STD_LOGIC;
    sck      : OUT STD_LOGIC;
    sdo      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    --
    cnv_clk  : IN  STD_LOGIC;
    cnv_rstn : IN  STD_LOGIC;

    -- AMBA AHB system signals
    HCLK    : IN STD_ULOGIC;
    HRESETn : IN STD_ULOGIC;

    -- AMBA APB Slave Interface
    apbi : IN  apb_slv_in_type;
    apbo : OUT apb_slv_out_type;

    -- AMBA AHB Master Interface
    AHB_Master_In  : IN  AHB_Mst_In_Type;
    AHB_Master_Out : OUT AHB_Mst_Out_Type;

    --
    coarse_time_0 : IN STD_LOGIC;

    -- 
    data_shaping_BW : OUT STD_LOGIC
    );
END lpp_top_lfr_wf_picker;

ARCHITECTURE tb OF lpp_top_lfr_wf_picker IS
  
  SIGNAL ready_matrix_f0_0                      : STD_LOGIC;
  SIGNAL ready_matrix_f0_1                      : STD_LOGIC;
  SIGNAL ready_matrix_f1                        : STD_LOGIC;
  SIGNAL ready_matrix_f2                        : STD_LOGIC;
  SIGNAL error_anticipating_empty_fifo          : STD_LOGIC;
  SIGNAL error_bad_component_error              : STD_LOGIC;
  SIGNAL debug_reg                              : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL status_ready_matrix_f0_0               : STD_LOGIC;
  SIGNAL status_ready_matrix_f0_1               : STD_LOGIC;
  SIGNAL status_ready_matrix_f1                 : STD_LOGIC;
  SIGNAL status_ready_matrix_f2                 : STD_LOGIC;
  SIGNAL status_error_anticipating_empty_fifo   : STD_LOGIC;
  SIGNAL status_error_bad_component_error       : STD_LOGIC;
  SIGNAL config_active_interruption_onNewMatrix : STD_LOGIC;
  SIGNAL config_active_interruption_onError     : STD_LOGIC;
  SIGNAL addr_matrix_f0_0                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f0_1                       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1                         : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2                         : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL status_full        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL data_shaping_SP0   : STD_LOGIC;
  SIGNAL data_shaping_SP1   : STD_LOGIC;
  SIGNAL data_shaping_R0    : STD_LOGIC;
  SIGNAL data_shaping_R1    : STD_LOGIC;
  SIGNAL delta_snapshot     : STD_LOGIC_VECTOR(delta_snapshot_size-1 DOWNTO 0);
  SIGNAL delta_f2_f1        : STD_LOGIC_VECTOR(delta_f2_f1_size-1 DOWNTO 0);
  SIGNAL delta_f2_f0        : STD_LOGIC_VECTOR(delta_f2_f0_size-1 DOWNTO 0);
  SIGNAL nb_burst_available : STD_LOGIC_VECTOR(nb_burst_available_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param  : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL enable_f0          : STD_LOGIC;
  SIGNAL enable_f1          : STD_LOGIC;
  SIGNAL enable_f2          : STD_LOGIC;
  SIGNAL enable_f3          : STD_LOGIC;
  SIGNAL burst_f0           : STD_LOGIC;
  SIGNAL burst_f1           : STD_LOGIC;
  SIGNAL burst_f2           : STD_LOGIC;
  SIGNAL addr_data_f0       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f1       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f2       : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f3       : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL sample_f0_wen   : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f0_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wen   : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f1_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wen   : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f2_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wen   : STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL sample_f3_wdata : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  CONSTANT ChanelCount     : INTEGER := 8;
  CONSTANT ncycle_cnv_high : INTEGER := 40;
  CONSTANT ncycle_cnv      : INTEGER := 250;
  SIGNAL   sample          : Samples(ChanelCount-1 DOWNTO 0);
  SIGNAL   sample_val      : STD_LOGIC;
  
BEGIN

  ready_matrix_f0_0             <= '0';
  ready_matrix_f0_1             <= '0';
  ready_matrix_f1               <= '0';
  ready_matrix_f2               <= '0';
  error_anticipating_empty_fifo <= '0';
  error_bad_component_error     <= '0';
  debug_reg                     <= (OTHERS => '0');

  lpp_top_apbreg_1 : lpp_top_apbreg
    GENERIC MAP (
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size  => nb_snapshot_param_size,
      delta_snapshot_size     => delta_snapshot_size,
      delta_f2_f0_size        => delta_f2_f0_size,
      delta_f2_f1_size        => delta_f2_f1_size,
      pindex                  => pindex,
      paddr                   => paddr,
      pmask                   => pmask,
      pirq                    => pirq)
    PORT MAP (
      HCLK    => HCLK,
      HRESETn => HRESETn,
      apbi    => apbi,
      apbo    => apbo,

      ready_matrix_f0_0                      => ready_matrix_f0_0,
      ready_matrix_f0_1                      => ready_matrix_f0_1,
      ready_matrix_f1                        => ready_matrix_f1,
      ready_matrix_f2                        => ready_matrix_f2,
      error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
      error_bad_component_error              => error_bad_component_error,
      debug_reg                              => debug_reg,
      status_ready_matrix_f0_0               => status_ready_matrix_f0_0,
      status_ready_matrix_f0_1               => status_ready_matrix_f0_1,
      status_ready_matrix_f1                 => status_ready_matrix_f1,
      status_ready_matrix_f2                 => status_ready_matrix_f2,
      status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
      status_error_bad_component_error       => status_error_bad_component_error,
      config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
      config_active_interruption_onError     => config_active_interruption_onError,
      addr_matrix_f0_0                       => addr_matrix_f0_0,
      addr_matrix_f0_1                       => addr_matrix_f0_1,
      addr_matrix_f1                         => addr_matrix_f1,
      addr_matrix_f2                         => addr_matrix_f2,

      status_full        => status_full,
      status_full_ack    => status_full_ack,
      status_full_err    => status_full_err,
      status_new_err     => status_new_err,
      data_shaping_BW    => data_shaping_BW,
      data_shaping_SP0   => data_shaping_SP0,
      data_shaping_SP1   => data_shaping_SP1,
      data_shaping_R0    => data_shaping_R0,
      data_shaping_R1    => data_shaping_R1,
      delta_snapshot     => delta_snapshot,
      delta_f2_f1        => delta_f2_f1,
      delta_f2_f0        => delta_f2_f0,
      nb_burst_available => nb_burst_available,
      nb_snapshot_param  => nb_snapshot_param,
      enable_f0          => enable_f0,
      enable_f1          => enable_f1,
      enable_f2          => enable_f2,
      enable_f3          => enable_f3,
      burst_f0           => burst_f0,
      burst_f1           => burst_f1,
      burst_f2           => burst_f2,
      addr_data_f0       => addr_data_f0,
      addr_data_f1       => addr_data_f1,
      addr_data_f2       => addr_data_f2,
      addr_data_f3       => addr_data_f3);



  
  DIGITAL_acquisition : AD7688_drvr_sync
    GENERIC MAP (
      ChanelCount     => ChanelCount,
      ncycle_cnv_high => ncycle_cnv_high,
      ncycle_cnv      => ncycle_cnv)
    PORT MAP (
      cnv_clk    => cnv_clk,                      -- 
      cnv_rstn   => cnv_rstn,                     -- 
      cnv_run    => cnv_run,                      --
      cnv        => cnv,                          -- 
      sck        => sck,                          -- 
      sdo        => sdo(ChanelCount-1 DOWNTO 0),  -- 
      sample     => sample,
      sample_val => sample_val);

  
  wf_picker_with_filter : IF ENABLE_FILTER = '1' GENERATE
    
    lpp_top_lfr_wf_picker_ip_1 : lpp_top_lfr_wf_picker_ip
      GENERIC MAP (
        hindex                  => hindex,
        nb_burst_available_size => nb_burst_available_size,
        nb_snapshot_param_size  => nb_snapshot_param_size,
        delta_snapshot_size     => delta_snapshot_size,
        delta_f2_f0_size        => delta_f2_f0_size,
        delta_f2_f1_size        => delta_f2_f1_size,
        tech                    => tech,
        Mem_use                 => use_RAM
        )
      PORT MAP (
        sample     => sample,
        sample_val => sample_val,

        cnv_clk  => cnv_clk,
        cnv_rstn => cnv_rstn,

        clk  => HCLK,
        rstn => HRESETn,

        sample_f0_wen      => sample_f0_wen,
        sample_f0_wdata    => sample_f0_wdata,
        sample_f1_wen      => sample_f1_wen,
        sample_f1_wdata    => sample_f1_wdata,
        sample_f2_wen      => sample_f2_wen,
        sample_f2_wdata    => sample_f2_wdata,
        sample_f3_wen      => sample_f3_wen,
        sample_f3_wdata    => sample_f3_wdata,
        AHB_Master_In      => AHB_Master_In,
        AHB_Master_Out     => AHB_Master_Out,
        coarse_time_0      => coarse_time_0,
        data_shaping_SP0   => data_shaping_SP0,
        data_shaping_SP1   => data_shaping_SP1,
        data_shaping_R0    => data_shaping_R0,
        data_shaping_R1    => data_shaping_R1,
        delta_snapshot     => delta_snapshot,
        delta_f2_f1        => delta_f2_f1,
        delta_f2_f0        => delta_f2_f0,
        enable_f0          => enable_f0,
        enable_f1          => enable_f1,
        enable_f2          => enable_f2,
        enable_f3          => enable_f3,
        burst_f0           => burst_f0,
        burst_f1           => burst_f1,
        burst_f2           => burst_f2,
        nb_burst_available => nb_burst_available,
        nb_snapshot_param  => nb_snapshot_param,
        status_full        => status_full,
        status_full_ack    => status_full_ack,
        status_full_err    => status_full_err,
        status_new_err     => status_new_err,
        addr_data_f0       => addr_data_f0,
        addr_data_f1       => addr_data_f1,
        addr_data_f2       => addr_data_f2,
        addr_data_f3       => addr_data_f3);

  END GENERATE wf_picker_with_filter;

  
  wf_picker_without_filter : IF ENABLE_FILTER = '0' GENERATE
    
    lpp_top_lfr_wf_picker_ip_2 : lpp_top_lfr_wf_picker_ip_whitout_filter
      GENERIC MAP (
        hindex                  => hindex,
        nb_burst_available_size => nb_burst_available_size,
        nb_snapshot_param_size  => nb_snapshot_param_size,
        delta_snapshot_size     => delta_snapshot_size,
        delta_f2_f0_size        => delta_f2_f0_size,
        delta_f2_f1_size        => delta_f2_f1_size,
        tech                    => tech
        )
      PORT MAP (
        sample     => sample,
        sample_val => sample_val,

        cnv_clk  => cnv_clk,
        cnv_rstn => cnv_rstn,

        clk  => HCLK,
        rstn => HRESETn,

        sample_f0_wen      => sample_f0_wen,
        sample_f0_wdata    => sample_f0_wdata,
        sample_f1_wen      => sample_f1_wen,
        sample_f1_wdata    => sample_f1_wdata,
        sample_f2_wen      => sample_f2_wen,
        sample_f2_wdata    => sample_f2_wdata,
        sample_f3_wen      => sample_f3_wen,
        sample_f3_wdata    => sample_f3_wdata,
        AHB_Master_In      => AHB_Master_In,
        AHB_Master_Out     => AHB_Master_Out,
        coarse_time_0      => coarse_time_0,
        data_shaping_SP0   => data_shaping_SP0,
        data_shaping_SP1   => data_shaping_SP1,
        data_shaping_R0    => data_shaping_R0,
        data_shaping_R1    => data_shaping_R1,
        delta_snapshot     => delta_snapshot,
        delta_f2_f1        => delta_f2_f1,
        delta_f2_f0        => delta_f2_f0,
        enable_f0          => enable_f0,
        enable_f1          => enable_f1,
        enable_f2          => enable_f2,
        enable_f3          => enable_f3,
        burst_f0           => burst_f0,
        burst_f1           => burst_f1,
        burst_f2           => burst_f2,
        nb_burst_available => nb_burst_available,
        nb_snapshot_param  => nb_snapshot_param,
        status_full        => status_full,
        status_full_ack    => status_full_ack,
        status_full_err    => status_full_err,
        status_new_err     => status_new_err,
        addr_data_f0       => addr_data_f0,
        addr_data_f1       => addr_data_f1,
        addr_data_f2       => addr_data_f2,
        addr_data_f3       => addr_data_f3);

  END GENERATE wf_picker_without_filter;
END tb;
