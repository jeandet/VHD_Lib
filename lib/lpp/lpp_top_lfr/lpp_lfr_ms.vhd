LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


LIBRARY lpp;
USE lpp.lpp_memory.ALL;
USE lpp.iir_filter.ALL;
USE lpp.spectral_matrix_package.ALL;
USE lpp.lpp_dma_pkg.ALL;
USE lpp.lpp_Header.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_matrix.ALL;
USE lpp.lpp_lfr_pkg.ALL;
USE lpp.lpp_fft.ALL;
USE lpp.fft_components.ALL;

ENTITY lpp_lfr_ms IS
  GENERIC (
    Mem_use : INTEGER := use_RAM
    );
  PORT (
    clk  : IN STD_LOGIC;
    rstn : IN STD_LOGIC;
    run  : IN STD_LOGIC;

    ---------------------------------------------------------------------------
    -- DATA INPUT
    ---------------------------------------------------------------------------
    start_date      : IN STD_LOGIC_VECTOR(30 DOWNTO 0);
    coarse_time     : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    --fine_time       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- todo
    --
    sample_f0_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f0_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    sample_f0_time  : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
    --
    sample_f1_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f1_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    sample_f1_time  : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);
    --
    sample_f2_wen   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    sample_f2_wdata : IN STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
    sample_f2_time  : IN  STD_LOGIC_VECTOR(47 DOWNTO 0);

    ---------------------------------------------------------------------------
    -- DMA
    ---------------------------------------------------------------------------
    dma_fifo_burst_valid: OUT STD_LOGIC;                      --TODO
    dma_fifo_data       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
    dma_fifo_ren        : IN  STD_LOGIC;                      --TODO
    dma_buffer_new      : OUT STD_LOGIC;                      --TODOx
    dma_buffer_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
    dma_buffer_length   : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);  --TODO
    dma_buffer_full     : IN  STD_LOGIC;                      --TODO
    dma_buffer_full_err : IN  STD_LOGIC;                      --TODO

    -- Reg out
    ready_matrix_f0           : OUT STD_LOGIC;                  -- TODO
    ready_matrix_f1           : OUT STD_LOGIC;                  -- TODO
    ready_matrix_f2           : OUT STD_LOGIC;                  -- TODO
--    error_bad_component_error : OUT STD_LOGIC;                  -- TODO
    error_buffer_full         : OUT STD_LOGIC;                  -- TODO
    error_input_fifo_write    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Reg In
    status_ready_matrix_f0 : IN STD_LOGIC;                      -- TODO
    status_ready_matrix_f1 : IN STD_LOGIC;                      -- TODO
    status_ready_matrix_f2 : IN STD_LOGIC;                      -- TODO

    addr_matrix_f0                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO
    addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO
    addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO
    
    length_matrix_f0                         : IN STD_LOGIC_VECTOR(25 DOWNTO 0); -- TODO
    length_matrix_f1                         : IN STD_LOGIC_VECTOR(25 DOWNTO 0); -- TODO
    length_matrix_f2                         : IN STD_LOGIC_VECTOR(25 DOWNTO 0); -- TODO

    matrix_time_f0 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- TODO
    matrix_time_f1 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- TODO
    matrix_time_f2 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0);  -- TODO
    ---------------------------------------------------------------------------
    debug_vector : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
END;

ARCHITECTURE Behavioral OF lpp_lfr_ms IS

  SIGNAL sample_f0_A_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_A_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_A_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f0_B_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f0_B_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f0_B_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f1_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f1_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f1_almost_full : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL sample_f2_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_f2_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  SIGNAL error_wen_f0 : STD_LOGIC;
  SIGNAL error_wen_f1 : STD_LOGIC;
  SIGNAL error_wen_f2 : STD_LOGIC;

  SIGNAL one_sample_f1_full : STD_LOGIC;
  SIGNAL one_sample_f1_wen  : STD_LOGIC;
  SIGNAL one_sample_f2_full : STD_LOGIC;
  SIGNAL one_sample_f2_wen  : STD_LOGIC;

  -----------------------------------------------------------------------------
  -- FSM / SWITCH SELECT CHANNEL
  -----------------------------------------------------------------------------
  TYPE   fsm_select_channel IS (IDLE, SWITCH_F0_A, SWITCH_F0_B, SWITCH_F1, SWITCH_F2);
  SIGNAL state_fsm_select_channel     : fsm_select_channel;
--  SIGNAL pre_state_fsm_select_channel : fsm_select_channel;
  SIGNAL select_channel     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL select_channel_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    
  SIGNAL sample_rdata : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  SIGNAL sample_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_empty : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------
  TYPE   fsm_load_FFT IS (IDLE, FIFO_1, FIFO_2, FIFO_3, FIFO_4, FIFO_5);
  SIGNAL state_fsm_load_FFT      : fsm_load_FFT;
--  SIGNAL next_state_fsm_load_FFT : fsm_load_FFT;
  SIGNAL select_fifo     : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL select_fifo_reg : STD_LOGIC_VECTOR(2 DOWNTO 0);

  SIGNAL sample_ren_s   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_load    : STD_LOGIC;
  SIGNAL sample_valid   : STD_LOGIC;
  SIGNAL sample_valid_r : STD_LOGIC;
  SIGNAL sample_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);


  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  SIGNAL fft_read                 : STD_LOGIC;
  SIGNAL fft_pong                 : STD_LOGIC;
  SIGNAL fft_data_im              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_re              : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL fft_data_valid           : STD_LOGIC;
  SIGNAL fft_ready                : STD_LOGIC;
  -----------------------------------------------------------------------------
