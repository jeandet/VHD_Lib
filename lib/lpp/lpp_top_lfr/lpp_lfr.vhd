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
USE lpp.lpp_lfr_pkg.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY lpp_lfr IS
  GENERIC (
    Mem_use                 : INTEGER := use_RAM;
    nb_burst_available_size : INTEGER := 11;
    nb_snapshot_param_size  : INTEGER := 11;
    delta_snapshot_size     : INTEGER := 16;
    delta_f2_f0_size        : INTEGER := 10;
    delta_f2_f1_size        : INTEGER := 10;

    pindex : INTEGER := 4;
    paddr  : INTEGER := 4;
    pmask  : INTEGER := 16#fff#;
    pirq_ms   : INTEGER := 0;
    pirq_wfp  : INTEGER := 1;

    hindex_wfp : INTEGER := 2;
    hindex_ms  : INTEGER := 3
        
    );
  PORT (
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    --
    sample_B   : IN Samples14v(2 DOWNTO 0);
    sample_E   : IN Samples14v(4 DOWNTO 0);
    sample_val      : IN  STD_LOGIC;
    -- 
    apbi            : IN  apb_slv_in_type;
    apbo            : OUT apb_slv_out_type;
    --
    ahbi_wfp        : IN  AHB_Mst_In_Type;
    ahbo_wfp        : OUT AHB_Mst_Out_Type;
    --
    ahbi_ms        : IN  AHB_Mst_In_Type;
    ahbo_ms        : OUT AHB_Mst_Out_Type;
    --
    coarse_time_0 : IN STD_LOGIC;
    --
    data_shaping_BW : OUT STD_LOGIC
    );
END lpp_lfr;

ARCHITECTURE beh OF lpp_lfr IS
  SIGNAL  sample          :  Samples14v(7 DOWNTO 0);
  SIGNAL  sample_s        :  Samples(7 DOWNTO 0);
  --
  SIGNAL data_shaping_SP0 : STD_LOGIC;
  SIGNAL data_shaping_SP1 : STD_LOGIC;
  SIGNAL data_shaping_R0  : STD_LOGIC;
  SIGNAL data_shaping_R1  : STD_LOGIC;
  --
  SIGNAL sample_f0_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f3_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  --
  SIGNAL sample_f0_val    : STD_LOGIC;
  SIGNAL sample_f1_val    : STD_LOGIC;
  SIGNAL sample_f2_val    : STD_LOGIC;
  SIGNAL sample_f3_val    : STD_LOGIC;
  --
  SIGNAL sample_f0_data  : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_data  : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_data  : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_data  : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  --
  SIGNAL sample_f0_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f3_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

  -- SM
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

  -- WFP
  SIGNAL status_full        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err     : STD_LOGIC_VECTOR(3 DOWNTO 0);
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

  --
  SIGNAL time_info : STD_LOGIC_VECTOR( (4*16)-1 DOWNTO 0);
  SIGNAL data_f0_wfp : STD_LOGIC_VECTOR(159 DOWNTO 0) ;
  SIGNAL data_f1_wfp : STD_LOGIC_VECTOR(159 DOWNTO 0) ;
  SIGNAL data_f2_wfp : STD_LOGIC_VECTOR(159 DOWNTO 0) ;
  SIGNAL data_f3_wfp : STD_LOGIC_VECTOR(159 DOWNTO 0) ;

  SIGNAL val_f0_wfp : STD_LOGIC;
  SIGNAL val_f1_wfp : STD_LOGIC;
  SIGNAL val_f2_wfp : STD_LOGIC;
  SIGNAL val_f3_wfp : STD_LOGIC;
