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

ENTITY lpp_lfr IS
  GENERIC (
    Mem_use                 : INTEGER := use_RAM;
    nb_data_by_buffer_size : INTEGER := 11;
    nb_word_by_buffer_size : INTEGER := 11;
    nb_snapshot_param_size  : INTEGER := 11;
    delta_vector_size       : INTEGER := 20;
    delta_vector_size_f0_2  : INTEGER := 7;

    pindex : INTEGER := 4;
    paddr  : INTEGER := 4;
    pmask  : INTEGER := 16#fff#;
    pirq_ms   : INTEGER := 0;
    pirq_wfp  : INTEGER := 1;

    hindex : INTEGER := 2;

    top_lfr_version : STD_LOGIC_VECTOR(31 DOWNTO 0)
        
    );
  PORT (
    clk             : IN  STD_LOGIC;
    rstn            : IN  STD_LOGIC;
    -- SAMPLE
    sample_B   : IN Samples14v(2 DOWNTO 0);
    sample_E   : IN Samples14v(4 DOWNTO 0);
    sample_val      : IN  STD_LOGIC;
    -- APB
    apbi            : IN  apb_slv_in_type;
    apbo            : OUT apb_slv_out_type;
    -- AHB
    ahbi           : IN  AHB_Mst_In_Type;
    ahbo           : OUT AHB_Mst_Out_Type;
    -- TIME
    coarse_time  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  -- todo
    fine_time    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
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
  SIGNAL delta_snapshot     : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0     : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0_2     : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
  SIGNAL delta_f1     : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f2     : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  
  SIGNAL nb_data_by_buffer : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
  SIGNAL nb_word_by_buffer : STD_LOGIC_VECTOR(nb_word_by_buffer_size-1 DOWNTO 0);
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

  SIGNAL run : STD_LOGIC;
  SIGNAL start_date : STD_LOGIC_VECTOR(30 DOWNTO 0);

  SIGNAL  data_f0_addr_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f0_data_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f0_data_out_valid       :  STD_LOGIC;
  SIGNAL  data_f0_data_out_valid_burst :  STD_LOGIC;
  SIGNAL  data_f0_data_out_ren         : STD_LOGIC;
    --f1
  SIGNAL  data_f1_addr_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f1_data_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f1_data_out_valid       :  STD_LOGIC;
  SIGNAL  data_f1_data_out_valid_burst :  STD_LOGIC;
  SIGNAL  data_f1_data_out_ren         : STD_LOGIC;
    --f2
  SIGNAL  data_f2_addr_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f2_data_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f2_data_out_valid       :  STD_LOGIC;
  SIGNAL  data_f2_data_out_valid_burst :  STD_LOGIC;
  SIGNAL  data_f2_data_out_ren         : STD_LOGIC;
    --f3
  SIGNAL  data_f3_addr_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f3_data_out             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f3_data_out_valid       :  STD_LOGIC;
  SIGNAL  data_f3_data_out_valid_burst :  STD_LOGIC;
  SIGNAL  data_f3_data_out_ren         : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  SIGNAL  data_f0_addr_out_s             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f0_data_out_valid_s       :  STD_LOGIC;
  SIGNAL  data_f0_data_out_valid_burst_s :  STD_LOGIC;
    --f1
  SIGNAL  data_f1_addr_out_s             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f1_data_out_valid_s       :  STD_LOGIC;
  SIGNAL  data_f1_data_out_valid_burst_s :  STD_LOGIC;
    --f2
  SIGNAL  data_f2_addr_out_s             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f2_data_out_valid_s       :  STD_LOGIC;
  SIGNAL  data_f2_data_out_valid_burst_s :  STD_LOGIC;
    --f3
  SIGNAL  data_f3_addr_out_s             :  STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL  data_f3_data_out_valid_s       :  STD_LOGIC;
  SIGNAL  data_f3_data_out_valid_burst_s :  STD_LOGIC;
  
  -----------------------------------------------------------------------------
  -- DMA RR
  -----------------------------------------------------------------------------
  SIGNAL dma_sel_valid : STD_LOGIC;
  SIGNAL dma_sel       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_valid  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL dma_rr_grant  : STD_LOGIC_VECTOR(3 DOWNTO 0);

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
  SIGNAL dma_valid_burst : STD_LOGIC;  -- (1 => BURST , 0 => SINGLE)
  SIGNAL dma_done        : STD_LOGIC;
  SIGNAL dma_ren         : STD_LOGIC;
  SIGNAL dma_address     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL dma_data_2        : STD_LOGIC_VECTOR(31 DOWNTO 0);
  
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
  lpp_lfr_apbreg_1: lpp_lfr_apbreg
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
      HCLK                                   => clk,
      HRESETn                                => rstn,
      apbi                                   => apbi,
      apbo                                   => apbo,
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
      status_full                            => status_full,
      status_full_ack                        => status_full_ack,
      status_full_err                        => status_full_err,
      status_new_err                         => status_new_err,
      data_shaping_BW                        => data_shaping_BW,
      data_shaping_SP0                       => data_shaping_SP0,
      data_shaping_SP1                       => data_shaping_SP1,
      data_shaping_R0                        => data_shaping_R0,
      data_shaping_R1                        => data_shaping_R1,
      delta_snapshot                         => delta_snapshot,
      delta_f0                               => delta_f0,
      delta_f0_2                             => delta_f0_2,
      delta_f1                               => delta_f1,
      delta_f2                               => delta_f2,
      nb_data_by_buffer                      => nb_data_by_buffer,
      nb_word_by_buffer                      => nb_word_by_buffer,
      nb_snapshot_param                      => nb_snapshot_param,
      enable_f0                              => enable_f0,
      enable_f1                              => enable_f1,
      enable_f2                              => enable_f2,
      enable_f3                              => enable_f3,
      burst_f0                               => burst_f0,
      burst_f1                               => burst_f1,
      burst_f2                               => burst_f2,
      run                                    => run,
      addr_data_f0                           => addr_data_f0,
      addr_data_f1                           => addr_data_f1,
      addr_data_f2                           => addr_data_f2,
      addr_data_f3                           => addr_data_f3,
      start_date                             => start_date);

  -----------------------------------------------------------------------------
  lpp_waveform_1: lpp_waveform
    GENERIC MAP (
      tech                    => inferred,
      data_size               => 6*16,
      nb_data_by_buffer_size  => nb_data_by_buffer_size,
      nb_word_by_buffer_size  => nb_word_by_buffer_size,
      nb_snapshot_param_size  => nb_snapshot_param_size,
      delta_vector_size       => delta_vector_size,
      delta_vector_size_f0_2  => delta_vector_size_f0_2
      )
    PORT MAP (
      clk                => clk,
      rstn               => rstn,

      reg_run            => run,
      reg_start_date     => start_date, 
      reg_delta_snapshot => delta_snapshot,
      reg_delta_f0       => delta_f0,  
      reg_delta_f0_2     => delta_f0_2,
      reg_delta_f1       => delta_f1,
      reg_delta_f2       => delta_f2,
      
      enable_f0          => enable_f0,
      enable_f1          => enable_f1,
      enable_f2          => enable_f2,
      enable_f3          => enable_f3,
      burst_f0           => burst_f0,
      burst_f1           => burst_f1,
      burst_f2           => burst_f2,
      
      nb_data_by_buffer => nb_data_by_buffer,
      nb_word_by_buffer => nb_word_by_buffer,
      nb_snapshot_param  => nb_snapshot_param,
      status_full        => status_full,
      status_full_ack    => status_full_ack,
      status_full_err    => status_full_err,
      status_new_err     => status_new_err,

      coarse_time        => coarse_time,
      fine_time          => fine_time, 

      --f0
      addr_data_f0       => addr_data_f0,
      data_f0_in_valid   => sample_f0_val,
      data_f0_in         => sample_f0_data,
      --f1
      addr_data_f1       => addr_data_f1,
      data_f1_in_valid   => sample_f1_val,
      data_f1_in         => sample_f1_data,
      --f2
      addr_data_f2       => addr_data_f2,
      data_f2_in_valid   => sample_f2_val,
      data_f2_in         => sample_f2_data,
      --f3
      addr_data_f3       => addr_data_f3,
      data_f3_in_valid   => sample_f3_val,
      data_f3_in         => sample_f3_data,
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
      data_f3_data_out_ren         => data_f3_data_out_ren
      
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
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge        
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
  
  data_f0_addr_out             <= data_f0_addr_out_s;   
  data_f1_addr_out             <= data_f1_addr_out_s;   
  data_f2_addr_out             <= data_f2_addr_out_s; 
  data_f3_addr_out             <= data_f3_addr_out_s;                              
  
  -----------------------------------------------------------------------------
  -- RoundRobin Selection For DMA
  -----------------------------------------------------------------------------

  dma_rr_valid(0) <= data_f0_data_out_valid OR data_f0_data_out_valid_burst;
  dma_rr_valid(1) <= data_f1_data_out_valid OR data_f1_data_out_valid_burst;
  dma_rr_valid(2) <= data_f2_data_out_valid OR data_f2_data_out_valid_burst;
  dma_rr_valid(3) <= data_f3_data_out_valid OR data_f3_data_out_valid_burst;

  RR_Arbiter_4_1: RR_Arbiter_4
    PORT MAP (
      clk       => clk,
      rstn      => rstn,
      in_valid  => dma_rr_valid,
      out_grant => dma_rr_grant);


  -----------------------------------------------------------------------------
  -- in  : dma_rr_grant
  --       send
  -- out : dma_sel
  --       dma_valid_burst
  --       dma_sel_valid
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN               -- asynchronous reset (active low)
      dma_sel  <= (OTHERS => '0');
      dma_send        <= '0';
      dma_valid_burst <= '0';
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
--      IF dma_sel = "0000" OR dma_send = '1' THEN
      IF dma_sel = "0000" OR dma_done = '1' THEN
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
        END IF;
      ELSE
        dma_sel   <= dma_sel;
        dma_send        <= '0';
      END IF;  
    END IF;
  END PROCESS;

  
  dma_address <= data_f0_addr_out WHEN dma_sel(0) = '1' ELSE
                 data_f1_addr_out WHEN dma_sel(1) = '1' ELSE
                 data_f2_addr_out WHEN dma_sel(2) = '1' ELSE
                 data_f3_addr_out ;
  
  dma_data <= data_f0_data_out WHEN dma_sel(0) = '1' ELSE
              data_f1_data_out WHEN dma_sel(1) = '1' ELSE
              data_f2_data_out WHEN dma_sel(2) = '1' ELSE
              data_f3_data_out ;

  --dma_valid_burst <= data_f0_data_out_valid_burst WHEN dma_sel(0) = '1' ELSE
  --                   data_f1_data_out_valid_burst WHEN dma_sel(1) = '1' ELSE
  --                   data_f2_data_out_valid_burst WHEN dma_sel(2) = '1' ELSE
  --                   data_f3_data_out_valid_burst WHEN dma_sel(3) = '1' ELSE
  --                   '0';
  
  --dma_sel_valid <= data_f0_data_out_valid WHEN dma_sel(0) = '1' ELSE
  --                 data_f1_data_out_valid WHEN dma_sel(1) = '1' ELSE
  --                 data_f2_data_out_valid WHEN dma_sel(2) = '1' ELSE
  --                 data_f3_data_out_valid WHEN dma_sel(3) = '1' ELSE
  --                 '0';

  -- TODO
  --dma_send       <= dma_sel_valid OR dma_valid_burst;
  
  --data_f0_data_out_ren <= dma_ren WHEN dma_sel_reg(0) = '1' ELSE '1';
  --data_f1_data_out_ren <= dma_ren WHEN dma_sel_reg(1) = '1' ELSE '1';
  --data_f2_data_out_ren <= dma_ren WHEN dma_sel_reg(2) = '1' ELSE '1';
  --data_f3_data_out_ren <= dma_ren WHEN dma_sel_reg(3) = '1' ELSE '1';
 
  data_f0_data_out_ren <= dma_ren WHEN dma_sel(0) = '1' ELSE '1';
  data_f1_data_out_ren <= dma_ren WHEN dma_sel(1) = '1' ELSE '1';
  data_f2_data_out_ren <= dma_ren WHEN dma_sel(2) = '1' ELSE '1';
  data_f3_data_out_ren <= dma_ren WHEN dma_sel(3) = '1' ELSE '1';
 
  
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    ongoing_reg             <= '0';
  --    dma_sel_reg         <= (OTHERS => '0');
  --    dma_send_reg        <= '0';
  --    dma_valid_burst_reg <= '0';
  --    dma_address_reg     <= (OTHERS => '0');
  --    dma_data_reg        <= (OTHERS => '0');
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    IF (dma_send = '1' AND ongoing_reg = '0') OR (dma_send = '1' AND dma_done = '1')THEN
  --      ongoing_reg             <= '1';
  --      dma_valid_burst_reg     <= dma_valid_burst;
  --      dma_sel_reg             <= dma_sel;
  --    ELSE
  --      IF dma_done = '1' THEN
  --        ongoing_reg <= '0';
  --      END IF;
  --    END IF;
  --    dma_send_reg        <= dma_send;
  --    dma_address_reg     <= dma_address;
  --    dma_data_reg        <= dma_data;
  --  END IF;
  --END PROCESS;

  dma_data_2 <= dma_data;
  --PROCESS (clk, rstn)
  --BEGIN  -- PROCESS
  --  IF rstn = '0' THEN                  -- asynchronous reset (active low)
  --    dma_data_2 <= (OTHERS => '0');
  --  ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
  --    dma_data_2 <= dma_data;
      
  --  END IF;
  --END PROCESS;

  
  -----------------------------------------------------------------------------
  -- DMA
  -----------------------------------------------------------------------------
  lpp_dma_singleOrBurst_1: lpp_dma_singleOrBurst
    GENERIC MAP (
      tech   => inferred,
      hindex => hindex)
    PORT MAP (
      HCLK           => clk,
      HRESETn        => rstn,
      run            => run,
      AHB_Master_In  => ahbi,
      AHB_Master_Out => ahbo,
      
      send           => dma_send,--_reg,
      valid_burst    => dma_valid_burst,--_reg,
      done           => dma_done,
      ren            => dma_ren,
      address        => dma_address,--_reg,
      data           => dma_data_2);--_reg);
  
  -----------------------------------------------------------------------------
  -- Matrix Spectral - TODO
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  --sample_f0_wen <= NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) &
  --                 NOT(sample_f0_val) & NOT(sample_f0_val) ;
  --sample_f1_wen <= NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) &
  --                 NOT(sample_f1_val) & NOT(sample_f1_val) ;
  --sample_f3_wen <= NOT(sample_f3_val) & NOT(sample_f3_val) & NOT(sample_f3_val) &
  --                 NOT(sample_f3_val) & NOT(sample_f3_val) ;

  --sample_f0_wdata <= sample_f0_data((3*16)-1 DOWNTO (1*16)) & sample_f0_data((6*16)-1 DOWNTO (3*16));  -- (MSB) E2 E1 B2 B1 B0 (LSB)
  --sample_f1_wdata <= sample_f1_data((3*16)-1 DOWNTO (1*16)) & sample_f1_data((6*16)-1 DOWNTO (3*16));
  --sample_f3_wdata <= sample_f3_data((3*16)-1 DOWNTO (1*16)) & sample_f3_data((6*16)-1 DOWNTO (3*16));
  -------------------------------------------------------------------------------
  --lpp_lfr_ms_1: lpp_lfr_ms
  --  GENERIC MAP (
  --    hindex => hindex_ms)
  --  PORT MAP (
  --    clk                                    => clk,
  --    rstn                                   => rstn,
  --    sample_f0_wen                          => sample_f0_wen,
  --    sample_f0_wdata                        => sample_f0_wdata,
  --    sample_f1_wen                          => sample_f1_wen,
  --    sample_f1_wdata                        => sample_f1_wdata,
  --    sample_f3_wen                          => sample_f3_wen,
  --    sample_f3_wdata                        => sample_f3_wdata,
  --    AHB_Master_In                          => ahbi_ms,
  --    AHB_Master_Out                         => ahbo_ms,
      
  --    ready_matrix_f0_0                      => ready_matrix_f0_0,
  --    ready_matrix_f0_1                      => ready_matrix_f0_1,
  --    ready_matrix_f1                        => ready_matrix_f1,
  --    ready_matrix_f2                        => ready_matrix_f2,
  --    error_anticipating_empty_fifo          => error_anticipating_empty_fifo,
  --    error_bad_component_error              => error_bad_component_error,
  --    debug_reg                              => debug_reg,
  --    status_ready_matrix_f0_0               => status_ready_matrix_f0_0,
  --    status_ready_matrix_f0_1               => status_ready_matrix_f0_1,
  --    status_ready_matrix_f1                 => status_ready_matrix_f1,
  --    status_ready_matrix_f2                 => status_ready_matrix_f2,
  --    status_error_anticipating_empty_fifo   => status_error_anticipating_empty_fifo,
  --    status_error_bad_component_error       => status_error_bad_component_error,
  --    config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
  --    config_active_interruption_onError     => config_active_interruption_onError,
  --    addr_matrix_f0_0                       => addr_matrix_f0_0,
  --    addr_matrix_f0_1                       => addr_matrix_f0_1,
  --    addr_matrix_f1                         => addr_matrix_f1,
  --    addr_matrix_f2                         => addr_matrix_f2);

END beh;