--  SIGNAL fft_linker_ReUse    : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  TYPE   fsm_load_MS_memory IS (IDLE, LOAD_FIFO, TRASH_FFT);
  SIGNAL state_fsm_load_MS_memory : fsm_load_MS_memory;
  SIGNAL current_fifo_load        : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL current_fifo_empty       : STD_LOGIC;
  SIGNAL current_fifo_locked      : STD_LOGIC;
  SIGNAL current_fifo_full        : STD_LOGIC;
  SIGNAL MEM_IN_SM_locked         : STD_LOGIC_VECTOR(4 DOWNTO 0);

  -----------------------------------------------------------------------------
  SIGNAL MEM_IN_SM_ReUse : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wen   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wen_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_ren   : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_wData : STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
  SIGNAL MEM_IN_SM_rData : STD_LOGIC_VECTOR(16*2*5-1 DOWNTO 0);
  SIGNAL MEM_IN_SM_Full  : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL MEM_IN_SM_Empty : STD_LOGIC_VECTOR(4 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL SM_in_data      : STD_LOGIC_VECTOR(32*2-1 DOWNTO 0);
  SIGNAL SM_in_ren       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL SM_in_empty     : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL SM_correlation_start     : STD_LOGIC;
  SIGNAL SM_correlation_auto      : STD_LOGIC;
  SIGNAL SM_correlation_done      : STD_LOGIC;
  SIGNAL SM_correlation_done_reg1 : STD_LOGIC;
  SIGNAL SM_correlation_done_reg2 : STD_LOGIC;
  SIGNAL SM_correlation_done_reg3 : STD_LOGIC;
  SIGNAL SM_correlation_begin     : STD_LOGIC;

  SIGNAL MEM_OUT_SM_Full_s    : STD_LOGIC;
  SIGNAL MEM_OUT_SM_Data_in_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Write_s   : STD_LOGIC;

  SIGNAL current_matrix_write      : STD_LOGIC;
  SIGNAL current_matrix_wait_empty : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL fifo_0_ready              : STD_LOGIC;
  SIGNAL fifo_1_ready              : STD_LOGIC;
  SIGNAL fifo_ongoing              : STD_LOGIC;

  SIGNAL FSM_DMA_fifo_ren    : STD_LOGIC;
  SIGNAL FSM_DMA_fifo_empty  : STD_LOGIC;
  SIGNAL FSM_DMA_fifo_empty_threshold  : STD_LOGIC;
  SIGNAL FSM_DMA_fifo_data   : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL FSM_DMA_fifo_status : STD_LOGIC_VECTOR(53 DOWNTO 4);
  -----------------------------------------------------------------------------
  SIGNAL MEM_OUT_SM_Write    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Read     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Data_in  : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Data_out : STD_LOGIC_VECTOR(63 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Full     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Empty    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_OUT_SM_Empty_Threshold    : STD_LOGIC_VECTOR(1 DOWNTO 0);

  -----------------------------------------------------------------------------
  -- TIME REG & INFOs
  -----------------------------------------------------------------------------
  SIGNAL all_time : STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);

  SIGNAL f_empty       : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL f_empty_reg   : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_update_f : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL time_reg_f    : STD_LOGIC_VECTOR(48*4-1 DOWNTO 0);
  
  SIGNAL time_reg_f0_A : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f0_B : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f1   : STD_LOGIC_VECTOR(47 DOWNTO 0);
  SIGNAL time_reg_f2   : STD_LOGIC_VECTOR(47 DOWNTO 0);

  --SIGNAL time_update_f0_A : STD_LOGIC;
  --SIGNAL time_update_f0_B : STD_LOGIC;
  --SIGNAL time_update_f1   : STD_LOGIC;
  --SIGNAL time_update_f2   : STD_LOGIC;
  --
  SIGNAL status_channel   : STD_LOGIC_VECTOR(49 DOWNTO 0);
  SIGNAL status_MS_input  : STD_LOGIC_VECTOR(49 DOWNTO 0);
  SIGNAL status_component : STD_LOGIC_VECTOR(53 DOWNTO 0);

  SIGNAL status_component_fifo_0     : STD_LOGIC_VECTOR(53 DOWNTO 4);
  SIGNAL status_component_fifo_1     : STD_LOGIC_VECTOR(53 DOWNTO 4);
  SIGNAL status_component_fifo_0_end : STD_LOGIC;
  SIGNAL status_component_fifo_1_end : STD_LOGIC;
  -----------------------------------------------------------------------------
  SIGNAL fft_ongoing_counter : STD_LOGIC;--_VECTOR(1 DOWNTO 0);
  
  SIGNAL fft_ready_reg         : STD_LOGIC;
  SIGNAL fft_ready_rising_down : STD_LOGIC;
  
  SIGNAL sample_load_reg         : STD_LOGIC;
  SIGNAL sample_load_rising_down : STD_LOGIC;

  -----------------------------------------------------------------------------
  SIGNAL sample_f1_wen_head     : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen_head_in  : STD_LOGIC;
  SIGNAL sample_f1_wen_head_out : STD_LOGIC;
  SIGNAL sample_f1_full_head_in : STD_LOGIC;
  SIGNAL sample_f1_full_head_out : STD_LOGIC;
  SIGNAL sample_f1_empty_head_in : STD_LOGIC;
  
  SIGNAL sample_f1_wdata_head   : STD_LOGIC_VECTOR((5*16)-1 DOWNTO 0);
  -----------------------------------------------------------------------------
  SIGNAL sample_f0_wen_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f1_wen_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL sample_f2_wen_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL ongoing : STD_LOGIC;
  
BEGIN

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      sample_f0_wen_s <= (OTHERS => '1');
      sample_f1_wen_s <= (OTHERS => '1');
      sample_f2_wen_s <= (OTHERS => '1');
      ongoing <= '0';      
    ELSIF clk'event AND clk = '1' THEN  -- rising clock edge
      IF ongoing = '1' THEN
        sample_f0_wen_s <= sample_f0_wen;
        sample_f1_wen_s <= sample_f1_wen;
        sample_f2_wen_s <= sample_f2_wen;
      ELSE
        IF start_date = coarse_time(30 DOWNTO 0) THEN
          ongoing <= '1';
        END IF;        
        sample_f0_wen_s <= (OTHERS => '1');
        sample_f1_wen_s <= (OTHERS => '1');
        sample_f2_wen_s <= (OTHERS => '1');
      END IF;
    END IF;
  END PROCESS;
  
  
  error_input_fifo_write <= error_wen_f2 & error_wen_f1 & error_wen_f0;


  switch_f0_inst : spectral_matrix_switch_f0
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      sample_wen => sample_f0_wen_s,

      fifo_A_empty => sample_f0_A_empty,
      fifo_A_full  => sample_f0_A_full,
      fifo_A_wen   => sample_f0_A_wen,

      fifo_B_empty => sample_f0_B_empty,
      fifo_B_full  => sample_f0_B_full,
      fifo_B_wen   => sample_f0_B_wen,

      error_wen => error_wen_f0);       -- TODO

  -----------------------------------------------------------------------------
  -- FIFO IN
  -----------------------------------------------------------------------------
  lppFIFOxN_f0_a : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 16,
      Addr_sz => 8,
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse => (OTHERS => '0'),

      run   => (OTHERS => '1'),

      wen   => sample_f0_A_wen,
      wdata => sample_f0_wdata,

      ren   => sample_f0_A_ren,
      rdata => sample_f0_A_rdata,

      empty       => sample_f0_A_empty,
      full        => sample_f0_A_full,
      almost_full => OPEN);             

  lppFIFOxN_f0_b : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 16,
      Addr_sz => 8,
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse => (OTHERS => '0'),
      run   => (OTHERS => '1'),

      wen         => sample_f0_B_wen,
      wdata       => sample_f0_wdata,
      ren         => sample_f0_B_ren,
      rdata       => sample_f0_B_rdata,
      empty       => sample_f0_B_empty,
      full        => sample_f0_B_full,
      almost_full => OPEN);

  -----------------------------------------------------------------------------
  -- sample_f1_wen   in
  -- sample_f1_wdata in
  -- sample_f1_full  OUT

  sample_f1_wen_head_in   <= '0' WHEN sample_f1_wen_s = "00000" ELSE '1';
  sample_f1_full_head_in  <= '0' WHEN sample_f1_full  = "00000" ELSE '1';
  sample_f1_empty_head_in <= '1' WHEN sample_f1_empty = "11111" ELSE '0';
  
  lpp_lfr_ms_reg_head_1:lpp_lfr_ms_reg_head
    PORT MAP (
      clk      => clk,
      rstn     => rstn,
      in_wen   => sample_f1_wen_head_in,
      in_data  => sample_f1_wdata,
      in_full  => sample_f1_full_head_in,
      in_empty => sample_f1_empty_head_in,
      out_write_error => error_wen_f1,
      out_wen  => sample_f1_wen_head_out,
      out_data => sample_f1_wdata_head,
      out_full => sample_f1_full_head_out);

  sample_f1_wen_head    <= sample_f1_wen_head_out & sample_f1_wen_head_out & sample_f1_wen_head_out & sample_f1_wen_head_out & sample_f1_wen_head_out;
  
  
  lppFIFOxN_f1 : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 16,
      Addr_sz => 8,
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse => (OTHERS => '0'),
      run   => (OTHERS => '1'),

      wen         => sample_f1_wen_head,
      wdata       => sample_f1_wdata_head,
      ren         => sample_f1_ren,
      rdata       => sample_f1_rdata,
      empty       => sample_f1_empty,
      full        => sample_f1_full,
      almost_full => sample_f1_almost_full); 


  one_sample_f1_wen <= '0' WHEN sample_f1_wen_head = "11111" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      one_sample_f1_full <= '0';
      --error_wen_f1       <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF sample_f1_full_head_out = '0' THEN
        one_sample_f1_full <= '0';
      ELSE
        one_sample_f1_full <= '1';
      END IF;
      --error_wen_f1 <= one_sample_f1_wen AND one_sample_f1_full;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------


  lppFIFOxN_f2 : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 16,
      Addr_sz => 8,
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse => (OTHERS => '0'),
      run   => (OTHERS => '1'),

      wen         => sample_f2_wen_s,
      wdata       => sample_f2_wdata,
      ren         => sample_f2_ren,
      rdata       => sample_f2_rdata,
      empty       => sample_f2_empty,
      full        => sample_f2_full,
      almost_full => OPEN);             


  one_sample_f2_wen <= '0' WHEN sample_f2_wen_s = "11111" ELSE '1';

  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      one_sample_f2_full <= '0';
      error_wen_f2       <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      IF sample_f2_full = "00000" THEN
        one_sample_f2_full <= '0';
      ELSE
        one_sample_f2_full <= '1';
      END IF;
      error_wen_f2 <= one_sample_f2_wen AND one_sample_f2_full;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------------
  -- FSM SELECT CHANNEL
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_fsm_select_channel <= IDLE;
      select_channel <= (OTHERS => '0');
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state_fsm_select_channel IS
        WHEN IDLE =>
          IF sample_f1_full = "11111" THEN
            state_fsm_select_channel <= SWITCH_F1;
            select_channel <= "10";
          ELSIF sample_f1_almost_full = "00000" THEN
            IF sample_f0_A_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F0_A;
              select_channel <= "00";
            ELSIF sample_f0_B_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F0_B;
              select_channel <= "01";
            ELSIF sample_f2_full = "11111" THEN
              state_fsm_select_channel <= SWITCH_F2;
              select_channel <= "11";
            END IF;
          END IF;
          
        WHEN SWITCH_F0_A =>
          IF sample_f0_A_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
            select_channel <= (OTHERS => '0');
          END IF;
        WHEN SWITCH_F0_B =>
          IF sample_f0_B_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
            select_channel <= (OTHERS => '0');
          END IF;
        WHEN SWITCH_F1 =>
          IF sample_f1_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
            select_channel <= (OTHERS => '0');
          END IF;
        WHEN SWITCH_F2 =>
          IF sample_f2_empty = "11111" THEN
            state_fsm_select_channel <= IDLE;
            select_channel <= (OTHERS => '0');
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      select_channel_reg <= (OTHERS => '0');
      --pre_state_fsm_select_channel <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN
      select_channel_reg <= select_channel;
      --pre_state_fsm_select_channel <= state_fsm_select_channel;
    END IF;
  END PROCESS;


  -----------------------------------------------------------------------------
  -- SWITCH SELECT CHANNEL
  -----------------------------------------------------------------------------
  sample_empty <= sample_f0_A_empty WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                  sample_f0_B_empty WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                  sample_f1_empty   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                  sample_f2_empty   WHEN state_fsm_select_channel = SWITCH_F2   ELSE
                  (OTHERS => '1');
  
  sample_full <= sample_f0_A_full WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                 sample_f0_B_full WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                 sample_f1_full   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                 sample_f2_full   WHEN state_fsm_select_channel = SWITCH_F2   ELSE
                 (OTHERS => '0');
  
  --sample_rdata <= sample_f0_A_rdata WHEN pre_state_fsm_select_channel = SWITCH_F0_A ELSE
  --                sample_f0_B_rdata WHEN pre_state_fsm_select_channel = SWITCH_F0_B ELSE
  --                sample_f1_rdata   WHEN pre_state_fsm_select_channel = SWITCH_F1   ELSE
  --                sample_f2_rdata;  -- WHEN state_fsm_select_channel = SWITCH_F2   ELSE
  sample_rdata <= sample_f0_A_rdata WHEN select_channel_reg = "00" ELSE
                  sample_f0_B_rdata WHEN select_channel_reg = "01" ELSE
                  sample_f1_rdata   WHEN select_channel_reg = "10"   ELSE
                  sample_f2_rdata;  -- WHEN state_fsm_select_channel = SWITCH_F2   ELSE


  sample_f0_A_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_A ELSE (OTHERS => '1');
  sample_f0_B_ren <= sample_ren WHEN state_fsm_select_channel = SWITCH_F0_B ELSE (OTHERS => '1');
  sample_f1_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F1   ELSE (OTHERS => '1');
  sample_f2_ren   <= sample_ren WHEN state_fsm_select_channel = SWITCH_F2   ELSE (OTHERS => '1');


  status_channel <= time_reg_f0_A & "00" WHEN state_fsm_select_channel = SWITCH_F0_A ELSE
                    time_reg_f0_B & "00" WHEN state_fsm_select_channel = SWITCH_F0_B ELSE
                    time_reg_f1 & "01"   WHEN state_fsm_select_channel = SWITCH_F1   ELSE
                    time_reg_f2 & "10";  -- WHEN state_fsm_select_channel = SWITCH_F2

  -----------------------------------------------------------------------------
  -- FSM LOAD FFT
  -----------------------------------------------------------------------------

  sample_ren <= (OTHERS => '1') WHEN fft_ongoing_counter = '1' ELSE
                sample_ren_s    WHEN sample_load = '1' ELSE
                (OTHERS => '1');

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_ren_s       <= (OTHERS => '1');
      state_fsm_load_FFT <= IDLE;
      status_MS_input    <= (OTHERS => '0');
      select_fifo        <= "000";
      --next_state_fsm_load_FFT <= IDLE;
      --sample_valid              <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state_fsm_load_FFT IS
        WHEN IDLE =>
          --sample_valid <= '0';
          sample_ren_s <= (OTHERS => '1');
          IF sample_full = "11111" AND sample_load = '1' THEN
            state_fsm_load_FFT <= FIFO_1;
            status_MS_input    <= status_channel;
            select_fifo <= "000";
          END IF;
          
        WHEN FIFO_1 =>
          sample_ren_s <= "1111" & NOT(sample_load);
          IF sample_empty(0) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_2;
            select_fifo <= "001";
          END IF;
          
        WHEN FIFO_2 =>
          sample_ren_s <= "111" & NOT(sample_load) & '1';
          IF sample_empty(1) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_3;
            select_fifo <= "010";
          END IF;
          
        WHEN FIFO_3 =>
          sample_ren_s <= "11" & NOT(sample_load) & "11";
          IF sample_empty(2) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_4;
            select_fifo <= "011";
          END IF;
          
        WHEN FIFO_4 =>
          sample_ren_s <= '1' & NOT(sample_load) & "111";
          IF sample_empty(3) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= FIFO_5;
            select_fifo <= "100";
          END IF;
          
        WHEN FIFO_5 =>
          sample_ren_s <= NOT(sample_load) & "1111";
          IF sample_empty(4) = '1' THEN
            sample_ren_s       <= (OTHERS => '1');
            state_fsm_load_FFT <= IDLE;
            select_fifo <= "000";
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
    END IF;
  END PROCESS;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      sample_valid_r          <= '0';
      select_fifo_reg <= (OTHERS => '0');
      --next_state_fsm_load_FFT <= IDLE;
    ELSIF clk'EVENT AND clk = '1' THEN
      select_fifo_reg <= select_fifo;
      --next_state_fsm_load_FFT <= state_fsm_load_FFT;
      IF sample_ren_s = "11111" THEN
        sample_valid_r <= '0';
      ELSE
        sample_valid_r <= '1';
      END IF;
    END IF;
  END PROCESS;

  sample_valid <= '0' WHEN fft_ongoing_counter = '1' ELSE sample_valid_r AND sample_load;

  --sample_data <= sample_rdata(16*1-1 DOWNTO 16*0) WHEN next_state_fsm_load_FFT = FIFO_1 ELSE
  --               sample_rdata(16*2-1 DOWNTO 16*1) WHEN next_state_fsm_load_FFT = FIFO_2 ELSE
  --               sample_rdata(16*3-1 DOWNTO 16*2) WHEN next_state_fsm_load_FFT = FIFO_3 ELSE
  --               sample_rdata(16*4-1 DOWNTO 16*3) WHEN next_state_fsm_load_FFT = FIFO_4 ELSE
  --               sample_rdata(16*5-1 DOWNTO 16*4);  --WHEN next_state_fsm_load_FFT = FIFO_5 ELSE
  sample_data <= sample_rdata(16*1-1 DOWNTO 16*0) WHEN select_fifo_reg = "000" ELSE
                 sample_rdata(16*2-1 DOWNTO 16*1) WHEN select_fifo_reg = "001" ELSE
                 sample_rdata(16*3-1 DOWNTO 16*2) WHEN select_fifo_reg = "010" ELSE
                 sample_rdata(16*4-1 DOWNTO 16*3) WHEN select_fifo_reg = "011"  ELSE
                 sample_rdata(16*5-1 DOWNTO 16*4);  --WHEN next_state_fsm_load_FFT = FIFO_5 ELSE
  
  -----------------------------------------------------------------------------
  -- FFT
  -----------------------------------------------------------------------------
  lpp_lfr_ms_FFT_1 : lpp_lfr_ms_FFT
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sample_valid   => sample_valid,
      fft_read       => fft_read,
      sample_data    => sample_data,
      sample_load    => sample_load,
      fft_pong       => fft_pong,
      fft_data_im    => fft_data_im,
      fft_data_re    => fft_data_re,
      fft_data_valid => fft_data_valid,
      fft_ready      => fft_ready);
  
  debug_vector(0) <= fft_data_valid;
  debug_vector(1) <= fft_ready;
  debug_vector(11 DOWNTO 2) <= (OTHERS => '0');

    
  -----------------------------------------------------------------------------
  fft_ready_rising_down   <= fft_ready_reg AND NOT fft_ready;
  sample_load_rising_down <= sample_load_reg AND NOT sample_load;
  
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      fft_ready_reg     <= '0';
      sample_load_reg   <= '0';

      fft_ongoing_counter <= '0';
    ELSIF clk'event AND clk = '1' THEN
      fft_ready_reg    <= fft_ready;
      sample_load_reg  <= sample_load;

      IF fft_ready_rising_down = '1' AND sample_load_rising_down = '0' THEN
        fft_ongoing_counter <= '0';