BEGIN
  
  sample(4 DOWNTO 0) <= sample_E(4 DOWNTO 0);
  sample(7 DOWNTO 5) <= sample_B(2 DOWNTO 0);

  all_channel: FOR i IN 7 DOWNTO 0 GENERATE
    sample_s(i) <= sample(i)(13) & sample(i)(13) & sample(i);
  END GENERATE all_channel;
  
  -----------------------------------------------------------------------------
  lpp_lfr_filter_1 : lpp_lfr_filter
    GENERIC MAP (
      Mem_use => Mem_use)
    PORT MAP (
      sample           => sample_s,
      sample_val       => sample_val,
      clk              => clk,
      rstn             => rstn,
      data_shaping_SP0 => data_shaping_SP0,
      data_shaping_SP1 => data_shaping_SP1,
      data_shaping_R0  => data_shaping_R0,
      data_shaping_R1  => data_shaping_R1,
      sample_f0_val    => sample_f0_val,
      sample_f1_val    => sample_f1_val,
      sample_f2_val    => sample_f2_val,
      sample_f3_val    => sample_f3_val,
      sample_f0_wdata  => sample_f0_data,
      sample_f1_wdata  => sample_f1_data,
      sample_f2_wdata  => sample_f2_data,
      sample_f3_wdata  => sample_f3_data);

  -----------------------------------------------------------------------------
  lpp_top_apbreg_1 : lpp_lfr_apbreg
    GENERIC MAP (
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size  => nb_snapshot_param_size,
      delta_snapshot_size     => delta_snapshot_size,
      delta_f2_f0_size        => delta_f2_f0_size,
      delta_f2_f1_size        => delta_f2_f1_size,
      pindex                  => pindex,
      paddr                   => paddr,
      pmask                   => pmask,
      pirq_ms                 => pirq_ms,
      pirq_wfp                => pirq_wfp)
    PORT MAP (
      HCLK    => clk,                    
      HRESETn => rstn,                  
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

  -----------------------------------------------------------------------------
  lpp_waveform_1: lpp_waveform
    GENERIC MAP (
      hindex                  => hindex_wfp,
      tech                    => inferred,
      data_size               => 160,
      nb_burst_available_size => nb_burst_available_size,
      nb_snapshot_param_size  => nb_snapshot_param_size,
      delta_snapshot_size     => delta_snapshot_size,
      delta_f2_f0_size        => delta_f2_f0_size,
      delta_f2_f1_size        => delta_f2_f1_size)
    PORT MAP (
      clk                => clk,
      rstn               => rstn,
      AHB_Master_In      => ahbi_wfp,
      AHB_Master_Out     => ahbo_wfp,
      coarse_time_0      => coarse_time_0,
      
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
      addr_data_f3       => addr_data_f3,
      
      data_f0_in         => data_f0_wfp,
      data_f1_in         => data_f1_wfp,
      data_f2_in         => data_f2_wfp,
      data_f3_in         => data_f3_wfp,
      data_f0_in_valid   => sample_f0_val,
      data_f1_in_valid   => sample_f1_val,
      data_f2_in_valid   => sample_f2_val,
      data_f3_in_valid   => sample_f3_val);
  
  data_f0_wfp <= sample_f0_data & time_info;
  data_f1_wfp <= sample_f1_data & time_info;
  data_f2_wfp <= sample_f2_data & time_info;
  data_f3_wfp <= sample_f3_data & time_info;

  -----------------------------------------------------------------------------
  sample_f0_wen <= NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) &
                   NOT(sample_f0_val) & NOT(sample_f0_val) ;
  sample_f1_wen <= NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) &
                   NOT(sample_f1_val) & NOT(sample_f1_val) ;
  sample_f3_wen <= NOT(sample_f3_val) & NOT(sample_f3_val) & NOT(sample_f3_val) &
                   NOT(sample_f3_val) & NOT(sample_f3_val) ;

  sample_f0_wdata <= sample_f0_data((3*16)-1 DOWNTO (1*16)) & sample_f0_data((6*16)-1 DOWNTO (3*16));  -- (MSB) E2 E1 B2 B1 B0 (LSB)
  sample_f1_wdata <= sample_f1_data((3*16)-1 DOWNTO (1*16)) & sample_f1_data((6*16)-1 DOWNTO (3*16));
  sample_f3_wdata <= sample_f3_data((3*16)-1 DOWNTO (1*16)) & sample_f3_data((6*16)-1 DOWNTO (3*16));
  -----------------------------------------------------------------------------
  lpp_lfr_ms_1: lpp_lfr_ms
    GENERIC MAP (
      hindex => hindex_ms)
    PORT MAP (
      clk                                    => clk,
      rstn                                   => rstn,
      sample_f0_wen                          => sample_f0_wen,
      sample_f0_wdata                        => sample_f0_wdata,
      sample_f1_wen                          => sample_f1_wen,
      sample_f1_wdata                        => sample_f1_wdata,
      sample_f3_wen                          => sample_f3_wen,
      sample_f3_wdata                        => sample_f3_wdata,
      AHB_Master_In                          => ahbi_ms,
      AHB_Master_Out                         => ahbo_ms,
      
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
      addr_matrix_f2                         => addr_matrix_f2);

END beh;