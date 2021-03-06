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
    Mem_use                : INTEGER := use_RAM;
    tech                   : INTEGER := inferred;
    nb_data_by_buffer_size : INTEGER := 32;
    nb_snapshot_param_size : INTEGER := 32;
    delta_vector_size      : INTEGER := 32;
    delta_vector_size_f0_2 : INTEGER := 7;
    
    pindex   : INTEGER := 15;
    paddr    : INTEGER := 15;
    pmask    : INTEGER := 16#fff#;
    pirq_ms  : INTEGER := 6;
    pirq_wfp : INTEGER := 14;

    hindex : INTEGER := 2;

    top_lfr_version : STD_LOGIC_VECTOR(23 DOWNTO 0) := X"020153";

    DEBUG_FORCE_DATA_DMA : INTEGER := 0;
    RTL_DESIGN_LIGHT     : INTEGER := 0;
    WINDOWS_HAANNING_PARAM_SIZE : INTEGER := 15; 
    DATA_SHAPING_SATURATION : INTEGER := 0    
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
    debug_vector    : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);   
    debug_vector_ms : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)    
    );
END lpp_lfr;

ARCHITECTURE beh OF lpp_lfr IS
  SIGNAL sample_s         : Samples(7 DOWNTO 0);
  --
  SIGNAL data_shaping_SP0 : STD_LOGIC;
  SIGNAL data_shaping_SP1 : STD_LOGIC;
  SIGNAL data_shaping_R0  : STD_LOGIC;
  SIGNAL data_shaping_R1  : STD_LOGIC;
  SIGNAL data_shaping_R2  : STD_LOGIC;
  --
  SIGNAL sample_f0_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wen    : STD_LOGIC_VECTOR(4 DOWNTO 0);
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
  SIGNAL sample_f0_data_sim : Samples(5 DOWNTO 0);
  SIGNAL sample_f1_data_sim : Samples(5 DOWNTO 0);
  SIGNAL sample_f2_data_sim : Samples(5 DOWNTO 0);
  SIGNAL sample_f3_data_sim : Samples(5 DOWNTO 0);
  --
  SIGNAL sample_f0_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f2_wdata  : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);

  -- SM
  SIGNAL ready_matrix_f0          : STD_LOGIC;
--  SIGNAL ready_matrix_f0_1        : STD_LOGIC;
  SIGNAL ready_matrix_f1          : STD_LOGIC;
  SIGNAL ready_matrix_f2          : STD_LOGIC;
  SIGNAL status_ready_matrix_f0   : STD_LOGIC;