--        CASE fft_ongoing_counter IS
--          WHEN "01" => fft_ongoing_counter <= "00";
----          WHEN "10" => fft_ongoing_counter <= "01";
--          WHEN OTHERS => NULL;
--        END CASE;
      ELSIF fft_ready_rising_down = '0' AND sample_load_rising_down = '1' THEN
        fft_ongoing_counter <= '1';
--        CASE fft_ongoing_counter IS
--          WHEN "00" => fft_ongoing_counter <= "01";
----          WHEN "01" => fft_ongoing_counter <= "10";
--          WHEN OTHERS => NULL;
--        END CASE;
      END IF;

    END IF;
  END PROCESS;
  
  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      state_fsm_load_MS_memory <= IDLE;
      current_fifo_load        <= "00001";
    ELSIF clk'EVENT AND clk = '1' THEN
      CASE state_fsm_load_MS_memory IS
        WHEN IDLE =>
          IF current_fifo_empty = '1' AND fft_ready = '1' AND current_fifo_locked = '0' THEN
            state_fsm_load_MS_memory <= LOAD_FIFO;
          END IF;
        WHEN LOAD_FIFO =>
          IF current_fifo_full = '1' THEN
            state_fsm_load_MS_memory <= TRASH_FFT;
          END IF;
        WHEN TRASH_FFT =>
          IF fft_ready = '0' THEN
            state_fsm_load_MS_memory <= IDLE;
            current_fifo_load        <= current_fifo_load(3 DOWNTO 0) & current_fifo_load(4);
          END IF;
        WHEN OTHERS => NULL;
      END CASE;
      
    END IF;
  END PROCESS;

  current_fifo_empty <= MEM_IN_SM_Empty(0) WHEN current_fifo_load(0) = '1' ELSE
                        MEM_IN_SM_Empty(1) WHEN current_fifo_load(1) = '1' ELSE
                        MEM_IN_SM_Empty(2) WHEN current_fifo_load(2) = '1' ELSE
                        MEM_IN_SM_Empty(3) WHEN current_fifo_load(3) = '1' ELSE
                        MEM_IN_SM_Empty(4);  -- WHEN current_fifo_load(3) = '1' ELSE
  
  current_fifo_full <= MEM_IN_SM_Full(0) WHEN current_fifo_load(0) = '1' ELSE
                       MEM_IN_SM_Full(1) WHEN current_fifo_load(1) = '1' ELSE
                       MEM_IN_SM_Full(2) WHEN current_fifo_load(2) = '1' ELSE
                       MEM_IN_SM_Full(3) WHEN current_fifo_load(3) = '1' ELSE
                       MEM_IN_SM_Full(4);  -- WHEN current_fifo_load(3) = '1' ELSE
  
  current_fifo_locked <= MEM_IN_SM_locked(0) WHEN current_fifo_load(0) = '1' ELSE
                         MEM_IN_SM_locked(1) WHEN current_fifo_load(1) = '1' ELSE
                         MEM_IN_SM_locked(2) WHEN current_fifo_load(2) = '1' ELSE
                         MEM_IN_SM_locked(3) WHEN current_fifo_load(3) = '1' ELSE
                         MEM_IN_SM_locked(4);  -- WHEN current_fifo_load(3) = '1' ELSE
  
  fft_read <= '0' WHEN state_fsm_load_MS_memory = IDLE ELSE '1';

  all_fifo : FOR I IN 4 DOWNTO 0 GENERATE
    MEM_IN_SM_wen_s(I) <= '0' WHEN fft_data_valid = '1'
                          AND state_fsm_load_MS_memory = LOAD_FIFO
                          AND current_fifo_load(I) = '1'
                          ELSE '1';
  END GENERATE all_fifo;

  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      MEM_IN_SM_wen <= (OTHERS => '1');
    ELSIF clk'EVENT AND clk = '1' THEN
      MEM_IN_SM_wen <= MEM_IN_SM_wen_s;
    END IF;
  END PROCESS;

  MEM_IN_SM_wData <= (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re) &
                     (fft_data_im & fft_data_re);
  -----------------------------------------------------------------------------
  

  -----------------------------------------------------------------------------
  Mem_In_SpectralMatrix : lppFIFOxN
    GENERIC MAP (
      tech    => 0,
      Mem_use => Mem_use,
      Data_sz => 32,                    --16,
      Addr_sz => 7,                     --8
      FifoCnt => 5)
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      ReUse => MEM_IN_SM_ReUse,
      run   => (OTHERS => '1'),

      wen   => MEM_IN_SM_wen,
      wdata => MEM_IN_SM_wData,

      ren         => MEM_IN_SM_ren,
      rdata       => MEM_IN_SM_rData,
      full        => MEM_IN_SM_Full,
      empty       => MEM_IN_SM_Empty,
      almost_full => OPEN);


  -----------------------------------------------------------------------------
  MS_control_1 : MS_control
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      current_status_ms => status_MS_input,

      fifo_in_lock  => MEM_IN_SM_locked,
      fifo_in_data  => MEM_IN_SM_rdata,
      fifo_in_full  => MEM_IN_SM_Full,
      fifo_in_empty => MEM_IN_SM_Empty,
      fifo_in_ren   => MEM_IN_SM_ren,
      fifo_in_reuse => MEM_IN_SM_ReUse,

      fifo_out_data  => SM_in_data,
      fifo_out_ren   => SM_in_ren,
      fifo_out_empty => SM_in_empty,

      current_status_component => status_component,

      correlation_start => SM_correlation_start,
      correlation_auto  => SM_correlation_auto,
      correlation_done  => SM_correlation_done);


  MS_calculation_1 : MS_calculation
    PORT MAP (
      clk  => clk,
      rstn => rstn,

      fifo_in_data  => SM_in_data,
      fifo_in_ren   => SM_in_ren,
      fifo_in_empty => SM_in_empty,

      fifo_out_data => MEM_OUT_SM_Data_in_s,  --    TODO
      fifo_out_wen  => MEM_OUT_SM_Write_s,    --      TODO
      fifo_out_full => MEM_OUT_SM_Full_s,     --       TODO

      correlation_start => SM_correlation_start,
      correlation_auto  => SM_correlation_auto,
      correlation_begin => SM_correlation_begin,
      correlation_done  => SM_correlation_done);

  -----------------------------------------------------------------------------
  PROCESS (clk, rstn)
  BEGIN  -- PROCESS
    IF rstn = '0' THEN                  -- asynchronous reset (active low)
      current_matrix_write        <= '0';
      current_matrix_wait_empty   <= '1';
      status_component_fifo_0     <= (OTHERS => '0');
      status_component_fifo_1     <= (OTHERS => '0');
      status_component_fifo_0_end <= '0';
      status_component_fifo_1_end <= '0';
      SM_correlation_done_reg1    <= '0';
      SM_correlation_done_reg2    <= '0';
      SM_correlation_done_reg3    <= '0';
      
    ELSIF clk'EVENT AND clk = '1' THEN  -- rising clock edge
      SM_correlation_done_reg1    <= SM_correlation_done;
      SM_correlation_done_reg2    <= SM_correlation_done_reg1;
      SM_correlation_done_reg3    <= SM_correlation_done_reg2;
      status_component_fifo_0_end <= '0';
      status_component_fifo_1_end <= '0';
      IF SM_correlation_begin = '1' THEN
        IF current_matrix_write = '0' THEN
          status_component_fifo_0 <= status_component(53 DOWNTO 4);
        ELSE
          status_component_fifo_1 <= status_component(53 DOWNTO 4);
        END IF;
      END IF;

      IF SM_correlation_done_reg3 = '1' THEN
        IF current_matrix_write = '0' THEN
          status_component_fifo_0_end <= '1';
        ELSE
          status_component_fifo_1_end <= '1';
        END IF;
        current_matrix_wait_empty <= '1';
        current_matrix_write      <= NOT current_matrix_write;
      END IF;

      IF current_matrix_wait_empty <= '1' THEN
        IF current_matrix_write = '0' THEN
          current_matrix_wait_empty <= NOT MEM_OUT_SM_Empty(0);
        ELSE
          current_matrix_wait_empty <= NOT MEM_OUT_SM_Empty(1);
        END IF;
      END IF;
      
    END IF;
  END PROCESS;

  MEM_OUT_SM_Full_s <= '1' WHEN SM_correlation_done = '1' ELSE
                       '1'                WHEN SM_correlation_done_reg1 = '1'  ELSE
                       '1'                WHEN SM_correlation_done_reg2 = '1'  ELSE
                       '1'                WHEN SM_correlation_done_reg3 = '1'  ELSE
                       '1'                WHEN current_matrix_wait_empty = '1' ELSE
                       MEM_OUT_SM_Full(0) WHEN current_matrix_write = '0'      ELSE
                       MEM_OUT_SM_Full(1);

  MEM_OUT_SM_Write(0) <= MEM_OUT_SM_Write_s WHEN current_matrix_write = '0' ELSE '1';
  MEM_OUT_SM_Write(1) <= MEM_OUT_SM_Write_s WHEN current_matrix_write = '1' ELSE '1';

  MEM_OUT_SM_Data_in <= MEM_OUT_SM_Data_in_s & MEM_OUT_SM_Data_in_s;
  -----------------------------------------------------------------------------

  --Mem_Out_SpectralMatrix : lppFIFOxN
  --  GENERIC MAP (
  --    tech    => 0,
  --    Mem_use => Mem_use,
  --    Data_sz => 32,
  --    Addr_sz => 8,
  --    FifoCnt => 2)
  --  PORT MAP (
  --    clk  => clk,
  --    rstn => rstn,

  --    ReUse => (OTHERS => '0'),
  --    run   => (OTHERS => '1'),

  --    wen   => MEM_OUT_SM_Write,
  --    wdata => MEM_OUT_SM_Data_in,

  --    ren   => MEM_OUT_SM_Read,
  --    rdata => MEM_OUT_SM_Data_out,

  --    full        => MEM_OUT_SM_Full,
  --    empty       => MEM_OUT_SM_Empty,
  --    almost_full => OPEN);

  
  all_Mem_Out_SpectralMatrix: FOR I IN 1 DOWNTO 0 GENERATE
    Mem_Out_SpectralMatrix_I: lpp_fifo
      GENERIC MAP (
        tech                  => 0,
        Mem_use               => Mem_use,
        EMPTY_THRESHOLD_LIMIT => 15,
        FULL_THRESHOLD_LIMIT  => 1,
        DataSz                => 32,
        AddrSz                => 8)
      PORT MAP (
        clk             => clk,
        rstn            => rstn,
        reUse           => '0',
        run             => run,

        ren             => MEM_OUT_SM_Read(I),                 
        rdata           => MEM_OUT_SM_Data_out(32*(I+1)-1 DOWNTO 32*i),
        
        wen             => MEM_OUT_SM_Write(I),                           
        wdata           => MEM_OUT_SM_Data_in(32*(I+1)-1 DOWNTO 32*i),                         
        
        empty           => MEM_OUT_SM_Empty(I),                
        full            => MEM_OUT_SM_Full(I),                         
        full_almost     => OPEN,                   
        empty_threshold => MEM_OUT_SM_Empty_Threshold(I),      
                                                        
        full_threshold  => OPEN);
    
  END GENERATE all_Mem_Out_SpectralMatrix;

  -----------------------------------------------------------------------------
