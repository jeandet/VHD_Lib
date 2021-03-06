LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY lpp;
USE lpp.lpp_ad_conv.ALL;
USE lpp.iir_filter.ALL;
USE lpp.FILTERcfg.ALL;
USE lpp.lpp_memory.ALL;
USE lpp.lpp_waveform_pkg.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_top_lfr_pkg.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.general_purpose.ALL;

LIBRARY techmap;
USE techmap.gencomp.ALL;

LIBRARY grlib;
USE grlib.amba.ALL;
USE grlib.stdlib.ALL;
USE grlib.devices.ALL;
USE GRLIB.DMA2AHB_Package.ALL;

ENTITY lpp_lfr_WFP_nMS IS
  GENERIC (
    Mem_use                : INTEGER := use_RAM;
    nb_data_by_buffer_size : INTEGER := 11;
    nb_word_by_buffer_size : INTEGER := 11;
    nb_snapshot_param_size : INTEGER := 11;
    delta_vector_size      : INTEGER := 20;
    delta_vector_size_f0_2 : INTEGER := 7;

    pindex   : INTEGER := 4;
    paddr    : INTEGER := 4;
    pmask    : INTEGER := 16#fff#;
    pirq_ms  : INTEGER := 0;
    pirq_wfp : INTEGER := 1;

    hindex : INTEGER := 2;

    top_lfr_version : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0')

    );
  PORT (
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    -- SAMPLE
    sample_B        : IN  Samples(2 DOWNTO 0);
    sample_E        : IN  Samples(4 DOWNTO 0);
    sample_val      : IN  STD_LOGIC;
    -- APB
    apbi            : IN  apb_slv_in_type;
    apbo            : OUT apb_slv_out_type;
    -- AHB
    ahbi            : IN  AHB_Mst_In_Type;
    ahbo            : OUT AHB_Mst_Out_Type;
    -- TIME
    coarse_time     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    -- 
    data_shaping_BW : OUT STD_LOGIC;
    --
    observation_reg : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)

    --debug
    --debug_f0_data       : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    --debug_f0_data_valid : OUT STD_LOGIC;
    --debug_f1_data       : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    --debug_f1_data_valid : OUT STD_LOGIC;
    --debug_f2_data       : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    --debug_f2_data_valid : OUT STD_LOGIC;
    --debug_f3_data       : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    --debug_f3_data_valid : OUT STD_LOGIC;

    ---- debug FIFO_IN
    --debug_f0_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f0_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f1_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f1_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f2_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f2_data_fifo_in_valid : OUT STD_LOGIC;
    --debug_f3_data_fifo_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f3_data_fifo_in_valid : OUT STD_LOGIC;

    ----debug FIFO OUT
    --debug_f0_data_fifo_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f0_data_fifo_out_valid : OUT STD_LOGIC;
    --debug_f1_data_fifo_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f1_data_fifo_out_valid : OUT STD_LOGIC;
    --debug_f2_data_fifo_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f2_data_fifo_out_valid : OUT STD_LOGIC;
    --debug_f3_data_fifo_out       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f3_data_fifo_out_valid : OUT STD_LOGIC;

    ----debug DMA IN
    --debug_f0_data_dma_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f0_data_dma_in_valid : OUT STD_LOGIC;
    --debug_f1_data_dma_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f1_data_dma_in_valid : OUT STD_LOGIC;
    --debug_f2_data_dma_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f2_data_dma_in_valid : OUT STD_LOGIC;
    --debug_f3_data_dma_in       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --debug_f3_data_dma_in_valid : OUT STD_LOGIC
    );
END lpp_lfr_WFP_nMS;

ARCHITECTURE beh OF lpp_lfr_WFP_nMS IS
--  SIGNAL sample           : Samples14v(7 DOWNTO 0);
  SIGNAL sample_s         : Samples(7 DOWNTO 0);
  --
  SIGNAL data_shaping_SP0 : STD_LOGIC;
  SIGNAL data_shaping_SP1 : STD_LOGIC;
  SIGNAL data_shaping_R0  : STD_LOGIC;
  SIGNAL data_shaping_R1  : STD_LOGIC;
  --