--  SIGNAL status_ready_matrix_f0_1 : STD_LOGIC;
  SIGNAL status_ready_matrix_f1   : STD_LOGIC;
  SIGNAL status_ready_matrix_f2   : STD_LOGIC;
  SIGNAL addr_matrix_f0           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f1           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL addr_matrix_f2           : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL length_matrix_f0         : STD_LOGIC_VECTOR(25 DOWNTO 0);
  SIGNAL length_matrix_f1         : STD_LOGIC_VECTOR(25 DOWNTO 0);
  SIGNAL length_matrix_f2         : STD_LOGIC_VECTOR(25 DOWNTO 0);

  -- WFP
  SIGNAL status_new_err  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL delta_snapshot  : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f0_2      : STD_LOGIC_VECTOR(delta_vector_size_f0_2-1 DOWNTO 0);
  SIGNAL delta_f1        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);
  SIGNAL delta_f2        : STD_LOGIC_VECTOR(delta_vector_size-1 DOWNTO 0);

  SIGNAL nb_data_by_buffer : STD_LOGIC_VECTOR(nb_data_by_buffer_size-1 DOWNTO 0);
  SIGNAL nb_snapshot_param : STD_LOGIC_VECTOR(nb_snapshot_param_size-1 DOWNTO 0);
  SIGNAL enable_f0         : STD_LOGIC;
  SIGNAL enable_f1         : STD_LOGIC;
  SIGNAL enable_f2         : STD_LOGIC;
  SIGNAL enable_f3         : STD_LOGIC;
  SIGNAL burst_f0          : STD_LOGIC;
  SIGNAL burst_f1          : STD_LOGIC;
  SIGNAL burst_f2          : STD_LOGIC;

  --SIGNAL run        : STD_LOGIC;
  SIGNAL start_date : STD_LOGIC_VECTOR(30 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  SIGNAL wfp_status_buffer_ready : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wfp_addr_buffer         : STD_LOGIC_VECTOR(32*4-1 DOWNTO 0);
  SIGNAL wfp_length_buffer       : STD_LOGIC_VECTOR(25 DOWNTO 0);
  SIGNAL wfp_ready_buffer        : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL wfp_buffer_time         : STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
  SIGNAL wfp_error_buffer_full   : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL matrix_time_f0 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f1 : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL matrix_time_f2 : STD_LOGIC_VECTOR(47 DOWNTO 0);


  SIGNAL error_buffer_full      : STD_LOGIC;
  SIGNAL error_input_fifo_write : STD_LOGIC_VECTOR(2 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL dma_fifo_burst_valid : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_fifo_data        : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL dma_fifo_data_forced_gen : STD_LOGIC_VECTOR(32-1 DOWNTO 0);      --21-04-2015
  SIGNAL dma_fifo_data_forced : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);      --21-04-2015
  SIGNAL dma_fifo_data_debug  : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);      --21-04-2015
  SIGNAL dma_fifo_ren         : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_buffer_new       : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_buffer_addr      : STD_LOGIC_VECTOR(32*5-1 DOWNTO 0);
  SIGNAL dma_buffer_length    : STD_LOGIC_VECTOR(26*5-1 DOWNTO 0);
  SIGNAL dma_buffer_full      : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_buffer_full_err  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL dma_grant_error      : STD_LOGIC;

  SIGNAL apb_reg_debug_vector : STD_LOGIC_VECTOR(11 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_time        :  STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL sample_f0_time     :  STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL sample_f1_time     :  STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL sample_f2_time     :  STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL sample_f3_time     :  STD_LOGIC_VECTOR(47 DOWNTO 0);
  
BEGIN

  -----------------------------------------------------------------------------
  
  sample_s(4 DOWNTO 0) <= sample_E(4 DOWNTO 0);
  sample_s(7 DOWNTO 5) <= sample_B(2 DOWNTO 0);
  sample_time <= coarse_time & fine_time;
  
  -----------------------------------------------------------------------------
  lpp_lfr_filter_1 : lpp_lfr_filter
    GENERIC MAP (
      tech             => tech,
      Mem_use          => Mem_use,
      RTL_DESIGN_LIGHT => RTL_DESIGN_LIGHT,
      DATA_SHAPING_SATURATION => DATA_SHAPING_SATURATION)
    PORT MAP (
      sample           => sample_s,
      sample_val       => sample_val,
      sample_time      => sample_time,
      clk              => clk,
      rstn             => rstn,
      data_shaping_SP0 => data_shaping_SP0,
      data_shaping_SP1 => data_shaping_SP1,
      data_shaping_R0  => data_shaping_R0,
      data_shaping_R1  => data_shaping_R1,
      data_shaping_R2  => data_shaping_R2,
      sample_f0_val    => sample_f0_val,
      sample_f1_val    => sample_f1_val,
      sample_f2_val    => sample_f2_val,
      sample_f3_val    => sample_f3_val,
      sample_f0_wdata  => sample_f0_data,
      sample_f1_wdata  => sample_f1_data,
      sample_f2_wdata  => sample_f2_data,
      sample_f3_wdata  => sample_f3_data,
      sample_f0_time   => sample_f0_time, 
      sample_f1_time   => sample_f1_time,
      sample_f2_time   => sample_f2_time,
      sample_f3_time   => sample_f3_time
      );

  -----------------------------------------------------------------------------
  lpp_lfr_apbreg_1 : lpp_lfr_apbreg
    GENERIC MAP (
      nb_data_by_buffer_size => nb_data_by_buffer_size,
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

--      run_ms => OPEN,--run_ms,

      ready_matrix_f0        => ready_matrix_f0,
      ready_matrix_f1        => ready_matrix_f1,
      ready_matrix_f2        => ready_matrix_f2,
      error_buffer_full      => error_buffer_full,       
      error_input_fifo_write => error_input_fifo_write,  
      status_ready_matrix_f0 => status_ready_matrix_f0,
      status_ready_matrix_f1 => status_ready_matrix_f1,
      status_ready_matrix_f2 => status_ready_matrix_f2,

      matrix_time_f0 => matrix_time_f0,
      matrix_time_f1 => matrix_time_f1,
      matrix_time_f2 => matrix_time_f2,

      addr_matrix_f0 => addr_matrix_f0,
      addr_matrix_f1 => addr_matrix_f1,
      addr_matrix_f2 => addr_matrix_f2,

      length_matrix_f0  => length_matrix_f0,
      length_matrix_f1  => length_matrix_f1,
      length_matrix_f2  => length_matrix_f2,
      status_new_err    => status_new_err,
      data_shaping_BW   => data_shaping_BW,
      data_shaping_SP0  => data_shaping_SP0,
      data_shaping_SP1  => data_shaping_SP1,
      data_shaping_R0   => data_shaping_R0,
      data_shaping_R1   => data_shaping_R1,
      data_shaping_R2   => data_shaping_R2,
      delta_snapshot    => delta_snapshot,
      delta_f0          => delta_f0,
      delta_f0_2        => delta_f0_2,
      delta_f1          => delta_f1,
      delta_f2          => delta_f2,
      nb_data_by_buffer => nb_data_by_buffer,
      nb_snapshot_param => nb_snapshot_param,
      enable_f0         => enable_f0,
      enable_f1         => enable_f1,
      enable_f2         => enable_f2,
      enable_f3         => enable_f3,
      burst_f0          => burst_f0,
      burst_f1          => burst_f1,
      burst_f2          => burst_f2,
      run               => OPEN,
      start_date        => start_date,
      wfp_status_buffer_ready => wfp_status_buffer_ready,
      wfp_addr_buffer         => wfp_addr_buffer,
      wfp_length_buffer       => wfp_length_buffer,
    
      wfp_ready_buffer        => wfp_ready_buffer,
      wfp_buffer_time         => wfp_buffer_time,
      wfp_error_buffer_full   => wfp_error_buffer_full,
      -------------------------------------------------------------------------
      sample_f3_v     => sample_f3_data(1*16-1 DOWNTO 0*16),
      sample_f3_e1    => sample_f3_data(2*16-1 DOWNTO 1*16),
      sample_f3_e2    => sample_f3_data(3*16-1 DOWNTO 2*16),
      sample_f3_valid => sample_f3_val,
      debug_vector => apb_reg_debug_vector
      );

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  lpp_waveform_1 : lpp_waveform
    GENERIC MAP (
      tech                   => tech,
      data_size              => 6*16,
      nb_data_by_buffer_size => nb_data_by_buffer_size,
      nb_snapshot_param_size => nb_snapshot_param_size,
      delta_vector_size      => delta_vector_size,
      delta_vector_size_f0_2 => delta_vector_size_f0_2
      )
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      reg_run            => '1',--run,
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
      nb_snapshot_param => nb_snapshot_param,
      status_new_err    => status_new_err,
      
      status_buffer_ready => wfp_status_buffer_ready,
      addr_buffer         => wfp_addr_buffer,
      length_buffer       => wfp_length_buffer,
      ready_buffer        => wfp_ready_buffer,
      buffer_time         => wfp_buffer_time,
      error_buffer_full   => wfp_error_buffer_full,

      coarse_time => coarse_time,
--      fine_time   => fine_time,

      --f0
      data_f0_in_valid             => sample_f0_val,
      data_f0_in                   => sample_f0_data,
      data_f0_time                 => sample_f0_time,
      --f1
      data_f1_in_valid             => sample_f1_val,
      data_f1_in                   => sample_f1_data,
      data_f1_time                 => sample_f1_time,
      --f2
      data_f2_in_valid             => sample_f2_val,
      data_f2_in                   => sample_f2_data,
      data_f2_time                 => sample_f2_time,
      --f3
      data_f3_in_valid             => sample_f3_val,
      data_f3_in                   => sample_f3_data,
      data_f3_time                 => sample_f3_time,
      -- OUTPUT -- DMA interface
    
      dma_fifo_valid_burst => dma_fifo_burst_valid(3 DOWNTO 0),
      dma_fifo_data        => dma_fifo_data(32*4-1 DOWNTO 0),
      dma_fifo_ren         => dma_fifo_ren(3 DOWNTO 0),
      dma_buffer_new       => dma_buffer_new(3 DOWNTO 0),
      dma_buffer_addr      => dma_buffer_addr(32*4-1 DOWNTO 0),
      dma_buffer_length    => dma_buffer_length(26*4-1 DOWNTO 0),
      dma_buffer_full      => dma_buffer_full(3 DOWNTO 0),
      dma_buffer_full_err  => dma_buffer_full_err(3 DOWNTO 0)

      );    

  -----------------------------------------------------------------------------
  -- Matrix Spectral
  -----------------------------------------------------------------------------
  sample_f0_wen <= NOT(sample_f0_val) & NOT(sample_f0_val) & NOT(sample_f0_val) &
                   NOT(sample_f0_val) & NOT(sample_f0_val);
  sample_f1_wen <= NOT(sample_f1_val) & NOT(sample_f1_val) & NOT(sample_f1_val) &
                   NOT(sample_f1_val) & NOT(sample_f1_val);
  sample_f2_wen <= NOT(sample_f2_val) & NOT(sample_f2_val) & NOT(sample_f2_val) &
                   NOT(sample_f2_val) & NOT(sample_f2_val);

  
  sample_f0_wdata <= sample_f0_data((3*16)-1 DOWNTO (1*16)) & sample_f0_data((6*16)-1 DOWNTO (3*16));  -- (MSB) E2 E1 B2 B1 B0 (LSB)
  sample_f1_wdata <= sample_f1_data((3*16)-1 DOWNTO (1*16)) & sample_f1_data((6*16)-1 DOWNTO (3*16));
  sample_f2_wdata <= sample_f2_data((3*16)-1 DOWNTO (1*16)) & sample_f2_data((6*16)-1 DOWNTO (3*16));

  -----------------------------------------------------------------------------
  lpp_lfr_ms_1 : lpp_lfr_ms
    GENERIC MAP (
      Mem_use => Mem_use,
      WINDOWS_HAANNING_PARAM_SIZE => WINDOWS_HAANNING_PARAM_SIZE)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      
      run  => '1',--run_ms,

      start_date => start_date,
      
      coarse_time => coarse_time,

      sample_f0_wen   => sample_f0_wen,
      sample_f0_wdata => sample_f0_wdata,
      sample_f0_time  => sample_f0_time,
      sample_f1_wen   => sample_f1_wen,
      sample_f1_wdata => sample_f1_wdata,
      sample_f1_time  => sample_f1_time,
      sample_f2_wen   => sample_f2_wen,
      sample_f2_wdata => sample_f2_wdata,
      sample_f2_time  => sample_f2_time,

      --DMA
      dma_fifo_burst_valid => dma_fifo_burst_valid(4),                  -- OUT
      dma_fifo_data        => dma_fifo_data((4+1)*32-1 DOWNTO 4*32),    -- OUT
      dma_fifo_ren         => dma_fifo_ren(4),                          -- IN
      dma_buffer_new       => dma_buffer_new(4),                        -- OUT
      dma_buffer_addr      => dma_buffer_addr((4+1)*32-1 DOWNTO 4*32),  -- OUT
      dma_buffer_length    => dma_buffer_length((4+1)*26-1 DOWNTO 4*26),  -- OUT
      dma_buffer_full      => dma_buffer_full(4),                       -- IN
      dma_buffer_full_err  => dma_buffer_full_err(4),                   -- IN



      --REG
      ready_matrix_f0        => ready_matrix_f0,
      ready_matrix_f1        => ready_matrix_f1,
      ready_matrix_f2        => ready_matrix_f2,
      error_buffer_full      => error_buffer_full,
      error_input_fifo_write => error_input_fifo_write,   

      status_ready_matrix_f0 => status_ready_matrix_f0,
      status_ready_matrix_f1 => status_ready_matrix_f1,
      status_ready_matrix_f2 => status_ready_matrix_f2,
      addr_matrix_f0         => addr_matrix_f0,
      addr_matrix_f1         => addr_matrix_f1,
      addr_matrix_f2         => addr_matrix_f2,

      length_matrix_f0 => length_matrix_f0,
      length_matrix_f1 => length_matrix_f1,
      length_matrix_f2 => length_matrix_f2,

      matrix_time_f0 => matrix_time_f0,
      matrix_time_f1 => matrix_time_f1,
      matrix_time_f2 => matrix_time_f2,

      debug_vector   => debug_vector_ms);

  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN 
    IF rstn = '0' THEN 
      dma_fifo_data_forced_gen <= X"00040003";
    ELSIF clk'event AND clk = '1' THEN
      IF dma_fifo_ren(0) = '0' THEN
        CASE dma_fifo_data_forced_gen IS
          WHEN X"00040003" => dma_fifo_data_forced_gen <= X"00050002";
          WHEN X"00050002" => dma_fifo_data_forced_gen <= X"00060001";
          WHEN X"00060001" => dma_fifo_data_forced_gen <= X"00040003";
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;
  
  dma_fifo_data_forced(32 * 1 -1 DOWNTO 32 * 0) <= dma_fifo_data_forced_gen;
  dma_fifo_data_forced(32 * 2 -1 DOWNTO 32 * 1) <= X"A0000100";
  dma_fifo_data_forced(32 * 3 -1 DOWNTO 32 * 2) <= X"08001000";
  dma_fifo_data_forced(32 * 4 -1 DOWNTO 32 * 3) <= X"80007000";
  dma_fifo_data_forced(32 * 5 -1 DOWNTO 32 * 4) <= X"0A000B00";
  
  dma_fifo_data_debug <= dma_fifo_data WHEN DEBUG_FORCE_DATA_DMA = 0 ELSE dma_fifo_data_forced;
  
  DMA_SubSystem_1 : DMA_SubSystem
    GENERIC MAP (
      hindex     => hindex,
      CUSTOM_DMA => 1)
    PORT MAP (
      clk  => clk,
      rstn => rstn,
      run  => '1',--run_dma,
      ahbi => ahbi,
      ahbo => ahbo,

      fifo_burst_valid => dma_fifo_burst_valid,  --fifo_burst_valid,
      fifo_data        => dma_fifo_data_debug,         --fifo_data,
      fifo_ren         => dma_fifo_ren,          --fifo_ren,

      buffer_new      => dma_buffer_new,       --buffer_new,
      buffer_addr     => dma_buffer_addr,      --buffer_addr,
      buffer_length   => dma_buffer_length,    --buffer_length,
      buffer_full     => dma_buffer_full,      --buffer_full,
      buffer_full_err => dma_buffer_full_err,  --buffer_full_err,
      grant_error     => dma_grant_error,
      debug_vector    => debug_vector(8 DOWNTO 0)
      );     --grant_error);

  -----------------------------------------------------------------------------
  -- OBSERVATION for SIMULATION
  all_channel_sim: FOR I IN 0 TO 5 GENERATE
    PROCESS (clk, rstn)
    BEGIN  -- PROCESS
      IF rstn = '0' THEN                  -- asynchronous reset (active low)
        sample_f0_data_sim(I) <= (OTHERS => '0');
        sample_f1_data_sim(I) <= (OTHERS => '0');
        sample_f2_data_sim(I) <= (OTHERS => '0');
        sample_f3_data_sim(I) <= (OTHERS => '0');
      ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
        IF sample_f0_val = '1' THEN sample_f0_data_sim(I) <= sample_f0_data(((I+1)*16)-1 DOWNTO (I*16)); END IF;
        IF sample_f1_val = '1' THEN sample_f1_data_sim(I) <= sample_f1_data(((I+1)*16)-1 DOWNTO (I*16)); END IF;
        IF sample_f2_val = '1' THEN sample_f2_data_sim(I) <= sample_f2_data(((I+1)*16)-1 DOWNTO (I*16)); END IF;
        IF sample_f3_val = '1' THEN sample_f3_data_sim(I) <= sample_f3_data(((I+1)*16)-1 DOWNTO (I*16)); END IF;  
      END IF;
    END PROCESS;
  END GENERATE all_channel_sim;
  -----------------------------------------------------------------------------
  
END beh;