--  MEM_OUT_SM_Read <= "00";
  PROCESS (clk, rstn)
  BEGIN
    IF rstn = '0' THEN
      fifo_0_ready <= '0';
      fifo_1_ready <= '0';
      fifo_ongoing <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF fifo_0_ready = '1' AND MEM_OUT_SM_Empty(0) = '1' THEN
        fifo_ongoing <= '1';
        fifo_0_ready <= '0';
      ELSIF status_component_fifo_0_end = '1' THEN
        fifo_0_ready <= '1';
      END IF;

      IF fifo_1_ready = '1' AND MEM_OUT_SM_Empty(1) = '1' THEN
        fifo_ongoing <= '0';
        fifo_1_ready <= '0';
      ELSIF status_component_fifo_1_end = '1' THEN
        fifo_1_ready <= '1';
      END IF;
      
    END IF;
  END PROCESS;

  MEM_OUT_SM_Read(0) <= '1' WHEN fifo_ongoing = '1' ELSE
                        '1' WHEN fifo_0_ready = '0' ELSE
                        FSM_DMA_fifo_ren;

  MEM_OUT_SM_Read(1) <= '1' WHEN fifo_ongoing = '0' ELSE
                        '1' WHEN fifo_1_ready = '0' ELSE
                        FSM_DMA_fifo_ren;

  FSM_DMA_fifo_empty <= MEM_OUT_SM_Empty(0) WHEN fifo_ongoing = '0' AND fifo_0_ready = '1' ELSE
                        MEM_OUT_SM_Empty(1) WHEN fifo_ongoing = '1' AND fifo_1_ready = '1' ELSE
                        '1';
  
  FSM_DMA_fifo_status <= status_component_fifo_0 WHEN fifo_ongoing = '0' ELSE
                         status_component_fifo_1;

  FSM_DMA_fifo_data <= MEM_OUT_SM_Data_out(31 DOWNTO 0) WHEN fifo_ongoing = '0' ELSE
                       MEM_OUT_SM_Data_out(63 DOWNTO 32);

    
  FSM_DMA_fifo_empty_threshold <= MEM_OUT_SM_Empty_Threshold(0) WHEN fifo_ongoing = '0' AND fifo_0_ready = '1'  ELSE
                                  MEM_OUT_SM_Empty_Threshold(1) WHEN fifo_ongoing = '1' AND fifo_1_ready = '1'  ELSE
                                  '1';
  
  -----------------------------------------------------------------------------
  --    fifo_matrix_type      => FSM_DMA_fifo_status(5 DOWNTO 4),       --IN
  --    fifo_matrix_component => FSM_DMA_fifo_status(3 DOWNTO 0),       --IN
  --    fifo_matrix_time      => FSM_DMA_fifo_status(53 DOWNTO 6),      --IN
  --    fifo_data             => FSM_DMA_fifo_data,                     --IN
  --    fifo_empty            => FSM_DMA_fifo_empty,                    --IN
  --    fifo_empty_threshold  => FSM_DMA_fifo_empty_threshold,          --IN
  --    fifo_ren              => FSM_DMA_fifo_ren,                      --OUT
  

  lpp_lfr_ms_fsmdma_1: lpp_lfr_ms_fsmdma
    PORT MAP (
      clk                    => clk,
      rstn                   => rstn,
      run                    => run,
      
      fifo_matrix_type       => FSM_DMA_fifo_status(5 DOWNTO 4),
      fifo_matrix_time       => FSM_DMA_fifo_status(53 DOWNTO 6),
      fifo_data              => FSM_DMA_fifo_data,
      fifo_empty             => FSM_DMA_fifo_empty,
      fifo_empty_threshold   => FSM_DMA_fifo_empty_threshold,
      fifo_ren               => FSM_DMA_fifo_ren,
      
      dma_fifo_valid_burst   => dma_fifo_burst_valid,
      dma_fifo_data          => dma_fifo_data,
      dma_fifo_ren           => dma_fifo_ren,
      dma_buffer_new         => dma_buffer_new,
      dma_buffer_addr        => dma_buffer_addr,
      dma_buffer_length      => dma_buffer_length,
      dma_buffer_full        => dma_buffer_full,
      dma_buffer_full_err    => dma_buffer_full_err,
      
      status_ready_matrix_f0 => status_ready_matrix_f0,
      status_ready_matrix_f1 => status_ready_matrix_f1,
      status_ready_matrix_f2 => status_ready_matrix_f2,
      addr_matrix_f0         => addr_matrix_f0,
      addr_matrix_f1         => addr_matrix_f1,
      addr_matrix_f2         => addr_matrix_f2,
      length_matrix_f0       => length_matrix_f0,
      length_matrix_f1       => length_matrix_f1,
      length_matrix_f2       => length_matrix_f2,
      ready_matrix_f0        => ready_matrix_f0,
      ready_matrix_f1        => ready_matrix_f1,
      ready_matrix_f2        => ready_matrix_f2,
      matrix_time_f0         => matrix_time_f0,
      matrix_time_f1         => matrix_time_f1,
      matrix_time_f2         => matrix_time_f2,
      error_buffer_full      => error_buffer_full);
  

  

    
  --dma_fifo_burst_valid: OUT STD_LOGIC;                      --TODO
  --dma_fifo_data       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
  --dma_fifo_ren        : IN  STD_LOGIC;                      --TODO
  --dma_buffer_new      : OUT STD_LOGIC;                      --TODO
  --dma_buffer_addr     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);  --TODO
  --dma_buffer_length   : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);  --TODO
  --dma_buffer_full     : IN  STD_LOGIC;                      --TODO
  --dma_buffer_full_err : IN  STD_LOGIC;                      --TODO

  ---- Reg out
  --ready_matrix_f0           : OUT STD_LOGIC;                  -- TODO
  --ready_matrix_f1           : OUT STD_LOGIC;                  -- TODO
  --ready_matrix_f2           : OUT STD_LOGIC;                  -- TODO
  --error_bad_component_error : OUT STD_LOGIC;                  -- TODO
  --error_buffer_full         : OUT STD_LOGIC;                  -- TODO

  ---- Reg In
  --status_ready_matrix_f0 : IN STD_LOGIC;                      -- TODO
  --status_ready_matrix_f1 : IN STD_LOGIC;                      -- TODO
  --status_ready_matrix_f2 : IN STD_LOGIC;                      -- TODO

  --addr_matrix_f0                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO
  --addr_matrix_f1                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO
  --addr_matrix_f2                         : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- TODO

  --matrix_time_f0 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- TODO
  --matrix_time_f1 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0); -- TODO
  --matrix_time_f2 : OUT STD_LOGIC_VECTOR(47 DOWNTO 0)  -- TODO
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --lpp_lfr_ms_fsmdma_1 : lpp_lfr_ms_fsmdma
  --  PORT MAP (
  --    HCLK    => clk,
  --    HRESETn => rstn,

  --    fifo_matrix_type      => FSM_DMA_fifo_status(5 DOWNTO 4),
  --    fifo_matrix_component => FSM_DMA_fifo_status(3 DOWNTO 0),
  --    fifo_matrix_time      => FSM_DMA_fifo_status(53 DOWNTO 6),
  --    fifo_data             => FSM_DMA_fifo_data,
  --    fifo_empty            => FSM_DMA_fifo_empty,
  --    fifo_ren              => FSM_DMA_fifo_ren,

  --    dma_addr        => dma_addr,
  --    dma_data        => dma_data,
  --    dma_valid       => dma_valid,
  --    dma_valid_burst => dma_valid_burst,
  --    dma_ren         => dma_ren,
  --    dma_done        => dma_done,

  --    ready_matrix_f0 => ready_matrix_f0,
  --    ready_matrix_f1 => ready_matrix_f1,
  --    ready_matrix_f2 => ready_matrix_f2,

  --    error_bad_component_error => error_bad_component_error,
  --    error_buffer_full         => error_buffer_full,

  --    debug_reg              => debug_reg,
  --    status_ready_matrix_f0 => status_ready_matrix_f0,
  --    status_ready_matrix_f1 => status_ready_matrix_f1,
  --    status_ready_matrix_f2 => status_ready_matrix_f2,

  --    config_active_interruption_onNewMatrix => config_active_interruption_onNewMatrix,
  --    config_active_interruption_onError     => config_active_interruption_onError,

  --    addr_matrix_f0 => addr_matrix_f0,
  --    addr_matrix_f1 => addr_matrix_f1,
  --    addr_matrix_f2 => addr_matrix_f2,

  --    matrix_time_f0 => matrix_time_f0,
  --    matrix_time_f1 => matrix_time_f1,
  --    matrix_time_f2 => matrix_time_f2
  --    );
  -----------------------------------------------------------------------------

  




  -----------------------------------------------------------------------------
  -- TIME MANAGMENT
  -----------------------------------------------------------------------------
  all_time <= sample_f2_time & sample_f1_time & sample_f0_time & sample_f0_time;
  --all_time         <= coarse_time & fine_time;
  --
  f_empty(0) <= '1' WHEN sample_f0_A_empty = "11111" ELSE '0';
  f_empty(1) <= '1' WHEN sample_f0_B_empty = "11111" ELSE '0';
  f_empty(2) <= '1' WHEN sample_f1_empty   = "11111" ELSE '0';
  f_empty(3) <= '1' WHEN sample_f2_empty   = "11111" ELSE '0';
  
  all_time_reg: FOR I IN 0 TO 3 GENERATE

    PROCESS (clk, rstn)
    BEGIN
      IF rstn = '0' THEN
        f_empty_reg(I) <= '1';
      ELSIF clk'event AND clk = '1' THEN
        f_empty_reg(I) <= f_empty(I);
      END IF;
    END PROCESS;    

    time_update_f(I) <= '1' WHEN f_empty(I) = '0' AND f_empty_reg(I) = '1' ELSE '0';

    s_m_t_m_f0_A : spectral_matrix_time_managment
      PORT MAP (
        clk      => clk,
        rstn     => rstn,
        time_in  => all_time((I+1)*48-1 DOWNTO I*48),
        update_1 => time_update_f(I),
        time_out => time_reg_f((I+1)*48-1 DOWNTO I*48)
        );

  END GENERATE all_time_reg;

  time_reg_f0_A <= time_reg_f((0+1)*48-1 DOWNTO 0*48);
  time_reg_f0_B <= time_reg_f((1+1)*48-1 DOWNTO 1*48);
  time_reg_f1   <= time_reg_f((2+1)*48-1 DOWNTO 2*48);
  time_reg_f2   <= time_reg_f((3+1)*48-1 DOWNTO 3*48);

  -----------------------------------------------------------------------------

END Behavioral;