--  SIGNAL sample_f0_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
--  SIGNAL sample_f1_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
--  SIGNAL sample_f3_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  --
  SIGNAL sample_f0_val    : STD_LOGIC;
  SIGNAL sample_f1_val    : STD_LOGIC;
  SIGNAL sample_f2_val    : STD_LOGIC;
  SIGNAL sample_f3_val    : STD_LOGIC;
  --
  SIGNAL sample_f0_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_data   : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  --
  --SIGNAL sample_f0_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  --SIGNAL sample_f1_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  --SIGNAL sample_f3_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

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
  SIGNAL status_full     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_ack : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_full_err : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL status_new_err  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL delta_snapshot  : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0_2      : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
  SIGNAL delta_f1        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f2        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);

  SIGNAL nb_data_by_buffer : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
  SIGNAL nb_word_by_buffer : STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL enable_f0         : STD_LOGIC;
  SIGNAL enable_f1         : STD_LOGIC;
  SIGNAL enable_f2         : STD_LOGIC;
  SIGNAL enable_f3         : STD_LOGIC;
  SIGNAL burst_f0          : STD_LOGIC;
  SIGNAL burst_f1          : STD_LOGIC;
  SIGNAL burst_f2          : STD_LOGIC;
  SIGNAL addr_data_f0      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f2      : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_data_f3      : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL run        : STD_LOGIC;
  SIGNAL start_date : STD_LOGIC_VECTOR(30 DOWNTO 0);

  SIGNAL data_f0_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out_valid       : STD_LOGIC;
  SIGNAL data_f0_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f0_data_out_ren         : STD_LOGIC;
  --f1
  SIGNAL data_f1_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out_valid       : STD_LOGIC;
  SIGNAL data_f1_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f1_data_out_ren         : STD_LOGIC;
  --f2
  SIGNAL data_f2_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out_valid       : STD_LOGIC;
  SIGNAL data_f2_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f2_data_out_ren         : STD_LOGIC;
  --f3
  SIGNAL data_f3_addr_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out_valid       : STD_LOGIC;
  SIGNAL data_f3_data_out_valid_burst : STD_LOGIC;
  SIGNAL data_f3_data_out_ren         : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL data_f0_addr_out_s             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f0_data_out_valid_s       : STD_LOGIC;
  SIGNAL data_f0_data_out_valid_burst_s : STD_LOGIC;
  --f1
  SIGNAL data_f1_addr_out_s             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f1_data_out_valid_s       : STD_LOGIC;
  SIGNAL data_f1_data_out_valid_burst_s : STD_LOGIC;
  --f2
  SIGNAL data_f2_addr_out_s             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f2_data_out_valid_s       : STD_LOGIC;
  SIGNAL data_f2_data_out_valid_burst_s : STD_LOGIC;
  --f3
  SIGNAL data_f3_addr_out_s             : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_f3_data_out_valid_s       : STD_LOGIC;
  SIGNAL data_f3_data_out_valid_burst_s : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- DMA RR
  -----------------------------------------------------------------------------
  SIGNAL dma_sel_valid   : STD_LOGIC;
  SIGNAL dma_rr_valid    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant_s  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_valid_ms : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL dma_rr_grant : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_sel      : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- DMA_REG
  -----------------------------------------------------------------------------
  SIGNAL ongoing_reg         : STD_LOGIC;
  SIGNAL dma_sel_reg         : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_send_reg        : STD_LOGIC;
  SIGNAL dma_valid_burst_reg : STD_LOGIC;  -- (1 => BURST , 0 => SINGLE)
  SIGNAL dma_address_reg     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data_reg        : STD_LOGIC_VECTOR(31 DOWNTO 0);


  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  SIGNAL dma_send        : STD_LOGIC;
  SIGNAL dma_valid_burst : STD_LOGIC;   -- (1 => BURST , 0 => SINGLE)
  SIGNAL dma_done        : STD_LOGIC;
  SIGNAL dma_ren         : STD_LOGIC;
  SIGNAL dma_address     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data_2      : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- DEBUG
  -----------------------------------------------------------------------------
  --
  SIGNAL sample_f0_data_debug : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f1_data_debug : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f2_data_debug : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);
  SIGNAL sample_f3_data_debug : STD_LOGIC_VECTOR((6*16)-1 DOWNTO 0);

  SIGNAL debug_reg0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg5 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg6 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL debug_reg7 : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- MS
  -----------------------------------------------------------------------------

  SIGNAL data_ms_addr        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_ms_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL data_ms_valid       : STD_LOGIC;
  SIGNAL data_ms_valid_burst : STD_LOGIC;
  SIGNAL data_ms_ren         : STD_LOGIC;
  SIGNAL data_ms_done        : STD_LOGIC;

  SIGNAL run_ms : STD_LOGIC;
  --SIGNAL ms_softandhard_rstn : STD_LOGIC;

  SIGNAL matrix_time_f0_0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f0_1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f1   : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f2   : STD_LOGIC_VECTOR(47 DOWNTO 0);
  
  
BEGIN
  
  sample_s(4 DOWNTO 0) <= sample_E(4 DOWNTO 0);
  sample_s(7 DOWNTO 5) <= sample_B(2 DOWNTO 0);

  --all_channel : FOR i IN 7 DOWNTO 0 GENERATE
  --  --sample_s(i) <= sample(i)(13) & sample(i)(13) & sample(i);
  --  sample_s(i) <= sample(i) & '0' & '0';
  --END GENERATE all_channel;

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
  lpp_lfr_apbreg_1 : lpp_lfr_apbreg
    GENERIC MAP (
      nb_data_by_buffer_size => nb_data_by_buffer_size,
      nb_word_by_buffer_size => nb_word_by_buffer_size,
      nb_snapshot_param_size => nb_snapshot_param_size,
      delta_vector_size      => delta_vector_size,
      delta_vector_size_f0_2 => delta_vector_size_f0_2,
      pindex                 => pindex,
      paddr                  => paddr,
      pmask                  => pmask,
      pirq_ms                => pirq_ms,
      pirq_wfp               => pirq_wfp,
      top_lfr_version        => top_lfr_version)
    PORT MAP (
      HCLK    => clk,
      HRESETn => rstn,
      apbi    => apbi,
      apbo    => apbo,

      run_ms => run_ms,

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

      matrix_time_f0_0 => matrix_time_f0_0,
      matrix_time_f0_1 => matrix_time_f0_1,
      matrix_time_f1   => matrix_time_f1,
      matrix_time_f2   => matrix_time_f2,

      addr_matrix_f0_0  => addr_matrix_f0_0,
      addr_matrix_f0_1  => addr_matrix_f0_1,
      addr_matrix_f1    => addr_matrix_f1,
      addr_matrix_f2    => addr_matrix_f2,
      status_full       => status_full,
      status_full_ack   => status_full_ack,
      status_full_err   => status_full_err,
      status_new_err    => status_new_err,
      data_shaping_BW   => data_shaping_BW,
      data_shaping_SP0  => data_shaping_SP0,
      data_shaping_SP1  => data_shaping_SP1,
      data_shaping_R0   => data_shaping_R0,
      data_shaping_R1   => data_shaping_R1,
      delta_snapshot    => delta_snapshot,
      delta_f0          => delta_f0,
      delta_f0_2        => delta_f0_2,
      delta_f1          => delta_f1,
      delta_f2          => delta_f2,
      nb_data_by_buffer => nb_data_by_buffer,
      nb_word_by_buffer => nb_word_by_buffer,
      nb_snapshot_param => nb_snapshot_param,
      enable_f0         => enable_f0,
      enable_f1         => enable_f1,
      enable_f2         => enable_f2,
      enable_f3         => enable_f3,
      burst_f0          => burst_f0,
      burst_f1          => burst_f1,
      burst_f2          => burst_f2,
      run               => run,
      addr_data_f0      => addr_data_f0,
      addr_data_f1      => addr_data_f1,
      addr_data_f2      => addr_data_f2,
      addr_data_f3      => addr_data_f3,
      start_date        => start_date,
      ---------------------------------------------------------------------------
      debug_reg0        => debug_reg0,
      debug_reg1        => debug_reg1,
      debug_reg2        => debug_reg2,
      debug_reg3        => debug_reg3,
      debug_reg4        => debug_reg4,
      debug_reg5        => debug_reg5,
      debug_reg6        => debug_reg6,
      debug_reg7        => debug_reg7);

  debug_reg5 <= sample_f0_data(32*1-1 DOWNTO 32*0);
  debug_reg6 <= sample_f0_data(32*2-1 DOWNTO 32*1);
  debug_reg7 <= sample_f0_data(32*3-1 DOWNTO 32*2);
  -----------------------------------------------------------------------------
  --sample_f0_data_debug <= x"01234567" & x"89ABCDEF" & x"02481357";  -- TODO : debug
  --sample_f1_data_debug <= x"00112233" & x"44556677" & x"8899AABB";  -- TODO : debug
  --sample_f2_data_debug <= x"CDEF1234" & x"ABBAEFFE" & x"01103773";  -- TODO : debug
  --sample_f3_data_debug <= x"FEDCBA98" & x"76543210" & x"78945612";  -- TODO : debug


  -----------------------------------------------------------------------------
  lpp_waveform_1 : lpp_waveform
    GENERIC MAP (
      tech                   => inferred,
      data_size              => 6*16,
      nb_data_by_buffer_size => nb_data_by_buffer_size,
      nb_word_by_buffer_size => nb_word_by_buffer_size,
      nb_snapshot_param_size => nb_snapshot_param_size,
      delta_vector_size      => delta_vector_size,
      delta_vector_size_f0_2 => delta_vector_size_f0_2
      )
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      reg_run            => run,
      reg_start_date     => start_date,
      reg_delta_snapshot => delta_snapshot,
      reg_delta_f0       => delta_f0,
      reg_delta_f0_2     => delta_f0_2,
      reg_delta_f1       => delta_f1,
      reg_delta_f2       => delta_f2,

      enable_f0 => enable_f0,
      enable_f1 => enable_f1,
      enable_f2 => enable_f2,
      enable_f3 => enable_f3,
      burst_f0  => burst_f0,
      burst_f1  => burst_f1,
      burst_f2  => burst_f2,

      nb_data_by_buffer => nb_data_by_buffer,
      nb_word_by_buffer => nb_word_by_buffer,
      nb_snapshot_param => nb_snapshot_param,
      status_full       => status_full,
      status_full_ack   => status_full_ack,
      status_full_err   => status_full_err,
      status_new_err    => status_new_err,

      coarse_time => coarse_time,
      fine_time   => fine_time,

      --f0
      addr_data_f0                 => addr_data_f0,
      data_f0_in_valid             => sample_f0_val,
      data_f0_in                   => sample_f0_data,  -- sample_f0_data_debug,  -- TODO : debug
      --f1
      addr_data_f1                 => addr_data_f1,
      data_f1_in_valid             => sample_f1_val,
      data_f1_in                   => sample_f1_data,  -- sample_f1_data_debug,  -- TODO : debug,
      --f2
      addr_data_f2                 => addr_data_f2,
      data_f2_in_valid             => sample_f2_val,
      data_f2_in                   => sample_f2_data,  -- sample_f2_data_debug,  -- TODO : debug,
      --f3
      addr_data_f3                 => addr_data_f3,
      data_f3_in_valid             => sample_f3_val,
      data_f3_in                   => sample_f3_data,  -- sample_f3_data_debug,  -- TODO : debug,
      -- OUTPUT -- DMA interface
      --f0
      data_f0_addr_out             => data_f0_addr_out_s,
      data_f0_data_out             => data_f0_data_out,
      data_f0_data_out_valid       => data_f0_data_out_valid_s,
      data_f0_data_out_valid_burst => data_f0_data_out_valid_burst_s,
      data_f0_data_out_ren         => data_f0_data_out_ren,
      --f1
      data_f1_addr_out             => data_f1_addr_out_s,
      data_f1_data_out             => data_f1_data_out,
      data_f1_data_out_valid       => data_f1_data_out_valid_s,
      data_f1_data_out_valid_burst => data_f1_data_out_valid_burst_s,
      data_f1_data_out_ren         => data_f1_data_out_ren,
      --f2
      data_f2_addr_out             => data_f2_addr_out_s,
      data_f2_data_out             => data_f2_data_out,
      data_f2_data_out_valid       => data_f2_data_out_valid_s,
      data_f2_data_out_valid_burst => data_f2_data_out_valid_burst_s,
      data_f2_data_out_ren         => data_f2_data_out_ren,
      --f3
      data_f3_addr_out             => data_f3_addr_out_s,
      data_f3_data_out             => data_f3_data_out,
      data_f3_data_out_valid       => data_f3_data_out_valid_s,
      data_f3_data_out_valid_burst => data_f3_data_out_valid_burst_s,
      data_f3_data_out_ren         => data_f3_data_out_ren ,

      -------------------------------------------------------------------------
      observation_reg => OPEN

      );


  -----------------------------------------------------------------------------
  -- TEMP
  -----------------------------------------------------------------------------

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      data_f0_data_out_valid       <= '0';
      data_f0_data_out_valid_burst <= '0';
      data_f1_data_out_valid       <= '0';
      data_f1_data_out_valid_burst <= '0';
      data_f2_data_out_valid       <= '0';
      data_f2_data_out_valid_burst <= '0';
      data_f3_data_out_valid       <= '0';
      data_f3_data_out_valid_burst <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge        
      data_f0_data_out_valid       <= data_f0_data_out_valid_s;
      data_f0_data_out_valid_burst <= data_f0_data_out_valid_burst_s;
      data_f1_data_out_valid       <= data_f1_data_out_valid_s;
      data_f1_data_out_valid_burst <= data_f1_data_out_valid_burst_s;
      data_f2_data_out_valid       <= data_f2_data_out_valid_s;
      data_f2_data_out_valid_burst <= data_f2_data_out_valid_burst_s;
      data_f3_data_out_valid       <= data_f3_data_out_valid_s;
      data_f3_data_out_valid_burst <= data_f3_data_out_valid_burst_s;
    END IF;
  END PROCESS;

  data_f0_addr_out <= data_f0_addr_out_s;
  data_f1_addr_out <= data_f1_addr_out_s;
  data_f2_addr_out <= data_f2_addr_out_s;
  data_f3_addr_out <= data_f3_addr_out_s;

  -----------------------------------------------------------------------------
  -- RoundRobin Selection For DMA
  -----------------------------------------------------------------------------

  dma_rr_valid(0) <= data_f0_data_out_valid OR data_f0_data_out_valid_burst;
  dma_rr_valid(1) <= data_f1_data_out_valid OR data_f1_data_out_valid_burst;
  dma_rr_valid(2) <= data_f2_data_out_valid OR data_f2_data_out_valid_burst;
  dma_rr_valid(3) <= data_f3_data_out_valid OR data_f3_data_out_valid_burst;

  RR_Arbiter_4_1 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid,
      out_grant => dma_rr_grant_s);

  dma_rr_valid_ms(0) <= data_ms_valid OR data_ms_valid_burst;
  dma_rr_valid_ms(1) <= '0' WHEN dma_rr_grant_s = "0000" ELSE '1';
  dma_rr_valid_ms(2) <= '0';
  dma_rr_valid_ms(3) <= '0';

  RR_Arbiter_4_2 : RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid_ms,
      out_grant => dma_rr_grant_ms);

  dma_rr_grant <= dma_rr_grant_ms(0) & "0000" WHEN dma_rr_grant_ms(0) = '1' ELSE '0' & dma_rr_grant_s;


  -----------------------------------------------------------------------------
  -- in  : dma_rr_grant
  --       send
  -- out : dma_sel
  --       dma_valid_burst
  --       dma_sel_valid
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      dma_sel         <= (OTHERS => '0');
      dma_send        <= '0';
      dma_valid_burst <= '0';
      data_ms_done    <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF run = '1' THEN
        data_ms_done <= '0';
        IF dma_sel = "00000" OR dma_done = '1' THEN
          dma_sel <= dma_rr_grant;
          IF dma_rr_grant(0) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f0_data_out_valid_burst;
            dma_sel_valid   <= data_f0_data_out_valid;
          ELSIF dma_rr_grant(1) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f1_data_out_valid_burst;
            dma_sel_valid   <= data_f1_data_out_valid;
          ELSIF dma_rr_grant(2) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f2_data_out_valid_burst;
            dma_sel_valid   <= data_f2_data_out_valid;
          ELSIF dma_rr_grant(3) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_f3_data_out_valid_burst;
            dma_sel_valid   <= data_f3_data_out_valid;
          ELSIF dma_rr_grant(4) = '1' THEN
            dma_send        <= '1';
            dma_valid_burst <= data_ms_valid_burst;
            dma_sel_valid   <= data_ms_valid;
          END IF;

          IF dma_sel(4) = '1' THEN
            data_ms_done <= '1';
          END IF;
        ELSE
          dma_sel  <= dma_sel;
          dma_send <= '0';
        END IF;
      ELSE
        data_ms_done    <= '0';
        dma_sel         <= (OTHERS => '0');
        dma_send        <= '0';
        dma_valid_burst <= '0';
      END IF;
    END IF;
  END PROCESS;


  dma_address <= data_f0_addr_out WHEN dma_sel(0) = '1' ELSE
                 data_f1_addr_out WHEN dma_sel(1) = '1' ELSE
                 data_f2_addr_out WHEN dma_sel(2) = '1' ELSE
                 data_f3_addr_out WHEN dma_sel(3) = '1' ELSE
                 data_ms_addr;
  
  dma_data <= data_f0_data_out WHEN dma_sel(0) = '1' ELSE
              data_f1_data_out WHEN dma_sel(1) = '1' ELSE
              data_f2_data_out WHEN dma_sel(2) = '1' ELSE
              data_f3_data_out WHEN dma_sel(3) = '1' ELSE
              data_ms_data;
  
  data_f0_data_out_ren <= dma_ren WHEN dma_sel(0) = '1' ELSE '1';
  data_f1_data_out_ren <= dma_ren WHEN dma_sel(1) = '1' ELSE '1';
  data_f2_data_out_ren <= dma_ren WHEN dma_sel(2) = '1' ELSE '1';
  data_f3_data_out_ren <= dma_ren WHEN dma_sel(3) = '1' ELSE '1';
  data_ms_ren          <= dma_ren WHEN dma_sel(4) = '1' ELSE '1';

  dma_data_2 <= dma_data;

  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  lpp_dma_singleOrBurst_1 : lpp_dma_singleOrBurst
    GENERIC MAP (
      tech   => inferred,
      hindex => hindex)
    PORT MAP (
      HCLK           => clk,
      HRESETn        => rstn,
      run            => run,
      AHB_Master_In  => ahbi,
      AHB_Master_Out => ahbo,

      send        => dma_send,
      valid_burst => dma_valid_burst,
      done        => dma_done,
      ren         => dma_ren,
      address     => dma_address,
      data        => dma_data_2);       

  -----------------------------------------------------------------------------
  -- Matrix Spectral
  -----------------------------------------------------------------------------
  data_ms_addr        <= (OTHERS => '0');
  data_ms_data        <= (OTHERS => '0');
  data_ms_valid       <= '0';
  data_ms_valid_burst <= '0';

  ready_matrix_f0_0             <= '0';
  ready_matrix_f0_1             <= '0';
  ready_matrix_f1               <= '0';
  ready_matrix_f2               <= '0';
  error_anticipating_empty_fifo <= '0';
  error_bad_component_error     <= '0';
  observation_reg               <= (OTHERS => '0');

  matrix_time_f2   <= (OTHERS => '0');
  matrix_time_f1   <= (OTHERS => '0');
  matrix_time_f0_1 <= (OTHERS => '0');
  matrix_time_f0_0 <= (OTHERS => '0');
  
END beh;
